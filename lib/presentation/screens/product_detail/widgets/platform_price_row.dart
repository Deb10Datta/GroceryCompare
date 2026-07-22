import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/bookmark_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency.dart';
import '../../../../data/models/bookmark.dart';
import '../../../../data/models/coupon.dart';
import '../../../../data/models/grocery_platform.dart';
import '../../../../data/models/product.dart';
import '../../../widgets/countdown_text.dart';
import '../../../widgets/platform_badge.dart';

class PlatformPriceRow extends StatelessWidget {
  final Product product;
  final GroceryPlatform platform;
  final double basePrice;
  final double effectivePrice;
  final Coupon? coupon;
  final bool isBest;

  const PlatformPriceRow({
    super.key,
    required this.product,
    required this.platform,
    required this.basePrice,
    required this.effectivePrice,
    required this.coupon,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return isBest ? _buildHeroCard(context, theme) : _buildPlainRow(context, theme);
  }

  /// The prototype's "CHEAPEST RIGHT NOW" gradient treatment — reserved for
  /// the top pick, so the single price that actually matters reads as the
  /// clear hero of the comparison list rather than just another row.
  Widget _buildHeroCard(BuildContext context, ThemeData theme) {
    final palette = theme.extension<AppPalette>()!;
    final onGradient = palette.onGradient;
    final savings = basePrice - effectivePrice;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: palette.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'CHEAPEST RIGHT NOW',
                style: TextStyle(
                  color: onGradient,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (savings > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: onGradient.withValues(alpha: 0.24),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Save ${formatCurrency(savings)}',
                    style: TextStyle(color: onGradient, fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
              BlocBuilder<BookmarkBloc, List<Bookmark>>(
                builder: (context, bookmarks) {
                  final saved = context.read<BookmarkBloc>().isBookmarked(product.id, platform.id);
                  return IconButton(
                    icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                    tooltip: coupon == null ? 'No active coupon to bookmark' : 'Bookmark offer',
                    style: IconButton.styleFrom(foregroundColor: onGradient),
                    onPressed: coupon == null
                        ? null
                        : () => context.read<BookmarkBloc>().add(
                              BookmarkToggled(productId: product.id, platformId: platform.id),
                            ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PlatformBadge(platform: platform, size: 30),
              const SizedBox(width: 10),
              Text(
                formatCurrency(effectivePrice),
                style: theme.textTheme.headlineMedium?.copyWith(color: onGradient, height: 0.9),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'at ${platform.name}',
                  style: TextStyle(color: onGradient.withValues(alpha: 0.9), fontSize: 13),
                ),
              ),
              if (effectivePrice < basePrice) ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    formatCurrency(basePrice),
                    style: TextStyle(
                      color: onGradient.withValues(alpha: 0.75),
                      decoration: TextDecoration.lineThrough,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (coupon != null) ...[
            const SizedBox(height: 10),
            Text(
              'Code ${coupon!.code} · min order ${formatCurrency(coupon!.minBasketValue)}',
              style: TextStyle(color: onGradient.withValues(alpha: 0.9), fontSize: 12),
            ),
            CountdownText(
              expiresAt: coupon!.expiresAt,
              style: TextStyle(color: onGradient.withValues(alpha: 0.9), fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlainRow(BuildContext context, ThemeData theme) {
    final palette = theme.extension<AppPalette>()!;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlatformBadge(platform: platform),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(platform.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (coupon != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Code ${coupon!.code} · min order ${formatCurrency(coupon!.minBasketValue)}',
                      style: theme.textTheme.bodySmall,
                    ),
                    CountdownText(
                      expiresAt: coupon!.expiresAt,
                      style: theme.textTheme.bodySmall?.copyWith(color: palette.urgent),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (effectivePrice < basePrice)
                  Text(
                    formatCurrency(basePrice),
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                Text(
                  formatCurrency(effectivePrice),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            BlocBuilder<BookmarkBloc, List<Bookmark>>(
              builder: (context, bookmarks) {
                final saved =
                    context.read<BookmarkBloc>().isBookmarked(product.id, platform.id);
                return IconButton(
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
                  tooltip: coupon == null ? 'No active coupon to bookmark' : 'Bookmark offer',
                  onPressed: coupon == null
                      ? null
                      : () => context.read<BookmarkBloc>().add(
                            BookmarkToggled(productId: product.id, platformId: platform.id),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
