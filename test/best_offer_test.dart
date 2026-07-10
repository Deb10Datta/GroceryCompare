import 'package:compare_grocery/data/repositories/catalog_repository.dart';
import 'package:compare_grocery/domain/best_offer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final catalog = CatalogRepository();

  test('best offer only considers the provided platforms', () {
    final product = catalog.products.first;
    final subset = [catalog.platforms.last];
    final best = findBestOffer(catalog, product, platforms: subset);
    expect(best.platform.id, subset.single.id);
  });

  test('restricting platforms never yields a cheaper price than the full set', () {
    final product = catalog.products.first;
    final full = findBestOffer(catalog, product);
    final restricted =
        findBestOffer(catalog, product, platforms: [catalog.platforms.first]);
    expect(restricted.effectivePrice, greaterThanOrEqualTo(full.effectivePrice));
  });
}
