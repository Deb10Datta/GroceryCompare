import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../../domain/best_offer.dart';
import '../../../helpers/serving_platforms.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/floating_tile.dart';
import '../../../widgets/platform_badge.dart';

/// BuyHatke-style vertical product card: artwork on top, name and unit,
/// then the cheapest cross-platform price with the winning platform badge.
/// Height must be bounded by the parent (horizontal row or grid extent).
class ProductGridCard extends StatelessWidget {
  final Product product;

  const ProductGridCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    // Best price hunted only across the stores that deliver to the user.
    final best = findBestOffer(
      catalog,
      product,
      platforms: watchServingPlatforms(context),
    );
    final category = catalog.categoryById(product.categoryId);
    final theme = Theme.of(context);

    return FloatingTile(
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/product/${product.id}'),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AppIconTile(
                    emoji: product.emoji,
                    color: category.color,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.displayName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  product.unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    PlatformBadge(platform: best.platform, size: 18),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        best.couponCode != null
                            ? 'Code ${best.couponCode}'
                            : 'Lowest on ${best.platform.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.extension<AppPalette>()!.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatCurrency(best.effectivePrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (best.hasDiscount) ...[
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(
                          formatCurrency(best.basePrice),
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
