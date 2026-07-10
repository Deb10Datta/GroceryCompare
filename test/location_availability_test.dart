import 'package:compare_grocery/data/services/pincode_service.dart';
import 'package:compare_grocery/domain/location_availability.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('pincode serviceability', () {
    test('metro PIN codes resolve to their city platforms', () {
      expect(cityForPincode('560034'), 'bengaluru');
      expect(platformIdsForPincode('560034').length, 5);
      expect(cityForPincode('110001'), 'delhi');
      expect(cityForPincode('700001'), 'kolkata');
    });

    test('longest matching prefix wins', () {
      // 1201xx is Ghaziabad even though 12xx also brushes other ranges.
      expect(cityForPincode('120102'), 'noida');
      expect(cityForPincode('121001'), 'faridabad');
    });

    test('unmapped PIN codes fall back to a non-empty default', () {
      expect(platformIdsForPincode('999999'), isNotEmpty);
    });

    test('a recognized PIN code beats the typed location', () {
      final ids = platformIdsServing(pincode: '700001', location: 'Bengaluru');
      expect(ids, platformIdsForPincode('700001'));
    });

    test('an unmapped PIN code defers to the typed location', () {
      final ids = platformIdsServing(pincode: '999999', location: 'Bengaluru');
      expect(ids, platformIdsAvailableFor('Bengaluru'));
    });
  });

  group('pincode validation', () {
    test('accepts a well-formed PIN code', () {
      expect(pincodeError('560034'), isNull);
    });

    test('empty input is not shouted at', () {
      expect(pincodeError(''), isNull);
    });

    test('rejects short, long, non-numeric and leading-zero codes', () {
      expect(pincodeError('5600'), isNotNull);
      expect(pincodeError('5600341'), isNotNull);
      expect(pincodeError('56OO34'), isNotNull);
      expect(pincodeError('060034'), isNotNull);
    });
  });

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
