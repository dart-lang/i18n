// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'messages.g.dart';

class MyShoppingCart {
  final _messages = ShoppingCartMessages(
      (id) => File(id.substring(id.indexOf('/') + 1)).readAsString());
  Future<void> loadMessages() async => await _messages.loadAllLocales();

  String itemsInCart(int number) => _messages.itemsInCart(number);
}
