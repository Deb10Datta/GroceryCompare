import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/profile_bloc.dart';
import '../../data/models/grocery_platform.dart';
import '../../data/repositories/catalog_repository.dart';

/// The platforms that actually deliver to the signed-in user's area —
/// every catalog surface (listings, best offers, price comparisons)
/// should price against these, never the full platform list. Watches the
/// profile so a location change rebuilds the caller.
List<GroceryPlatform> watchServingPlatforms(BuildContext context) {
  final profile = context.watch<ProfileBloc>().state;
  return context.read<CatalogRepository>().platformsServing(
        pincode: profile.pincode,
        location: profile.location,
      );
}
