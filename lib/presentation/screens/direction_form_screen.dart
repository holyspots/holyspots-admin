import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/direction_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class DirectionFormScreen extends ConsumerStatefulWidget {
  final String? directionId;

  const DirectionFormScreen({super.key, this.directionId});

  @override
  ConsumerState<DirectionFormScreen> createState() => _DirectionFormScreenState();
}

class _DirectionFormScreenState extends ConsumerState<DirectionFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _titleRuController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _titleHiController = TextEditingController();
  final _contentRuController = TextEditingController();
  final _contentEnController = TextEditingController();
  final _contentHiController = TextEditingController();
  final _orderController = TextEditingController();

  DirectionType _type = DirectionType.bus;
  String? _regionId;
  bool _isLoading = false;
  bool _isSaving = false;
  Direction? _direction;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.directionId != null) {
      _loadDirection();
    } else {
      _orderController.text = '1';
    }
  }

  Future<void> _loadDirection() async {
    setState(() => _isLoading = true);
    try {
      final direction = await ref.read(directionDetailProvider(widget.directionId!).future);
      _direction = direction;
      _titleRuController.text = direction.title.ru;
      _titleEnController.text = direction.title.en;
      _titleHiController.text = direction.title.hi;
      _contentRuController.text = direction.content.ru;
      _contentEnController.text = direction.content.en;
      _contentHiController.text = direction.content.hi;
      _orderController.text = direction.order.toString();
      _type = direction.type;
      _regionId = direction.regionId;
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleRuController.dispose();
    _titleEnController.dispose();
    _titleHiController.dispose();
    _contentRuController.dispose();
    _contentEnController.dispose();
    _contentHiController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_titleRuController.text.isEmpty && _titleEnController.text.isEmpty) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        final input = DirectionInput(
          title: LocalizedText(
            ru: _titleRuController.text,
            en: _titleEnController.text,
            hi: _titleHiController.text,
          ),
          content: LocalizedText(
            ru: _contentRuController.text,
            en: _contentEnController.text,
            hi: _contentHiController.text,
          ),
          type: _type,
          regionId: _regionId,
          order: int.tryParse(_orderController.text) ?? 1,
        );

        if (widget.directionId == null) {
          await client!.createDirection(input);
        } else {
          await client!.updateDirection(widget.directionId!, input);
        }
      }

      ref.invalidate(directionsProvider);
      if (mounted) context.go('/directions');
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
    final isNew = widget.directionId == null;
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
                onPressed: () => context.go('/directions'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addDirection : l10n.editDirection,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/directions'),
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
              // Left column
              SizedBox(
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type selector
                    Text(
                      l10n.directionType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DirectionType.values.map((type) => _TypeOption(
                        type: type,
                        selected: _type == type,
                        onTap: () => setState(() => _type = type),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                    // Region selector
                    regionsAsync.when(
                      data: (regions) => AdminDropdown(
                        label: l10n.region,
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
                          _buildLanguageFields(l10n, _titleRuController, _contentRuController),
                          _buildLanguageFields(l10n, _titleEnController, _contentEnController),
                          _buildLanguageFields(l10n, _titleHiController, _contentHiController),
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
    TextEditingController titleController,
    TextEditingController contentController,
  ) {
    return Column(
      children: [
        AdminTextField(
          label: l10n.directionTitle,
          controller: titleController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.directionContent,
          controller: contentController,
          maxLines: 8,
        ),
      ],
    );
  }
}

class _TypeOption extends StatelessWidget {
  final DirectionType type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, label) = switch (type) {
      DirectionType.bus => (Icons.directions_bus, l10n.directionTypeBus),
      DirectionType.train => (Icons.train, l10n.directionTypeTrain),
      DirectionType.plane => (Icons.flight, l10n.directionTypePlane),
      DirectionType.walk => (Icons.directions_walk, l10n.directionTypeWalk),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
