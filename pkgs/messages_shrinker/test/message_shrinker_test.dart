// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:messages_shrinker/messages_shrinker.dart';
import 'package:test/test.dart';

void main() {
  test('json', () {
    var input = '''
class JsonData {
  static final String jsonData =
      r'[0,"en","s69t31",1,[5,12,18,19],[1,"helloAndWelcome","Welcome  von !",[8,0],[13,1]],[1,"test "],[1,"test  new messages",[5,0]],"No new messages","No new messages","No new messages",[3,0,7,[2,8,4,9,6,10]],[6,"newMessages",6,11],[1,"test "],"No new messages","One new message",[1,"test  new messages of type ",[5,0],[27,1]],[4,0,{"male":14,"female":15,"other":16}],[6,"newMessages2",13,17],[1,"helloAndWelcome2","Welcome  von !",[8,0],[13,1]]]';
}
''';
    var output = MessageShrinker().shrinkJson(input, [1]);
    var expectedOutput = '''
class JsonData {
  static final String jsonData =
      r'[0,"en","s69t31",1,[11],"test ",[1,"test  new messages",[5,0]],"No new messages","No new messages","No new messages",[3,0,6,[2,7,4,8,6,9]],[6,"newMessages",5,10]]';
}
''';
    expect(output, expectedOutput);
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