class Coupon {
  final String platformId;
  final String code;
  final double discountPercent;
  final double maxDiscountCap;
  final double minBasketValue;
  final DateTime expiresAt;

  const Coupon({
    required this.platformId,
    required this.code,
    required this.discountPercent,
    required this.maxDiscountCap,
    required this.minBasketValue,
    required this.expiresAt,
  });

  /// Discount applied only once [amount] (a whole basket total) meets
  /// [minBasketValue] — used for the authoritative cart-level comparison.
  double discountFor(double amount) {
    if (amount < minBasketValue) return 0;
    return _capped(amount);
  }

  /// Discount shown on a single product's price preview, ignoring the
  /// min-basket gate — illustrates "the deal you'd get if you qualify".
  double previewDiscount(double amount) => _capped(amount);

  double _capped(double amount) {
    final raw = amount * discountPercent / 100;
    return raw > maxDiscountCap ? maxDiscountCap : raw;
  }
}
