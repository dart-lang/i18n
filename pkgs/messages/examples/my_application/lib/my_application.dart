import 'package:my_shopping_cart/my_shopping_cart.dart';

import 'messages.g.dart';

Future<String> items() async {
  var myShoppingCart = MyShoppingCart();
  await myShoppingCart.loadMessages();
  return myShoppingCart.itemsInCart(5);
}

Future<String> sale() async {
  var myShoppingCart = MyAppMessages();
  await myShoppingCart.loadAllLocales();
  return myShoppingCart.current_sale_name(
    DateTime.now().month < 4 || DateTime.now().month > 10 ? 'winter' : 'summer',
  );
}
