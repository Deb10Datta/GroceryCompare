import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/currency.dart';
import '../../../../data/models/coupon.dart';
import '../../../../data/models/product.dart';
import '../../../../data/services/platform_session_manager.dart';
import '../../../../domain/cart_comparator.dart';
import '../../../widgets/platform_badge.dart';
import '../platform_browser_screen.dart';

typedef CartEntry = ({Product product, int quantity});

/// Hands the user off to the chosen platform's own website to complete
/// the purchase. None of these platforms offer a public API to pre-fill a
/// third-party cart, so this sheet does the honest next-best thing:
/// per-item deep links into the platform's search, a one-tap copyable
/// shopping list, the coupon code ready to paste, and then opens the
/// storefront in the browser. Resolves true once the user confirms they
/// placed the order there.
Future<bool?> showPlatformHandoffSheet(
  BuildContext context, {
  required PlatformTotal total,
  required List<CartEntry> items,
}) {
  final sessionManager = context.read<PlatformSessionManager>();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => PlatformHandoffSheet(
      total: total,
      items: items,
      sessionManager: sessionManager,
    ),
  );
}

class PlatformHandoffSheet extends StatefulWidget {
  final PlatformTotal total;
  final List<CartEntry> items;
  final PlatformSessionManager sessionManager;

  const PlatformHandoffSheet({
    super.key,
    required this.total,
    required this.items,
    required this.sessionManager,
  });

  @override
  State<PlatformHandoffSheet> createState() => _PlatformHandoffSheetState();
}

class _PlatformHandoffSheetState extends State<PlatformHandoffSheet> {
  bool _siteOpened = false;
  bool _listCopied = false;

  String get _platformName => widget.total.platform.name;

  /// The hidden browser session for this platform, when one is alive
  /// (Android/iOS with the store serving the user's PIN code).
  PlatformCartSession? get _session =>
      widget.sessionManager.sessionFor(widget.total.platform.id);

  String get _shoppingListText {
    final buffer = StringBuffer('My grocery list:\n');
    for (final item in widget.items) {
      buffer.writeln('• ${item.product.displayName} (${item.product.unit}) × ${item.quantity}');
    }
    final coupon = widget.total.coupon;
    if (widget.total.couponApplied && coupon != null) {
      buffer.writeln('Coupon: ${coupon.code}');
    }
    return buffer.toString();
  }

  Future<void> _copyList() async {
    await Clipboard.setData(ClipboardData(text: _shoppingListText));
    if (!mounted) return;
    setState(() => _listCopied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shopping list copied — paste it anywhere 📋')),
    );
  }

  Future<void> _copyCoupon(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coupon $code copied — apply it at checkout 🎟️')),
    );
  }

  Future<void> _openItem(Product product) async {
    final uri = widget.total.platform.searchUri(product.displayName);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openStore() async {
    // Preferred path: promote this platform's hidden session to a visible
    // in-app browser tab; every other store's session auto-closes.
    final promoted = widget.sessionManager.promote(widget.total.platform.id);
    if (promoted != null) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PlatformBrowserScreen(
          session: promoted,
          coupon: widget.total.couponApplied ? widget.total.coupon : null,
        ),
      ));
      if (!mounted) return;
      setState(() => _siteOpened = true);
      return;
    }

    // Fallback for targets without WebView support: external browser.
    final launched = await launchUrl(
      widget.total.platform.websiteUri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted) return;
    if (launched) {
      setState(() => _siteOpened = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't open $_platformName — check your browser and try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coupon = widget.total.coupon;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.storefront_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Checkout on $_platformName',
                      style: theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PlatformBadge(platform: widget.total.platform, size: 28),
                ],
              ),
              const Divider(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: _siteOpened ? _buildFinishStage(theme, coupon) : _buildPrepareStage(theme, coupon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrepareStage(ThemeData theme, Coupon? coupon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.total.totalSavings > 0
              ? "You'll pay about ${formatCurrency(widget.total.finalTotal)} on $_platformName "
                  'after ${formatCurrency(widget.total.totalSavings)} in offers.'
              : "You'll pay about ${formatCurrency(widget.total.finalTotal)} on $_platformName.",
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _session != null
                    ? 'Your items — already lined up in your $_platformName tab'
                    : 'Your items — tap ↗ to open one on $_platformName',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              ...widget.items.map((item) => Row(
                    children: [
                      Text(item.product.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item.product.displayName} · ${item.product.unit} × ${item.quantity}',
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_session == null)
                        IconButton(
                          icon: const Icon(Icons.open_in_new, size: 18),
                          tooltip: 'Find on $_platformName',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _openItem(item.product),
                        ),
                    ],
                  )),
            ],
          ),
        ),
        if (widget.total.couponApplied && coupon != null) ...[
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              dense: true,
              leading: const Text('🎟️', style: TextStyle(fontSize: 20)),
              title: Text('Apply ${coupon.code} at checkout'),
              subtitle: Text('Saves ${formatCurrency(widget.total.rawTotal - widget.total.afterCoupon)}'),
              trailing: IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy coupon code',
                onPressed: () => _copyCoupon(coupon.code),
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          _session != null
              ? 'We\'ve kept a live $_platformName tab warming up with your '
                  'items. Continuing opens that tab — the other stores\' tabs '
                  'close automatically.'
              : '$_platformName doesn\'t let other apps pre-fill its cart, so '
                  'we\'ve prepped your list — open items above or copy the '
                  'list, then finish your purchase on their site.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _copyList,
                icon: Icon(_listCopied ? Icons.check : Icons.copy_all, size: 18),
                label: Text(_listCopied ? 'List copied' : 'Copy list'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: _openStore,
                icon: Icon(
                  _session != null ? Icons.tab : Icons.open_in_new,
                  size: 18,
                ),
                label: Text(
                  _session != null ? 'Continue on $_platformName' : 'Open $_platformName',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFinishStage(ThemeData theme, Coupon? coupon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        const Icon(Icons.shopping_cart_checkout, size: 48),
        const SizedBox(height: 12),
        Text('Finish up on $_platformName', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(
          switch ((widget.total.couponApplied && coupon != null, _session != null)) {
            (true, true) =>
              'All done on $_platformName? Don\'t forget ${coupon!.code} at checkout.',
            (false, true) => 'All done shopping on $_platformName?',
            (true, false) =>
              'We opened $_platformName in your browser. Add your items, apply '
                  '${coupon!.code} at checkout, and pay there.',
            (false, false) =>
              'We opened $_platformName in your browser. Add your items and pay there.',
          },
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('I placed my order 🎉'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not yet — keep my cart here'),
          ),
        ),
      ],
    );
  }
}
