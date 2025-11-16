# Offline-First Architecture: Building Apps That Work Anywhere

## What You'll Learn

In this comprehensive lesson, you'll master:
- What offline-first architecture is and why it matters
- Designing apps that work without internet
- Sync strategies (when to sync, conflict resolution)
- Cache-first vs Network-first patterns
- Implementing offline-first with all storage solutions
- Detecting network connectivity
- Queue failed requests for retry
- Optimistic UI updates
- Complete offline-first app example
- 5 progressive exercises

By the end, you'll build apps that work flawlessly with or without internet!

## Understanding Offline-First (Like Teaching a 5-Year-Old)

### What is Offline-First?

Imagine you're reading a book:

**Bad App (Network-Only):**
```
You: "I want to read my book" 📖
App: "Sorry, you need WiFi to read!"
You: "But I downloaded it yesterday..."
App: "Doesn't matter. No WiFi = No reading!" ❌

*Goes into tunnel with no signal*
App: *crashes* 💥
```

**Good App (Offline-First):**
```
You: "I want to read my book" 📖
App: "Here it is! Reading from your device" ✅

*Goes into tunnel with no signal*
App: *still works perfectly* ✨
You: "I'll add a bookmark"
App: "Saved locally! I'll sync when WiFi returns" 🔄

*WiFi comes back*
App: "Syncing your bookmark... Done!" ✅
```

**Offline-First Principles:**
1. **Works offline by default** - App is fully functional without internet
2. **Local data is source of truth** - Always read from device first
3. **Sync in background** - Update from server when available
4. **Queue failed actions** - Retry when connection returns
5. **Fast and smooth** - No waiting for network

### Real-Life Examples

**Apps That SHOULD Be Offline-First:**
- ✅ Note-taking app (write notes anywhere!)
- ✅ Todo list (check off tasks on subway)
- ✅ Expense tracker (log expenses immediately)
- ✅ Reading app (read books without WiFi)
- ✅ Podcast app (download and listen offline)

**Apps That Need Internet (But Can Cache):**
- ⚠️ Social media (can cache feed for offline viewing)
- ⚠️ News app (cache articles for offline reading)
- ⚠️ Shopping app (cache product info, sync cart later)
- ⚠️ Maps (download area for offline navigation)

## Part 1: Network Connectivity Detection

### Setting Up Connectivity Package

Add to `pubspec.yaml`:

```yaml
dependencies:
  connectivity_plus: ^5.0.0
```

### Basic Connectivity Check

```dart
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  // Check current connectivity
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();

    return result != ConnectivityResult.none;
  }

  // Check specific connection type
  Future<ConnectivityResult> getConnectionType() async {
    return await _connectivity.checkConnectivity();
  }

  // Listen to connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  // Detailed connection info
  Future<String> getConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();

    switch (result) {
      case ConnectivityResult.wifi:
        return 'Connected to WiFi';
      case ConnectivityResult.mobile:
        return 'Connected to Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Connected to Ethernet';
      case ConnectivityResult.vpn:
        return 'Connected via VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown Connection';
    }
  }
}
```

### Connectivity Provider

```dart
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;
  ConnectivityResult _connectionType = ConnectivityResult.none;

  bool get isOnline => _isOnline;
  ConnectivityResult get connectionType => _connectionType;

  ConnectivityProvider() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    _connectionType = result;
    _isOnline = result != ConnectivityResult.none;
    notifyListeners();
  }

  String get connectionStatusText {
    if (!_isOnline) return 'Offline';

    switch (_connectionType) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      default:
        return 'Online';
    }
  }
}

// Usage in main.dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ConnectivityProvider(),
      child: MyApp(),
    ),
  );
}

// Show connectivity status in UI
class ConnectivityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        if (connectivity.isOnline) {
          return SizedBox.shrink();  // Don't show anything when online
        }

        return MaterialBanner(
          content: Text('You are offline. Changes will sync when connected.'),
          backgroundColor: Colors.orange,
          leading: Icon(Icons.cloud_off),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
```

## Part 2: Cache Strategies

### Strategy 1: Cache-First (Offline-First)

**Flow:**
1. Read from cache immediately
2. Display cached data
3. Fetch from network in background
4. Update cache and UI

```dart
class ArticleService {
  final ApiClient api;
  final Box<Article> cacheBox;

  ArticleService({required this.api, required this.cacheBox});

  // Cache-first strategy
  Future<List<Article>> getArticles() async {
    // 1. Get cached data immediately
    final cachedArticles = cacheBox.values.toList();

    // 2. Return cached data (don't wait for network!)
    if (cachedArticles.isNotEmpty) {
      // Fetch from network in background
      _updateCacheInBackground();

      return cachedArticles;
    }

    // 3. No cache - fetch from network
    return await _fetchAndCache();
  }

  Future<void> _updateCacheInBackground() async {
    try {
      final articles = await api.getArticles();

      // Update cache
      await cacheBox.clear();
      for (var article in articles) {
        await cacheBox.put(article.id, article);
      }
    } catch (e) {
      // Failed to update - that's okay, we have cache!
      print('Background update failed: $e');
    }
  }

  Future<List<Article>> _fetchAndCache() async {
    try {
      final articles = await api.getArticles();

      // Cache for next time
      for (var article in articles) {
        await cacheBox.put(article.id, article);
      }

      return articles;
    } catch (e) {
      // Network failed and no cache
      throw Exception('No cached data and network unavailable');
    }
  }
}

// Usage in UI
class ArticleListScreen extends StatefulWidget {
  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final articleService = ArticleService(/*...*/);
  List<Article> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    // Shows cached data instantly, then updates from network
    final data = await articleService.getArticles();

    setState(() {
      articles = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && articles.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return ArticleCard(article: articles[index]);
        },
      ),
    );
  }
}
```

### Strategy 2: Network-First (Online-First)

**Flow:**
1. Try network first
2. If fails, use cache
3. Update cache on success

```dart
class ProductService {
  final ApiClient api;
  final Box<Product> cacheBox;

  ProductService({required this.api, required this.cacheBox});

  // Network-first strategy
  Future<List<Product>> getProducts() async {
    try {
      // 1. Try network first
      final products = await api.getProducts();

      // 2. Update cache
      await cacheBox.clear();
      for (var product in products) {
        await cacheBox.put(product.id, product);
      }

      return products;
    } catch (e) {
      // 3. Network failed - use cache
      print('Network failed, using cache: $e');

      final cachedProducts = cacheBox.values.toList();

      if (cachedProducts.isEmpty) {
        throw Exception('No network and no cached data');
      }

      return cachedProducts;
    }
  }
}
```

### Strategy 3: Stale-While-Revalidate

**Flow:**
1. Return cache immediately (even if stale)
2. Fetch from network
3. Update cache and notify

```dart
class NewsService {
  final ApiClient api;
  final Box<NewsArticle> cacheBox;
  final _controller = StreamController<List<NewsArticle>>.broadcast();

  Stream<List<NewsArticle>> get newsStream => _controller.stream;

  // Stale-while-revalidate strategy
  Future<void> loadNews() async {
    // 1. Emit cached data immediately (even if old)
    final cachedNews = cacheBox.values.toList();
    if (cachedNews.isNotEmpty) {
      _controller.add(cachedNews);
    }

    // 2. Fetch fresh data from network
    try {
      final freshNews = await api.getNews();

      // 3. Update cache
      await cacheBox.clear();
      for (var article in freshNews) {
        await cacheBox.put(article.id, article);
      }

      // 4. Emit fresh data
      _controller.add(freshNews);
    } catch (e) {
      // Network failed - already showing cache
      print('Network failed: $e');
    }
  }

  void dispose() {
    _controller.close();
  }
}

// Usage
class NewsScreen extends StatelessWidget {
  final newsService = NewsService(/*...*/);

  @override
  Widget build(BuildContext context) {
    // Load news (shows cache immediately, then updates)
    newsService.loadNews();

    return StreamBuilder<List<NewsArticle>>(
      stream: newsService.newsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final articles = snapshot.data!;

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return NewsCard(article: articles[index]);
          },
        );
      },
    );
  }
}
```

## Part 3: Optimistic Updates

**Optimistic Update** = Update UI immediately, sync with server later

### Example: Todo App with Optimistic Updates

```dart
class OptimisticTodoService {
  final ApiClient api;
  final Box<Todo> localBox;
  final NetworkService network;
  final _syncQueue = <PendingAction>[];

  // Add todo optimistically
  Future<void> addTodo(Todo todo) async {
    // 1. Save locally immediately
    await localBox.put(todo.id, todo);
    // UI updates right away! ✨

    // 2. Try to sync with server
    try {
      if (await network.isConnected()) {
        await api.createTodo(todo);
      } else {
        // Offline - queue for later
        _syncQueue.add(PendingAction(
          type: ActionType.create,
          data: todo,
        ));
      }
    } catch (e) {
      // Failed to sync - queue it
      _syncQueue.add(PendingAction(
        type: ActionType.create,
        data: todo,
      ));
    }
  }

  // Toggle todo optimistically
  Future<void> toggleTodo(String id) async {
    final todo = localBox.get(id);
    if (todo == null) return;

    // 1. Update locally immediately
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    await localBox.put(id, updated);
    // UI updates right away! ✨

    // 2. Try to sync with server
    try {
      if (await network.isConnected()) {
        await api.updateTodo(updated);
      } else {
        _syncQueue.add(PendingAction(
          type: ActionType.update,
          data: updated,
        ));
      }
    } catch (e) {
      _syncQueue.add(PendingAction(
        type: ActionType.update,
        data: updated,
      ));
    }
  }

  // Delete todo optimistically
  Future<void> deleteTodo(String id) async {
    final todo = localBox.get(id);
    if (todo == null) return;

    // 1. Delete locally immediately
    await localBox.delete(id);
    // UI updates right away! ✨

    // 2. Try to sync with server
    try {
      if (await network.isConnected()) {
        await api.deleteTodo(id);
      } else {
        _syncQueue.add(PendingAction(
          type: ActionType.delete,
          data: todo,
        ));
      }
    } catch (e) {
      _syncQueue.add(PendingAction(
        type: ActionType.delete,
        data: todo,
      ));
    }
  }

  // Process sync queue when online
  Future<void> processSyncQueue() async {
    if (_syncQueue.isEmpty) return;
    if (!await network.isConnected()) return;

    final queue = List<PendingAction>.from(_syncQueue);
    _syncQueue.clear();

    for (var action in queue) {
      try {
        switch (action.type) {
          case ActionType.create:
            await api.createTodo(action.data as Todo);
            break;
          case ActionType.update:
            await api.updateTodo(action.data as Todo);
            break;
          case ActionType.delete:
            await api.deleteTodo((action.data as Todo).id);
            break;
        }
      } catch (e) {
        // Failed - add back to queue
        _syncQueue.add(action);
      }
    }
  }
}

enum ActionType { create, update, delete }

class PendingAction {
  final ActionType type;
  final dynamic data;

  PendingAction({required this.type, required this.data});
}
```

### UI with Optimistic Updates

```dart
class TodoListScreen extends StatelessWidget {
  final OptimisticTodoService todoService;

  TodoListScreen({required this.todoService});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: todoService.localBox.listenable(),
      builder: (context, Box<Todo> box, _) {
        final todos = box.values.toList();

        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return ListTile(
              title: Text(todo.title),
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (_) {
                  // Updates UI immediately! ✨
                  todoService.toggleTodo(todo.id);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Deletes from UI immediately! ✨
                  todoService.deleteTodo(todo.id);
                },
              ),
            );
          },
        );
      },
    );
  }
}
```

## Part 4: Conflict Resolution

What happens when local changes conflict with server changes?

### Strategy 1: Last-Write-Wins (Simple)

```dart
class ConflictResolver {
  // Server data always wins
  Future<Todo> serverWins(Todo local, Todo server) async {
    return server;
  }

  // Local data always wins
  Future<Todo> localWins(Todo local, Todo server) async {
    return local;
  }

  // Most recent wins (by timestamp)
  Future<Todo> lastWriteWins(Todo local, Todo server) async {
    if (local.updatedAt.isAfter(server.updatedAt)) {
      return local;
    }
    return server;
  }
}
```

### Strategy 2: Field-Level Merge (Advanced)

```dart
class ConflictResolver {
  // Merge individual fields
  Future<Todo> mergeFields(Todo local, Todo server) async {
    return Todo(
      id: server.id,
      // Use most recent value for each field
      title: local.updatedAt.isAfter(server.updatedAt)
          ? local.title
          : server.title,
      isCompleted: local.updatedAt.isAfter(server.updatedAt)
          ? local.isCompleted
          : server.isCompleted,
      updatedAt: local.updatedAt.isAfter(server.updatedAt)
          ? local.updatedAt
          : server.updatedAt,
    );
  }
}
```

### Strategy 3: User Decides (Best UX)

```dart
class ConflictResolver {
  Future<Todo> userDecides(
    BuildContext context,
    Todo local,
    Todo server,
  ) async {
    final choice = await showDialog<ConflictChoice>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conflict Detected'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This todo was modified on another device.'),
            SizedBox(height: 16),
            Text('Your version:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(local.title),
            SizedBox(height: 8),
            Text('Server version:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(server.title),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ConflictChoice.useLocal),
            child: Text('Keep Mine'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ConflictChoice.useServer),
            child: Text('Use Server'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ConflictChoice.keepBoth),
            child: Text('Keep Both'),
          ),
        ],
      ),
    );

    switch (choice) {
      case ConflictChoice.useLocal:
        return local;
      case ConflictChoice.useServer:
        return server;
      case ConflictChoice.keepBoth:
        // Create duplicate with new ID
        return local.copyWith(
          id: '${local.id}_local',
          title: '${local.title} (Local)',
        );
      default:
        return server;  // Default to server
    }
  }
}

enum ConflictChoice { useLocal, useServer, keepBoth }
```

## Part 5: Complete Offline-First App Example

### Models

```dart
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  bool isSynced;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
```

### Service

```dart
class OfflineNoteService {
  final Box<Note> localBox;
  final ApiClient api;
  final ConnectivityProvider connectivity;

  OfflineNoteService({
    required this.localBox,
    required this.api,
    required this.connectivity,
  }) {
    // Auto-sync when connectivity returns
    connectivity.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    if (connectivity.isOnline) {
      syncWithServer();
    }
  }

  // CREATE
  Future<void> createNote({
    required String title,
    required String content,
  }) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    // Save locally immediately
    await localBox.put(note.id, note);

    // Try to sync
    if (connectivity.isOnline) {
      _syncNote(note);
    }
  }

  // READ
  List<Note> getAllNotes() {
    return localBox.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Stream<List<Note>> watchNotes() {
    return localBox.watch().map((_) => getAllNotes());
  }

  // UPDATE
  Future<void> updateNote({
    required String id,
    String? title,
    String? content,
  }) async {
    final note = localBox.get(id);
    if (note == null) return;

    final updated = note.copyWith(
      title: title,
      content: content,
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    await localBox.put(id, updated);

    if (connectivity.isOnline) {
      _syncNote(updated);
    }
  }

  // DELETE
  Future<void> deleteNote(String id) async {
    await localBox.delete(id);

    if (connectivity.isOnline) {
      try {
        await api.deleteNote(id);
      } catch (e) {
        print('Failed to delete from server: $e');
      }
    }
  }

  // SYNC
  Future<void> syncWithServer() async {
    if (!connectivity.isOnline) return;

    try {
      // 1. Get all local notes that aren't synced
      final unsyncedNotes = localBox.values
          .where((note) => !note.isSynced)
          .toList();

      // 2. Push local changes to server
      for (var note in unsyncedNotes) {
        await _syncNote(note);
      }

      // 3. Pull server changes
      final serverNotes = await api.getAllNotes();

      for (var serverNote in serverNotes) {
        final localNote = localBox.get(serverNote.id);

        if (localNote == null) {
          // New from server - add it
          await localBox.put(serverNote.id, serverNote.copyWith(isSynced: true));
        } else if (serverNote.updatedAt.isAfter(localNote.updatedAt)) {
          // Server is newer - update local
          await localBox.put(serverNote.id, serverNote.copyWith(isSynced: true));
        }
      }

      print('Sync completed ✅');
    } catch (e) {
      print('Sync failed: $e');
    }
  }

  Future<void> _syncNote(Note note) async {
    try {
      await api.saveNote(note);

      final updated = note.copyWith(isSynced: true);
      await localBox.put(note.id, updated);
    } catch (e) {
      print('Failed to sync note ${note.id}: $e');
    }
  }

  // Count unsynced notes
  int get unsyncedCount {
    return localBox.values.where((note) => !note.isSynced).length;
  }
}
```

### UI

```dart
class NoteListScreen extends StatelessWidget {
  final OfflineNoteService noteService;
  final ConnectivityProvider connectivity;

  NoteListScreen({
    required this.noteService,
    required this.connectivity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          // Connectivity indicator
          Consumer<ConnectivityProvider>(
            builder: (context, conn, _) {
              return Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      conn.isOnline ? Icons.cloud_done : Icons.cloud_off,
                      color: conn.isOnline ? Colors.green : Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(conn.connectionStatusText),
                  ],
                ),
              );
            },
          ),

          // Unsynced count
          ValueListenableBuilder(
            valueListenable: noteService.localBox.listenable(),
            builder: (context, box, _) {
              final unsynced = noteService.unsyncedCount;

              if (unsynced == 0) return SizedBox.shrink();

              return Padding(
                padding: EdgeInsets.all(8),
                child: Chip(
                  label: Text('$unsynced unsynced'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
          ),

          // Manual sync button
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () => noteService.syncWithServer(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline banner
          Consumer<ConnectivityProvider>(
            builder: (context, conn, _) {
              if (conn.isOnline) return SizedBox.shrink();

              return Container(
                width: double.infinity,
                color: Colors.orange,
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.cloud_off, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Offline - Changes will sync when connected',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),

          // Note list
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: noteService.localBox.listenable(),
              builder: (context, Box<Note> box, _) {
                final notes = noteService.getAllNotes();

                if (notes.isEmpty) {
                  return Center(
                    child: Text('No notes yet! Tap + to create one.'),
                  );
                }

                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        title: Text(note.title),
                        subtitle: Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sync indicator
                            if (!note.isSynced)
                              Icon(
                                Icons.sync_problem,
                                color: Colors.orange,
                                size: 16,
                              ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => noteService.deleteNote(note.id),
                            ),
                          ],
                        ),
                        onTap: () => _editNote(context, note),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNote(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _createNote(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                noteService.createNote(
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _editNote(BuildContext context, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              noteService.updateNote(
                id: note.id,
                title: titleController.text,
                content: contentController.text,
              );
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

## Part 6: Best Practices

### 1. Always Check Connectivity Before Network Calls

```dart
// ✅ Good
Future<void> fetchData() async {
  if (await connectivity.isConnected()) {
    try {
      final data = await api.fetchData();
      await cache.save(data);
    } catch (e) {
      // Use cache as fallback
    }
  } else {
    // Use cache directly
    return cache.getData();
  }
}
```

### 2. Show Sync Status to User

```dart
// ✅ Good: Visual feedback
Widget buildSyncIndicator() {
  return Row(
    children: [
      if (isSyncing)
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      if (!isSyncing && unsyncedCount > 0)
        Icon(Icons.sync_problem, color: Colors.orange),
      if (!isSyncing && unsyncedCount == 0)
        Icon(Icons.cloud_done, color: Colors.green),
    ],
  );
}
```

### 3. Implement Retry Logic

```dart
Future<T> retryOnFail<T>(Future<T> Function() fn, {int retries = 3}) async {
  for (int attempt = 1; attempt <= retries; attempt++) {
    try {
      return await fn();
    } catch (e) {
      if (attempt == retries) rethrow;

      await Future.delayed(Duration(seconds: attempt * 2));
    }
  }

  throw Exception('Should never reach here');
}

// Usage
await retryOnFail(() => api.syncData());
```

### 4. Batch Sync Operations

```dart
// ✅ Good: Sync multiple items at once
Future<void> syncAll() async {
  final unsynced = getUnsyncedItems();

  // Batch API call
  await api.batchSync(unsynced);

  // Mark all as synced
  for (var item in unsynced) {
    item.isSynced = true;
    await item.save();
  }
}
```

### 5. Handle Large Data Sets

```dart
// ✅ Good: Pagination for large datasets
Future<void> syncLargeDataset() async {
  int page = 0;
  bool hasMore = true;

  while (hasMore) {
    final data = await api.fetchPage(page, limit: 100);

    for (var item in data) {
      await cache.save(item);
    }

    hasMore = data.length == 100;
    page++;
  }
}
```

## Exercises

### Exercise 1: Offline Todo List (Beginner-Intermediate)

Build a todo app that works completely offline.

**Requirements:**
- Create, read, update, delete todos locally
- Show connectivity status
- Auto-sync when online
- Show unsynced count
- Mark todos with sync status indicator
- Pull-to-refresh to force sync

### Exercise 2: Offline News Reader (Intermediate)

Create a news app with offline reading capability.

**Requirements:**
- Fetch articles from API
- Cache articles for offline reading
- Mark articles as read
- Favorite articles (always available offline)
- Show timestamp of last sync
- Auto-sync in background when WiFi available
- Delete old cached articles (keep only recent 50)

### Exercise 3: Expense Tracker with Offline Support (Intermediate-Advanced)

Build expense tracker that works offline.

**Requirements:**
- Add expenses offline
- Sync with server when online
- Conflict resolution (if expense modified on another device)
- Queue failed syncs for retry
- Show sync progress
- Statistics work offline (from cached data)
- Export data functionality

### Exercise 4: Collaborative Note-Taking (Advanced)

Create note app with multi-device sync and conflict resolution.

**Requirements:**
- Create/edit notes offline
- Sync across devices
- Detect conflicts (same note edited on 2 devices)
- Let user choose resolution strategy
- Real-time sync when online
- Offline queue with retry
- Version history (show previous versions)
- Merge non-conflicting fields automatically

**Conflict Resolution:**
```dart
// Example conflict
Local:  "Buy milk and eggs"  (edited at 2:00 PM)
Server: "Buy milk and bread" (edited at 2:05 PM)

// Let user choose:
// - Keep local version
// - Use server version
// - Keep both (create duplicate)
// - Merge manually
```

### Exercise 5: Offline-First Social Feed (Advanced)

Build social media feed that works offline.

**Requirements:**
- Cache feed for offline viewing
- Like/comment work offline (queued for sync)
- Optimistic UI updates
- Show posts as "pending" until synced
- Pull-to-refresh when online
- Infinite scroll with pagination
- Images cached for offline viewing
- Handle failed posts (retry or delete)
- Background sync service

**Advanced Features:**
- Prefetch next page in background
- Smart cache eviction (remove old posts)
- Track data usage (WiFi vs mobile data)
- Compress images before upload
- Batch upload when WiFi available

## What You've Learned

✅ What offline-first architecture is and why it matters
✅ Detecting network connectivity
✅ Cache strategies (cache-first, network-first, stale-while-revalidate)
✅ Optimistic UI updates
✅ Sync queues for failed operations
✅ Conflict resolution strategies
✅ Complete offline-first app implementation
✅ Best practices (retry logic, batch operations, visual feedback)
✅ Real-world patterns for production apps

## What's Next

Congratulations! You've completed **Phase 8: Local Data Storage**!

You now know:
1. **SharedPreferences** - Simple settings
2. **SQLite** - Raw SQL database
3. **Hive** - Fast NoSQL storage
4. **Drift** - Type-safe SQL
5. **Offline-First** - Apps that work anywhere!

Next up: **Phase 9: Animations Mastery** - Make your apps come alive with beautiful animations!

You're building production-ready Flutter apps! 🚀
