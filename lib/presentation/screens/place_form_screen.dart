import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/place_model.dart';
import '../../data/models/localized_text.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class PlaceFormScreen extends ConsumerStatefulWidget {
  final String? placeId;

  const PlaceFormScreen({super.key, this.placeId});

  @override
  ConsumerState<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends ConsumerState<PlaceFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameRuController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameHiController = TextEditingController();
  final _descrRuController = TextEditingController();
  final _descrEnController = TextEditingController();
  final _descrHiController = TextEditingController();
  final _addressRuController = TextEditingController();
  final _addressEnController = TextEditingController();
  final _addressHiController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  PlaceType _type = PlaceType.hotel;
  String? _regionId;
  String? _mainPhoto;
  bool _isLoading = false;
  bool _isSaving = false;
  Place? _place;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.placeId != null) {
      _loadPlace();
    }
  }

  Future<void> _loadPlace() async {
    setState(() => _isLoading = true);
    try {
      final place = await ref.read(placeDetailProvider(widget.placeId!).future);
      _place = place;
      _nameRuController.text = place.name.ru;
      _nameEnController.text = place.name.en;
      _nameHiController.text = place.name.hi;
      _descrRuController.text = place.descr.ru;
      _descrEnController.text = place.descr.en;
      _descrHiController.text = place.descr.hi;
      _addressRuController.text = place.address.ru;
      _addressEnController.text = place.address.en;
      _addressHiController.text = place.address.hi;
      _phoneController.text = place.phone ?? '';
      _websiteController.text = place.website ?? '';
      _latController.text = place.lat?.toString() ?? '';
      _lngController.text = place.lng?.toString() ?? '';
      _type = place.type;
      _regionId = place.regionId;
      _mainPhoto = place.mainPhoto;
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
    _addressRuController.dispose();
    _addressEnController.dispose();
    _addressHiController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _latController.dispose();
    _lngController.dispose();
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
        final input = PlaceInput(
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
          address: LocalizedText(
            ru: _addressRuController.text,
            en: _addressEnController.text,
            hi: _addressHiController.text,
          ),
          type: _type,
          regionId: _regionId,
          mainPhoto: _mainPhoto,
          phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
          website: _websiteController.text.isNotEmpty ? _websiteController.text : null,
          lat: double.tryParse(_latController.text),
          lng: double.tryParse(_lngController.text),
        );

        if (widget.placeId == null) {
          await client!.createPlace(input);
        } else {
          await client!.updatePlace(widget.placeId!, input);
        }
      }

      ref.invalidate(placesProvider);
      if (mounted) context.go('/places');
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
    final isNew = widget.placeId == null;
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
                onPressed: () => context.go('/places'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addPlace : l10n.editPlace,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/places'),
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
                    Text(
                      l10n.placePhoto,
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
                    const SizedBox(height: 20),
                    // Type selector
                    Text(
                      l10n.placeType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _TypeOption(
                          icon: Icons.hotel,
                          label: l10n.placeTypeHotel,
                          selected: _type == PlaceType.hotel,
                          onTap: () => setState(() => _type = PlaceType.hotel),
                        ),
                        const SizedBox(width: 12),
                        _TypeOption(
                          icon: Icons.restaurant,
                          label: l10n.placeTypeFood,
                          selected: _type == PlaceType.food,
                          onTap: () => setState(() => _type = PlaceType.food),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    AdminTextField(
                      label: l10n.placePhone,
                      controller: _phoneController,
                    ),
                    const SizedBox(height: 16),
                    AdminTextField(
                      label: l10n.placeWebsite,
                      controller: _websiteController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AdminTextField(
                            label: l10n.latitude,
                            controller: _latController,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AdminTextField(
                            label: l10n.longitude,
                            controller: _lngController,
                          ),
                        ),
                      ],
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
                      height: 450,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildLanguageFields(l10n, _nameRuController, _descrRuController, _addressRuController),
                          _buildLanguageFields(l10n, _nameEnController, _descrEnController, _addressEnController),
                          _buildLanguageFields(l10n, _nameHiController, _descrHiController, _addressHiController),
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
    TextEditingController addressController,
  ) {
    return Column(
      children: [
        AdminTextField(
          label: l10n.placeName,
          controller: nameController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.placeAddress,
          controller: addressController,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.placeDescription,
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

class _TypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
