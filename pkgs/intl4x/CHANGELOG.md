## 0.17.0

- Make `year` and `month` not zoneable, as this is a runtime error in ICU4X.

## 0.16.0

- Add class modifiers.

## 0.15.0

- API overhaul:
  - Getting rid of the Intl object, as it only served as a wrapper of Locale. So the ...Format objects are now the top-level things.
  - Remove most ...Options objects from the public API, as they make it more verbose. Users now directly input the options to the top-level ...Format constructor.
  - Use => instead of block bodies for methods where possible.
  - Fix some imports
  - Add documentation to some classes.
  - Remove some methods which are not implemented in ICU4X

## 0.14.0

- Change timezone API, adding a dependency on package:timezone.

## 0.13.2

- Add `withEra`.

## 0.13.1

- Fix casemapping on the web.

## 0.13.0

- Add examples of extensions to `List` and `DateTime` formatting.
- Removing `EcmaPolicy`, fixing Locale printing, and other small clean-ups.
- Update to `native_toolchain_c` v0.16.7.
- Make package compatible to run on Windows again.
- Update to `native_toolchain_c` v0.17.1.
- Move logic to package:icu4x.
- Switch `DateTime` formatting API and more clean-ups.

## 0.12.2

- Add lower- and uppercasing.
- Use new artifacts from `intl4x-icu-v.0.12.2-artifacts`.

## 0.12.1

- Use new artifacts from `intl4x-icu-v.0.12.0-artifacts`.

## 0.12.0

- Update to ICU4X 2.0.

## 0.11.4

- Remove `native_assets_*` dependencies for `hooks` and `code_assets`.

## 0.11.3

- Use new artifacts from `intl4x-icu-v.0.11.2-artifacts` release.

## 0.11.2

- Use locally modified build_tools.dart for building icu4x libs.

## 0.11.1

- Fix fraction digits parsing and allow no hook options key in the pubspec.

## 0.11.0

- Remove dep on package:js.
- Introduce link hook.

## 0.10.1

- Upgrade to new artifacts.

## 0.10.0

- Upgrade minimum SDK to `3.6.0-0`.
- Move hook code to `lib/src/`.

## 0.9.2

- Copy files instead of symlinking, for easier upgrading.
- Get binaries from Github and check their hashes.

## 0.9.1

- Small fixes in imports.

## 0.9.0

- Update for `icu4x` and `build.dart` changes.
- Fix leaking API.

## 0.8.2

- Add ICU4X support for number formatting.
- Add resource identifier annotations.
- Add ICU4X support for plural rules.
- Add ICU4X support for display names.
- Add ICU4X support for list formatting.
- Add ICU4X support for datetime formatting.

## 0.8.1

- Add ICU4X support for collation.

## 0.7.1

- Export plural rules.

## 0.7.0

- Add conformance testing workflow.
- Add ECMA `PluralRules`.

## 0.6.0

- Add full ECMA locale.

## 0.5.1

- Add `copyWith` methods.

## 0.5.0

- Add `DateTime` formatting.

## 0.4.0

- Add a `Locale` class.
- Update the readme to add standard markdown badges.

## 0.3.0

- Add display names.

## 0.2.0

- Add list format.

## 0.1.0

- Initial version.
- Add list collation.
