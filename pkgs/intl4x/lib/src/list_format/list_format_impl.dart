import '../../ecma_policy.dart';
import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../utils.dart';
import 'list_format_4x.dart';
import 'list_format_options.dart';
import 'list_format_stub.dart' if (dart.library.js) 'list_format_ecma.dart';

abstract class ListFormatImpl {
  final Locale locale;

  ListFormatImpl(this.locale);

  String formatImpl(List<String> list, ListFormatOptions options);

  factory ListFormatImpl.build(
    Locale locales,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        localeMatcher,
        ecmaPolicy,
        getListFormatterECMA,
        getListFormatter4X,
      );
}
