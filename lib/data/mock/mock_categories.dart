import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../models/grocery_category.dart';

// Category tint set — draws from the same warm "Market" tokens as
// core/theme/app_theme.dart, plus two muted extras (ochre, slate blue) for
// hues the design system doesn't otherwise define. These are flat
// compile-time constants (this file has no BuildContext to read brightness
// from), so they intentionally stay fixed across light and dark.
const _popBlue = slateBlueColor;
const _popPink = berryColor;
const _popYellow = ochreColor;
const _popOrange = accent2Color;
const _popGreen = leafColor;

const List<GroceryCategory> mockCategories = [
  GroceryCategory(
    id: 'electronics',
    name: 'Electronics',
    emoji: '🎧',
    icon: Icons.devices_other,
    color: _popBlue,
  ),
  GroceryCategory(
    id: 'health_personal_care',
    name: 'Health & Personal Care',
    emoji: '🧴',
    icon: Icons.health_and_safety,
    color: _popGreen,
  ),
  GroceryCategory(
    id: 'home_improvement',
    name: 'Home Improvement',
    emoji: '🛠️',
    icon: Icons.handyman,
    color: _popYellow,
  ),
  GroceryCategory(
    id: 'computers_accessories',
    name: 'Computers & Accessories',
    emoji: '💻',
    icon: Icons.computer,
    color: _popOrange,
  ),
  GroceryCategory(
    id: 'shoes',
    name: 'Shoes',
    emoji: '👟',
    icon: Icons.directions_run,
    color: _popPink,
  ),
  GroceryCategory(
    id: 'sports_fitness_outdoors',
    name: 'Sports, Fitness & Outdoors',
    emoji: '🏋️',
    icon: Icons.fitness_center,
    color: _popGreen,
  ),
  GroceryCategory(
    id: 'home_kitchen',
    name: 'Home & Kitchen',
    emoji: '🍳',
    icon: Icons.kitchen,
    color: _popYellow,
  ),
  GroceryCategory(
    id: 'grocery_gourmet',
    name: 'Grocery & Gourmet Food',
    emoji: '🛒',
    icon: Icons.local_grocery_store,
    color: _popGreen,
  ),
  GroceryCategory(
    id: 'clothing_accessories',
    name: 'Clothing & Accessories',
    emoji: '👕',
    icon: Icons.checkroom,
    color: _popOrange,
  ),
  GroceryCategory(
    id: 'beauty',
    name: 'Beauty',
    emoji: '💄',
    icon: Icons.auto_awesome,
    color: _popPink,
  ),
  GroceryCategory(
    id: 'watches',
    name: 'Watches',
    emoji: '⌚',
    icon: Icons.watch,
    color: _popBlue,
  ),
  GroceryCategory(
    id: 'car_motorbike',
    name: 'Car & Motorbike',
    emoji: '🏍️',
    icon: Icons.two_wheeler,
    color: _popPink,
  ),
  GroceryCategory(
    id: 'toys_games',
    name: 'Toys & Games',
    emoji: '🧸',
    icon: Icons.toys,
    color: _popYellow,
  ),
  GroceryCategory(
    id: 'musical_instruments',
    name: 'Musical Instruments',
    emoji: '🎸',
    icon: Icons.music_note,
    color: _popOrange,
  ),
  GroceryCategory(
    id: 'jewellery',
    name: 'Jewellery',
    emoji: '💎',
    icon: Icons.diamond,
    color: _popBlue,
  ),
  GroceryCategory(
    id: 'office_products',
    name: 'Office Products',
    emoji: '🖊️',
    icon: Icons.edit_note,
    color: _popYellow,
  ),
  GroceryCategory(
    id: 'kindle_store',
    name: 'Kindle Store',
    emoji: '📖',
    icon: Icons.menu_book,
    color: _popBlue,
  ),
  GroceryCategory(
    id: 'outdoor_living',
    name: 'Outdoor Living',
    emoji: '⛺',
    icon: Icons.deck,
    color: _popGreen,
  ),
  GroceryCategory(
    id: 'video_games',
    name: 'Video Games',
    emoji: '🎮',
    icon: Icons.sports_esports,
    color: _popOrange,
  ),
  GroceryCategory(
    id: 'pet_supplies',
    name: 'Pet Supplies',
    emoji: '🐶',
    icon: Icons.pets,
    color: _popYellow,
  ),
  GroceryCategory(
    id: 'home_medical',
    name: 'Home Medical Supplies',
    emoji: '🩺',
    icon: Icons.medical_services,
    color: _popPink,
  ),
  GroceryCategory(
    id: 'software',
    name: 'Software',
    emoji: '💿',
    icon: Icons.terminal,
    color: _popGreen,
  ),
  GroceryCategory(
    id: 'bags_wallets_luggage',
    name: 'Bags, Wallets & Luggage',
    emoji: '🧳',
    icon: Icons.luggage,
    color: _popOrange,
  ),
];
