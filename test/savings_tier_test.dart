import 'package:compare_grocery/domain/savings_tier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('currentTierFor picks the right tier at boundaries', () {
    expect(currentTierFor(0).label, 'Bargain Rookie');
    expect(currentTierFor(499).label, 'Bargain Rookie');
    expect(currentTierFor(500).label, 'Deal Hunter');
    expect(currentTierFor(1999).label, 'Deal Hunter');
    expect(currentTierFor(2000).label, 'Discount Ninja');
    expect(currentTierFor(4999).label, 'Discount Ninja');
    expect(currentTierFor(5000).label, 'Savings Master');
    expect(currentTierFor(9999).label, 'Savings Master');
    expect(currentTierFor(10000).label, 'Frugal Legend');
    expect(currentTierFor(1000000).label, 'Frugal Legend');
  });

  test('nextTierFor returns the next threshold or null when maxed out', () {
    expect(nextTierFor(0)!.label, 'Deal Hunter');
    expect(nextTierFor(499)!.label, 'Deal Hunter');
    expect(nextTierFor(500)!.label, 'Discount Ninja');
    expect(nextTierFor(10000), isNull);
  });
}
