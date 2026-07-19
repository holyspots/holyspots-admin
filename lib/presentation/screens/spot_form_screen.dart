import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/spot_model.dart';
import '../../data/models/localized_text.dart';
import '../../data/models/geo_point.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_form_dialog.dart';

class SpotFormScreen extends ConsumerStatefulWidget {
  final String? spotId;
  final String? regionId;

  const SpotFormScreen({super.key, this.spotId, this.regionId});

  @override
  ConsumerState<SpotFormScreen> createState() => _SpotFormScreenState();
}

class _SpotFormScreenState extends ConsumerState<SpotFormScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _nameRuController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameHiController = TextEditingController();
  final _descrRuController = TextEditingController();
  final _descrEnController = TextEditingController();
  final _descrHiController = TextEditingController();
  final _addressController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _orderController = TextEditingController();

  String? _mainPhoto;
  List<String> _photos = [];
  List<SpotAudio> _audios = [];
  bool _isLoading = false;
  bool _isSaving = false;
  Spot? _spot;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.spotId != null) {
      _loadSpot();
    } else {
      _orderController.text = '1';
    }
  }

  Future<void> _loadSpot() async {
    setState(() => _isLoading = true);
    try {
      final spot = await ref.read(spotDetailProvider(widget.spotId!).future);
      _spot = spot;
      _nameRuController.text = spot.name.ru;
      _nameEnController.text = spot.name.en;
      _nameHiController.text = spot.name.hi;
      _descrRuController.text = spot.descr.ru;
      _descrEnController.text = spot.descr.en;
      _descrHiController.text = spot.descr.hi;
      _addressController.text = spot.address ?? '';
      _latController.text = spot.location?.latitude.toString() ?? '';
      _lngController.text = spot.location?.longitude.toString() ?? '';
      _orderController.text = spot.order.toString();
      _mainPhoto = spot.mainPhoto;
      _photos = List.from(spot.photos);
      _audios = List.from(spot.audios);
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
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
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

        GeoPoint? location;
        final lat = double.tryParse(_latController.text);
        final lng = double.tryParse(_lngController.text);
        if (lat != null && lng != null) {
          location = GeoPoint(latitude: lat, longitude: lng);
        }

        // Use the regionId from widget or from loaded spot
        final regionIds = widget.regionId != null
            ? [widget.regionId!]
            : _spot?.regionIds ?? [];

        final input = SpotInput(
          regionIds: regionIds,
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
          location: location,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          order: int.tryParse(_orderController.text) ?? 1,
          photos: _photos,
          audios: _audios,
        );

        if (widget.spotId == null) {
          await client!.createSpot(input);
        } else {
          await client!.updateSpot(widget.spotId!, input);
        }
      }

      ref.invalidate(spotsProvider);
      if (mounted) context.go('/spots');
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
    final isNew = widget.spotId == null;

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
                onPressed: () => context.go('/spots'),
              ),
              const SizedBox(width: 8),
              Text(
                isNew ? l10n.addSpot : l10n.editSpot,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.outline(
                label: l10n.cancel,
                onPressed: () => context.go('/spots'),
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

          // Form - two columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main photo
                    Text(
                      l10n.spotPhoto,
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
                    const SizedBox(height: 24),

                    // Language tabs for name/description
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

                    const SizedBox(height: 24),

                    // Address
                    AdminTextField(
                      label: l10n.spotAddress,
                      controller: _addressController,
                    ),
                    const SizedBox(height: 20),

                    // Coordinates
                    Row(
                      children: [
                        Expanded(
                          child: AdminTextField(
                            label: l10n.latitude,
                            controller: _latController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdminTextField(
                            label: l10n.longitude,
                            controller: _lngController,
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
              const SizedBox(width: 32),

              // Right column - photos gallery and audios
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photos gallery section
                    Text(
                      l10n.spotPhotos,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PhotosGallery(
                      photos: _photos,
                      onChanged: (photos) => setState(() => _photos = photos),
                    ),

                    const SizedBox(height: 32),

                    // Audios section
                    Text(
                      l10n.spotAudios,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _AudiosSection(
                      audios: _audios,
                      onChanged: (audios) => setState(() => _audios = audios),
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
          label: l10n.spotName,
          controller: nameController,
          required: true,
        ),
        const SizedBox(height: 20),
        AdminTextField(
          label: l10n.spotDescription,
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

class _PhotosGallery extends StatelessWidget {
  final List<String> photos;
  final ValueChanged<List<String>> onChanged;

  const _PhotosGallery({required this.photos, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: photos.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.photo_library, size: 32, color: AppColors.textSecondary),
                  const SizedBox(height: 8),
                  Text(
                    l10n.uploadPhoto,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...photos.asMap().entries.map((entry) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          entry.value,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80,
                            height: 80,
                            color: AppColors.background,
                            child: const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () {
                            final newPhotos = List<String>.from(photos);
                            newPhotos.removeAt(entry.key);
                            onChanged(newPhotos);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                // Add photo button
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.add, color: AppColors.textSecondary),
                ),
              ],
            ),
    );
  }
}

class _AudiosSection extends StatelessWidget {
  final List<SpotAudio> audios;
  final ValueChanged<List<SpotAudio>> onChanged;

  const _AudiosSection({required this.audios, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final languages = ['ru', 'en', 'hi'];

    return Column(
      children: languages.map((lang) {
        final audio = audios.where((a) => a.lang == lang).firstOrNull;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                audio != null ? Icons.audiotrack : Icons.audiotrack_outlined,
                size: 18,
                color: audio != null ? AppColors.success : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      audio?.file ?? l10n.noAudio,
                      style: TextStyle(
                        fontSize: 12,
                        color: audio != null ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AdminButton.text(
                label: audio != null ? l10n.replaceFile : l10n.add,
                onPressed: () {
                  // File upload would be handled here
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
