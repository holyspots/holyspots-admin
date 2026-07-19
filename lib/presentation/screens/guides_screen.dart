import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/guide_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class GuidesScreen extends ConsumerWidget {
  const GuidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final guidesAsync = ref.watch(guidesProvider);
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
                l10n.menuGuides,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              AdminButton.primary(
                label: l10n.addGuide,
                icon: Icons.add,
                onPressed: () => context.go('/guides/new'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: guidesAsync.when(
              data: (guides) => AdminTable<Guide>(
                columns: [
                  AdminTableColumn(
                    header: l10n.guidePhoto,
                    width: 80,
                    cellBuilder: (guide) => _GuidePhoto(url: guide.photo),
                  ),
                  AdminTableColumn(
                    header: l10n.guideName,
                    flex: true,
                    cellBuilder: (guide) => AdminTableCell(
                      guide.name.getByLocale(locale),
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.guidePhone,
                    width: 150,
                    cellBuilder: (guide) => AdminTableCell(guide.phone ?? '-'),
                  ),
                  AdminTableColumn(
                    header: l10n.order,
                    width: 80,
                    cellBuilder: (guide) => AdminTableCell('${guide.order}'),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (guide) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => context.go('/guides/${guide.id}'),
                          color: AppColors.textSecondary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, guide),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: guides,
                onRowTap: (guide) => context.go('/guides/${guide.id}'),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Guide guide) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteGuide),
        content: Text('${l10n.confirmDelete} "${guide.name.ru}"?'),
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
        await client!.deleteGuide(guide.id);
      }
      ref.invalidate(guidesProvider);
    }
  }
}

class _GuidePhoto extends StatelessWidget {
  final String? url;

  const _GuidePhoto({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(25),
        ),
        child: const Icon(Icons.person, color: AppColors.textSecondary),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
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
