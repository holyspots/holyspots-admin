import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/dimens.dart';
import '../../core/constants/typography.dart';
import '../../core/l10n/app_localizations.dart';
import 'admin_nav_bar.dart';
import 'language_toggle.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Title bar (window chrome simulation)
          Container(
            height: AppDimens.titleBarHeight,
            decoration: const BoxDecoration(
              color: AppColors.titleBar,
              border: Border(
                bottom: BorderSide(color: AppColors.titleBarBorder),
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: Text(
                            'H',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${l10n.appTitle} — ${l10n.adminPanel}',
                        style: AppTypography.windowTitle,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: LanguageToggle(),
                ),
                _WindowButton(icon: '─', onTap: () {}),
                _WindowButton(icon: '□', onTap: () {}),
                _WindowButton(icon: '✕', onTap: () {}),
              ],
            ),
          ),

          // Horizontal navigation bar
          const AdminNavBar(),

          // Content
          Expanded(
            child: Container(
              color: AppColors.surface,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _WindowButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _WindowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 46,
        height: AppDimens.titleBarHeight,
        child: Center(
          child: Text(
            icon,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF575F6A),
            ),
          ),
        ),
      ),
    );
  }
}
