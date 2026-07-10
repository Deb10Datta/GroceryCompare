import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/cart_bloc.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../blocs/savings_bloc.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/services/platform_session_manager.dart';
import '../../../domain/cart_comparator.dart';
import 'widgets/cart_line_item.dart';
import 'widgets/platform_comparison_card.dart';
import 'widgets/platform_handoff_sheet.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartBloc, Map<String, int>>(
        builder: (context, rawCart) {
          // Drop items persisted under product IDs that no longer exist in
          // the catalog (e.g. after a catalog overhaul), instead of crashing.
          final cart = {
            for (final e in rawCart.entries)
              if (catalog.productByIdOrNull(e.key) != null) e.key: e.value,
          };
          if (cart.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Your cart is empty.\nGo add some snacks! 🍪',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final profile = context.watch<ProfileBloc>().state;
          // Only stores that actually deliver to the user's PIN code get a
          // total and a checkout link; the rest aren't shown at all.
          final servingPlatforms = catalog.platformsServing(
            pincode: profile.pincode,
            location: profile.location,
          );
          final hiddenCount = catalog.platforms.length - servingPlatforms.length;
          final totals = CartComparator(catalog).compare(
            cart,
            profile.preferredPayment,
            platforms: servingPlatforms,
          );

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Items', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              ...cart.entries.map((e) {
                final product = catalog.productById(e.key);
                return CartLineItem(product: product, quantity: e.value);
              }),
              const Divider(height: 32),
              Text('Compare total across platforms', style: Theme.of(context).textTheme.titleMedium),
              if (hiddenCount > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '$hiddenCount store${hiddenCount == 1 ? '' : 's'} not shown — '
                  'no delivery to PIN ${profile.pincode.isEmpty ? 'your area' : profile.pincode} yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              for (var i = 0; i < totals.length; i++)
                PlatformComparisonCard(
                  total: totals[i],
                  isBest: i == 0,
                  onCheckout: () async {
                    final items = [
                      for (final e in cart.entries)
                        (product: catalog.productById(e.key), quantity: e.value),
                    ];
                    final confirmed = await showPlatformHandoffSheet(
                      context,
                      total: totals[i],
                      items: items,
                    );
                    if (!context.mounted) return;

                    // Committing to one platform closed the other hidden
                    // store tabs — reopen the full set for whatever the
                    // user shops next.
                    final sessionProfile = context.read<ProfileBloc>().state;
                    final manager = context.read<PlatformSessionManager>();
                    manager.startSessions(
                      pincode: sessionProfile.pincode,
                      location: sessionProfile.location,
                    );

                    if (confirmed != true) {
                      manager.syncCart(context.read<CartBloc>().state);
                      return;
                    }
                    context.read<SavingsBloc>().add(SavingsRecorded(
                          platformName: totals[i].platform.name,
                          amountSaved: totals[i].totalSavings,
                        ));
                    context.read<CartBloc>().add(const CartCleared());
                    context.go('/home/dashboard');
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
