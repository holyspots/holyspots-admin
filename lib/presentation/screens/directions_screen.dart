import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/direction_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class DirectionsScreen extends ConsumerWidget {
  const DirectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedRegionId = ref.watch(selectedRegionIdProvider);
    final directionsAsync = ref.watch(directionsProvider(selectedRegionId));
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
                l10n.menuDirections,
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
                label: l10n.addDirection,
                icon: Icons.add,
                onPressed: () => context.go('/directions/new'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: directionsAsync.when(
              data: (directions) => AdminTable<Direction>(
                columns: [
                  AdminTableColumn(
                    header: l10n.directionTitle,
                    flex: true,
                    cellBuilder: (direction) => AdminTableCell(
                      direction.title.getByLocale(locale),
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.directionType,
                    width: 120,
                    cellBuilder: (direction) => _TypeBadge(type: direction.type),
                  ),
                  AdminTableColumn(
                    header: l10n.order,
                    width: 80,
                    cellBuilder: (direction) => AdminTableCell('${direction.order}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (direction) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => context.go('/directions/${direction.id}'),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, direction),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: directions,
                onRowTap: (direction) => context.go('/directions/${direction.id}'),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Direction direction) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteDirection),
        content: Text('${l10n.confirmDelete} "${direction.title.ru}"?'),
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
        await client!.deleteDirection(direction.id);
      }
      ref.invalidate(directionsProvider);
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final DirectionType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (icon, color, label) = switch (type) {
      DirectionType.bus => (Icons.directions_bus, Colors.blue, l10n.directionTypeBus),
      DirectionType.train => (Icons.train, Colors.green, l10n.directionTypeTrain),
      DirectionType.plane => (Icons.flight, Colors.purple, l10n.directionTypePlane),
      DirectionType.walk => (Icons.directions_walk, Colors.orange, l10n.directionTypeWalk),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
