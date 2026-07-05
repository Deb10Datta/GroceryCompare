import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/profile_bloc.dart';
import '../../../blocs/savings_bloc.dart';
import '../../../core/utils/currency.dart';
import '../../../data/models/savings_record.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../widgets/platform_badge.dart';
import 'widgets/savings_master_badge.dart';
import 'widgets/savings_roadmap.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    final profile = context.watch<ProfileBloc>().state;
    final localStores = catalog.platformsAvailableFor(profile.location);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Savings Story')),
      body: BlocBuilder<SavingsBloc, List<SavingsRecord>>(
        builder: (context, records) {
          final total = records.fold(0.0, (sum, r) => sum + r.amountSaved);
          final active = records.where((r) => r.status == OrderStatus.placed).toList();
          final completed = records.where((r) => r.status == OrderStatus.delivered).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (profile.location.isNotEmpty) ...[
                Text('Stores operating in your locality 📍', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(profile.location, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                if (localStores.isEmpty)
                  const Text('No partner stores found for this location yet.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: localStores.map((p) {
                      return Chip(
                        avatar: PlatformBadge(platform: p, size: 24),
                        label: Text(p.name),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 24),
              ],
              SavingsMasterBadge(totalSavings: total),
              const SizedBox(height: 24),
              Text('Savings Roadmap 🗺️', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SavingsRoadmap(totalSavings: total),
              const SizedBox(height: 24),
              if (active.isNotEmpty) ...[
                Text('Active orders 🚚', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                ...active.map((r) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.local_shipping_outlined),
                        title: Text('Order on ${r.platformName}'),
                        subtitle: Text(DateFormat('MMM d, y · h:mm a').format(r.timestamp)),
                        trailing: OutlinedButton(
                          onPressed: () =>
                              context.read<SavingsBloc>().add(OrderMarkedDelivered(r.id)),
                          child: const Text('Mark delivered'),
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
              ],
              Text('Order history', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              if (completed.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('No delivered orders yet — go save some money! 💸'),
                )
              else
                ...completed.map((r) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text('Saved ${formatCurrency(r.amountSaved)} on ${r.platformName}'),
                        subtitle: Text(DateFormat('MMM d, y · h:mm a').format(r.timestamp)),
                        trailing: const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }
}
