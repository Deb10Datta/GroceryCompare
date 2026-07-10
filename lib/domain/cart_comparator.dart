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
/// basket value) and the user's preferred-payment offer are applied.
class CartComparator {
  const CartComparator(this.catalog);

  final CatalogRepository catalog;

  /// Pass [platforms] to compare only the stores actually serving the
  /// user's area; defaults to every platform in the catalog.
  List<PlatformTotal> compare(
    Map<String, int> cartItems,
    PaymentMethod preferredPayment, {
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
      for (final offer in catalog.paymentOffersFor(platform.id)) {
        if (offer.method == preferredPayment) {
          paymentOffer = offer;
          break;
        }
      }
      final paymentDiscount = paymentOffer?.discountFor(rawTotal) ?? 0;
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
