import 'package:icu/icu.dart';

import 'locale.dart';

extension Locale4X on Locale {
  ICU4XLocale to4X() {
    final icu4xLocale = ICU4XLocale.und()..language = language;
    if (region != null) icu4xLocale.region = region!;
    if (script != null) icu4xLocale.script = script!;
    return icu4xLocale;
  }
}
