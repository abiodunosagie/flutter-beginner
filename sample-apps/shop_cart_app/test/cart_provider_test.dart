import 'package:flutter_test/flutter_test.dart';
import 'package:shop_cart_app/models/product.dart';
import 'package:shop_cart_app/providers/cart_provider.dart';

void main() {
  test('add merges quantities and totals', () {
    final cart = CartProvider();
    const p = Product(id: '1', name: 'A', price: 10, emoji: 'x');
    cart.add(p);
    cart.add(p);
    expect(cart.totalQty, 2);
    expect(cart.totalPrice, 20);
    cart.setQty('1', 0);
    expect(cart.isEmpty, true);
  });
}
