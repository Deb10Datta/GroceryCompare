import 'package:compare_grocery/data/repositories/catalog_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final catalog = CatalogRepository();

  test('every product has a price offer on every platform', () {
    for (final product in catalog.products) {
      for (final platform in catalog.platforms) {
        expect(
          () => catalog.priceOf(product.id, platform.id),
          returnsNormally,
          reason: 'Missing price for ${product.id} on ${platform.id}',
        );
      }
    }
  });

  test('every platform has exactly one coupon', () {
    for (final platform in catalog.platforms) {
      expect(catalog.couponForPlatform(platform.id), isNotNull);
    }
  });

  test('every product belongs to a known category', () {
    final categoryIds = catalog.categories.map((c) => c.id).toSet();
    for (final product in catalog.products) {
      expect(categoryIds.contains(product.categoryId), isTrue,
          reason: '${product.id} has unknown category ${product.categoryId}');
    }
  });
}
