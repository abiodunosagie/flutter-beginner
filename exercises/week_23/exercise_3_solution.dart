/// Exercise 3 Solution: Stream Controllers - Building a Chat System
///
/// This solution demonstrates:
/// - Creating and managing StreamControllers
/// - Broadcast streams for multiple listeners
/// - Proper resource cleanup
/// - Real-world stream architecture

import 'dart:async';

class ChatMessage {
  final String user;
  final String message;
  final DateTime timestamp;
  final String? messageId;

  ChatMessage({
    required this.user,
    required this.message,
    required this.timestamp,
    this.messageId,
  });

  @override
  String toString() {
    return '[${timestamp.hour}:${timestamp.minute}:${timestamp.second}] $user: $message';
  }
}

class UserEvent {
  final String user;
  final bool joined;
  final DateTime timestamp;

  UserEvent({
    required this.user,
    required this.joined,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return '$user ${joined ? "joined" : "left"} the chat';
  }
}

class TypingEvent {
  final String user;
  final bool isTyping;
  final DateTime timestamp;

  TypingEvent({
    required this.user,
    required this.isTyping,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return '$user is ${isTyping ? "" : "not "}typing...';
  }
}

class ChatRoom {
  final String roomName;
  final Set<String> _users = {};

  // StreamControllers (broadcast for multiple listeners)
  final _messageController = StreamController<ChatMessage>.broadcast();
  final _userEventController = StreamController<UserEvent>.broadcast();
  final _typingController = StreamController<TypingEvent>.broadcast();

  ChatRoom({required this.roomName});

  // Expose streams
  Stream<ChatMessage> get messages => _messageController.stream;
  Stream<UserEvent> get userEvents => _userEventController.stream;
  Stream<TypingEvent> get typingEvents => _typingController.stream;

  // Getters
  int get userCount => _users.length;
  List<String> get activeUsers => _users.toList();

  void sendMessage(String user, String message) {
    if (!_users.contains(user)) {
      _messageController.addError('User $user is not in the chat room');
      return;
    }

    if (message.trim().isEmpty) {
      _messageController.addError('Message cannot be empty');
      return;
    }

    final chatMessage = ChatMessage(
      user: user,
      message: message,
      timestamp: DateTime.now(),
      messageId: '${user}_${DateTime.now().millisecondsSinceEpoch}',
    );

    _messageController.add(chatMessage);
  }

  void userJoined(String user) {
    if (_users.contains(user)) {
      _userEventController.addError('User $user is already in the chat room');
      return;
    }

    _users.add(user);

    _userEventController.add(UserEvent(
      user: user,
      joined: true,
    ));

    // Send system message
    _messageController.add(ChatMessage(
      user: 'System',
      message: '$user joined the chat',
      timestamp: DateTime.now(),
    ));
  }

  void userLeft(String user) {
    if (!_users.contains(user)) {
      _userEventController.addError('User $user is not in the chat room');
      return;
    }

    _users.remove(user);

    _userEventController.add(UserEvent(
      user: user,
      joined: false,
    ));

    // Send system message
    _messageController.add(ChatMessage(
      user: 'System',
      message: '$user left the chat',
      timestamp: DateTime.now(),
    ));
  }

  void userTyping(String user, bool isTyping) {
    if (!_users.contains(user)) {
      return;
    }

    _typingController.add(TypingEvent(
      user: user,
      isTyping: isTyping,
    ));
  }

  void dispose() {
    _messageController.close();
    _userEventController.close();
    _typingController.close();
    _users.clear();
  }
}

// Example usage:
void main() async {
  final chatRoom = ChatRoom(roomName: 'Flutter Devs');

  print('=== Chat Room: ${chatRoom.roomName} ===\n');

  // Set up listeners
  final messageSubscription = chatRoom.messages.listen(
    (message) => print('📨 $message'),
    onError: (error) => print('❌ Message Error: $error'),
  );

  final userEventSubscription = chatRoom.userEvents.listen(
    (event) => print('👤 $event'),
    onError: (error) => print('❌ User Event Error: $error'),
  );

  final typingSubscription = chatRoom.typingEvents.listen(
    (event) => print('⌨️  $event'),
  );

  // Simulate chat activity
  print('--- Users joining ---');
  chatRoom.userJoined('Alice');
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.userJoined('Bob');
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.userJoined('Charlie');
  await Future.delayed(Duration(seconds: 1));

  print('\n--- Active users: ${chatRoom.activeUsers} ---\n');

  print('--- Chat conversation ---');
  chatRoom.sendMessage('Alice', 'Hello everyone!');
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.userTyping('Bob', true);
  await Future.delayed(Duration(seconds: 1));
  chatRoom.userTyping('Bob', false);
  chatRoom.sendMessage('Bob', 'Hi Alice! Welcome!');
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.sendMessage('Charlie', 'Hey folks! Great to be here.');
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.userTyping('Alice', true);
  await Future.delayed(Duration(seconds: 1));
  chatRoom.userTyping('Alice', false);
  chatRoom.sendMessage('Alice', 'This chat room is awesome!');
  await Future.delayed(Duration(seconds: 1));

  print('\n--- Bob leaving ---');
  chatRoom.userLeft('Bob');
  await Future.delayed(Duration(seconds: 1));

  chatRoom.sendMessage('Charlie', 'See you later Bob!');
  await Future.delayed(Duration(seconds: 1));

  print('\n--- Error handling test ---');
  chatRoom.sendMessage('David', 'This should fail');  // David not in room
  await Future.delayed(Duration(milliseconds: 500));

  chatRoom.sendMessage('Alice', '');  // Empty message
  await Future.delayed(Duration(seconds: 1));

  // Cleanup
  print('\n--- Closing chat room ---');
  await messageSubscription.cancel();
  await userEventSubscription.cancel();
  await typingSubscription.cancel();
  chatRoom.dispose();

  print('Chat room closed.');
}
