import 'package:flutter_test/flutter_test.dart';
import 'package:live_prices_app/main.dart';

void main() {
  testWidgets('ticker page loads', (tester) async {
    await tester.pumpWidget(const LivePricesApp());
    expect(find.text('Live prices'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
  });
}
