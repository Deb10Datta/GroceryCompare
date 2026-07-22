import 'package:compare_grocery/data/models/payment_method.dart';
import 'package:compare_grocery/data/repositories/catalog_repository.dart';
import 'package:compare_grocery/domain/cart_comparator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final catalog = CatalogRepository();
  final comparator = CartComparator(catalog);

  test('sorts platform totals ascending by final total', () {
    final cart = {for (final p in catalog.products.take(3)) p.id: 2};
    final totals = comparator.compare(cart, {PaymentMethod.upi});

    expect(totals.length, catalog.platforms.length);
    for (var i = 1; i < totals.length; i++) {
      expect(totals[i].finalTotal, greaterThanOrEqualTo(totals[i - 1].finalTotal));
    }
  });

  test('coupon only applies once the raw basket total meets its min basket value', () {
    final product = catalog.products.first;
    final smallCart = {product.id: 1};
    final totals = comparator.compare(smallCart, {PaymentMethod.upi});

    for (final total in totals) {
      final coupon = total.coupon;
      if (coupon != null && total.rawTotal < coupon.minBasketValue) {
        expect(total.couponApplied, isFalse);
        expect(total.afterCoupon, total.rawTotal);
      }
    }
  });

  test('coupon applies and reduces the total once min basket value is met', () {
    final bigCart = {for (final p in catalog.products) p.id: 3};
    final totals = comparator.compare(bigCart, {PaymentMethod.upi});

    for (final total in totals) {
      final coupon = total.coupon;
      if (coupon != null && total.rawTotal >= coupon.minBasketValue) {
        expect(total.couponApplied, isTrue);
        expect(total.afterCoupon, lessThan(total.rawTotal));
      }
    }
  });

  test('payment offer only applies when it matches a method the user owns', () {
    final bigCart = {for (final p in catalog.products) p.id: 3};
    final totals = comparator.compare(bigCart, {PaymentMethod.upi});

    for (final total in totals) {
      if (total.paymentOfferApplied) {
        expect(total.paymentOffer!.method, PaymentMethod.upi);
        expect(total.finalTotal, lessThan(total.afterCoupon));
      }
    }
  });

  test('owning no offered method leaves only default coupon discounts', () {
    final bigCart = {for (final p in catalog.products) p.id: 3};
    final totals = comparator.compare(bigCart, <PaymentMethod>{});

    for (final total in totals) {
      expect(total.paymentOffer, isNull);
      expect(total.paymentOfferApplied, isFalse);
      expect(total.finalTotal, total.afterCoupon);
    }
  });

  test('picks the best offer when several match the owned methods', () {
    // Blinkit runs both a UPI offer (cap ₹40) and a credit-card offer
    // (cap ₹60); a user owning both should get the bigger discount.
    final bigCart = {for (final p in catalog.products) p.id: 3};
    final totals = comparator.compare(
      bigCart,
      {PaymentMethod.upi, PaymentMethod.creditCard},
    );

    final blinkit = totals.firstWhere((t) => t.platform.id == 'blinkit');
    expect(blinkit.paymentOffer!.method, PaymentMethod.creditCard);
    expect(blinkit.paymentOfferApplied, isTrue);
  });

  test('final total is never more than the raw total', () {
    final cart = {for (final p in catalog.products) p.id: 1};
    for (final method in PaymentMethod.values) {
      final totals = comparator.compare(cart, {method});
      for (final total in totals) {
        expect(total.finalTotal, lessThanOrEqualTo(total.rawTotal));
      }
    }
  });
}
