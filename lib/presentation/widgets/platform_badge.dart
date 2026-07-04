import 'package:flutter/material.dart';

import '../../data/models/grocery_platform.dart';

class PlatformBadge extends StatelessWidget {
  final GroceryPlatform platform;
  final double size;

  const PlatformBadge({super.key, required this.platform, this.size = 36});

  @override
  Widget build(BuildContext context) {
    final onColor =
        platform.color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: platform.color,
      child: Text(
        platform.badgeLabel,
        style: TextStyle(
          fontSize: size * 0.32,
          fontWeight: FontWeight.bold,
          color: onColor,
        ),
      ),
    );
  }
}
