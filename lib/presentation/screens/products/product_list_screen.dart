import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/category_filter_cubit.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/grocery_category.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../helpers/serving_platforms.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/floating_tile.dart';
import 'widgets/product_grid_card.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Compare Grocery 🛒')),
      body: BlocBuilder<CategoryFilterCubit, String?>(
        builder: (context, selectedCategoryId) {
          return Column(
            children: [
              SizedBox(
                height: 56,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                          avatar: AppIconTile(
                            icon: category.icon,
                            color: category.color,
                            size: 26,
                          ),
                          label: Text(category.name),
                          selected: selected,
                          onSelected: (_) => context
                              .read<CategoryFilterCubit>()
                              .select(selected ? null : category.id),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: selectedCategoryId == null
                    ? const _AllCategoriesView()
                    : _CategoryGridView(categoryId: selectedCategoryId),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Home listing in the BuyHatke style: a savings hero banner followed by one
/// section per category, each with a horizontally scrolling row of products.
class _AllCategoriesView extends StatelessWidget {
  const _AllCategoriesView();

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    final categories = catalog.categories
        .where((c) => catalog.productsByCategory(c.id).isNotEmpty)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: categories.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return const _HeroBanner();
        final category = categories[i - 1];
        return _CategorySection(
          category: category,
          products: catalog.productsByCategory(category.id),
        );
      },
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.extension<AppPalette>()!;
    // Pitch only the stores that actually deliver to the user's area.
    final platforms = watchServingPlatforms(context);
    final names = platforms.take(3).map((p) => p.name).join(', ');
    final extraCount = platforms.length - 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: FloatingTile(
        interactive: false,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: palette.heroGradient,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compare & buy at the cheapest price',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: palette.onGradient,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                extraCount > 0
                    ? 'Live prices across $names & $extraCount more in your area — '
                          'save money in under 60 seconds.'
                    : 'Live prices across $names in your area — '
                          'save money in under 60 seconds.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: palette.onGradient.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final GroceryCategory category;
  final List<Product> products;

  const _CategorySection({required this.category, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Row(
            children: [
              AppIconTile(icon: category.icon, color: category.color, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    context.read<CategoryFilterCubit>().select(category.id),
                child: Text('See all (${products.length})'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, i) => SizedBox(
              width: 150,
              child: ProductGridCard(product: products[i]),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full listing for a single selected category, as a two-column card grid.
class _CategoryGridView extends StatelessWidget {
  final String categoryId;

  const _CategoryGridView({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    final category = catalog.categoryById(categoryId);
    final products = catalog.productsByCategory(categoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              AppIconTile(icon: category.icon, color: category.color, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.name,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${products.length} items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 198,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) => ProductGridCard(product: products[i]),
          ),
        ),
      ],
    );
  }
}
