// Example 03: Real-time Updates
// See data sync instantly across devices

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real-time Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const RealTimeDemoScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// REAL-TIME DEMO SCREEN
// ═══════════════════════════════════════════════════════════════

class RealTimeDemoScreen extends StatefulWidget {
  const RealTimeDemoScreen({super.key});

  @override
  State<RealTimeDemoScreen> createState() => _RealTimeDemoScreenState();
}

class _RealTimeDemoScreenState extends State<RealTimeDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Firestore'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Presence'),
            Tab(icon: Icon(Icons.message), text: 'Messages'),
            Tab(icon: Icon(Icons.poll), text: 'Poll'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OnlinePresenceTab(),
          LiveMessagesTab(),
          LivePollTab(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 1: ONLINE PRESENCE
// Shows users who are currently "online"
// ═══════════════════════════════════════════════════════════════

class OnlinePresenceTab extends StatefulWidget {
  const OnlinePresenceTab({super.key});

  @override
  State<OnlinePresenceTab> createState() => _OnlinePresenceTabState();
}

class _OnlinePresenceTabState extends State<OnlinePresenceTab> {
  final _db = FirebaseFirestore.instance;
  String? _myUserId;

  @override
  void initState() {
    super.initState();
    _goOnline();
  }

  @override
  void dispose() {
    _goOffline();
    super.dispose();
  }

  Future<void> _goOnline() async {
    // Create a unique user ID for this session
    final docRef = await _db.collection('online_users').add({
      'name': 'User ${DateTime.now().millisecondsSinceEpoch % 1000}',
      'joinedAt': FieldValue.serverTimestamp(),
      'color': Colors.primaries[DateTime.now().second % Colors.primaries.length]
          .value,
    });
    setState(() => _myUserId = docRef.id);
  }

  Future<void> _goOffline() async {
    if (_myUserId != null) {
      await _db.collection('online_users').doc(_myUserId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Explanation
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.purple.shade50,
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.purple),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Open this app on multiple devices or browser tabs. '
                  'Watch users appear and disappear in real-time!',
                ),
              ),
            ],
          ),
        ),

        // Online users count
        StreamBuilder<QuerySnapshot>(
          stream: _db.collection('online_users').snapshots(),
          builder: (context, snapshot) {
            final count = snapshot.data?.docs.length ?? 0;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '$count user${count == 1 ? '' : 's'} online',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          },
        ),

        // List of online users
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _db
                .collection('online_users')
                .orderBy('joinedAt', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = snapshot.data!.docs;

              if (users.isEmpty) {
                return const Center(child: Text('No users online'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final data = user.data() as Map<String, dynamic>;
                  final isMe = user.id == _myUserId;

                  return Card(
                    color: isMe ? Colors.purple.shade100 : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(data['color'] ?? 0xFF9C27B0),
                        child: Text(
                          (data['name'] as String? ?? '?').substring(0, 1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        data['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: isMe ? FontWeight.bold : null,
                        ),
                      ),
                      subtitle: Text(isMe ? 'You' : 'Online'),
                      trailing: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 2: LIVE MESSAGES
// A simple chat that updates in real-time
// ═══════════════════════════════════════════════════════════════

class LiveMessagesTab extends StatefulWidget {
  const LiveMessagesTab({super.key});

  @override
  State<LiveMessagesTab> createState() => _LiveMessagesTabState();
}

class _LiveMessagesTabState extends State<LiveMessagesTab> {
  final _db = FirebaseFirestore.instance;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    await _db.collection('messages').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'sender': 'User ${DateTime.now().millisecondsSinceEpoch % 1000}',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Explanation
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Send a message and watch it appear instantly on all devices!',
                ),
              ),
            ],
          ),
        ),

        // Messages list
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _db
                .collection('messages')
                .orderBy('timestamp', descending: false)
                .limitToLast(50)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data!.docs;

              if (messages.isEmpty) {
                return const Center(
                  child: Text('No messages yet. Send the first one!'),
                );
              }

              // Scroll to bottom when new messages arrive
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final data = msg.data() as Map<String, dynamic>;

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['sender'] ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(data['text'] ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Message input
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TAB 3: LIVE POLL
// Vote and see results update instantly
// ═══════════════════════════════════════════════════════════════

class LivePollTab extends StatelessWidget {
  const LivePollTab({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('polls').doc('favorite_color').snapshots(),
      builder: (context, snapshot) {
        // Initialize poll if it doesn't exist
        if (snapshot.hasData && !snapshot.data!.exists) {
          db.collection('polls').doc('favorite_color').set({
            'question': 'What is your favorite color?',
            'options': {
              'red': 0,
              'blue': 0,
              'green': 0,
              'purple': 0,
            },
            'totalVotes': 0,
          });
        }

        final data = snapshot.data?.data() as Map<String, dynamic>?;
        final options = (data?['options'] as Map<String, dynamic>?) ?? {};
        final totalVotes = data?['totalVotes'] ?? 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vote and watch the results update in real-time '
                        'as others vote too!',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Question
              Text(
                data?['question'] ?? 'What is your favorite color?',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '$totalVotes vote${totalVotes == 1 ? '' : 's'}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Options
              ..._buildPollOptions(context, db, options, totalVotes),

              const SizedBox(height: 24),

              // Reset button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () {
                    db.collection('polls').doc('favorite_color').update({
                      'options': {
                        'red': 0,
                        'blue': 0,
                        'green': 0,
                        'purple': 0,
                      },
                      'totalVotes': 0,
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Poll'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildPollOptions(
    BuildContext context,
    FirebaseFirestore db,
    Map<String, dynamic> options,
    int totalVotes,
  ) {
    final colors = {
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'purple': Colors.purple,
    };

    return options.entries.map((entry) {
      final color = entry.key;
      final votes = entry.value as int;
      final percentage = totalVotes > 0 ? votes / totalVotes : 0.0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            db.collection('polls').doc('favorite_color').update({
              'options.$color': FieldValue.increment(1),
              'totalVotes': FieldValue.increment(1),
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colors[color] ?? Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colors[color],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      color.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$votes vote${votes == 1 ? '' : 's'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: Colors.grey[200],
                    color: colors[color],
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Real-time Streams
 *    - collection.snapshots() returns a Stream
 *    - StreamBuilder updates UI automatically
 *    - No need to manually refresh!
 *
 * 2. Online Presence
 *    - Add document when user joins
 *    - Delete document when user leaves
 *    - Real-time list of active users
 *
 * 3. Live Chat
 *    - Messages appear instantly
 *    - orderBy for chronological order
 *    - limitToLast for recent messages only
 *
 * 4. Live Voting
 *    - FieldValue.increment() for atomic updates
 *    - Percentage calculations from real-time data
 *    - All voters see updates instantly
 *
 * ═══════════════════════════════════════════════════════════════
 * TRY THIS:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Open the app on two devices or browser tabs
 * 2. Watch the "Online" tab show both users
 * 3. Send messages between them
 * 4. Vote in the poll and see results update!
 *
 */
