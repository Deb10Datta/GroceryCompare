import '../models/price_offer.dart';
import 'mock_platforms.dart';
import 'mock_products.dart';

// Deterministic per-platform pricing variance so each platform looks
// realistically cheaper/pricier without ever using randomness (keeps
// bookmarked offers stable across app restarts).
const List<double> _platformMultipliers = [1.00, 0.94, 1.06, 0.90, 1.03];

List<PriceOffer> buildMockPriceOffers() {
  final offers = <PriceOffer>[];
  for (var pi = 0; pi < mockProducts.length; pi++) {
    final product = mockProducts[pi];
    for (var ti = 0; ti < mockPlatforms.length; ti++) {
      final platform = mockPlatforms[ti];
      final wobble = ((pi + ti * 3) % 5 - 2) * 0.015;
      final multiplier = _platformMultipliers[ti] + wobble;
      final price = (product.basePrice * multiplier).roundToDouble();
      offers.add(PriceOffer(productId: product.id, platformId: platform.id, price: price));
    }
  }
  return offers;
}
