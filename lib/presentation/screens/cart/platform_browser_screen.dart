import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../data/models/coupon.dart';
import '../../../data/services/platform_session_manager.dart';
import '../../widgets/platform_badge.dart';

/// The chosen platform's hidden session, promoted to a visible in-app
/// browser. Every other platform's session has already been closed by the
/// time this screen appears. The strip along the bottom holds the user's
/// cart items — tapping one loads that item's search results on the site
/// so it can be added to the real cart with one more tap.
class PlatformBrowserScreen extends StatefulWidget {
  final PlatformCartSession session;
  final Coupon? coupon;

  const PlatformBrowserScreen({super.key, required this.session, this.coupon});

  @override
  State<PlatformBrowserScreen> createState() => _PlatformBrowserScreenState();
}

class _PlatformBrowserScreenState extends State<PlatformBrowserScreen> {
  int? _openedItemIndex;

  Future<void> _copyCoupon(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Coupon $code copied — paste it at checkout 🎟️')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platform = widget.session.platform;
    final coupon = widget.coupon;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Back to comparison',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformBadge(platform: platform, size: 26),
            const SizedBox(width: 8),
            Flexible(child: Text(platform.name, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          if (coupon != null)
            TextButton.icon(
              onPressed: () => _copyCoupon(coupon.code),
              icon: const Text('🎟️'),
              label: Text(coupon.code),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Done'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: WebViewWidget(controller: widget.session.controller),
      bottomNavigationBar: widget.session.items.isEmpty
          ? null
          : SafeArea(
              child: Container(
                height: 56,
                color: theme.colorScheme.surfaceContainerHighest,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    for (var i = 0; i < widget.session.items.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          avatar: Text(widget.session.items[i].product.emoji),
                          label: Text(
                            '${widget.session.items[i].product.displayName} '
                            '× ${widget.session.items[i].quantity}',
                          ),
                          backgroundColor: _openedItemIndex == i
                              ? theme.colorScheme.primaryContainer
                              : null,
                          onPressed: () {
                            setState(() => _openedItemIndex = i);
                            widget.session
                                .showSearchFor(widget.session.items[i].product);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
