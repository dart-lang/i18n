// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_shrinker/messages_shrinker.dart';
import 'package:test/test.dart';

void main() {
  test('json', () {
    var input =
        '[0,"en","skm01b",1,["helloAndWelcome","Welcome  von  <",["8",0],["d",1]],["aboutMessage","About ",["6",0]],[6,"newMessages","test ",[3,0,["test  new messages",["5",0]],[2,"No new messages",4,"One new message",5,"Two new Messages"]]],[6,"newMessages2","test ",[4,0,"Two new Messages",{"male":"No new messages","female":"One new message"}]]]';
    var shrunkJson = '[0,"en","skm01b",1,["aboutMessage","About ",["6",0]]]';
    expect(
      MessageShrinker().shrinkJson(input, [1]),
      '''
class JsonData {
  static final String jsonData =
      r'$shrunkJson';
}
''',
    );
  });

  test('native', () {
    var testfile = File('test/testarb.carb');
    var output = MessageShrinker().shrinkNative(
      testfile.readAsBytesSync(),
      [1],
    );
    var testShrunkfile = File('test/testarb_shrunk.carb');
    var expectedOutput = testShrunkfile.readAsBytesSync();
    expect(output, expectedOutput);
  });
}
