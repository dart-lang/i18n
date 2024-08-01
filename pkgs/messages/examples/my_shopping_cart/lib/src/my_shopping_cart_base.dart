import 'messages.g.dart';

class MyShoppingCart {
  final _messages = ShoppingCartMessages();
  Future<void> loadMessages() async => await _messages.loadAllLocales();

  String itemsInCart(int number) => _messages.itemsInCart(number);
}
