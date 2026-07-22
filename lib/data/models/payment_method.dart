enum PaymentMethod { upi, creditCard, debitCard, netBanking, wallet, cod }

extension PaymentMethodX on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.upi => 'UPI',
        PaymentMethod.creditCard => 'Credit Card',
        PaymentMethod.debitCard => 'Debit Card',
        PaymentMethod.netBanking => 'Net Banking',
        PaymentMethod.wallet => 'Wallet',
        PaymentMethod.cod => 'Cash on Delivery',
      };

  String get emoji => switch (this) {
        PaymentMethod.upi => '📱',
        PaymentMethod.creditCard => '💳',
        PaymentMethod.debitCard => '🏧',
        PaymentMethod.netBanking => '🏦',
        PaymentMethod.wallet => '👛',
        PaymentMethod.cod => '💵',
      };

  /// Question shown above the provider chips once the method is ticked.
  String get providerPrompt => switch (this) {
        PaymentMethod.upi => 'Which UPI apps do you use?',
        PaymentMethod.creditCard => 'Who issued your credit cards?',
        PaymentMethod.debitCard => 'Which banks issued your debit cards?',
        PaymentMethod.netBanking => 'Which banks do you net-bank with?',
        PaymentMethod.wallet => 'Which wallets do you keep loaded?',
        PaymentMethod.cod => '',
      };

  /// Providers the user can record under this method — UPI apps, card
  /// issuers, net-banking banks, wallets. Cash on Delivery has none.
  List<String> get providers => switch (this) {
        PaymentMethod.upi => const [
            'Google Pay',
            'PhonePe',
            'Paytm UPI',
            'BHIM',
            'Amazon Pay UPI',
            'CRED',
            'WhatsApp Pay',
          ],
        PaymentMethod.creditCard => const [
            'HDFC Bank',
            'SBI Card',
            'ICICI Bank',
            'Axis Bank',
            'Kotak',
            'American Express',
            'RBL Bank',
          ],
        PaymentMethod.debitCard => const [
            'SBI',
            'HDFC Bank',
            'ICICI Bank',
            'Axis Bank',
            'Kotak',
            'PNB',
            'Bank of Baroda',
            'Canara Bank',
          ],
        PaymentMethod.netBanking => const [
            'SBI',
            'HDFC Bank',
            'ICICI Bank',
            'Axis Bank',
            'Kotak',
            'PNB',
            'Bank of Baroda',
            'Yes Bank',
            'IDFC First',
          ],
        PaymentMethod.wallet => const [
            'Paytm Wallet',
            'Amazon Pay',
            'Mobikwik',
            'Freecharge',
            'Airtel Money',
          ],
        PaymentMethod.cod => const [],
      };
}
