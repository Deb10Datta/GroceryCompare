import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/profile_bloc.dart';
import '../../../data/models/grocery_platform.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../widgets/platform_badge.dart';

/// Simulated account-linking step shown once, right after onboarding.
/// There's no real API to log into or sign up for accounts on Blinkit,
/// Zepto, etc., so this is an honest, clearly-mocked progress animation —
/// no network calls are made to any third-party platform.
class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  late final List<GroceryPlatform> _platforms;
  late final UserProfile _profile;
  final Set<String> _linked = {};
  bool _verifyingOtp = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    final catalog = context.read<CatalogRepository>();
    _profile = context.read<ProfileBloc>().state;
    _platforms = catalog.platformsAvailableFor(_profile.location);
    _run();
  }

  Future<void> _run() async {
    for (final platform in _platforms) {
      await Future.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      setState(() => _linked.add(platform.id));
    }

    if (_profile.isNewUser) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _verifyingOtp = true);
      await Future.delayed(const Duration(milliseconds: 900));
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
    }

    if (!mounted) return;
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    final isNewUser = _profile.isNewUser;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNewUser ? 'Setting up your accounts 🔐' : 'Logging you in 🔐',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                isNewUser
                    ? "Creating ${_profile.name.isEmpty ? 'your' : "${_profile.name}'s"} accounts with "
                        '${_profile.email} on the stores that deliver to your area.'
                    : 'Using ${_profile.email} / ${_profile.phoneNumber} to sign in to the '
                        'stores that deliver to your area.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(_profile.location, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: _platforms.map((platform) {
                    final linked = _linked.contains(platform.id);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: PlatformBadge(platform: platform),
                        title: Text(platform.name),
                        trailing: linked
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (_verifyingOtp && !_done)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: 12),
                      Text('Verifying OTP...'),
                    ],
                  ),
                ),
              if (_done)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go('/home/dashboard'),
                    child: const Text('Continue'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
