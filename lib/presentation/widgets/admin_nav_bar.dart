import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class AdminNavBar extends ConsumerWidget {
  const AdminNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentPath = GoRouterState.of(context).matchedLocation;
    final config = ref.watch(appConfigProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.menu,
      ),
      child: Wrap(
        spacing: 14,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _NavTab(
            label: l10n.menuSpots,
            isActive: currentPath.startsWith('/spots'),
            onTap: () => context.go('/spots'),
          ),
          _NavTab(
            label: l10n.menuRegions,
            isActive: currentPath.startsWith('/regions'),
            onTap: () => context.go('/regions'),
          ),
          _NavTab(
            label: l10n.menuGuides,
            isActive: currentPath.startsWith('/guides'),
            onTap: () => context.go('/guides'),
          ),
          _NavTab(
            label: l10n.menuMaps,
            isActive: currentPath.startsWith('/maps'),
            onTap: () => context.go('/maps'),
          ),
          _NavTab(
            label: l10n.menuReviews,
            isActive: currentPath.startsWith('/reviews'),
            onTap: () => context.go('/reviews'),
          ),
          _NavTab(
            label: l10n.menuPlaces,
            isActive: currentPath.startsWith('/places'),
            onTap: () => context.go('/places'),
          ),
          _NavTab(
            label: l10n.menuDirections,
            isActive: currentPath.startsWith('/directions'),
            onTap: () => context.go('/directions'),
          ),
          const _WrapSpacer(),
          Text(
            config?.userEmail ?? 'admin',
            style: const TextStyle(
              fontSize: 17,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          _NavTab(
            label: l10n.logout,
            isActive: false,
            onTap: () {
              ref.read(appConfigProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 44,
        constraints: const BoxConstraints(minWidth: 110),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17,
            color: isActive ? Colors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Spacer widget for use in Wrap (private to avoid conflict with Flutter's Spacer)
class _WrapSpacer extends StatelessWidget {
  const _WrapSpacer();

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: SizedBox.shrink());
  }
}
