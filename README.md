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
- **The "account linking" step is simulated.** After onboarding, the app
  *animates* logging into (or creating accounts on) the stores in your
  area — but it makes **no network calls to any grocery platform**.
  Automating real logins against third-party services without their
  authorization isn't something this project does.
- **Checkout is a demo.** The "Secure checkout" sheet accepts any name
  and card number and **processes no real payment** — it's labeled as
  such in the UI.
- **Everything is stored on-device.** Profile, cart, bookmarks, and order
  history persist locally via `hydrated_bloc`. There is no server, no
  login backend, and no data leaves your machine.

## Capabilities

| Area | What it does |
|---|---|
| **Onboarding** | Collects your email + phone (existing grocery-app user) *or* registers you as a new user — both are **mandatory and validated**, with quirky error messages for a malformed email or a phone number that isn't 10 digits. Then name/avatar, your **tribe** (quirky life-stage tiles like "Prime Minister of the Household"), location, favorite category, and preferred payment method. Runs once; persisted locally. |
| **Location-aware stores** | Your location determines which platforms "deliver" to you (e.g. all 5 in Bengaluru/Mumbai/Delhi, fewer elsewhere). Shown as "Stores operating in your locality" on the Dashboard. |
| **Account linking (simulated)** | A one-time animated screen that "signs you in" to each local store — with an OTP-verification step if you registered as a new user. |
| **Dashboard (landing page)** | Your home screen: a **Start shopping** tile that jumps straight to the catalog, local stores, a gamified **Savings Master** badge, a savings roadmap, active orders, and order history. |
| **Product list** | 23 categories (Electronics, Shoes, Video Games, Pet Supplies, …) with brand-level products — the same product type often exists from multiple brands at different prices. Pre-filtered to your favorite category; each card shows the best coupon-applied price and the minimum basket needed to unlock it. |
| **Dark neon theme** | The whole app runs on a midnight-blue dark theme accented with neon blue, red, yellow, purple, and green. |
| **Product detail** | Every platform's price side by side (base price, coupon code, min basket, live expiry countdown), a bookmark toggle per offer, and a **quantity stepper** so you can add several units at once. |
| **Cart comparison** | Totals your whole basket on *every* platform, applying each platform's coupon (once you meet its min basket) and your payment method's offer, then highlights the cheapest. |
| **Checkout (demo)** | A contained "Secure checkout" sheet: order summary → mock payment form → confirmation. Records your savings on completion. |
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

1. **Sign in or register.** On first launch, either enter the email and
   phone number "registered with your grocery apps," or tick
   *I am a new user with no registered accounts* and register with a
   fresh email + phone. Both fields are required — and if the email looks
   fishy 🐟 or the phone isn't 10 digits 🐦, the form will let you know in
   its own quirky way.
2. **Complete onboarding.** Pick a name and avatar, choose your **tribe**
   (from "Single and rocking" to "Age is just a Number"), enter your
   location (try `Koramangala, Bengaluru` for all five stores), choose
   your usual category, and pick how you like to pay.
3. **Watch the (simulated) account linking.** The app "connects" you to
   each store that delivers to your area — with an OTP step if you're a
   new user — then drops you on the **Dashboard**, your home screen.
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
   on every platform with coupons and payment offers applied where you
   qualify, cheapest first. Tap **Place order (demo)** on your pick and
   complete the demo checkout sheet (any name/card number works — nothing
   is charged).
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
- Account linking, OTP verification, and checkout are simulations by
  design (see *What to expect* above).
- Only the Chrome web target has been verified in this environment —
  install Android Studio / Xcode to test on a device or emulator.
