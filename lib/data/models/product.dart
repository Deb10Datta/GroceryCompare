class Product {
  final String id;
  final String categoryId;
  final String brand;
  final String name;
  final String unit;
  final String emoji;
  final double basePrice;

  const Product({
    required this.id,
    required this.categoryId,
    required this.brand,
    required this.name,
    required this.unit,
    required this.emoji,
    required this.basePrice,
  });

  /// Display name including the brand, e.g. "Sony Wireless Headphones".
  String get displayName => brand.isEmpty ? name : '$brand $name';
}
