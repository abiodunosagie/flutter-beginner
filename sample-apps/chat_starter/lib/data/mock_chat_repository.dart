import 'dart:async';

import '../models/message.dart';

/// Local mock chat so the sample runs without Firebase.
/// Swap this for Firestore later (see Full-App App 04).
class MockChatRepository {
  MockChatRepository._();
  static final instance = MockChatRepository._();

  final _messages = <ChatMessage>[
    ChatMessage(
      id: '1',
      senderId: 'friend',
      text: 'Hey — this is the mock chat starter.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '2',
      senderId: 'friend',
      text: 'Type below. Wire Firebase when you finish Level 11.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
  ];

  final _controller = StreamController<List<ChatMessage>>.broadcast();

  static const me = 'me';
  static const friend = 'friend';

  Stream<List<ChatMessage>> watchMessages() async* {
    yield List.unmodifiable(_messages);
    yield* _controller.stream;
  }

  void _emit() => _controller.add(List.unmodifiable(_messages));

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _messages.add(
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        senderId: me,
        text: trimmed,
        createdAt: DateTime.now(),
      ),
    );
    _emit();

    // Simulate friend reply for demo “realtime” feel
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      _messages.add(
        ChatMessage(
          id: '${DateTime.now().microsecondsSinceEpoch}-r',
          senderId: friend,
          text: 'Echo: $trimmed',
          createdAt: DateTime.now(),
        ),
      );
      _emit();
    });
  }
}
