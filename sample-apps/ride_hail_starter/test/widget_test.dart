import 'package:flutter_test/flutter_test.dart';
import 'package:ride_hail_starter/main.dart';

void main() {
  testWidgets('role home loads', (tester) async {
    await tester.pumpWidget(const RideHailApp());
    expect(find.text('I am a Rider'), findsOneWidget);
    expect(find.text('I am a Driver'), findsOneWidget);
  });
}
