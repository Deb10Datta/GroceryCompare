import 'dart:async';

import 'package:flutter/material.dart';

class CountdownText extends StatefulWidget {
  final DateTime expiresAt;
  final TextStyle? style;

  const CountdownText({super.key, required this.expiresAt, this.style});

  @override
  State<CountdownText> createState() => _CountdownTextState();
}

class _CountdownTextState extends State<CountdownText> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.expiresAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining = widget.expiresAt.difference(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining.isNegative) {
      return Text(
        'Offer expired',
        style: (widget.style ?? const TextStyle())
            .copyWith(color: Theme.of(context).colorScheme.error),
      );
    }
    final h = _remaining.inHours;
    final m = _remaining.inMinutes % 60;
    final s = _remaining.inSeconds % 60;
    final text = h > 0 ? '⏳ ${h}h ${m}m left' : '⏳ ${m}m ${s}s left';
    return Text(text, style: widget.style);
  }
}
