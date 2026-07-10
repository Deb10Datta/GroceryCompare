import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/category_filter_cubit.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../data/models/payment_method.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/services/pincode_service.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/platform_badge.dart';
import '../../widgets/quirky_back_button.dart';

const _stepCount = 5;

/// Sex / gender categories offered on the name step. Stored on the
/// profile for our own record keeping only.
const sexChoices = [
  ('Female', '♀️'),
  ('Male', '♂️'),
  ('Non-binary', '🌈'),
  ('Prefer not to say', '🤫'),
];

/// Quirky life-stage "vibe" tiles picked on the name step — stored on the
/// profile as the user's tribe, and the tile's emoji doubles as the avatar.
const tribeChoices = [
  ('Single and rocking', '🎸'),
  ('Someone special on standby', '💘'),
  ('About to be hitched', '💍'),
  ('Newly formed Tag Team', '🤼'),
  ('Prime Minister of the Household', '🏛️'),
  ('Awaiting a Small Member', '🍼'),
  ('Separated but a Beast', '🦁'),
  ('Family Feud', '🎪'),
  ("Still rolling at mid 30's", '🛹'),
  ('Age is just a Number', '🎂'),
];

final _emailPattern = RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$');

/// Quirky error for a bad email, or null when it's valid. Empty fields get
/// no error text (the Next button already refuses to budge), so the form
/// doesn't yell at people before they've even started typing.
String? emailError(String value) {
  final v = value.trim();
  if (v.isEmpty) return null;
  if (!v.contains('@')) {
    return "That email is missing its @ — the little swirl is kind of the whole point 🌀";
  }
  if (!_emailPattern.hasMatch(v)) {
    return 'Hmm, that email looks fishy 🐟 Try something like you@somewhere.com';
  }
  return null;
}

/// Quirky error for a phone number that isn't 10 digits, or null when valid.
/// Accepts an optional +91 / 0 prefix and ignores spaces and dashes.
String? phoneError(String value) {
  var digits = value.trim().replaceAll(RegExp(r'[\s-]'), '');
  if (digits.isEmpty) return null;
  if (digits.startsWith('+91')) digits = digits.substring(3);
  if (digits.length == 11 && digits.startsWith('0')) digits = digits.substring(1);
  if (RegExp(r'[^\d]').hasMatch(digits)) {
    return 'Phone numbers are a digits-only club 🕶️ — no letters allowed past the bouncer';
  }
  if (digits.length < 10) {
    return 'Only ${digits.length} digit${digits.length == 1 ? '' : 's'}? Even carrier pigeons need 10 to find you 🐦';
  }
  if (digits.length > 10) {
    return "That's ${digits.length} digits — a phone number and a half! Keep it to 10 ✂️";
  }
  return null;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _pincodeService = PincodeService();

  int _page = 0;
  String _avatar = '🙂';
  String? _sex;
  String? _tribe;
  String? _categoryId;
  PaymentMethod _paymentMethod = PaymentMethod.upi;

  // Live PIN-code serviceability check state.
  PincodeLookupResult? _pincodeLookup;
  bool _checkingPincode = false;
  bool _pincodeUnknown = false;
  bool _locationAutoFilled = false;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _pincodeController.dispose();
    _pincodeService.dispose();
    super.dispose();
  }

  // The location step needs a verified PIN code: 6 valid digits, the
  // serviceability check finished, and the postal API didn't reject it.
  bool get _locationStepValid =>
      _pincodeController.text.trim().length == 6 &&
      pincodeError(_pincodeController.text) == null &&
      !_checkingPincode &&
      !_pincodeUnknown &&
      _pincodeLookup != null;

  // Contact details are for our own record keeping: both mandatory and
  // both must be well-formed before Next unlocks.
  bool get _contactStepValid =>
      _emailController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      emailError(_emailController.text) == null &&
      phoneError(_phoneController.text) == null;

  bool get _canContinue => switch (_page) {
        0 => _nameController.text.trim().isNotEmpty && _sex != null && _tribe != null,
        1 => _contactStepValid,
        2 => _locationStepValid,
        3 => _categoryId != null,
        _ => true,
      };

  void _onPincodeChanged(String value) {
    final pin = value.trim();
    setState(() {
      // Any in-flight check is now stale; its result will be discarded.
      _checkingPincode = false;
      _pincodeUnknown = false;
      _pincodeLookup = null;
      if (_locationAutoFilled) {
        _locationController.clear();
        _locationAutoFilled = false;
      }
    });
    if (pin.length == 6 && pincodeError(pin) == null) {
      _checkServiceability(pin);
    }
  }

  Future<void> _checkServiceability(String pin) async {
    setState(() => _checkingPincode = true);
    PincodeLookupResult? result;
    var unknown = false;
    try {
      result = await _pincodeService.lookup(pin);
    } on UnknownPincodeException {
      unknown = true;
    }
    if (!mounted) return;
    // The user may have edited the PIN while we were checking — if so,
    // this result is stale and a newer check is already on its way.
    if (_pincodeController.text.trim() != pin) return;
    setState(() {
      _checkingPincode = false;
      _pincodeUnknown = unknown;
      _pincodeLookup = result;
      if (result != null && result.displayLocation.isNotEmpty &&
          (_locationController.text.trim().isEmpty || _locationAutoFilled)) {
        _locationController.text = result.displayLocation;
        _locationAutoFilled = true;
      }
    });
  }

  void _next() {
    if (_page == _stepCount - 1) {
      context.read<ProfileBloc>().add(OnboardingCompleted(
            name: _nameController.text.trim(),
            sex: _sex!,
            email: _emailController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            avatarEmoji: _avatar,
            tribe: _tribe!,
            location: _locationController.text.trim(),
            pincode: _pincodeController.text.trim(),
            categoryId: _categoryId!,
            paymentMethod: _paymentMethod,
          ));
      context.read<CategoryFilterCubit>().select(_categoryId);
      context.go('/store-setup');
      return;
    }
    setState(() => _page++);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _previous() {
    setState(() => _page--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = context.read<CatalogRepository>();

    return Scaffold(
      floatingActionButton: _page > 0 ? QuirkyBackButton(onPressed: _previous) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(_stepCount, (i) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= _page
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _buildNameStep(context),
                  _buildContactStep(context),
                  _buildLocationStep(context),
                  _buildCategoryStep(context, catalog),
                  _buildPaymentStep(context),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canContinue ? _next : null,
                  child: Text(_page == _stepCount - 1 ? 'Set up my stores 🏪' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameStep(BuildContext context) {
    return _StepScaffold(
      title: 'Hey there! What should we call you? 👋',
      subtitle: "We'll use this to cheer you on when you save big.",
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('How do you identify?', style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: sexChoices.map((choice) {
                final (label, emoji) = choice;
                return ChoiceChip(
                  avatar: Text(emoji, style: const TextStyle(fontSize: 16)),
                  label: Text(label),
                  selected: label == _sex,
                  onSelected: (_) => setState(() => _sex = label),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Pick your vibe', style: Theme.of(context).textTheme.titleSmall),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'No judgement — every vibe deserves great deals.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tribeChoices.map((choice) {
              final (label, emoji) = choice;
              final selected = label == _tribe;
              return ChoiceChip(
                avatar: Text(emoji, style: const TextStyle(fontSize: 18)),
                label: Text(label),
                selected: selected,
                // The vibe's emoji doubles as the profile avatar.
                onSelected: (_) => setState(() {
                  _tribe = label;
                  _avatar = emoji;
                }),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactStep(BuildContext context) {
    return _StepScaffold(
      title: 'How do we reach you? ✉️',
      subtitle: 'Kept only in our records — for your savings reports and order '
          'history. Never shared with the grocery platforms.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email (required)',
              hintText: 'you@somewhere.com',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.alternate_email),
              errorText: emailError(_emailController.text),
              errorMaxLines: 3,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone number (required)',
              hintText: '10 digits',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.phone_outlined),
              errorText: phoneError(_phoneController.text),
              errorMaxLines: 3,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep(BuildContext context) {
    final catalog = context.read<CatalogRepository>();
    final lookup = _pincodeLookup;

    return _StepScaffold(
      title: 'Where should we deliver? 📍',
      subtitle: "Drop in your PIN code and we'll check which stores are active in your area.",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _pincodeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 6,
            decoration: InputDecoration(
              labelText: 'PIN code (required)',
              hintText: 'e.g. 560034',
              counterText: '',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.pin_drop_outlined),
              suffixIcon: _checkingPincode
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (_locationStepValid ? const Icon(Icons.check_circle, color: Colors.green) : null),
              errorText: _pincodeUnknown
                  ? "India Post has never heard of that PIN code 📪 Double-check the digits?"
                  : pincodeError(_pincodeController.text),
              errorMaxLines: 3,
            ),
            onChanged: _onPincodeChanged,
          ),
          if (_checkingPincode) ...[
            const SizedBox(height: 12),
            Text(
              'Checking which stores deliver to ${_pincodeController.text.trim()}…',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (lookup != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            lookup.displayLocation.isEmpty
                                ? 'PIN ${lookup.pincode}'
                                : lookup.displayLocation,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    if (lookup.source == PincodeLookupSource.offline) ...[
                      const SizedBox(height: 4),
                      Text(
                        "Couldn't reach the postal service — showing our best offline estimate.",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.deepOrange),
                      ),
                    ],
                    const Divider(height: 20),
                    Text('Stores in your area', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    ...catalog.platforms.map((platform) {
                      final active = lookup.platformIds.contains(platform.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            PlatformBadge(platform: platform, size: 26),
                            const SizedBox(width: 10),
                            Expanded(child: Text(platform.name)),
                            Icon(
                              active ? Icons.check_circle : Icons.remove_circle_outline,
                              size: 18,
                              color: active ? Colors.green : Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              active ? 'Delivers here' : 'Not yet',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Locality (edit if needed)',
                hintText: 'e.g. Koramangala, Bengaluru',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home_outlined),
              ),
              onChanged: (_) => setState(() => _locationAutoFilled = false),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryStep(BuildContext context, CatalogRepository catalog) {
    return _StepScaffold(
      title: 'What are you usually stocking up on? 🛍️',
      subtitle: "We'll show this first, but you can browse everything.",
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: catalog.categories.map((category) {
          final selected = category.id == _categoryId;
          return ChoiceChip(
            avatar: AppIconTile(icon: category.icon, color: category.color, size: 26),
            label: Text(category.name),
            selected: selected,
            onSelected: (_) => setState(() => _categoryId = category.id),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentStep(BuildContext context) {
    return _StepScaffold(
      title: 'How do you like to pay? 💳',
      subtitle: "We'll surface payment offers that match this.",
      child: RadioGroup<PaymentMethod>(
        groupValue: _paymentMethod,
        onChanged: (v) => setState(() => _paymentMethod = v!),
        child: Column(
          children: PaymentMethod.values.map((method) {
            return Card(
              child: RadioListTile<PaymentMethod>(
                value: method,
                title: Text('${method.emoji}  ${method.label}'),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _StepScaffold({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
