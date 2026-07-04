import 'package:flutter/material.dart';

import '../../../../core/utils/currency.dart';
import '../../../../domain/roadmap_items.dart';

class SavingsRoadmap extends StatelessWidget {
  final double totalSavings;

  const SavingsRoadmap({super.key, required this.totalSavings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: savingsRoadmap.map((item) {
        final progress = (totalSavings / item.cost).clamp(0.0, 1.0);
        final unlocked = totalSavings >= item.cost;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Text(item.emoji, style: const TextStyle(fontSize: 26)),
            title: Text(item.name),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(value: progress),
              ),
            ),
            trailing: unlocked
                ? const Text('🎉 Unlocked!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                : Text(formatCurrency(item.cost)),
          ),
        );
      }).toList(),
    );
  }
}
