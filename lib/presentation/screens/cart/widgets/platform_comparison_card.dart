import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/currency.dart';
import '../../../../data/models/payment_method.dart';
import '../../../../domain/cart_comparator.dart';
import '../../../widgets/floating_tile.dart';
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
    final theme = Theme.of(context);
    final palette = theme.extension<AppPalette>()!;
    final coupon = total.coupon;
    final missingForCoupon = (coupon != null && !total.couponApplied)
        ? coupon.minBasketValue - total.rawTotal
        : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FloatingTile(
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: isBest
              ? RoundedRectangleBorder(
                  side: BorderSide(color: palette.success, width: 1.6),
                  borderRadius: BorderRadius.circular(22),
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
                      child: Text(
                        total.platform.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
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
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                Text(
                  formatCurrency(total.finalTotal),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                if (total.couponApplied)
                  Text(
                    '✅ ${coupon!.code} applied · saved ${formatCurrency(total.rawTotal - total.afterCoupon)}',
                  )
                else if (coupon != null)
                  Text(
                    'Add ${formatCurrency(missingForCoupon)} more to unlock ${coupon.code}',
                    style: TextStyle(color: palette.urgent),
                  ),
                if (total.paymentOfferApplied)
                  Text(
                    '✅ ${total.paymentOffer!.method.emoji} ${total.paymentOffer!.method.label} offer applied '
                    '· saved ${formatCurrency(total.afterCoupon - total.finalTotal)}',
                  )
                else if (total.paymentOffer != null)
                  Text(
                    'Add ${formatCurrency(total.paymentOffer!.minBasketValue - total.rawTotal)} more '
                    'to unlock the ${total.paymentOffer!.method.label} offer',
                    style: TextStyle(color: palette.urgent),
                  ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: onCheckout,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text('Buy on ${total.platform.name}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
