import '../models/product.dart';

const List<Product> mockProducts = [
  // Fruits & Vegetables
  Product(id: 'banana', categoryId: 'fruits_veg', name: 'Banana', unit: '1 dozen', emoji: '🍌', basePrice: 45),
  Product(id: 'tomato', categoryId: 'fruits_veg', name: 'Tomato', unit: '1 kg', emoji: '🍅', basePrice: 32),
  Product(id: 'onion', categoryId: 'fruits_veg', name: 'Onion', unit: '1 kg', emoji: '🧅', basePrice: 28),
  Product(id: 'apple', categoryId: 'fruits_veg', name: 'Apple', unit: '4 pcs', emoji: '🍎', basePrice: 120),
  Product(id: 'potato', categoryId: 'fruits_veg', name: 'Potato', unit: '1 kg', emoji: '🥔', basePrice: 25),

  // Dairy & Bread
  Product(id: 'milk', categoryId: 'dairy_bread', name: 'Milk', unit: '1 L', emoji: '🥛', basePrice: 62),
  Product(id: 'bread', categoryId: 'dairy_bread', name: 'Brown Bread', unit: '400 g', emoji: '🍞', basePrice: 45),
  Product(id: 'paneer', categoryId: 'dairy_bread', name: 'Paneer', unit: '200 g', emoji: '🧀', basePrice: 85),
  Product(id: 'eggs', categoryId: 'dairy_bread', name: 'Eggs', unit: '6 pcs', emoji: '🥚', basePrice: 48),
  Product(id: 'curd', categoryId: 'dairy_bread', name: 'Curd', unit: '400 g', emoji: '🥣', basePrice: 40),

  // Snacks & Namkeen
  Product(id: 'chips', categoryId: 'snacks', name: 'Potato Chips', unit: '52 g', emoji: '🍟', basePrice: 20),
  Product(id: 'namkeen', categoryId: 'snacks', name: 'Namkeen Mix', unit: '200 g', emoji: '🥨', basePrice: 60),
  Product(id: 'biscuits', categoryId: 'snacks', name: 'Biscuits', unit: '200 g', emoji: '🍪', basePrice: 30),
  Product(id: 'popcorn', categoryId: 'snacks', name: 'Popcorn', unit: '80 g', emoji: '🍿', basePrice: 45),

  // Beverages
  Product(id: 'cola', categoryId: 'beverages', name: 'Cola', unit: '750 ml', emoji: '🥤', basePrice: 40),
  Product(id: 'orange_juice', categoryId: 'beverages', name: 'Orange Juice', unit: '1 L', emoji: '🧃', basePrice: 110),
  Product(id: 'green_tea', categoryId: 'beverages', name: 'Green Tea', unit: '25 bags', emoji: '🍵', basePrice: 150),
  Product(id: 'coffee', categoryId: 'beverages', name: 'Instant Coffee', unit: '200 g', emoji: '☕', basePrice: 220),

  // Personal Care
  Product(id: 'shampoo', categoryId: 'personal_care', name: 'Shampoo', unit: '340 ml', emoji: '🧴', basePrice: 210),
  Product(id: 'toothpaste', categoryId: 'personal_care', name: 'Toothpaste', unit: '150 g', emoji: '🪥', basePrice: 55),
  Product(id: 'soap', categoryId: 'personal_care', name: 'Soap (4-pack)', unit: '4 pcs', emoji: '🧼', basePrice: 96),
  Product(id: 'handwash', categoryId: 'personal_care', name: 'Hand Wash', unit: '250 ml', emoji: '🧴', basePrice: 89),

  // Household
  Product(id: 'dish_soap', categoryId: 'household', name: 'Dish Soap', unit: '500 ml', emoji: '🧽', basePrice: 99),
  Product(id: 'detergent', categoryId: 'household', name: 'Detergent', unit: '1 kg', emoji: '🧺', basePrice: 145),
  Product(id: 'toilet_roll', categoryId: 'household', name: 'Toilet Roll (4-pack)', unit: '4 pcs', emoji: '🧻', basePrice: 120),
  Product(id: 'room_freshener', categoryId: 'household', name: 'Room Freshener', unit: '250 ml', emoji: '🌸', basePrice: 175),
];
