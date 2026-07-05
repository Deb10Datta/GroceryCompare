import 'package:flutter/material.dart';

import '../models/grocery_category.dart';

// Neon accent palette — matches the dark theme in core/theme/app_theme.dart.
const _neonBlue = Color(0xFF00E5FF);
const _neonRed = Color(0xFFFF1744);
const _neonYellow = Color(0xFFFFEA00);
const _neonPurple = Color(0xFFD500F9);
const _neonGreen = Color(0xFF00E676);

const List<GroceryCategory> mockCategories = [
  GroceryCategory(
    id: 'electronics',
    name: 'Electronics',
    emoji: '🎧',
    icon: Icons.devices_other,
    color: _neonBlue,
  ),
  GroceryCategory(
    id: 'health_personal_care',
    name: 'Health & Personal Care',
    emoji: '🧴',
    icon: Icons.health_and_safety,
    color: _neonGreen,
  ),
  GroceryCategory(
    id: 'home_improvement',
    name: 'Home Improvement',
    emoji: '🛠️',
    icon: Icons.handyman,
    color: _neonYellow,
  ),
  GroceryCategory(
    id: 'computers_accessories',
    name: 'Computers & Accessories',
    emoji: '💻',
    icon: Icons.computer,
    color: _neonPurple,
  ),
  GroceryCategory(
    id: 'shoes',
    name: 'Shoes',
    emoji: '👟',
    icon: Icons.directions_run,
    color: _neonRed,
  ),
  GroceryCategory(
    id: 'sports_fitness_outdoors',
    name: 'Sports, Fitness & Outdoors',
    emoji: '🏋️',
    icon: Icons.fitness_center,
    color: _neonGreen,
  ),
  GroceryCategory(
    id: 'home_kitchen',
    name: 'Home & Kitchen',
    emoji: '🍳',
    icon: Icons.kitchen,
    color: _neonYellow,
  ),
  GroceryCategory(
    id: 'grocery_gourmet',
    name: 'Grocery & Gourmet Food',
    emoji: '🛒',
    icon: Icons.local_grocery_store,
    color: _neonGreen,
  ),
  GroceryCategory(
    id: 'clothing_accessories',
    name: 'Clothing & Accessories',
    emoji: '👕',
    icon: Icons.checkroom,
    color: _neonPurple,
  ),
  GroceryCategory(
    id: 'beauty',
    name: 'Beauty',
    emoji: '💄',
    icon: Icons.auto_awesome,
    color: _neonRed,
  ),
  GroceryCategory(
    id: 'watches',
    name: 'Watches',
    emoji: '⌚',
    icon: Icons.watch,
    color: _neonBlue,
  ),
  GroceryCategory(
    id: 'car_motorbike',
    name: 'Car & Motorbike',
    emoji: '🏍️',
    icon: Icons.two_wheeler,
    color: _neonRed,
  ),
  GroceryCategory(
    id: 'toys_games',
    name: 'Toys & Games',
    emoji: '🧸',
    icon: Icons.toys,
    color: _neonYellow,
  ),
  GroceryCategory(
    id: 'musical_instruments',
    name: 'Musical Instruments',
    emoji: '🎸',
    icon: Icons.music_note,
    color: _neonPurple,
  ),
  GroceryCategory(
    id: 'jewellery',
    name: 'Jewellery',
    emoji: '💎',
    icon: Icons.diamond,
    color: _neonBlue,
  ),
  GroceryCategory(
    id: 'office_products',
    name: 'Office Products',
    emoji: '🖊️',
    icon: Icons.edit_note,
    color: _neonYellow,
  ),
  GroceryCategory(
    id: 'kindle_store',
    name: 'Kindle Store',
    emoji: '📖',
    icon: Icons.menu_book,
    color: _neonBlue,
  ),
  GroceryCategory(
    id: 'outdoor_living',
    name: 'Outdoor Living',
    emoji: '⛺',
    icon: Icons.deck,
    color: _neonGreen,
  ),
  GroceryCategory(
    id: 'video_games',
    name: 'Video Games',
    emoji: '🎮',
    icon: Icons.sports_esports,
    color: _neonPurple,
  ),
  GroceryCategory(
    id: 'pet_supplies',
    name: 'Pet Supplies',
    emoji: '🐶',
    icon: Icons.pets,
    color: _neonYellow,
  ),
  GroceryCategory(
    id: 'home_medical',
    name: 'Home Medical Supplies',
    emoji: '🩺',
    icon: Icons.medical_services,
    color: _neonRed,
  ),
  GroceryCategory(
    id: 'software',
    name: 'Software',
    emoji: '💿',
    icon: Icons.terminal,
    color: _neonGreen,
  ),
  GroceryCategory(
    id: 'bags_wallets_luggage',
    name: 'Bags, Wallets & Luggage',
    emoji: '🧳',
    icon: Icons.luggage,
    color: _neonPurple,
  ),
];
