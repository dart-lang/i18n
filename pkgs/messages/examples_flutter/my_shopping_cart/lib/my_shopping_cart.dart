// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library my_shopping_cart;

import 'package:flutter/services.dart';

import 'src/messages.g.dart';

class MyShoppingCart {
  final _messages = ShoppingCartMessages(rootBundle.loadString);
  Future<void> loadLocales() async => await _messages.loadAllLocales();

  String itemsInCart(int number) => _messages.itemsInCart(number);
}
