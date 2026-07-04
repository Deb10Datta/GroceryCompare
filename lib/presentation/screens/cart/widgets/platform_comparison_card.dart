import 'package:flutter/material.dart';

import '../../../../core/utils/currency.dart';
import '../../../../data/models/payment_method.dart';
import '../../../../domain/cart_comparator.dart';
import '../../../widgets/platform_badge.dart';

class PlatformComparisonCard extends StatelessWidget {
  final PlatformTotal total;
  final bool isBest;
  final VoidCallback onCheckout;

  const PlatformComparisonCard({
    super.key,
    required this.total,
    required this.isBest,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final coupon = total.coupon;
    final missingForCoupon =
        (coupon != null && !total.couponApplied) ? coupon.minBasketValue - total.rawTotal : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isBest ? 3 : 1,
      shape: isBest
          ? RoundedRectangleBorder(
              side: const BorderSide(color: Colors.green, width: 1.5),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PlatformBadge(platform: total.platform),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(total.platform.name, style: Theme.of(context).textTheme.titleMedium),
                ),
                if (isBest)
                  const Chip(
                    avatar: Icon(Icons.emoji_events, size: 16),
                    label: Text('Best deal'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (total.finalTotal < total.rawTotal)
              Text(
                formatCurrency(total.rawTotal),
                style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
              ),
            Text(
              formatCurrency(total.finalTotal),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (total.couponApplied)
              Text('✅ ${coupon!.code} applied · saved ${formatCurrency(total.rawTotal - total.afterCoupon)}')
            else if (coupon != null)
              Text(
                'Add ${formatCurrency(missingForCoupon)} more to unlock ${coupon.code}',
                style: const TextStyle(color: Colors.deepOrange),
              ),
            if (total.paymentOfferApplied)
              Text('✅ ${total.paymentOffer!.method.emoji} ${total.paymentOffer!.method.label} offer applied'),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: onCheckout, child: const Text('Place order (demo)')),
            ),
          ],
        ),
      ),
    );
  }
}
