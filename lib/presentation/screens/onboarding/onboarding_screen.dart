import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/category_filter_cubit.dart';
import '../../../blocs/profile_bloc.dart';
import '../../../data/models/payment_method.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../widgets/app_icon_tile.dart';
import '../../widgets/quirky_back_button.dart';

const _avatarChoices = ['🙂', '😎', '🥳', '🧑‍🍳', '🛒', '👩‍🍳', '🐼', '🦊'];
const _stepCount = 5;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _existingEmailController = TextEditingController();
  final _existingPhoneController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _newPhoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();

  int _page = 0;
  bool _isNewUser = false;
  String _avatar = _avatarChoices.first;
  String? _categoryId;
  PaymentMethod _paymentMethod = PaymentMethod.upi;

  @override
  void dispose() {
    _pageController.dispose();
    _existingEmailController.dispose();
    _existingPhoneController.dispose();
    _newEmailController.dispose();
    _newPhoneController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool get _canContinue => switch (_page) {
        0 => _isNewUser
            ? _newEmailController.text.trim().isNotEmpty && _newPhoneController.text.trim().isNotEmpty
            : _existingEmailController.text.trim().isNotEmpty &&
                _existingPhoneController.text.trim().isNotEmpty,
        1 => _nameController.text.trim().isNotEmpty,
        2 => _locationController.text.trim().isNotEmpty,
        3 => _categoryId != null,
        _ => true,
      };

  void _next() {
    if (_page == _stepCount - 1) {
      context.read<ProfileBloc>().add(OnboardingCompleted(
            email: _isNewUser ? _newEmailController.text.trim() : _existingEmailController.text.trim(),
            phoneNumber: _isNewUser ? _newPhoneController.text.trim() : _existingPhoneController.text.trim(),
            isNewUser: _isNewUser,
            name: _nameController.text.trim(),
            avatarEmoji: _avatar,
            location: _locationController.text.trim(),
            categoryId: _categoryId!,
            paymentMethod: _paymentMethod,
          ));
      context.read<CategoryFilterCubit>().select(_categoryId);
      context.go('/account-linking');
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
                  _buildAccountStep(context),
                  _buildNameStep(context),
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
                  child: Text(_page == _stepCount - 1 ? "Let's start saving! 🚀" : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStep(BuildContext context) {
    return _StepScaffold(
      title: "Let's link your grocery accounts 📲",
      subtitle: 'This helps us compare prices for the apps you already use.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Already have grocery app accounts?', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _existingEmailController,
                    enabled: !_isNewUser,
                    decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _existingPhoneController,
                    enabled: !_isNewUser,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please provide the phone number which is currently registered with grocery apps.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            value: _isNewUser,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text('I am a new user with no registered accounts'),
            onChanged: (v) => setState(() => _isNewUser = v ?? false),
          ),
          if (_isNewUser) ...[
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Register a new account', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newEmailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _newPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone number', border: OutlineInputBorder()),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
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
          Text('Pick your vibe', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: _avatarChoices.map((emoji) {
              final selected = emoji == _avatar;
              return ChoiceChip(
                label: Text(emoji, style: const TextStyle(fontSize: 20)),
                selected: selected,
                onSelected: (_) => setState(() => _avatar = emoji),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep(BuildContext context) {
    return _StepScaffold(
      title: 'Where are we shopping today? 📍',
      subtitle: 'Prices and delivery can vary a little by area.',
      child: TextField(
        controller: _locationController,
        decoration: const InputDecoration(
          labelText: 'Locality, city',
          hintText: 'e.g. Koramangala, Bengaluru',
          border: OutlineInputBorder(),
        ),
        onChanged: (_) => setState(() {}),
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
