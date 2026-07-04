import 'payment_method.dart';

class PaymentOffer {
  final String platformId;
  final PaymentMethod method;
  final double discountPercent;
  final double maxDiscountCap;
  final double minBasketValue;

  const PaymentOffer({
    required this.platformId,
    required this.method,
    required this.discountPercent,
    required this.maxDiscountCap,
    required this.minBasketValue,
  });

  double discountFor(double amount) {
    if (amount < minBasketValue) return 0;
    final raw = amount * discountPercent / 100;
    return raw > maxDiscountCap ? maxDiscountCap : raw;
  }
}
