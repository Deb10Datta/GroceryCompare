import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/profile_bloc.dart';
import '../../presentation/screens/bookmarks/bookmarks_screen.dart';
import '../../presentation/screens/cart/cart_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/home/home_shell.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/product_detail/product_detail_screen.dart';
import '../../presentation/screens/products/product_list_screen.dart';
import 'go_router_refresh_stream.dart';

GoRouter buildAppRouter(ProfileBloc profileBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(profileBloc.stream),
    redirect: (context, state) {
      final onboardingComplete = profileBloc.state.onboardingComplete;
      final goingToOnboarding = state.matchedLocation == '/onboarding';

      if (!onboardingComplete && !goingToOnboarding) return '/onboarding';
      if (onboardingComplete && (state.matchedLocation == '/' || goingToOnboarding)) {
        return '/home/products';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/home/products',
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: '/home/cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/home/bookmarks',
            builder: (context, state) => const BookmarksScreen(),
          ),
          GoRoute(
            path: '/home/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) =>
            ProductDetailScreen(productId: state.pathParameters['id']!),
      ),
    ],
  );
}
