import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/bookmark_bloc.dart';
import '../../../data/models/bookmark.dart';
import '../../../data/repositories/catalog_repository.dart';
import 'widgets/bookmark_card.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarked Offers')),
      body: BlocBuilder<BookmarkBloc, List<Bookmark>>(
        builder: (context, bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No bookmarks yet.\nSave a deal from a product page! 🔖',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final sorted = [...bookmarks]..sort((a, b) => b.savedAt.compareTo(a.savedAt));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: sorted.length,
            itemBuilder: (context, i) {
              final bookmark = sorted[i];
              final product = catalog.productById(bookmark.productId);
              final platform = catalog.platformById(bookmark.platformId);
              final coupon = catalog.couponForPlatform(bookmark.platformId);
              final basePrice = catalog.priceOf(bookmark.productId, bookmark.platformId);
              final discount = coupon?.previewDiscount(basePrice) ?? 0;

              return BookmarkCard(
                product: product,
                platform: platform,
                coupon: coupon,
                basePrice: basePrice,
                effectivePrice: basePrice - discount,
                onTap: () => context.push('/product/${product.id}'),
                onRemove: () => context.read<BookmarkBloc>().add(
                      BookmarkToggled(productId: bookmark.productId, platformId: bookmark.platformId),
                    ),
              );
            },
          );
        },
      ),
    );
  }
}
