import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/cart_bloc.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../blocs/savings_bloc.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../domain/cart_comparator.dart';
import 'widgets/cart_line_item.dart';
import 'widgets/checkout_sheet.dart';
import 'widgets/platform_comparison_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: BlocBuilder<CartBloc, Map<String, int>>(
        builder: (context, cart) {
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
          final totals = CartComparator(catalog).compare(cart, profile.preferredPayment);

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
              const SizedBox(height: 8),
              for (var i = 0; i < totals.length; i++)
                PlatformComparisonCard(
                  total: totals[i],
                  isBest: i == 0,
                  onCheckout: () async {
                    final confirmed = await showCheckoutSheet(context, totals[i]);
                    if (confirmed != true || !context.mounted) return;
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
