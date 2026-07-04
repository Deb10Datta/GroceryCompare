import 'package:intl/intl.dart';

final NumberFormat _currencyFormat =
    NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

String formatCurrency(double amount) => _currencyFormat.format(amount);
