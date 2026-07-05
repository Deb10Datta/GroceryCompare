import 'package:compare_grocery/domain/location_availability.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recognized metros resolve to their configured platforms', () {
    expect(platformIdsAvailableFor('Koramangala, Bengaluru'), contains('blinkit'));
    expect(platformIdsAvailableFor('Koramangala, Bengaluru').length, 5);
  });

  test('matching is case-insensitive', () {
    expect(platformIdsAvailableFor('MUMBAI'), platformIdsAvailableFor('mumbai'));
  });

  test('unrecognized locations fall back to a non-empty default', () {
    final ids = platformIdsAvailableFor('Some Random Village');
    expect(ids, isNotEmpty);
  });
}
