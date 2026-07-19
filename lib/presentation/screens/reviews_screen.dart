import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/l10n/app_localizations.dart';
import '../../data/models/review_model.dart';
import '../providers/data_providers.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin_table.dart';
import '../widgets/admin_button.dart';

class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final approvalFilter = ref.watch(reviewApprovalFilterProvider);
    final fromDate = ref.watch(reviewFromDateProvider);
    final toDate = ref.watch(reviewToDateProvider);

    final query = ReviewQuery(
      isApproved: approvalFilter,
      fromDate: fromDate,
      toDate: toDate,
    );
    final reviewsAsync = ref.watch(reviewsProvider(query));

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                l10n.menuReviews,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Filter buttons
              _FilterChip(
                label: l10n.reviewAll,
                selected: approvalFilter == null,
                onTap: () => ref.read(reviewApprovalFilterProvider.notifier).state = null,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: l10n.reviewPending,
                selected: approvalFilter == false,
                onTap: () => ref.read(reviewApprovalFilterProvider.notifier).state = false,
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: l10n.reviewApproved,
                selected: approvalFilter == true,
                onTap: () => ref.read(reviewApprovalFilterProvider.notifier).state = true,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: reviewsAsync.when(
              data: (response) => AdminTable<Review>(
                columns: [
                  AdminTableColumn(
                    header: l10n.reviewSpot,
                    width: 150,
                    cellBuilder: (review) => AdminTableCell(
                      review.spotId,
                      bold: true,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.reviewAuthor,
                    width: 150,
                    cellBuilder: (review) => AdminTableCell(review.authorName),
                  ),
                  AdminTableColumn(
                    header: l10n.reviewRating,
                    width: 80,
                    cellBuilder: (review) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${review.rating}'),
                      ],
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.reviewText,
                    flex: true,
                    cellBuilder: (review) => AdminTableCell(
                      review.text,
                      maxLines: 2,
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.reviewDate,
                    width: 120,
                    cellBuilder: (review) => AdminTableCell(
                      _formatDate(review.createdAt),
                    ),
                  ),
                  AdminTableColumn(
                    header: l10n.reviewStatus,
                    width: 100,
                    cellBuilder: (review) => _StatusBadge(isApproved: review.isApproved),
                  ),
                  AdminTableColumn(
                    header: '',
                    width: 100,
                    cellBuilder: (review) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!review.isApproved)
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, size: 18),
                            onPressed: () => _approveReview(context, ref, review),
                            color: AppColors.success,
                            tooltip: l10n.reviewApprove,
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _confirmDelete(context, ref, review),
                          color: AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ],
                data: response.data,
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Future<void> _approveReview(BuildContext context, WidgetRef ref, Review review) async {
    final config = ref.read(appConfigProvider);
    if (!(config?.isMockMode ?? true)) {
      final client = ref.read(apiClientProvider);
      await client!.approveReview(review.id);
    }
    ref.invalidate(reviewsProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Review review) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReview),
        content: Text('${l10n.confirmDelete}?'),
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
        await client!.deleteReview(review.id);
      }
      ref.invalidate(reviewsProvider);
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isApproved;

  const _StatusBadge({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isApproved ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isApproved ? l10n.reviewApproved : l10n.reviewPending,
        style: TextStyle(
          color: isApproved ? AppColors.success : AppColors.warning,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
