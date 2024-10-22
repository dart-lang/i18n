// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:my_shopping_cart/my_shopping_cart.dart';
import 'package:test/test.dart';

void main() {
  test('test name', () async {
    var myShoppingCart = MyShoppingCart();
    await myShoppingCart.loadMessages();
    expect(myShoppingCart.itemsInCart(2), '2 items in cart');
  });
}
