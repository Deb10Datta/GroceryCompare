import 'package:compare_grocery/main.dart' as app;
import 'package:compare_grocery/presentation/screens/products/widgets/product_grid_card.dart';
import 'package:compare_grocery/presentation/widgets/quirky_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Scripted walkthrough of the whole app, capturing the screenshots the
/// README embeds. Run with chromedriver listening on :4444:
///
///   flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/walkthrough_test.dart \
///     -d chrome --browser-dimension 430,932 --release
///
/// Uses fixed-duration pumps instead of pumpAndSettle throughout because
/// coupon countdowns tick every second and would never settle.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> settle(WidgetTester tester,
      [Duration duration = const Duration(milliseconds: 500)]) async {
    await tester.pump(duration);
    await tester.pump(const Duration(milliseconds: 400));
  }

  /// Pumps until [finder] matches or [maxSeconds] elapse — for stages
  /// gated on page transitions or real async work (pincode lookup,
  /// store-setup animation).
  Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
      {int maxSeconds = 15}) async {
    for (var i = 0; i < maxSeconds * 2; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (finder.evaluate().isNotEmpty) return;
    }
    expect(finder, findsWidgets); // fail with a useful message
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder.first);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(finder.first);
    await tester.pump(const Duration(milliseconds: 300));
  }

  /// Types into the TextField whose decoration label is [label] — index-
  /// free so leftover fields from a transitioning PageView page can't be
  /// hit by accident.
  Future<void> typeInto(WidgetTester tester, String label, String text) async {
    final field = find.widgetWithText(TextField, label);
    await tester.ensureVisible(field.first);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(field.first, text);
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('full walkthrough with screenshots', (tester) async {
    await app.main();
    await settle(tester, const Duration(seconds: 2));

    // ── Onboarding: name, sex, vibe ─────────────────────────────────
    await pumpUntilFound(tester, find.text('Your name'));
    await typeInto(tester, 'Your name', 'Ananya');
    await tapVisible(tester, find.text('Prefer not to say'));
    await tapVisible(tester, find.text('Prime Minister of the Household'));
    await settle(tester);
    await binding.takeScreenshot('onboarding_profile');
    await tapVisible(tester, find.text('Next'));
    await settle(tester);

    // ── Contact details (record keeping) ────────────────────────────
    await pumpUntilFound(tester, find.text('How do we reach you? ✉️'));
    await typeInto(tester, 'Email (required)', 'ananya@example.com');
    await typeInto(tester, 'Phone number (required)', '9876543210');
    await settle(tester);
    await binding.takeScreenshot('onboarding_contact');
    await tapVisible(tester, find.text('Next'));
    await settle(tester);

    // ── PIN code with live serviceability check ─────────────────────
    await pumpUntilFound(tester, find.text('Where should we deliver? 📍'));
    await typeInto(tester, 'PIN code (required)', '560034');
    await pumpUntilFound(tester, find.text('Stores in your area'));
    await settle(tester);
    await binding.takeScreenshot('onboarding_pincode');
    await tapVisible(tester, find.text('Next'));
    await settle(tester);

    // ── Favourite category, then payment ────────────────────────────
    await pumpUntilFound(
        tester, find.text('What are you usually stocking up on? 🛍️'));
    await tapVisible(tester, find.byType(ChoiceChip));
    await tapVisible(tester, find.text('Next'));
    await settle(tester);
    await pumpUntilFound(tester, find.text('How do you like to pay? 💳'));
    // Record a couple of payment methods: tick UPI and pick apps under it,
    // then tick Credit Card too — the step needs at least one method.
    await tapVisible(tester, find.text('📱  UPI'));
    await tapVisible(tester, find.text('Google Pay'));
    await tapVisible(tester, find.text('PhonePe'));
    await tapVisible(tester, find.text('💳  Credit Card'));
    await settle(tester);
    await binding.takeScreenshot('onboarding_payment');
    await tapVisible(tester, find.text('Set up my stores 🏪'));

    // ── Store setup (serviceable stores only) ───────────────────────
    await pumpUntilFound(tester, find.text("Let's start saving! 🚀"));
    await settle(tester);
    await binding.takeScreenshot('store_setup');
    await tapVisible(tester, find.text("Let's start saving! 🚀"));

    // ── Dashboard ───────────────────────────────────────────────────
    await pumpUntilFound(tester, find.text('Start shopping'));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('dashboard');

    // ── Product list ────────────────────────────────────────────────
    await tapVisible(tester, find.text('Start shopping'));
    await pumpUntilFound(tester, find.byType(ProductGridCard));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('product_list');

    // ── Product detail: bookmark an offer, add to cart ──────────────
    await tapVisible(tester, find.byType(ProductGridCard));
    await pumpUntilFound(tester, find.text('Add to cart'));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('product_detail');
    await tapVisible(tester, find.byIcon(Icons.bookmark_border));
    await tapVisible(tester, find.text('Add to cart'));
    // Let the confirmation snackbar play out before moving on.
    await tester.pump(const Duration(seconds: 5));
    await tapVisible(tester, find.byType(QuirkyBackButton));
    await settle(tester);

    // ── Cart comparison across serviceable stores ───────────────────
    await tapVisible(tester, find.text('Cart'));
    await pumpUntilFound(tester, find.textContaining('Buy on'));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('cart_comparison');

    // ── Checkout handoff sheet ──────────────────────────────────────
    await tapVisible(tester, find.textContaining('Buy on'));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('checkout_handoff');

    // Dismiss the sheet via the barrier, then visit bookmarks.
    await tester.tapAt(const Offset(215, 60));
    await settle(tester);
    await tapVisible(tester, find.text('Bookmarks'));
    await settle(tester, const Duration(seconds: 1));
    await binding.takeScreenshot('bookmarks');
  });
}
