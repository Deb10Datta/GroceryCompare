import 'package:flutter/material.dart';

/// A playful, tilted "back" affordance meant to sit in the bottom-left of
/// the screen (via `floatingActionButtonLocation: FloatingActionButtonLocation.startFloat`)
/// instead of a plain AppBar arrow — a little squircle that tilts and
/// bounces on tap.
class QuirkyBackButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const QuirkyBackButton({super.key, required this.onPressed, this.tooltip = 'Go back'});

  @override
  State<QuirkyBackButton> createState() => _QuirkyBackButtonState();
}

class _QuirkyBackButtonState extends State<QuirkyBackButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.82),
        onTapCancel: () => setState(() => _scale = 1),
        onTapUp: (_) {
          setState(() => _scale = 1);
          widget.onPressed();
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Transform.rotate(
            angle: -0.12,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle: 0.12,
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
