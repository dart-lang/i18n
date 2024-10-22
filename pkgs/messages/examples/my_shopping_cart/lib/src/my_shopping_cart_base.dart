import 'dart:io';

import 'messages.g.dart';

class MyShoppingCart {
  final _messages = ShoppingCartMessages(
      (id) => File(id.substring(id.indexOf('/') + 1)).readAsString());
  Future<void> loadMessages() async => await _messages.loadAllLocales();

  String itemsInCart(int number) => _messages.itemsInCart(number);
}
