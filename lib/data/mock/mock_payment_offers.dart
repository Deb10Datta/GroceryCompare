import '../models/payment_method.dart';
import '../models/payment_offer.dart';

const List<PaymentOffer> mockPaymentOffers = [
  PaymentOffer(
    platformId: 'blinkit',
    method: PaymentMethod.upi,
    discountPercent: 10,
    maxDiscountCap: 40,
    minBasketValue: 149,
  ),
  PaymentOffer(
    platformId: 'zepto',
    method: PaymentMethod.creditCard,
    discountPercent: 15,
    maxDiscountCap: 75,
    minBasketValue: 199,
  ),
  PaymentOffer(
    platformId: 'instamart',
    method: PaymentMethod.wallet,
    discountPercent: 12,
    maxDiscountCap: 50,
    minBasketValue: 199,
  ),
  PaymentOffer(
    platformId: 'bigbasket',
    method: PaymentMethod.debitCard,
    discountPercent: 8,
    maxDiscountCap: 60,
    minBasketValue: 299,
  ),
  PaymentOffer(
    platformId: 'jiomart',
    method: PaymentMethod.upi,
    discountPercent: 10,
    maxDiscountCap: 50,
    minBasketValue: 199,
  ),
];
