import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/city_model.dart';
import '../../data/models/spot_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_pagination.dart';

class SpotsScreen extends ConsumerStatefulWidget {
  const SpotsScreen({super.key});

  @override
  ConsumerState<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends ConsumerState<SpotsScreen> {
  String? _selectedCityId;
  int _currentPage = 1;
  static const _itemsPerPage = 20;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider).languageCode;
    final citiesAsync = ref.watch(citiesProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuSpots,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // City filter
              citiesAsync.when(
                data: (cities) => _CityDropdown(
                  cities: cities,
                  selectedId: _selectedCityId,
                  locale: locale,
                  onChanged: (id) => setState(() {
                    _selectedCityId = id;
                    _currentPage = 1;
                  }),
                ),
                loading: () => const SizedBox(width: 200),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 16),
              AdminButton.primary(
                label: l10n.addSpot,
                icon: Icons.add,
                onPressed: _selectedCityId != null
                    ? () => context.go('/spots/new?cityId=$_selectedCityId')
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content
          Expanded(
            child: _selectedCityId == null
                ? Center(
                    child: Text(
                      l10n.selectCity,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  )
                : Consumer(
                    builder: (context, ref, _) {
                      final query = SpotQuery(
                        cityId: _selectedCityId,
                        page: _currentPage,
                        limit: _itemsPerPage,
                      );
                      final spotsAsync = ref.watch(spotsProvider(query));

                      return spotsAsync.when(
                        data: (response) => Column(
                          children: [
                            Expanded(
                              child: AdminTable<Spot>(
                                columns: [
                                  AdminTableColumn(
                                    header: l10n.spotPhoto,
                                    width: 80,
                                    cellBuilder: (s) => _SpotPhoto(url: s.mainPhoto),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.spotName,
                                    flex: true,
                                    cellBuilder: (s) => AdminTableCell(
                                      s.name.getByLocale(locale),
                                      bold: true,
                                    ),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.spotAddress,
                                    width: 200,
                                    cellBuilder: (s) => AdminTableCell(
                                      s.address ?? '—',
                                      secondary: s.address == null,
                                    ),
                                  ),
                                  AdminTableColumn(
                                    header: l10n.spotCoordinates,
                                    width: 150,
                                    cellBuilder: (s) => AdminTableCell(
                                      s.location != null
                                          ? '${s.location!.latitude.toStringAsFixed(4)}, ${s.location!.longitude.toStringAsFixed(4)}'
                                          : '—',
                                      secondary: s.location == null,
                                    ),
                                  ),
                                  AdminTableColumn(
                                    header: '',
                                    width: 100,
                                    cellBuilder: (s) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined, size: 18),
                                          onPressed: () => context.go('/spots/${s.id}'),
                                          color: AppColors.textSecondary,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, size: 18),
                                          onPressed: () => _confirmDelete(context, ref, s),
                                          color: AppColors.error,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                data: response.data,
                                onRowTap: (s) => context.go('/spots/${s.id}'),
                              ),
                            ),
                            AdminPagination(
                              currentPage: response.pagination.page,
                              totalPages: response.pagination.totalPages,
                              totalItems: response.pagination.total,
                              itemsPerPage: response.pagination.limit,
                              onPageChanged: (page) => setState(() => _currentPage = page),
                            ),
                          ],
                        ),
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                        error: (e, _) => Center(
                          child: Text('${l10n.error}: $e'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Spot spot) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSpot),
        content: Text('${l10n.confirmDelete} "${spot.name.ru}"?'),
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
        await client!.deleteSpot(spot.id);
      }
      ref.invalidate(spotsProvider);
    }
  }
}

class _CityDropdown extends StatelessWidget {
  final List<City> cities;
  final String? selectedId;
  final String locale;
  final void Function(String?) onChanged;

  const _CityDropdown({
    required this.cities,
    required this.selectedId,
    required this.locale,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selectedId,
          isExpanded: true,
          hint: Text(l10n.selectCity),
          items: cities
              .map((city) => DropdownMenuItem(
                    value: city.id,
                    child: Text(
                      city.name.getByLocale(locale),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SpotPhoto extends StatelessWidget {
  final String? url;

  const _SpotPhoto({this.url});

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
