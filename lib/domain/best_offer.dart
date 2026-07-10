import '../data/models/grocery_platform.dart';
import '../data/models/product.dart';
import '../data/repositories/catalog_repository.dart';

/// The cheapest coupon-adjusted price for a single product across every
/// platform, plus the coupon that produced it (if any).
class BestOffer {
  final GroceryPlatform platform;
  final double basePrice;
  final double effectivePrice;
  final String? couponCode;
  final double? couponMinBasket;

  const BestOffer({
    required this.platform,
    required this.basePrice,
    required this.effectivePrice,
    this.couponCode,
    this.couponMinBasket,
  });

  bool get hasDiscount => effectivePrice < basePrice;
}

/// Pass [platforms] to consider only the stores serving the user's area;
/// defaults to every platform in the catalog.
BestOffer findBestOffer(
  CatalogRepository catalog,
  Product product, {
  List<GroceryPlatform>? platforms,
}) {
  final candidates = platforms ?? catalog.platforms;
  var bestPrice = double.infinity;
  var bestBase = 0.0;
  var bestPlatform = candidates.first;
  String? bestCouponCode;
  double? bestMinBasket;

  for (final platform in candidates) {
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

  return BestOffer(
    platform: bestPlatform,
    basePrice: bestBase,
    effectivePrice: bestPrice,
    couponCode: bestCouponCode,
    couponMinBasket: bestMinBasket,
  );
}
