# Compare Grocery 🛒

A Flutter app that compares grocery prices, coupons, and payment offers
across quick-commerce platforms — so you always know which app has the
best deal before you order.

The five simulated platforms are **Blinkit, Zepto, Swiggy Instamart,
BigBasket, and JioMart**. Their "logos" are stylized colored initials
(BK, ZP, IM, BB, JM), not the real trademarked artwork.

## ⚠️ What to expect (read this first)

This is a **fully self-contained demo**. It looks and behaves like a real
price-comparison app, but:

- **All prices, coupons, and payment offers are mock data.** None of the
  five platforms expose a public pricing API, so the app runs on a
  realistic, deterministic mock catalog (90+ branded products across 23
  categories, from Electronics to Pet Supplies — several product types are
  offered by more than one brand) behind a repository layer. Swapping in a
  real backend later means replacing one class: `CatalogRepository`.
- **PIN-code serviceability is real (via India Post), store coverage is
  curated.** Your PIN code is validated live against the free India Post
  API and resolved to a locality; which stores "deliver" there comes from
  a curated metro map (with an offline postal-prefix fallback), because
  the platforms expose no public serviceability API.
- **Checkout hands you off to the real store.** There is no partner API
  to pre-fill a third-party cart, so the app preps your shopping list and
  coupon code, then opens the chosen platform's own website to finish the
  purchase — in an in-app browser tab on Android/iOS (where hidden store
  sessions are kept warm), or your external browser elsewhere. No
  payment ever happens inside this app.
- **Everything is stored on-device.** Profile (including the email/phone
  collected for record keeping), cart, bookmarks, and order history
  persist locally via `hydrated_bloc`. Nothing is sent to the grocery
  platforms.

## Capabilities

| Area | What it does |
|---|---|
| **Onboarding** | Five steps: your name, sex category, and a quirky **vibe tile** ("Single and rocking" … "Age is just a Number") whose emoji becomes your avatar; email + phone (**mandatory, validated**, kept only for the app's own record keeping); your **PIN code** with a live serviceability check; favorite category; and preferred payment method. Runs once; persisted locally. |
| **PIN-code serviceability** | Your 6-digit PIN is validated live against the India Post API, resolved to a locality, and mapped to the stores that deliver there (all 5 in metro PINs like 560034, fewer elsewhere; offline prefix fallback if the API is unreachable). Every price surface in the app is scoped to those stores only. |
| **Store setup** | A one-time screen after onboarding that checks each store against your PIN and (on Android/iOS) opens a hidden browser session for exactly the serviceable ones, which then mirror your cart as you shop. |
| **Dashboard (landing page)** | Your home screen: a **Start shopping** tile that jumps straight to the catalog, local stores, a gamified **Savings Master** badge, a savings roadmap, active orders, and order history. |
| **Product list** | 23 categories (Electronics, Shoes, Video Games, Pet Supplies, …) with brand-level products — the same product type often exists from multiple brands at different prices. Pre-filtered to your favorite category; each card shows the best coupon-applied price and the minimum basket needed to unlock it. |
| **Bright pop theme** | Neo-brutalist look: orange/yellow/blue/green on a warm cream canvas, thick black outlines on every section, and **floating tiles** whose shadows are cast from a virtual light source at the screen centre — shifting as you scroll, with hover lift and press feedback. |
| **Product detail** | Every platform's price side by side (base price, coupon code, min basket, live expiry countdown), a bookmark toggle per offer, and a **quantity stepper** so you can add several units at once. |
| **Cart comparison** | Totals your whole basket on every platform *serving your PIN code*, applying each platform's coupon (once you meet its min basket) and your payment method's offer, then highlights the cheapest. Stores that don't deliver to you show no total and no buy link. |
| **Checkout handoff** | "Buy on …" opens a handoff sheet: order summary, copyable shopping list and coupon code, per-item search deep links, then the platform's own website — as a promoted in-app browser tab on Android/iOS (other stores' hidden tabs auto-close) or the external browser elsewhere. Confirming "I placed my order" records your savings. |
| **Order lifecycle** | Placed orders stay under "Active orders" on the Dashboard until you tap **Mark delivered**, then move to order history. |
| **Bookmarks** | Saved offers with store badges, live expiry countdowns, and quick-links back to the product. |
| **Savings gamification** | Badge tiers (Bargain Rookie 🌱 → Deal Hunter 🔍 → Discount Ninja 🥷 → Savings Master 🏆 → Frugal Legend 👑) plus a quirky roadmap of things you could buy with what you've saved (☕ chai → ✈️ a weekend trip). |
| **Quirky navigation** | A playful back-arrow button floats at the bottom-left of every drill-in page. |

## Screenshots

| Onboarding | Product list | Product detail |
|---|---|---|
| ![Onboarding](docs/screenshots/onboarding.png) | ![Product list](docs/screenshots/product_list.png) | ![Product detail](docs/screenshots/product_detail.png) |

| Cart comparison | Dashboard | Bookmarks |
|---|---|---|
| ![Cart comparison](docs/screenshots/cart_comparison.png) | ![Dashboard](docs/screenshots/dashboard.png) | ![Bookmarks](docs/screenshots/bookmarks.png) |

## Dependencies

Runtime packages (see `pubspec.yaml`):

| Package | Version | Why it's here |
|---|---|---|
| `flutter_bloc` | ^9.1.0 | State management (Bloc/Cubit pattern) |
| `equatable` | ^2.0.5 | Value equality for states and models |
| `hydrated_bloc` | ^10.0.0 | Automatic on-device persistence of profile, cart, bookmarks, and savings history |
| `path_provider` | ^2.1.4 | Storage directory for `hydrated_bloc` on mobile/desktop |
| `go_router` | ^15.1.2 | Navigation: onboarding redirect, bottom-nav shell, product-detail deep links |
| `intl` | ^0.20.2 | ₹ currency and date formatting |
| `http` | ^1.2.2 | Live PIN-code lookups against the India Post API |
| `url_launcher` | ^6.3.1 | Opens the chosen store's website for checkout (external-browser fallback) |
| `webview_flutter` | ^4.10.0 | Hidden per-store browser sessions + in-app checkout tab (Android/iOS only) |
| `cupertino_icons` | ^1.0.8 | iOS-style icons (Flutter default) |

Dev packages: `flutter_test` (unit tests) and `flutter_lints` ^6.0.0
(static analysis rules).

Pinned overrides: `path_provider_android: 2.2.15` and
`path_provider_foundation: 2.4.1` — newer versions can fail to build on
Windows when your username contains a space (a native-assets build-hook
bug). Remove the overrides once the upstream bug is fixed.

Environment: Dart SDK ^3.12.2 (comes with a current stable Flutter).

## Setup

1. **Install the Flutter SDK** (stable channel) — see
   [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install).
   Verify with:
   ```bash
   flutter doctor
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run it**:
   ```bash
   flutter run -d chrome   # web — no extra setup needed
   flutter run             # or on a connected Android/iOS device/emulator,
                            # once you've installed the Android SDK / Xcode
   ```

## User guide — a full walkthrough

1. **Introduce yourself.** Enter your name, pick a sex category, and
   choose your **vibe** (from "Single and rocking" to "Age is just a
   Number" — its emoji becomes your avatar). Next, enter your email and
   phone — kept only for the app's own records, and if the email looks
   fishy 🐟 or the phone isn't 10 digits 🐦, the form will let you know in
   its own quirky way.
2. **Enter your PIN code.** The app checks it live against India Post
   (try `560034` for all five stores, `700001` for just two) and shows
   exactly which stores deliver to you, with your locality auto-filled.
   Then choose your usual category and how you like to pay.
3. **Watch the store setup.** The app checks each store against your PIN
   and keeps only the serviceable ones ready (on Android/iOS it opens a
   hidden browser tab per store), then drops you on the **Dashboard**.
4. **Browse products.** Tap **Start shopping** on the Dashboard (or open
   the **Products** tab). The list is already filtered to your favorite
   category; tap **All** or another chip to change it. Many product types
   come from multiple brands (e.g. Running Shoes by Nike *and* Adidas).
   Tap any product to compare its price on every platform.
5. **Add to cart.** On the product page, use the **− / +** stepper to
   pick a quantity, then tap **Add to cart**. The cart isn't tied to one
   platform — it's just products and quantities.
6. **Bookmark deals.** Tap the 🔖 icon on any platform's row to save that
   offer. Find it later in the **Bookmarks** tab, expiry countdown and
   all.
7. **Compare and order.** Open the **Cart** tab: your basket is totaled
   on every store serving your PIN with coupons and payment offers
   applied where you qualify, cheapest first. Tap **Buy on …**, review
   the handoff sheet (copy your list and coupon code), and finish the
   purchase on the store's own website; then confirm **I placed my
   order** to record your savings.
8. **Track the order.** You land back on the Dashboard with the order
   under **Active orders 🚚**. When your imaginary groceries arrive, tap
   **Mark delivered** to move it into order history.
9. **Watch your savings grow.** Every order records what you saved versus
   the undiscounted total. Your Savings Master badge levels up and the
   roadmap unlocks progressively sillier rewards.

## Project structure

```
lib/
  data/
    models/         Plain data classes (Product, Coupon, PaymentOffer, ...)
    mock/           Static mock catalog (products, platforms, coupons, ...)
    repositories/   CatalogRepository — the one seam to swap in a real API
  domain/           Pure business logic: CartComparator, location availability,
                    savings tiers, roadmap items
  blocs/            ProfileBloc, CartBloc, BookmarkBloc, SavingsBloc,
                    CategoryFilterCubit
  presentation/
    screens/        One folder per screen, with screen-local widgets alongside
    widgets/        Shared widgets (platform badge, countdown, quirky back button)
  core/             Theme, currency formatting, router
  app.dart          Providers + MaterialApp.router wiring
  main.dart         Entry point, HydratedBloc storage init
test/               Unit tests: cart math, savings tiers, location availability,
                    catalog consistency
```

## Testing

```bash
flutter analyze   # static analysis — should report no issues
flutter test      # unit tests: cart-total math, coupon/payment-offer
                   # gating, savings tiers, location filtering, catalog data
```

## Known limitations

- Mock data is regenerated deterministically at app start, so coupon
  expiry countdowns reset relative to launch time — there's no backend to
  persist a "real" expiry.
- Carts can't be pre-filled on the stores' websites (no partner APIs), so
  checkout preps your list/coupon and hands off; hidden store sessions
  and the in-app checkout tab need Android/iOS (`webview_flutter` has no
  web/desktop support) — other targets fall back to the external browser.
- Only the Chrome web target has been verified in this environment —
  install Android Studio / Xcode to test on a device or emulator.
