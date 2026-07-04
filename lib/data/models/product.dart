class Product {
  final String id;
  final String categoryId;
  final String name;
  final String unit;
  final String emoji;
  final double basePrice;

  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.unit,
    required this.emoji,
    required this.basePrice,
  });
}
