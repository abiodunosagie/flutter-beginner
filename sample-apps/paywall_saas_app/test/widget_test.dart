import 'package:flutter_test/flutter_test.dart';
import 'package:paywall_saas_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home loads', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PaywallSaasApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Notes SaaS'), findsOneWidget);
  });
}
