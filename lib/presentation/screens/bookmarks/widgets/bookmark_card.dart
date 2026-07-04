import 'package:flutter/material.dart';

import '../../../../core/utils/currency.dart';
import '../../../../data/models/coupon.dart';
import '../../../../data/models/grocery_platform.dart';
import '../../../../data/models/product.dart';
import '../../../widgets/countdown_text.dart';
import '../../../widgets/platform_badge.dart';

class BookmarkCard extends StatelessWidget {
  final Product product;
  final GroceryPlatform platform;
  final Coupon? coupon;
  final double basePrice;
  final double effectivePrice;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const BookmarkCard({
    super.key,
    required this.product,
    required this.platform,
    required this.coupon,
    required this.basePrice,
    required this.effectivePrice,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: PlatformBadge(platform: platform),
        title: Text('${product.emoji} ${product.name}'),
        subtitle: coupon == null
            ? const Text('No active coupon on this platform right now')
            : CountdownText(
                expiresAt: coupon!.expiresAt,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.deepOrange),
              ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (effectivePrice < basePrice)
              Text(
                formatCurrency(basePrice),
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            Text(formatCurrency(effectivePrice), style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.bookmark_remove_outlined, size: 20),
              onPressed: onRemove,
              tooltip: 'Remove bookmark',
            ),
          ],
        ),
      ),
    );
  }
}
