import 'package:flutter/material.dart';

/// Gives its child the polished-web-app "floating tile" treatment:
///
/// * a soft drop shadow cast by an imaginary light source at the centre of
///   the screen — tiles above the centre throw their shadow upward, tiles
///   below throw it downward, and the shadow leans further and softens as
///   the tile scrolls away from the light;
/// * hover lift (slight scale-up, deeper shadow) and press-down feedback
///   (scale-down, flattened shadow) with cursor affordance;
/// * a small fade-and-rise entrance animation when the tile first mounts.
///
/// Purely visual: it listens to raw pointer events, so any InkWell,
/// ListTile or button inside keeps receiving taps and ripples untouched.
class FloatingTile extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;

  /// Whether hover/press feedback should play (true for tappable tiles).
  final bool interactive;

  const FloatingTile({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.interactive = true,
  });

  @override
  State<FloatingTile> createState() => _FloatingTileState();
}

class _FloatingTileState extends State<FloatingTile> {
  ScrollNotificationObserverState? _scrollObserver;

  /// Tile centre's displacement from the screen centre, each axis in -1..1.
  Offset _fromLight = Offset.zero;
  bool _hovered = false;
  bool _pressed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollObserver?.removeListener(_onScroll);
    _scrollObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollObserver?.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateLight());
  }

  @override
  void dispose() {
    _scrollObserver?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification ||
        notification is ScrollEndNotification) {
      _updateLight();
    }
  }

  void _updateLight() {
    if (!mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final screen = MediaQuery.sizeOf(context);
    if (screen.isEmpty) return;
    final tileCenter = box.localToGlobal(box.size.center(Offset.zero));
    final next = Offset(
      ((tileCenter.dx - screen.width / 2) / (screen.width / 2)).clamp(
        -1.0,
        1.0,
      ),
      ((tileCenter.dy - screen.height / 2) / (screen.height / 2)).clamp(
        -1.0,
        1.0,
      ),
    );
    // Skip sub-pixel churn so scrolling doesn't rebuild tiles needlessly.
    if ((next - _fromLight).distance > 0.02) {
      setState(() => _fromLight = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Shadow falls away from the central light source; hovering lifts the
    // tile (longer, softer shadow) and pressing pushes it flat.
    final lift = _pressed ? 0.35 : (_hovered ? 1.5 : 1.0);
    final shadowOffset = Offset(
      _fromLight.dx * 12 * lift,
      (4 + _fromLight.dy * 14) * lift,
    );
    final blur =
        (18 + 12 * _fromLight.distance) * (_hovered && !_pressed ? 1.4 : 1.0);
    final alpha = _pressed ? 0.18 : (_hovered ? 0.42 : 0.30);

    Widget tile = AnimatedScale(
      scale: _pressed ? 0.97 : (_hovered ? 1.015 : 1.0),
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          boxShadow: [
            // Main directional shadow cast by the central light source.
            BoxShadow(
              color: Colors.black.withValues(alpha: alpha),
              offset: shadowOffset,
              blurRadius: blur,
              spreadRadius: -1,
            ),
            // Tight contact shadow hugging the tile, for grounded depth.
            BoxShadow(
              color: Colors.black.withValues(alpha: alpha * 0.55),
              offset: Offset(shadowOffset.dx * 0.3, shadowOffset.dy * 0.3),
              blurRadius: blur * 0.35,
              spreadRadius: 0,
            ),
          ],
        ),
        child: widget.child,
      ),
    );

    if (widget.interactive) {
      // Listener (not GestureDetector) so inner InkWells still win taps.
      tile = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() {
          _hovered = false;
          _pressed = false;
        }),
        child: Listener(
          onPointerDown: (_) => setState(() => _pressed = true),
          onPointerUp: (_) => setState(() => _pressed = false),
          onPointerCancel: (_) => setState(() => _pressed = false),
          child: tile,
        ),
      );
    }

    // Entrance: fade in and rise, like a web page revealing cards.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: tile,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - t)),
          child: child,
        ),
      ),
    );
  }
}
