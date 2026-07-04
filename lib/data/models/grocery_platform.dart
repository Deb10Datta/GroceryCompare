import 'package:flutter/material.dart';

class GroceryPlatform {
  final String id;
  final String name;
  final String badgeLabel;
  final Color color;

  const GroceryPlatform({
    required this.id,
    required this.name,
    required this.badgeLabel,
    required this.color,
  });
}
