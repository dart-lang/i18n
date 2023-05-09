// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../ecma/ecma_policy.dart';
import '../locale.dart';
import '../options.dart';
import '../test_checker.dart';
import '../utils.dart';
import 'list_format_4x.dart';
import 'list_format_options.dart';
import 'list_format_stub.dart' if (dart.library.js) 'list_format_ecma.dart';

class ListFormat {
  final ListFormatImpl _listFormatImpl;

  const ListFormat(this._listFormatImpl);

  factory ListFormat.build(
    List<Locale> locales,
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

  /// Locale-dependant concatenation of lists, for example in `en-US` locale
  /// ```dart
  /// format(['A', 'B', 'C']) == 'A, B, and C'
  /// ```
  String format(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  }) {
    if (isInTest) {
      return '${list.join(', ')}-${_listFormatImpl.locales}';
    } else {
      return _listFormatImpl.formatImpl(
        list,
        localeMatcher: localeMatcher,
        type: type,
        style: style,
      );
    }
  }
}

abstract class ListFormatImpl {
  final List<Locale> locales;

  ListFormatImpl(this.locales);

  String formatImpl(
    List<String> list, {
    LocaleMatcher localeMatcher = LocaleMatcher.bestfit,
    Type type = Type.conjunction,
    ListStyle style = ListStyle.long,
  });
}
