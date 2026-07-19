import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/guide_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class GuideFormScreen extends ConsumerStatefulWidget {
  final String? guideId;

  const GuideFormScreen({super.key, this.guideId});

  @override
  ConsumerState<GuideFormScreen> createState() => _GuideFormScreenState();
}

class _GuideFormScreenState extends ConsumerState<GuideFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameRuController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameHiController = TextEditingController();
  final _bioRuController = TextEditingController();
  final _bioEnController = TextEditingController();
  final _bioHiController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _telegramController = TextEditingController();
  final _orderController = TextEditingController();

  String? _photo;
  bool _isLoading = false;
  bool _isSaving = false;
  Guide? _guide;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.guideId != null) {
      _loadGuide();
    } else {
      _orderController.text = '1';
    }
  }

  Future<void> _loadGuide() async {
    setState(() => _isLoading = true);
    try {
      final guide = await ref.read(guideDetailProvider(widget.guideId!).future);
      _guide = guide;
      _nameRuController.text = guide.name.ru;
      _nameEnController.text = guide.name.en;
      _nameHiController.text = guide.name.hi;
      _bioRuController.text = guide.bio.ru;
      _bioEnController.text = guide.bio.en;
      _bioHiController.text = guide.bio.hi;
      _phoneController.text = guide.phone ?? '';
      _whatsappController.text = guide.whatsapp ?? '';
      _telegramController.text = guide.telegram ?? '';
      _orderController.text = guide.order.toString();
      _photo = guide.photo;
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
    _bioRuController.dispose();
    _bioEnController.dispose();
    _bioHiController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _telegramController.dispose();
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
        final input = GuideInput(
          name: LocalizedText(
            ru: _nameRuController.text,
            en: _nameEnController.text,
            hi: _nameHiController.text,
          ),
          bio: LocalizedText(
            ru: _bioRuController.text,
            en: _bioEnController.text,
            hi: _bioHiController.text,
          ),
          photo: _photo,
          phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
          whatsapp: _whatsappController.text.isNotEmpty ? _whatsappController.text : null,
          telegram: _telegramController.text.isNotEmpty ? _telegramController.text : null,
          order: int.tryParse(_orderController.text) ?? 1,
        );

        if (widget.guideId == null) {
          await client!.createGuide(input);
        } else {
          await client!.updateGuide(widget.guideId!, input);
        }
      }

      ref.invalidate(guidesProvider);
      if (mounted) context.go('/guides');
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
    final isNew = widget.guideId == null;

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
                onPressed: () => context.go('/guides'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addGuide : l10n.editGuide,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/guides'),
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
                      l10n.guidePhoto,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PhotoUploadBox(
                      url: _photo,
                      onChanged: (url) => setState(() => _photo = url),
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
                          _buildLanguageFields(l10n, _nameRuController, _bioRuController),
                          _buildLanguageFields(l10n, _nameEnController, _bioEnController),
                          _buildLanguageFields(l10n, _nameHiController, _bioHiController),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Contact fields
                    Row(
                      children: [
                        Expanded(
                          child: AdminTextField(
                            label: l10n.guidePhone,
                            controller: _phoneController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdminTextField(
                            label: 'WhatsApp',
                            controller: _whatsappController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdminTextField(
                            label: 'Telegram',
                            controller: _telegramController,
                          ),
                        ),
                      ],
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
    TextEditingController bioController,
  ) {
    return Column(
      children: [
        AdminTextField(
          label: l10n.guideName,
          controller: nameController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.guideBio,
          controller: bioController,
          maxLines: 4,
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
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(75),
      ),
      child: url != null && url!.isNotEmpty
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Image.network(
                    url!,
                    width: 150,
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
