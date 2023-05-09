import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'number_format.dart';
import 'number_format_4x.dart';
import 'number_format_stub.dart' if (dart.library.js) 'number_format_ecma.dart';

NumberFormat getFormatter(
  List<Locale> locales,
  LocaleMatcher localeMatcher,
  EcmaPolicy ecmaPolicy,
) =>
    buildFormatter(
      locales,
      localeMatcher,
      ecmaPolicy,
      getNumberFormatterECMA,
      getNumberFormatter4X,
    );
