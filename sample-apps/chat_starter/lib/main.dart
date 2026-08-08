import 'package:flutter/material.dart';

import 'pages/chat_page.dart';

void main() {
  runApp(const ChatStarterApp());
}

class ChatStarterApp extends StatelessWidget {
  const ChatStarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Starter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}
