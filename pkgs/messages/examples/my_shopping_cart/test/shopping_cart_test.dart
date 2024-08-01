import 'package:my_shopping_cart/my_shopping_cart.dart';
import 'package:test/test.dart';

void main() {
  test('test name', () async {
    var myShoppingCart = MyShoppingCart();
    await myShoppingCart.loadMessages();
    expect(myShoppingCart.itemsInCart(2), '2 items in cart');
  });
}
