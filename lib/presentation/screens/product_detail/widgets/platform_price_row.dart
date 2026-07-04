import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/bookmark_bloc.dart';
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
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isBest
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
          : null,
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
                  Row(
                    children: [
                      Text(platform.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                      if (isBest) ...[
                        const SizedBox(width: 6),
                        const Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text('Best deal'),
                        ),
                      ],
                    ],
                  ),
                  if (coupon != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Code ${coupon!.code} · min order ${formatCurrency(coupon!.minBasketValue)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    CountdownText(
                      expiresAt: coupon!.expiresAt,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.deepOrange),
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
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: 12,
                      color: Colors.grey,
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
