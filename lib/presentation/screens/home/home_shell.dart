import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/cart_bloc.dart';

const _tabs = ['/home/products', '/home/cart', '/home/bookmarks', '/home/dashboard'];

class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  int _indexForLocation(String location) {
    final idx = _tabs.indexWhere((t) => location.startsWith(t));
    return idx == -1 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<CartBloc, Map<String, int>>(
        builder: (context, cart) {
          final itemCount = cart.values.fold(0, (a, b) => a + b);
          return NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (i) => context.go(_tabs[i]),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.storefront_outlined),
                selectedIcon: Icon(Icons.storefront),
                label: 'Products',
              ),
              NavigationDestination(
                icon: Badge(
                  label: Text('$itemCount'),
                  isLabelVisible: itemCount > 0,
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
                selectedIcon: const Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              const NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
            ],
          );
        },
      ),
    );
  }
}
