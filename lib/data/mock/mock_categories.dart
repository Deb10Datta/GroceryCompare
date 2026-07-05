import 'package:flutter/material.dart';

import '../models/grocery_category.dart';

const List<GroceryCategory> mockCategories = [
  GroceryCategory(
    id: 'fruits_veg',
    name: 'Fruits & Vegetables',
    emoji: '🥦',
    icon: Icons.eco,
    color: Color(0xFF66BB6A),
  ),
  GroceryCategory(
    id: 'dairy_bread',
    name: 'Dairy & Bread',
    emoji: '🥛',
    icon: Icons.bakery_dining,
    color: Color(0xFFFFCA28),
  ),
  GroceryCategory(
    id: 'snacks',
    name: 'Snacks & Namkeen',
    emoji: '🍟',
    icon: Icons.cookie,
    color: Color(0xFFFF8A65),
  ),
  GroceryCategory(
    id: 'beverages',
    name: 'Beverages',
    emoji: '🥤',
    icon: Icons.local_cafe,
    color: Color(0xFF4FC3F7),
  ),
  GroceryCategory(
    id: 'personal_care',
    name: 'Personal Care',
    emoji: '🧴',
    icon: Icons.spa,
    color: Color(0xFFBA68C8),
  ),
  GroceryCategory(
    id: 'household',
    name: 'Household',
    emoji: '🧹',
    icon: Icons.cleaning_services,
    color: Color(0xFF90A4AE),
  ),
];
