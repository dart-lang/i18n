// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:my_shopping_cart/my_shopping_cart.dart';

import 'src/messages.g.dart';

Future<String> items() async {
  var myShoppingCart = MyShoppingCart();
  await myShoppingCart.loadMessages();
  return myShoppingCart.itemsInCart(5);
}

Future<String> sale() async {
  var appMessages = MyAppMessages(
      (id) => File(id.substring(id.indexOf('/') + 1)).readAsString());
  await appMessages.loadAllLocales();
  return appMessages.current_sale_name(
    DateTime.now().month < 4 || DateTime.now().month > 10 ? 'winter' : 'summer',
  );
}
