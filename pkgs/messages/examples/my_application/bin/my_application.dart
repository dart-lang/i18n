// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:my_application/my_application.dart';

Future<void> main(List<String> arguments) async {
  print('Currently: ${await sale()}. ${await items()}!');
}
