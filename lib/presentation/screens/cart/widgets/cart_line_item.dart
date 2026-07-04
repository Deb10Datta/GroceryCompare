import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/cart_bloc.dart';
import '../../../../data/models/product.dart';

class CartLineItem extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartLineItem({super.key, required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(product.emoji, style: const TextStyle(fontSize: 26)),
      title: Text(product.name),
      subtitle: Text(product.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => context.read<CartBloc>().add(CartItemRemoved(product.id)),
          ),
          Text('$quantity', style: Theme.of(context).textTheme.titleMedium),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.read<CartBloc>().add(CartItemAdded(product.id)),
          ),
        ],
      ),
    );
  }
}
