import 'package:flutter/material.dart';

class GroceryCategory {
  final String id;
  final String name;
  final String emoji;
  final IconData icon;
  final Color color;

  const GroceryCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
    required this.color,
  });
}
