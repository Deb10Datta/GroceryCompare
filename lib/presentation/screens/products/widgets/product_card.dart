import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/currency.dart';
import '../../../../data/models/product.dart';
import '../../../../data/repositories/catalog_repository.dart';
import '../../../widgets/app_icon_tile.dart';
import '../../../widgets/platform_badge.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    var bestPrice = double.infinity;
    var bestBase = 0.0;
    var bestPlatform = catalog.platforms.first;
    String? bestCouponCode;
    double? bestMinBasket;

    for (final platform in catalog.platforms) {
      final base = catalog.priceOf(product.id, platform.id);
      final coupon = catalog.couponForPlatform(platform.id);
      final discount = coupon?.previewDiscount(base) ?? 0;
      final effective = base - discount;
      if (effective < bestPrice) {
        bestPrice = effective;
        bestBase = base;
        bestPlatform = platform;
        bestCouponCode = discount > 0 ? coupon!.code : null;
        bestMinBasket = discount > 0 ? coupon!.minBasketValue : null;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        onTap: () => context.push('/product/${product.id}'),
        leading: AppIconTile(
          emoji: product.emoji,
          color: catalog.categoryById(product.categoryId).color,
        ),
        title: Text('${product.name} · ${product.unit}'),
        subtitle: Row(
          children: [
            PlatformBadge(platform: bestPlatform, size: 22),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                bestCouponCode != null
                    ? 'Code $bestCouponCode · min order ${formatCurrency(bestMinBasket!)}'
                    : 'Best price on ${bestPlatform.name}',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (bestPrice < bestBase)
              Text(
                formatCurrency(bestBase),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            Text(
              formatCurrency(bestPrice),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
