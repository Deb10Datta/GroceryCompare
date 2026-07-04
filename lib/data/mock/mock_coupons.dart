import '../models/coupon.dart';

// Expiries are anchored to app-launch time so the countdown demo always
// has live offers to show.
List<Coupon> buildMockCoupons() {
  final now = DateTime.now();
  return [
    Coupon(
      platformId: 'blinkit',
      code: 'BKFRESH20',
      discountPercent: 20,
      maxDiscountCap: 40,
      minBasketValue: 199,
      expiresAt: now.add(const Duration(hours: 6)),
    ),
    Coupon(
      platformId: 'zepto',
      code: 'ZAP15',
      discountPercent: 15,
      maxDiscountCap: 60,
      minBasketValue: 249,
      expiresAt: now.add(const Duration(hours: 18)),
    ),
    Coupon(
      platformId: 'instamart',
      code: 'SWIGGY10',
      discountPercent: 10,
      maxDiscountCap: 50,
      minBasketValue: 149,
      expiresAt: now.add(const Duration(days: 1, hours: 4)),
    ),
    Coupon(
      platformId: 'bigbasket',
      code: 'BBBIG25',
      discountPercent: 25,
      maxDiscountCap: 75,
      minBasketValue: 349,
      expiresAt: now.add(const Duration(hours: 3)),
    ),
    Coupon(
      platformId: 'jiomart',
      code: 'JIOSAVE12',
      discountPercent: 12,
      maxDiscountCap: 45,
      minBasketValue: 199,
      expiresAt: now.add(const Duration(days: 2)),
    ),
  ];
}
