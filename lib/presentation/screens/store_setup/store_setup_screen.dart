import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/cart_bloc.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../data/models/grocery_platform.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/services/platform_session_manager.dart';
import '../../widgets/floating_tile.dart';
import '../../widgets/platform_badge.dart';

enum _StoreStatus { checking, live, unavailable }

/// Shown once, right after onboarding: walks through every platform,
/// marks the ones serving the user's PIN code, and opens a hidden browser
/// session for exactly those. Unavailable stores get no session at all.
class StoreSetupScreen extends StatefulWidget {
  const StoreSetupScreen({super.key});

  @override
  State<StoreSetupScreen> createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  late final List<GroceryPlatform> _allPlatforms;
  late final Set<String> _availableIds;
  late final UserProfile _profile;
  late final bool _sessionsSupported;
  final Map<String, _StoreStatus> _status = {};
  bool _done = false;

  @override
  void initState() {
    super.initState();
    final catalog = context.read<CatalogRepository>();
    final manager = context.read<PlatformSessionManager>();
    _profile = context.read<ProfileBloc>().state;
    _allPlatforms = catalog.platforms;
    _availableIds = catalog
        .platformsServing(
          pincode: _profile.pincode,
          location: _profile.location,
        )
        .map((p) => p.id)
        .toSet();
    _sessionsSupported = manager.isSupported;
    for (final p in _allPlatforms) {
      _status[p.id] = _StoreStatus.checking;
    }

    // Open the hidden browser sessions for the serviceable stores only,
    // and mirror whatever is already in the cart into them.
    manager.startSessions(
      pincode: _profile.pincode,
      location: _profile.location,
    );
    manager.syncCart(context.read<CartBloc>().state);

    _run();
  }

  Future<void> _run() async {
    for (final platform in _allPlatforms) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() {
        _status[platform.id] = _availableIds.contains(platform.id)
            ? _StoreStatus.live
            : _StoreStatus.unavailable;
      });
    }
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _done = true);
  }

  String _subtitleFor(_StoreStatus status) => switch (status) {
    _StoreStatus.checking => 'Checking your PIN code…',
    _StoreStatus.live =>
      _sessionsSupported
          ? 'Delivers to you — browser session opened'
          : 'Delivers to you',
    _StoreStatus.unavailable =>
      _sessionsSupported
          ? 'Not in your area yet — session closed'
          : 'Not in your area yet',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Setting up your stores 🏪',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Checking which stores deliver to PIN ${_profile.pincode} and keeping '
                'only those ready for your cart.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _profile.location,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: _allPlatforms.map((platform) {
                    final status = _status[platform.id]!;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FloatingTile(
                        interactive: false,
                        child: Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            leading: PlatformBadge(platform: platform),
                            title: Text(platform.name),
                            subtitle: Text(_subtitleFor(status)),
                            trailing: switch (status) {
                              _StoreStatus.checking => const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              _StoreStatus.live => const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              _StoreStatus.unavailable => Icon(
                                Icons.remove_circle_outline,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (_done)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/home/dashboard'),
                    child: const Text("Let's start saving! 🚀"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
