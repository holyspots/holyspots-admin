import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/place_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedRegionId = ref.watch(selectedRegionIdProvider);
    final placesAsync = ref.watch(placesProvider(selectedRegionId));
    final locale = ref.watch(localeProvider).languageCode;
    final regionsAsync = ref.watch(regionsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuPlaces,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 24),
              // Region filter
              SizedBox(
                width: 200,
                child: regionsAsync.when(
                  data: (regions) => DropdownButtonFormField<String?>(
                    value: selectedRegionId,
                    decoration: InputDecoration(
                      labelText: l10n.filterByRegion,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem<String?>(value: null, child: Text(l10n.allRegions)),
                      ...regions.map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Text(r.name.getByLocale(locale)),
                      )),
                    ],
                    onChanged: (v) => ref.read(selectedRegionIdProvider.notifier).state = v,
                  ),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addPlace,
                icon: Icons.add,
                onPressed: () => context.go('/places/new'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: placesAsync.when(
              data: (places) => AdminTable<Place>(
                columns: [
                  AdminTableColumn(
                    header: l10n.placePhoto,
                    width: 80,
                    cellBuilder: (place) => _PlacePhoto(url: place.mainPhoto),
                  ),
                  AdminTableColumn(
                    header: l10n.placeName,
                    flex: true,
                    cellBuilder: (place) => AdminTableCell(
                      place.name.getByLocale(locale),
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.placeType,
                    width: 120,
                    cellBuilder: (place) => _TypeBadge(type: place.type),
                  ),
                  AdminTableColumn(
                    header: l10n.placeAddress,
                    width: 200,
                    cellBuilder: (place) => AdminTableCell(
                      place.address.getByLocale(locale),
                      maxLines: 2,
                    ),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (place) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => context.go('/places/${place.id}'),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, place),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: places,
                onRowTap: (place) => context.go('/places/${place.id}'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (e, _) => Center(
                child: Text('${l10n.error}: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Place place) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deletePlace),
        content: Text('${l10n.confirmDelete} "${place.name.ru}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final config = ref.read(appConfigProvider);
      if (!(config?.isMockMode ?? true)) {
        final client = ref.read(apiClientProvider);
        await client!.deletePlace(place.id);
      }
      ref.invalidate(placesProvider);
    }
  }
}

class _PlacePhoto extends StatelessWidget {
  final String? url;

  const _PlacePhoto({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.place, color: AppColors.textSecondary),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        url!,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 50,
          height: 50,
          color: AppColors.background,
          child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final PlaceType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHotel = type == PlaceType.hotel;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHotel ? Colors.blue.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHotel ? Icons.hotel : Icons.restaurant,
            size: 14,
            color: isHotel ? Colors.blue : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            isHotel ? l10n.placeTypeHotel : l10n.placeTypeFood,
            style: TextStyle(
              color: isHotel ? Colors.blue : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
