import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/offline_map_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class MapFormScreen extends ConsumerStatefulWidget {
  final String? mapId;

  const MapFormScreen({super.key, this.mapId});

  @override
  ConsumerState<MapFormScreen> createState() => _MapFormScreenState();
}

class _MapFormScreenState extends ConsumerState<MapFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameRuController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameHiController = TextEditingController();
  final _descrRuController = TextEditingController();
  final _descrEnController = TextEditingController();
  final _descrHiController = TextEditingController();
  final _versionController = TextEditingController();

  String? _regionId;
  String? _fileUrl;
  int _sizeBytes = 0;
  bool _isLoading = false;
  bool _isSaving = false;
  OfflineMap? _map;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.mapId != null) {
      _loadMap();
    } else {
      _versionController.text = '1.0';
    }
  }

  Future<void> _loadMap() async {
    setState(() => _isLoading = true);
    try {
      final map = await ref.read(mapDetailProvider(widget.mapId!).future);
      _map = map;
      _nameRuController.text = map.name.ru;
      _nameEnController.text = map.name.en;
      _nameHiController.text = map.name.hi;
      _descrRuController.text = map.descr.ru;
      _descrEnController.text = map.descr.en;
      _descrHiController.text = map.descr.hi;
      _versionController.text = map.version;
      _regionId = map.regionId;
      _fileUrl = map.fileUrl;
      _sizeBytes = map.sizeBytes;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameRuController.dispose();
    _nameEnController.dispose();
    _nameHiController.dispose();
    _descrRuController.dispose();
    _descrEnController.dispose();
    _descrHiController.dispose();
    _versionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameRuController.text.isEmpty && _nameEnController.text.isEmpty) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        final input = OfflineMapInput(
          name: LocalizedText(
            ru: _nameRuController.text,
            en: _nameEnController.text,
            hi: _nameHiController.text,
          ),
          descr: LocalizedText(
            ru: _descrRuController.text,
            en: _descrEnController.text,
            hi: _descrHiController.text,
          ),
          regionId: _regionId,
          fileUrl: _fileUrl ?? '',
          sizeBytes: _sizeBytes,
          version: _versionController.text,
        );

        if (widget.mapId == null) {
          await client!.createMap(input);
        } else {
          await client!.updateMap(widget.mapId!, input);
        }
      }

      ref.invalidate(mapsProvider);
      if (mounted) context.go('/maps');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNew = widget.mapId == null;
    final regionsAsync = ref.watch(regionsProvider);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/maps'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addMap : l10n.editMap,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/maps'),
              ),
              const SizedBox(width: 12),
              AdminButton.primary(
                label: l10n.save,
                onPressed: _isSaving ? null : _handleSave,
                isLoading: _isSaving,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Form
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File upload section
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.mapFile,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FileUploadBox(
                      fileUrl: _fileUrl,
                      sizeBytes: _sizeBytes,
                      onChanged: (url, size) => setState(() {
                        _fileUrl = url;
                        _sizeBytes = size;
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Region selector
                    regionsAsync.when(
                      data: (regions) => AdminDropdown(
                        label: l10n.mapRegion,
                        value: _regionId,
                        items: [
                          const DropdownMenuItem(value: null, child: Text('-')),
                          ...regions.map((r) => DropdownMenuItem(
                            value: r.id,
                            child: Text(r.name.ru),
                          )),
                        ],
                        onChanged: (v) => setState(() => _regionId = v),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    const SizedBox(height: 20),
                    AdminTextField(
                      label: l10n.mapVersion,
                      controller: _versionController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),

              // Fields section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language tabs
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.primary,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorColor: AppColors.primary,
                      tabs: const [
                        Tab(text: 'RU'),
                        Tab(text: 'EN'),
                        Tab(text: 'HI'),
                      ],
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLanguageFields(l10n, _nameRuController, _descrRuController),
                          _buildLanguageFields(l10n, _nameEnController, _descrEnController),
                          _buildLanguageFields(l10n, _nameHiController, _descrHiController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageFields(
    AppLocalizations l10n,
    TextEditingController nameController,
    TextEditingController descrController,
  ) {
    return Column(
      children: [
        AdminTextField(
          label: l10n.mapName,
          controller: nameController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.mapDescription,
          controller: descrController,
          maxLines: 4,
        ),
      ],
    );
  }
}

class _FileUploadBox extends StatelessWidget {
  final String? fileUrl;
  final int sizeBytes;
  final void Function(String?, int) onChanged;

  const _FileUploadBox({
    this.fileUrl,
    required this.sizeBytes,
    required this.onChanged,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: fileUrl != null && fileUrl!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.map, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileUrl!.split('/').last,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => onChanged(null, 0),
                    ),
                  ],
                ),
                Text(
                  _formatSize(sizeBytes),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.upload_file, size: 48, color: AppColors.textSecondary),
                const SizedBox(height: 8),
                Text(
                  l10n.uploadFile,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
    );
  }
}
