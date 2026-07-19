import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/region_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class RegionsScreen extends ConsumerWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final regionsAsync = ref.watch(regionsProvider);
    final locale = ref.watch(localeProvider).languageCode;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuRegions,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addRegion,
                icon: Icons.add,
                onPressed: () => context.go('/regions/new'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: regionsAsync.when(
              data: (regions) => AdminTable<Region>(
                columns: [
                  AdminTableColumn(
                    header: l10n.regionPhoto,
                    width: 80,
                    cellBuilder: (region) => _RegionPhoto(url: region.mainPhoto),
                  ),
                  AdminTableColumn(
                    header: l10n.regionName,
                    flex: true,
                    cellBuilder: (region) => AdminTableCell(
                      region.name.getByLocale(locale),
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.spotsCount,
                    width: 100,
                    cellBuilder: (region) => AdminTableCell('${region.spotsCount}'),
                  ),
                  AdminTableColumn(
                    header: l10n.order,
                    width: 80,
                    cellBuilder: (region) => AdminTableCell('${region.order}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (region) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => context.go('/regions/${region.id}'),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, region),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: regions,
                onRowTap: (region) => context.go('/regions/${region.id}'),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Region region) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteRegion),
        content: Text('${l10n.confirmDelete} "${region.name.ru}"?'),
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
        await client!.deleteRegion(region.id);
      }
      ref.invalidate(regionsProvider);
    }
  }
}

class _RegionPhoto extends StatelessWidget {
  final String? url;

  const _RegionPhoto({this.url});

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
        child: const Icon(Icons.location_city, color: AppColors.textSecondary),
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
