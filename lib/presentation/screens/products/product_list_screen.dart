import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/category_filter_cubit.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../widgets/app_icon_tile.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Grocery 🛒')),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: BlocBuilder<CategoryFilterCubit, String?>(
              builder: (context, selectedCategoryId) {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: selectedCategoryId == null,
                        onSelected: (_) =>
                            context.read<CategoryFilterCubit>().select(null),
                      ),
                    ),
                    ...catalog.categories.map((category) {
                      final selected = category.id == selectedCategoryId;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: AppIconTile(icon: category.icon, color: category.color, size: 26),
                          label: Text(category.name),
                          selected: selected,
                          onSelected: (_) => context
                              .read<CategoryFilterCubit>()
                              .select(selected ? null : category.id),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<CategoryFilterCubit, String?>(
              builder: (context, categoryId) {
                final products = categoryId == null
                    ? catalog.products
                    : catalog.productsByCategory(categoryId);
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: products.length,
                  itemBuilder: (context, i) => ProductCard(product: products[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
