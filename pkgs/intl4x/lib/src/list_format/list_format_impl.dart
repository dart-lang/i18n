// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart' show ResourceIdentifier;

import '../../ecma_policy.dart';
import '../data.dart';
import '../ecma/ecma_policy.dart';
import '../locale/locale.dart';
import '../options.dart';
import '../utils.dart';
import 'list_format_options.dart';
import 'list_format_stub.dart' if (dart.library.js) 'list_format_ecma.dart';
import 'list_format_stub_4x.dart' if (dart.library.io) 'list_format_4x.dart';

abstract class ListFormatImpl {
  final Locale locale;
  final ListFormatOptions options;

  ListFormatImpl(this.locale, this.options);

  String formatImpl(List<String> list);

  @ResourceIdentifier('ListFormat')
  static ListFormatImpl build(
    Locale locales,
    Data data,
    ListFormatOptions options,
    LocaleMatcher localeMatcher,
    EcmaPolicy ecmaPolicy,
  ) =>
      buildFormatter(
        locales,
        data,
        options,
        localeMatcher,
        ecmaPolicy,
        getListFormatterECMA,
        getListFormatter4X,
      );
}
