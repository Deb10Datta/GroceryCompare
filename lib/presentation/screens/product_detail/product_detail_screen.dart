import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/cart_bloc.dart';
import '../../../data/models/coupon.dart';
import '../../../data/models/grocery_platform.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../helpers/serving_platforms.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/quirky_back_button.dart';
import 'widgets/platform_price_row.dart';

class _PlatformRowData {
  final GroceryPlatform platform;
  final double base;
  final double effective;
  final Coupon? coupon;

  const _PlatformRowData({
    required this.platform,
    required this.base,
    required this.effective,
    required this.coupon,
  });
}

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    final product = catalog.productById(widget.productId);

    // Compare prices only across the stores delivering to the user.
    final servingPlatforms = watchServingPlatforms(context);
    final hiddenCount = catalog.platforms.length - servingPlatforms.length;
    final rows = servingPlatforms.map((platform) {
      final base = catalog.priceOf(product.id, platform.id);
      final coupon = catalog.couponForPlatform(platform.id);
      final discount = coupon?.previewDiscount(base) ?? 0;
      return _PlatformRowData(
        platform: platform,
        base: base,
        effective: base - discount,
        coupon: coupon,
      );
    }).toList()
      ..sort((a, b) => a.effective.compareTo(b.effective));

    final category = catalog.categoryById(product.categoryId);

    return Scaffold(
      appBar: AppBar(title: Text(product.displayName)),
      floatingActionButton: QuirkyBackButton(onPressed: () => Navigator.of(context).pop()),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              AppIconTile(emoji: product.emoji, color: category.color, size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.displayName, style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      product.brand.isEmpty ? product.unit : '${product.unit} · by ${product.brand}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Compare across platforms', style: Theme.of(context).textTheme.titleMedium),
          if (hiddenCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '$hiddenCount store${hiddenCount == 1 ? '' : 's'} not shown — '
                'no delivery to your area yet.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++)
            PlatformPriceRow(
              product: product,
              platform: rows[i].platform,
              basePrice: rows[i].base,
              effectivePrice: rows[i].effective,
              coupon: rows[i].coupon,
              isBest: i == 0,
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Quantity', style: Theme.of(context).textTheme.titleSmall),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: 'Decrease quantity',
                onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              ),
              Text('$_quantity', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                tooltip: 'Increase quantity',
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () {
              context.read<CartBloc>().add(CartItemAdded(product.id, quantity: _quantity));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added $_quantity × ${product.displayName} to cart 🛒')),
              );
              setState(() => _quantity = 1);
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
