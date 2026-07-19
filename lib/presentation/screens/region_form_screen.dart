import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/region_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class RegionFormScreen extends ConsumerStatefulWidget {
  final String? regionId;

  const RegionFormScreen({super.key, this.regionId});

  @override
  ConsumerState<RegionFormScreen> createState() => _RegionFormScreenState();
}

class _RegionFormScreenState extends ConsumerState<RegionFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameRuController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameHiController = TextEditingController();
  final _descrRuController = TextEditingController();
  final _descrEnController = TextEditingController();
  final _descrHiController = TextEditingController();
  final _orderController = TextEditingController();

  String? _mainPhoto;
  bool _isLoading = false;
  bool _isSaving = false;
  Region? _region;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.regionId != null) {
      _loadRegion();
    } else {
      _orderController.text = '1';
    }
  }

  Future<void> _loadRegion() async {
    setState(() => _isLoading = true);
    try {
      final region = await ref.read(regionDetailProvider(widget.regionId!).future);
      _region = region;
      _nameRuController.text = region.name.ru;
      _nameEnController.text = region.name.en;
      _nameHiController.text = region.name.hi;
      _descrRuController.text = region.descr.ru;
      _descrEnController.text = region.descr.en;
      _descrHiController.text = region.descr.hi;
      _orderController.text = region.order.toString();
      _mainPhoto = region.mainPhoto;
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
    _orderController.dispose();
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
        final input = RegionInput(
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
          mainPhoto: _mainPhoto,
          order: int.tryParse(_orderController.text) ?? 1,
        );

        if (widget.regionId == null) {
          await client!.createRegion(input);
        } else {
          await client!.updateRegion(widget.regionId!, input);
        }
      }

      ref.invalidate(regionsProvider);
      if (mounted) context.go('/regions');
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
    final isNew = widget.regionId == null;

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
                onPressed: () => context.go('/regions'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addRegion : l10n.editRegion,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/regions'),
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
              // Photo section
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.regionPhoto,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PhotoUploadBox(
                      url: _mainPhoto,
                      onChanged: (url) => setState(() => _mainPhoto = url),
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
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLanguageFields(l10n, _nameRuController, _descrRuController),
                          _buildLanguageFields(l10n, _nameEnController, _descrEnController),
                          _buildLanguageFields(l10n, _nameHiController, _descrHiController),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: 100,
                      child: AdminTextField(
                        label: l10n.order,
                        controller: _orderController,
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
          label: l10n.regionName,
          controller: nameController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.regionDescription,
          controller: descrController,
          maxLines: 6,
        ),
      ],
    );
  }
}

class _PhotoUploadBox extends StatelessWidget {
  final String? url;
  final ValueChanged<String?> onChanged;

  const _PhotoUploadBox({this.url, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: url != null && url!.isNotEmpty
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url!,
                    width: 200,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image, size: 48, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => onChanged(null),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_photo_alternate, size: 48, color: AppColors.textSecondary),
                const SizedBox(height: 8),
                Text(
                  l10n.uploadPhoto,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
    );
  }
}
