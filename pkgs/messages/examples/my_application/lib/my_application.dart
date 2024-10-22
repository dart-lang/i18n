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
