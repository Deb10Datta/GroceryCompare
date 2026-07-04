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

class CompareGroceryApp extends StatefulWidget {
  const CompareGroceryApp({super.key});

  @override
  State<CompareGroceryApp> createState() => _CompareGroceryAppState();
}

class _CompareGroceryAppState extends State<CompareGroceryApp> {
  final _catalog = CatalogRepository();
  late final ProfileBloc _profileBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _profileBloc = ProfileBloc();
    _router = buildAppRouter(_profileBloc);
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CatalogRepository>.value(
      value: _catalog,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileBloc>.value(value: _profileBloc),
          BlocProvider<CartBloc>(create: (_) => CartBloc()),
          BlocProvider<BookmarkBloc>(create: (_) => BookmarkBloc()),
          BlocProvider<SavingsBloc>(create: (_) => SavingsBloc()),
          BlocProvider<CategoryFilterCubit>(create: (_) => CategoryFilterCubit()),
        ],
        child: MaterialApp.router(
          title: 'Compare Grocery',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
