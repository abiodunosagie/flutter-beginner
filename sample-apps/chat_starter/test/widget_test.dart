import 'package:chat_starter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chat loads', (tester) async {
    await tester.pumpWidget(const ChatStarterApp());
    expect(find.text('Chat starter'), findsOneWidget);
  });
}
