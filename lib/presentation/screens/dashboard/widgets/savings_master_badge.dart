import 'package:flutter/material.dart';

import '../../../../core/utils/currency.dart';
import '../../../../domain/savings_tier.dart';

class SavingsMasterBadge extends StatelessWidget {
  final double totalSavings;

  const SavingsMasterBadge({super.key, required this.totalSavings});

  @override
  Widget build(BuildContext context) {
    final tier = currentTierFor(totalSavings);
    final next = nextTierFor(totalSavings);
    final progress = next == null
        ? 1.0
        : ((totalSavings - tier.minTotal) / (next.minTotal - tier.minTotal)).clamp(0.0, 1.0);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(tier.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 8),
            Text(
              tier.label,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Lifetime savings: ${formatCurrency(totalSavings)}',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: progress, minHeight: 10),
            ),
            const SizedBox(height: 6),
            if (next != null)
              Text('${formatCurrency(next.minTotal - totalSavings)} more to become a '
                  '${next.label} ${next.emoji}')
            else
              const Text("You've maxed out the leaderboard! Legendary. 👑"),
          ],
        ),
      ),
    );
  }
}
