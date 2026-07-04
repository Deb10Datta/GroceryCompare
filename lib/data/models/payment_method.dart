enum PaymentMethod { upi, creditCard, debitCard, wallet, cod }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.upi => 'UPI',
        PaymentMethod.creditCard => 'Credit Card',
        PaymentMethod.debitCard => 'Debit Card',
        PaymentMethod.wallet => 'Wallet',
        PaymentMethod.cod => 'Cash on Delivery',
      };

  String get emoji => switch (this) {
        PaymentMethod.upi => '📱',
        PaymentMethod.creditCard => '💳',
        PaymentMethod.debitCard => '💳',
        PaymentMethod.wallet => '👛',
        PaymentMethod.cod => '💵',
      };
}
