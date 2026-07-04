class SavingsTier {
  final double minTotal;
  final String label;
  final String emoji;

  const SavingsTier({
    required this.minTotal,
    required this.label,
    required this.emoji,
  });
}

const List<SavingsTier> savingsTiers = [
  SavingsTier(minTotal: 0, label: 'Bargain Rookie', emoji: '🌱'),
  SavingsTier(minTotal: 500, label: 'Deal Hunter', emoji: '🔍'),
  SavingsTier(minTotal: 2000, label: 'Discount Ninja', emoji: '🥷'),
  SavingsTier(minTotal: 5000, label: 'Savings Master', emoji: '🏆'),
  SavingsTier(minTotal: 10000, label: 'Frugal Legend', emoji: '👑'),
];

SavingsTier currentTierFor(double total) {
  var tier = savingsTiers.first;
  for (final t in savingsTiers) {
    if (total >= t.minTotal) tier = t;
  }
  return tier;
}

SavingsTier? nextTierFor(double total) {
  for (final t in savingsTiers) {
    if (total < t.minTotal) return t;
  }
  return null;
}
