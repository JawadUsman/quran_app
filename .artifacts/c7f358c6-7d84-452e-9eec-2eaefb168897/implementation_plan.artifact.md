# Upgrade Project to Dart 3, Null Safety & Fix All Build Issues

Fix all build, compilation, and dependency resolution issues across the Flutter project to ensure clean compilation on modern Flutter (Dart SDK 3.x).

## User Review Required

> [!IMPORTANT]
> The project currently specifies Dart SDK `<3.0.0` and uses `// @dart=2.11` headers in 65 Dart files, preventing compilation on Dart 3 SDK. Migrating to Dart 3 & Sound Null Safety requires updating dependency constraints in `pubspec.yaml`, stripping legacy `@dart=2.11` headers, adopting null safety types, and running `build_runner` for MobX, Moor/Drift, and BuiltValue code generators.

> [!WARNING]
> Package updates include major version upgrades for `audioplayers`, `dio`, `connectivity`, `material_design_icons_flutter`, `font_awesome_flutter`, `intl`, `moor`/`drift`, `shimmer`, and others. Some API calls in services/widgets may require updates to match modern package signatures.

## Proposed Changes

### Configuration & Dependencies

#### [MODIFY] [pubspec.yaml](file:///Users/jawadusman/Flutter/quran_app/pubspec.yaml)
- Update Dart SDK environment constraint to `sdk: ">=3.0.0 <4.0.0"`
- Upgrade dependencies to Dart 3-compatible versions (`cupertino_icons`, `logger`, `rxdart`, `rx_command`, `mobx`, `flutter_mobx`, `material_design_icons_flutter`, `intl`, `font_awesome_flutter`, `bubble_tab_indicator`, `built_collection`, `built_value`, `shimmer`, `scrollable_positioned_list`, `xml2json`, `tuple`, `rx_shared_preferences`, `expandable`, `sqflite`, `path_provider`, `json_annotation`, `moor`/`drift`, `sqlite3_flutter_libs`, `animator`, `draggable_scrollbar`, `yaml`, `dio`, `flutter_launcher_icons`, `audioplayers`, `fluttertoast`, `connectivity`/`connectivity_plus`, `flutter_cache_manager`, `shared_preferences`, `in_app_update`)
- Upgrade dev dependencies (`build_runner`, `mobx_codegen`, `built_value_generator`, `json_serializable`, `moor_generator`)

---

### Sound Null Safety & Code Migrations

#### [MODIFY] All 65 Dart files with `// @dart=2.11`
- Remove `// @dart=2.11` headers
- Add sound null-safety type annotations (`?`, `required`, non-nullable types)
- Fix legacy constructor syntax (e.g. `@required` -> `required`, `Key key` -> `Key? key`)

#### [MODIFY] [app_icon_button.dart](file:///Users/jawadusman/Flutter/quran_app/lib/app_widgets/app_icon_button.dart)
- Remove `// @dart=2.11`
- Update parameters to nullable/required (`Key? key`, `required Widget icon`, `required VoidCallback onTap`)

#### [MODIFY] Code Generators & Generated Files
- Run `flutter pub run build_runner build --delete-conflicting-outputs` to update all `.g.dart` files (`models.g.dart`, `appdb.g.dart`, `quran_provider.g.dart`, store files)

#### [MODIFY] Service & Widget Implementations
- Update `Audioplayers`, `Connectivity`, `Dio`, and MobX API usages where signatures changed in breaking upgrades.
- Fix all remaining `flutter analyze` errors and warnings.

## Verification Plan

### Automated Tests
- Run `flutter pub get` to verify package resolution.
- Run `flutter pub run build_runner build --delete-conflicting-outputs` to ensure code generation completes without errors.
- Run `flutter analyze` to verify zero errors across the entire project.
- Run `flutter test` (if unit tests exist) to verify tests pass.

### Manual Verification
- Verify the app builds cleanly via `flutter build apk --debug` or `flutter check`.
