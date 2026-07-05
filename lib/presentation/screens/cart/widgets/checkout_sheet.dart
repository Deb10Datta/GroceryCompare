import 'package:flutter/material.dart';

import '../../../../core/utils/currency.dart';
import '../../../../domain/cart_comparator.dart';
import '../../../widgets/platform_badge.dart';

enum _CheckoutStage { form, paying, done }

/// A contained "frame" the user completes payment inside, standing in for
/// a real embedded checkout — there's no payment processor behind this,
/// so it's a clearly-mocked form that never leaves the app.
Future<bool?> showCheckoutSheet(BuildContext context, PlatformTotal total) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => CheckoutSheet(total: total),
  );
}

class CheckoutSheet extends StatefulWidget {
  final PlatformTotal total;

  const CheckoutSheet({super.key, required this.total});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();
  _CheckoutStage _stage = _CheckoutStage.form;

  bool get _canPay =>
      _nameController.text.trim().isNotEmpty && _cardController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    setState(() => _stage = _CheckoutStage.paying);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _stage = _CheckoutStage.done);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline, size: 18),
                const SizedBox(width: 6),
                Text('Secure checkout', style: Theme.of(context).textTheme.labelLarge),
                const Spacer(),
                PlatformBadge(platform: widget.total.platform, size: 28),
              ],
            ),
            const Divider(height: 24),
            switch (_stage) {
              _CheckoutStage.form => _buildForm(context),
              _CheckoutStage.paying => _buildPaying(context),
              _CheckoutStage.done => _buildDone(context),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${widget.total.platform.name} order', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Total: ${formatCurrency(widget.total.finalTotal)}', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Cardholder name', border: OutlineInputBorder()),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _cardController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card number',
            hintText: '•••• •••• •••• ••••',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _canPay ? _pay : null,
            child: Text('Pay ${formatCurrency(widget.total.finalTotal)}'),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Demo checkout — no real payment is processed.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPaying(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing payment...'),
          ],
        ),
      ),
    );
  }

  Widget _buildDone(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 56),
        const SizedBox(height: 12),
        Text('Order placed! 🎉', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text('You saved ${formatCurrency(widget.total.totalSavings)} on ${widget.total.platform.name}'),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Done'),
          ),
        ),
      ],
    );
  }
}
