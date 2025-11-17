/// Week 32, Exercise 4: Riverpod Family and Caching
///
/// INTERMEDIATE-ADVANCED LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() {
  runApp(const CachingApp());
}

class CachingApp extends StatelessWidget {
  const CachingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caching Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cached Data')),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('User ${index + 1}'),
            subtitle: const Text('Cached data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserDetailScreen(userId: index + 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final int userId;

  const UserDetailScreen({required this.userId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User $userId Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 50, child: Text('$userId', style: const TextStyle(fontSize: 32))),
            const SizedBox(height: 20),
            Text('User $userId', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Data cached for fast access'),
          ],
        ),
      ),
    );
  }
}

/*
Real Riverpod Family implementation:

// Provider with family modifier
final userProvider = FutureProvider.family<User, int>((ref, userId) async {
  return await fetchUser(userId);
});

// Auto-dispose for cache management
final userProviderAutoDispose = FutureProvider.autoDispose.family<User, int>(
  (ref, userId) async {
    // Keep alive for 1 minute
    final link = ref.keepAlive();
    Timer(Duration(minutes: 1), () {
      link.close();
    });

    return await fetchUser(userId);
  },
);

// Usage
class UserDetail extends ConsumerWidget {
  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider(userId));

    return asyncUser.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (user) => Text(user.name),
    );
  }
}

// Invalidate cache
ref.invalidate(userProvider(userId));

// Refresh specific user
ref.refresh(userProvider(userId));
*/
