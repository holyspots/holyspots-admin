import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/offline_map_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class MapsScreen extends ConsumerWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mapsAsync = ref.watch(mapsProvider);
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
                l10n.menuMaps,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addMap,
                icon: Icons.add,
                onPressed: () => context.go('/maps/new'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: mapsAsync.when(
              data: (maps) => AdminTable<OfflineMap>(
                columns: [
                  AdminTableColumn(
                    header: l10n.mapName,
                    flex: true,
                    cellBuilder: (map) => AdminTableCell(
                      map.name.getByLocale(locale),
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.mapRegion,
                    width: 150,
                    cellBuilder: (map) => AdminTableCell(map.regionId ?? '-'),
                  ),
                  AdminTableColumn(
                    header: l10n.mapSize,
                    width: 100,
                    cellBuilder: (map) => AdminTableCell(_formatSize(map.sizeBytes)),
                  ),
                  AdminTableColumn(
                    header: l10n.mapVersion,
                    width: 100,
                    cellBuilder: (map) => AdminTableCell(map.version),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (map) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => context.go('/maps/${map.id}'),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, map),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: maps,
                onRowTap: (map) => context.go('/maps/${map.id}'),
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

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, OfflineMap map) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMap),
        content: Text('${l10n.confirmDelete} "${map.name.ru}"?'),
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
        await client!.deleteMap(map.id);
      }
      ref.invalidate(mapsProvider);
    }
  }
}
