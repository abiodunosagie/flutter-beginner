import 'package:flutter_test/flutter_test.dart';
import 'package:shop_cart_app/main.dart';

void main() {
  testWidgets('catalog loads', (tester) async {
    await tester.pumpWidget(const ShopCartApp());
    expect(find.text('ShopCart'), findsOneWidget);
    expect(find.text('Add'), findsWidgets);
  });
}
