import 'package:flutter/material.dart';

/// A generated icon tile used wherever we'd otherwise show a real product/
/// category photo — since there's no real product-image API to pull from,
/// this renders a consistent, tinted rounded tile from either an emoji
/// (kept per-product, so items stay visually distinguishable) or a
/// Material icon (used for the more generic category-level artwork).
class AppIconTile extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final Color color;
  final double size;

  const AppIconTile({
    super.key,
    this.emoji,
    this.icon,
    required this.color,
    this.size = 44,
  }) : assert(emoji != null || icon != null, 'Provide an emoji or an icon');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.2),
      ),
      child: emoji != null
          ? Text(emoji!, style: TextStyle(fontSize: size * 0.5))
          : Icon(icon, color: color, size: size * 0.55),
    );
  }
}
