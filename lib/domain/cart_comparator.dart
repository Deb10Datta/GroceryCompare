import '../data/models/coupon.dart';
import '../data/models/grocery_platform.dart';
import '../data/models/payment_method.dart';
import '../data/models/payment_offer.dart';
import '../data/repositories/catalog_repository.dart';

class PlatformTotal {
  final GroceryPlatform platform;
  final double rawTotal;
  final double afterCoupon;
  final double finalTotal;
  final Coupon? coupon;
  final bool couponApplied;
  final PaymentOffer? paymentOffer;
  final bool paymentOfferApplied;

  const PlatformTotal({
    required this.platform,
    required this.rawTotal,
    required this.afterCoupon,
    required this.finalTotal,
    required this.coupon,
    required this.couponApplied,
    required this.paymentOffer,
    required this.paymentOfferApplied,
  });

  double get totalSavings => rawTotal - finalTotal;
}

/// Computes, for a cart of productId->quantity, what the basket would cost
/// on each platform after that platform's active coupon (gated on minimum
/// basket value) and the best payment offer matching a method the user has
/// on record are applied. When a platform runs no offer for any of the
/// user's methods, only its default coupon codes count.
class CartComparator {
  const CartComparator(this.catalog);

  final CatalogRepository catalog;

  /// Pass [platforms] to compare only the stores actually serving the
  /// user's area; defaults to every platform in the catalog.
  List<PlatformTotal> compare(
    Map<String, int> cartItems,
    Set<PaymentMethod> ownedMethods, {
    List<GroceryPlatform>? platforms,
  }) {
    final results = <PlatformTotal>[];
    for (final platform in platforms ?? catalog.platforms) {
      var rawTotal = 0.0;
      for (final entry in cartItems.entries) {
        rawTotal += catalog.priceOf(entry.key, platform.id) * entry.value;
      }

      final coupon = catalog.couponForPlatform(platform.id);
      final couponDiscount = coupon?.discountFor(rawTotal) ?? 0;
      final afterCoupon = rawTotal - couponDiscount;

      PaymentOffer? paymentOffer;
      var paymentDiscount = 0.0;
      for (final offer in catalog.paymentOffersFor(platform.id)) {
        if (!ownedMethods.contains(offer.method)) continue;
        final discount = offer.discountFor(rawTotal);
        if (paymentOffer == null || discount > paymentDiscount) {
          paymentOffer = offer;
          paymentDiscount = discount;
        }
      }
      final finalTotal = afterCoupon - paymentDiscount;

      results.add(PlatformTotal(
        platform: platform,
        rawTotal: rawTotal,
        afterCoupon: afterCoupon,
        finalTotal: finalTotal,
        coupon: coupon,
        couponApplied: couponDiscount > 0,
        paymentOffer: paymentOffer,
        paymentOfferApplied: paymentDiscount > 0,
      ));
    }
    results.sort((a, b) => a.finalTotal.compareTo(b.finalTotal));
    return results;
  }
}
