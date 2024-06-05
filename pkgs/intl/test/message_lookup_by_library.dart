// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:intl/message_lookup_by_library.dart';
import 'package:test/test.dart';

void main() {
  test('Resolves message successfully after unsuccessful lookup', () {
    final CompositeMessageLookup lookup = CompositeMessageLookup();
    final lookupMessage =
        lookup.lookupMessage('Hello', 'pt', 'greeting', null, null);
    expect(lookupMessage, 'Hello');

    lookup.addLocale(
      'pt',
      (locale) =>
          TestMessageLookupByLibrary('pt', {'greeting': () => 'Bom dia'}),
    );

    final lookupMessage2 =
        lookup.lookupMessage('Hello', 'pt', 'greeting', null, null);
    expect(lookupMessage2, 'Bom dia');
  });
}

class TestMessageLookupByLibrary extends MessageLookupByLibrary {
  @override
  final Map<String, dynamic> messages;

  @override
  final String localeName;

  TestMessageLookupByLibrary(this.localeName, this.messages);
}
