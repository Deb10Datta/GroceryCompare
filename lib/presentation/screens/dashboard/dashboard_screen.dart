import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/savings_bloc.dart';
import '../../../core/utils/currency.dart';
import '../../../data/models/savings_record.dart';
import 'widgets/savings_master_badge.dart';
import 'widgets/savings_roadmap.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Savings Story')),
      body: BlocBuilder<SavingsBloc, List<SavingsRecord>>(
        builder: (context, records) {
          final total = records.fold(0.0, (sum, r) => sum + r.amountSaved);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SavingsMasterBadge(totalSavings: total),
              const SizedBox(height: 24),
              Text('Savings Roadmap 🗺️', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SavingsRoadmap(totalSavings: total),
              const SizedBox(height: 24),
              Text('History', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (records.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No orders placed yet — go save some money! 💸'),
                )
              else
                ...records.map((r) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('Saved ${formatCurrency(r.amountSaved)} on ${r.platformName}'),
                        subtitle: Text(DateFormat('MMM d, y · h:mm a').format(r.timestamp)),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}
