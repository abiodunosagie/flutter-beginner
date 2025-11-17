/// Exercise 3: Stream Controllers - Building a Chat System
///
/// Level: Intermediate
///
/// Task:
/// Create a ChatRoom class using StreamController to manage
/// real-time chat messages, user status, and notifications.
///
/// Requirements:
/// 1. Create ChatRoom class with StreamControllers for:
///    - Messages (broadcast)
///    - User join/leave events (broadcast)
///    - Typing indicators (broadcast)
///
/// 2. Implement methods:
///    - sendMessage(String user, String message)
///    - userJoined(String user)
///    - userLeft(String user)
///    - userTyping(String user, bool isTyping)
///
/// 3. Expose streams for listening:
///    - Stream<ChatMessage> get messages
///    - Stream<UserEvent> get userEvents
///    - Stream<TypingEvent> get typingEvents
///
/// 4. Handle stream cleanup (dispose method)
/// 5. Add error handling

class ChatMessage {
  final String user;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.user,
    required this.message,
    required this.timestamp,
  });
}

class UserEvent {
  final String user;
  final bool joined;  // true = joined, false = left

  UserEvent({required this.user, required this.joined});
}

class TypingEvent {
  final String user;
  final bool isTyping;

  TypingEvent({required this.user, required this.isTyping});
}

class ChatRoom {
  // TODO: Create StreamControllers

  // TODO: Implement streams (getters)

  // TODO: Implement sendMessage
  void sendMessage(String user, String message) {
    throw UnimplementedError();
  }

  // TODO: Implement userJoined
  void userJoined(String user) {
    throw UnimplementedError();
  }

  // TODO: Implement userLeft
  void userLeft(String user) {
    throw UnimplementedError();
  }

  // TODO: Implement userTyping
  void userTyping(String user, bool isTyping) {
    throw UnimplementedError();
  }

  // TODO: Implement dispose
  void dispose() {
    throw UnimplementedError();
  }
}

// Example usage:
void main() async {
  final chatRoom = ChatRoom();

  // Listen to messages
  chatRoom.messages.listen((message) {
    print('[${message.timestamp}] ${message.user}: ${message.message}');
  });

  // Listen to user events
  chatRoom.userEvents.listen((event) {
    print('${event.user} ${event.joined ? "joined" : "left"} the chat');
  });

  // Simulate chat activity
  chatRoom.userJoined('Alice');
  chatRoom.sendMessage('Alice', 'Hello everyone!');

  await Future.delayed(Duration(seconds: 1));
  chatRoom.userJoined('Bob');
  chatRoom.sendMessage('Bob', 'Hi Alice!');

  await Future.delayed(Duration(seconds: 2));
  chatRoom.dispose();
}
