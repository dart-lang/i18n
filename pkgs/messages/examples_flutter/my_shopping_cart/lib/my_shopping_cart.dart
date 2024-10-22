library my_shopping_cart;

import 'package:flutter/services.dart';

import 'src/messages.g.dart';

class MyShoppingCart {
  final _messages = ShoppingCartMessages(rootBundle.loadString);
  Future<void> loadLocales() async => await _messages.loadAllLocales();

  String itemsInCart(int number) => _messages.itemsInCart(number);
}
