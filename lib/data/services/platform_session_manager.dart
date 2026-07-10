import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/grocery_platform.dart';
import '../models/product.dart';
import '../repositories/catalog_repository.dart';

/// A live, hidden browser session on one platform's website. The WebView
/// exists off-screen from the moment serviceability is confirmed, so the
/// site's cookies (including its cart) stay warm; item searches are
/// preloaded into it as the user builds their cart in our app.
class PlatformCartSession {
  PlatformCartSession({required this.platform, required this.controller});

  final GroceryPlatform platform;
  final WebViewController controller;

  /// Cart items mirrored into this session, newest last.
  final List<({Product product, int quantity})> items = [];

  void showSearchFor(Product product) {
    controller.loadRequest(platform.searchUri(product.displayName));
  }

  void showHome() {
    controller.loadRequest(platform.websiteUri);
  }
}

/// Keeps one hidden browser session per platform that serves the user's
/// PIN code — and only those. Sessions are started right after the
/// serviceability check, mirror the in-app cart as it grows, and when the
/// user commits to one platform that session is promoted to a visible
/// browser while every other session is closed.
///
/// WebViews only exist on Android and iOS; on other targets [isSupported]
/// is false, no sessions are created, and checkout falls back to opening
/// the platform's website in the external browser.
///
/// Deliberately NOT a Listenable: it's served through RepositoryProvider,
/// and screens always read the session state fresh on build.
class PlatformSessionManager {
  PlatformSessionManager({required this.catalog});

  final CatalogRepository catalog;
  final Map<String, PlatformCartSession> _sessions = {};
  Map<String, int> _mirroredCart = const {};

  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  List<PlatformCartSession> get sessions => List.unmodifiable(_sessions.values);

  PlatformCartSession? sessionFor(String platformId) => _sessions[platformId];

  /// (Re)opens hidden sessions for exactly the platforms serving this
  /// area, closing any sessions left over from a previous location.
  void startSessions({required String pincode, required String location}) {
    if (!isSupported) return;
    _closeAll();
    final available = catalog.platformsServing(pincode: pincode, location: location);
    for (final platform in available) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(platform.websiteUri);
      _sessions[platform.id] = PlatformCartSession(
        platform: platform,
        controller: controller,
      );
    }
    _mirroredCart = const {};
  }

  /// Mirrors the in-app cart into every live session. Newly added products
  /// get their search results preloaded in each hidden tab, so whichever
  /// platform the user eventually picks already has the legwork done.
  void syncCart(Map<String, int> cart) {
    if (_sessions.isEmpty) return;
    final newlyAdded = [
      for (final id in cart.keys)
        if (!_mirroredCart.containsKey(id)) id,
    ];
    _mirroredCart = Map.of(cart);

    for (final session in _sessions.values) {
      session.items
        ..clear()
        ..addAll([
          for (final e in cart.entries)
            if (catalog.productByIdOrNull(e.key) != null)
              (product: catalog.productById(e.key), quantity: e.value),
        ]);
    }
    // Preload the most recent addition's search in every hidden tab.
    if (newlyAdded.isNotEmpty) {
      final product = catalog.productByIdOrNull(newlyAdded.last);
      if (product != null) {
        for (final session in _sessions.values) {
          session.showSearchFor(product);
        }
      }
    }
  }

  /// The user committed to one platform: every other session auto-closes
  /// and the chosen one is returned, ready to be shown full-screen.
  PlatformCartSession? promote(String platformId) {
    final chosen = _sessions[platformId];
    if (chosen == null) return null;
    for (final session in _sessions.values) {
      if (session.platform.id != platformId) {
        // Point the doomed tab at a blank page so the site stops working
        // in the background, then drop our only reference to it.
        session.controller.loadRequest(Uri.parse('about:blank'));
      }
    }
    _sessions.removeWhere((id, _) => id != platformId);
    return chosen;
  }

  void _closeAll() {
    for (final session in _sessions.values) {
      session.controller.loadRequest(Uri.parse('about:blank'));
    }
    _sessions.clear();
  }

  void dispose() {
    _closeAll();
  }
}
