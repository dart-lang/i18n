import '../bindings/dart/lib.g.dart' as icu;

import 'locale.dart';

extension Locale4X on Locale {
  icu.Locale to4X() {
    final icu4xLocale = icu.Locale.und()..language = language;
    if (region != null) icu4xLocale.region = region!;
    if (script != null) icu4xLocale.script = script!;
    return icu4xLocale;
  }
}
