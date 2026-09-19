# Be Right Bark

A Flutter app for marking and tracking location spots during dog walks. Users can drop pins at their current GPS position, name them, view a list of active spots with distance info, and manage them.

## Tech Stack

- **Flutter** (Dart SDK ^3.9.2)
- **State management:** flutter_riverpod 2.6.1
- **Routing:** go_router 14.0.0
- **Persistence:** Hive (with hive_flutter, hive_generator), shared_preferences
- **Location:** geolocator 13.0.0, latlong2
- **Maps:** flutter_map 7.0.2
- **Fonts:** google_fonts (Quicksand, Lilita One, Nunito)
- **i18n/formatting:** intl
- **Theming:** Material 3

## Project Structure

```
lib/
  main.dart              # App entry point, Hive init, permission init
  router.dart            # GoRouter config with ShellRoute + page transitions
  assets/                # Bundled images (mark_spot_icon.png)
  constants/             # App-wide constants (name.dart)
  models/                # Hive data models (Location)
  providers/             # Riverpod providers (location CRUD, user position stream)
  services/              # Platform service wrappers (GeolocatorService)
  features/              # Feature modules, each containing screens + widgets + controllers
    mark_spot/           # Core feature: mark current location as a spot
    active_spots/        # List and detail views for saved spots
    picked_up/           # Pick-up confirmation (WIP)
    map/                 # Map view with flutter_map (WIP)
    settings/            # Settings screen (WIP)
    good_human/          # Good human badges (WIP)
    stylesetter.dart     # Design system reference/testing screen
  widgets/               # Shared reusable widgets
    app_container.dart   # Main scaffold (header + bottom tabs + body)
    buttons/             # ButtonLarge, ButtonMedium, ButtonSmall
    confirmation/        # Confirmation dialog
    form_text_field.dart # Text input field
    map_pin.dart         # Map pin widget
    navigation/          # BottomTabs, HeaderBar
    titles/              # TitleLarge, TitleMedium, TitleSmall
  styles/                # Design tokens (colors, theme, typography, spacers)
  utils/                 # Helpers (permissions, hive box opener, time formatting, distance calc)
```

## Commands

```bash
# Run the app
flutter run

# Analyze code
flutter analyze

# Run tests
flutter test

# Regenerate Hive adapters (after changing models)
dart run build_runner build

# Get dependencies
flutter pub get
```

## Architecture Conventions

- **Feature-based organisation:** Each feature in `features/` owns its screens, controllers, and feature-specific widgets. Shared widgets live in `widgets/`.
- **Riverpod for state:** Use `Notifier`/`NotifierProvider` for mutable state, `StreamProvider` for reactive streams. Providers live in `providers/`.
- **GoRouter:** All routes defined in `router.dart`. ShellRoute wraps screens with `AppContainer` (bottom tabs + header). Use `_fadePageTransition` for tab switches, `_slideUpPageTransition` for detail/modal routes.
- **Hive for persistence:** The `Location` model is a `HiveObject`. The single `locations` box is opened at startup via `openHiveBox`. Always use `LocationNotifier` (not the box directly) for reads/writes.
- **Constants files:** Feature-specific magic values (strings, asset paths) go in a `constants.dart` alongside the widget.
- **Package imports:** `always_use_package_imports` lint is enforced. Use `package:be_right_bark/...` imports, not relative paths.
- **Lint rules:** `always_declare_return_types`, `prefer_const_constructors`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`, `avoid_unnecessary_containers`, `unawaited_futures`, `use_super_parameters` are all enforced.

## Testing

- Tests mirror the `lib/` structure under `test/` (e.g. `test/features/`, `test/widgets/`, `test/utils/`).
- `test/helpers/` contains shared test utilities:
  - `FakeLocationNotifier` — in-memory fake of `LocationNotifier` for widget tests. Use `seed()` to pre-populate locations.
  - `createTestLocations(count)` — generates fixture `Location` objects with London coordinates.
  - `test_tile_provider.dart` — fake tile provider for flutter_map in widget tests.
- Override `locationProvider` with `FakeLocationNotifier` in test `ProviderScope` overrides rather than mocking Hive directly.

## Style Guide

- **Design tokens** are in `styles/`: `colors.dart` (green/orange/gold/beige palette), `typography.dart` (font sizes), `spacers.dart` (spacing values), `theme.dart` (Material ThemeData).
- **Button variants:** `ButtonLarge` (250x250 circle), `ButtonMedium` (stadium shape), `ButtonSmall` (text/outlined/filled).
- Three font families: Quicksand (body), Lilita One (display), Nunito (labels).
