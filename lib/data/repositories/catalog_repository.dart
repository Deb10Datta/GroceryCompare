import '../mock/mock_categories.dart';
import '../mock/mock_coupons.dart';
import '../mock/mock_payment_offers.dart';
import '../mock/mock_platforms.dart';
import '../mock/mock_price_offers.dart';
import '../mock/mock_products.dart';
import '../models/coupon.dart';
import '../models/grocery_category.dart';
import '../models/grocery_platform.dart';
import '../models/payment_offer.dart';
import '../models/price_offer.dart';
import '../models/product.dart';

/// Read-only catalog of platforms, products, prices, coupons and payment
/// offers. Backed by static mock data today, but every lookup is behind
/// this repository so a real pricing API could be swapped in later.
class CatalogRepository {
  CatalogRepository()
      : platforms = mockPlatforms,
        categories = mockCategories,
        products = mockProducts,
        priceOffers = buildMockPriceOffers(),
        coupons = buildMockCoupons(),
        paymentOffers = mockPaymentOffers;

  final List<GroceryPlatform> platforms;
  final List<GroceryCategory> categories;
  final List<Product> products;
  final List<PriceOffer> priceOffers;
  final List<Coupon> coupons;
  final List<PaymentOffer> paymentOffers;

  GroceryPlatform platformById(String id) =>
      platforms.firstWhere((p) => p.id == id);

  Product productById(String id) => products.firstWhere((p) => p.id == id);

  GroceryCategory categoryById(String id) =>
      categories.firstWhere((c) => c.id == id);

  List<Product> productsByCategory(String categoryId) =>
      products.where((p) => p.categoryId == categoryId).toList();

  double priceOf(String productId, String platformId) {
    for (final offer in priceOffers) {
      if (offer.productId == productId && offer.platformId == platformId) {
        return offer.price;
      }
    }
    throw StateError('No price offer for $productId on $platformId');
  }

  Coupon? couponForPlatform(String platformId) {
    for (final coupon in coupons) {
      if (coupon.platformId == platformId) return coupon;
    }
    return null;
  }

  List<PaymentOffer> paymentOffersFor(String platformId) =>
      paymentOffers.where((o) => o.platformId == platformId).toList();
}
