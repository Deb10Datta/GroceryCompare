import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/bookmark_bloc.dart';
import 'blocs/cart_bloc.dart';
import 'blocs/category_filter_cubit.dart';
import 'blocs/profile_bloc.dart';
import 'blocs/savings_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/catalog_repository.dart';
import 'data/services/platform_session_manager.dart';

class CompareGroceryApp extends StatefulWidget {
  const CompareGroceryApp({super.key});

  @override
  State<CompareGroceryApp> createState() => _CompareGroceryAppState();
}

class _CompareGroceryAppState extends State<CompareGroceryApp> {
  final _catalog = CatalogRepository();
  late final PlatformSessionManager _sessionManager;
  late final ProfileBloc _profileBloc;
  late final CartBloc _cartBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _sessionManager = PlatformSessionManager(catalog: _catalog);
    _profileBloc = ProfileBloc();
    _cartBloc = CartBloc();
    _router = buildAppRouter(_profileBloc);

    // Returning users skip onboarding, so their hidden store sessions are
    // reopened here from the persisted profile and cart.
    final profile = _profileBloc.state;
    if (profile.onboardingComplete) {
      _sessionManager.startSessions(
        pincode: profile.pincode,
        location: profile.location,
      );
      _sessionManager.syncCart(_cartBloc.state);
    }
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    _profileBloc.close();
    _cartBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CatalogRepository>.value(value: _catalog),
        RepositoryProvider<PlatformSessionManager>.value(value: _sessionManager),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>.value(value: _profileBloc),
          BlocProvider<CartBloc>.value(value: _cartBloc),
          BlocProvider<BookmarkBloc>(create: (_) => BookmarkBloc()),
          BlocProvider<SavingsBloc>(create: (_) => SavingsBloc()),
          BlocProvider<CategoryFilterCubit>(create: (_) => CategoryFilterCubit()),
        ],
        child: BlocListener<CartBloc, Map<String, int>>(
          // Every cart change is mirrored into the hidden store sessions,
          // so each live platform tab keeps pace with the user's basket.
          listener: (context, cart) => _sessionManager.syncCart(cart),
          child: MaterialApp.router(
            title: 'Compare Grocery',
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            darkTheme: buildAppDarkTheme(),
            themeMode: ThemeMode.system,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
