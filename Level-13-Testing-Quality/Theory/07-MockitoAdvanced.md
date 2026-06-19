# Mockito Advanced: Pro Testing Techniques

## The Big Idea In One Sentence

> Beyond stubbing returns, Mockito can verify that a method was actually called (and how many times), match flexible arguments, and stub async results, so you test behavior, not just values.

## The Simple Explanation

Now that you know how to create pretend (mock) objects, let's learn the advanced tricks! It's like learning to do more complicated magic tricks after mastering the basic ones.

```
┌─────────────────────────────────────────────────────────┐
│              BASIC vs ADVANCED MOCKING                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  BASIC:                                                  │
│  "When you call this, return that"                       │
│                                                          │
│  ADVANCED:                                               │
│  • "Return different things each time"                   │
│  • "Wait exactly 2 seconds before responding"            │
│  • "Remember what was sent and check it later"           │
│  • "Call the real function sometimes"                    │
│  • "Create smart fakes that act almost real"             │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Stubbing: Multiple Responses

### Returning Different Values Each Time

```dart
test('API returns different results on each call', () async {
  final mockApi = MockApiClient();

  // First call returns page 1, second call returns page 2
  when(mockApi.get(any))
      .thenAnswer((_) async => {'page': 1})
      .thenAnswer((_) async => {'page': 2})
      .thenAnswer((_) async => {'page': 3});

  expect(await mockApi.get('/data'), {'page': 1});
  expect(await mockApi.get('/data'), {'page': 2});
  expect(await mockApi.get('/data'), {'page': 3});
});
```

### Real-World Example: Pagination

```dart
class DataService {
  final ApiClient apiClient;
  int currentPage = 1;

  DataService(this.apiClient);

  Future<List<Item>> loadNextPage() async {
    final response = await apiClient.get('/items?page=$currentPage');
    currentPage++;
    return (response['items'] as List)
        .map((json) => Item.fromJson(json))
        .toList();
  }
}

test('loads multiple pages correctly', () async {
  final mockApi = MockApiClient();

  // Each call returns different page
  when(mockApi.get('/items?page=1'))
      .thenAnswer((_) async => {'items': [{'id': 1}, {'id': 2}]});
  when(mockApi.get('/items?page=2'))
      .thenAnswer((_) async => {'items': [{'id': 3}, {'id': 4}]});
  when(mockApi.get('/items?page=3'))
      .thenAnswer((_) async => {'items': [{'id': 5}]});

  final service = DataService(mockApi);

  final page1 = await service.loadNextPage();
  expect(page1, hasLength(2));

  final page2 = await service.loadNextPage();
  expect(page2, hasLength(2));

  final page3 = await service.loadNextPage();
  expect(page3, hasLength(1));
});
```

---

## Simulating Delays

### Adding Realistic Delays

```dart
test('handles slow API responses', () async {
  final mockApi = MockApiClient();

  // Simulate 2-second delay
  when(mockApi.get(any)).thenAnswer((_) async {
    await Future.delayed(Duration(seconds: 2));
    return {'data': 'loaded'};
  });

  final service = DataService(mockApi);

  // Test that your loading indicator appears
  final future = service.loadData();
  expect(service.isLoading, true);

  await future;
  expect(service.isLoading, false);
});
```

### Testing Timeouts

```dart
test('times out if API is too slow', () async {
  final mockApi = MockApiClient();

  // Simulate very slow response (10 seconds)
  when(mockApi.get(any)).thenAnswer((_) async {
    await Future.delayed(Duration(seconds: 10));
    return {'data': 'too late'};
  });

  final service = DataService(mockApi, timeout: Duration(seconds: 5));

  // Should timeout before 10 seconds
  expect(
    () => service.loadData(),
    throwsA(isA<TimeoutException>()),
  );
});
```

---

## Capturing Arguments

### Why Capture Arguments?

Sometimes you want to verify WHAT DATA was sent to a method:

```dart
test('sends correct user data to API', () async {
  final mockApi = MockApiClient();
  when(mockApi.post(any, any))
      .thenAnswer((_) async => {'success': true});

  final service = UserService(mockApi);
  await service.createUser('Alice', 'alice@example.com');

  // Capture the data that was sent
  final captured = verify(
    mockApi.post('/users', captureAny)
  ).captured;

  // Check the captured data
  expect(captured.single, {
    'name': 'Alice',
    'email': 'alice@example.com',
  });
});
```

### Capturing Multiple Calls

```dart
test('sends multiple requests with correct data', () async {
  final mockApi = MockApiClient();
  when(mockApi.post(any, any))
      .thenAnswer((_) async => {'success': true});

  final service = BatchService(mockApi);
  await service.uploadBatch(['item1', 'item2', 'item3']);

  // Capture all post calls
  final captured = verify(
    mockApi.post('/upload', captureAny)
  ).captured;

  // Check each captured request
  expect(captured, hasLength(3));
  expect(captured[0], {'item': 'item1'});
  expect(captured[1], {'item': 'item2'});
  expect(captured[2], {'item': 'item3'});
});
```

---

## Custom Argument Matchers

### Creating Your Own Matchers

```dart
// Custom matcher for valid email addresses
class IsValidEmail extends Matcher {
  @override
  bool matches(item, Map matchState) {
    if (item is! String) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(item);
  }

  @override
  Description describe(Description description) =>
      description.add('a valid email address');
}

// Use it in tests
test('only accepts valid email addresses', () {
  final mockApi = MockApiClient();
  when(mockApi.register(argThat(IsValidEmail())))
      .thenAnswer((_) async => {'success': true});

  // This works (valid email)
  mockApi.register('user@example.com');

  // This doesn't match the mock (invalid email)
  expect(
    () => mockApi.register('notanemail'),
    throwsA(anything),  // No matching stub
  );
});
```

### Matcher for Data Objects

```dart
class IsUserWithName extends Matcher {
  final String expectedName;

  IsUserWithName(this.expectedName);

  @override
  bool matches(item, Map matchState) {
    if (item is! User) return false;
    return item.name == expectedName;
  }

  @override
  Description describe(Description description) =>
      description.add('User with name $expectedName');
}

// Usage
test('creates user with correct name', () async {
  final mockDb = MockDatabase();
  when(mockDb.save(argThat(IsUserWithName('Alice'))))
      .thenAnswer((_) async => true);

  final service = UserService(mockDb);
  await service.createUser(User(name: 'Alice', age: 30));

  verify(mockDb.save(argThat(IsUserWithName('Alice')))).called(1);
});
```

---

## Partial Mocks: Calling Real Methods

Sometimes you want to mock SOME methods but use real ones for others:

### Using @GenerateNiceMocks

```dart
// Create a partial mock that calls real methods by default
@GenerateNiceMocks([MockSpec<UserRepository>()])
import 'user_repository_test.mocks.dart';

test('uses real validation but mocked database', () async {
  final mockRepo = MockUserRepository();

  // Mock only the database call
  when(mockRepo.saveToDatabase(any))
      .thenAnswer((_) async => true);

  // Use real validation method
  when(mockRepo.validateUser(any))
      .thenCallRealMethod();  // ← Use real implementation!

  final user = User(name: '', email: 'invalid');
  final result = await mockRepo.validateUser(user);

  expect(result, false);  // Real validation fails
  verifyNever(mockRepo.saveToDatabase(any));  // Never tried to save
});
```

---

## Smart Mocks: Fake Implementations

Create "fake" objects that act almost like the real thing:

### In-Memory Database Fake

```dart
class FakeDatabase implements Database {
  final Map<int, User> _users = {};
  int _nextId = 1;

  @override
  Future<User> save(User user) async {
    final id = _nextId++;
    final userWithId = User(
      id: id,
      name: user.name,
      email: user.email,
    );
    _users[id] = userWithId;
    return userWithId;
  }

  @override
  Future<User?> find(int id) async {
    return _users[id];
  }

  @override
  Future<List<User>> getAll() async {
    return _users.values.toList();
  }

  @override
  Future<void> delete(int id) async {
    _users.remove(id);
  }
}

// Using the fake
test('user service works with database', () async {
  final fakeDb = FakeDatabase();
  final service = UserService(fakeDb);

  // Add users
  await service.createUser('Alice', 'alice@example.com');
  await service.createUser('Bob', 'bob@example.com');

  // Retrieve users
  final users = await service.getAllUsers();
  expect(users, hasLength(2));
  expect(users[0].name, 'Alice');
  expect(users[1].name, 'Bob');

  // Delete user
  await service.deleteUser(1);
  final remaining = await service.getAllUsers();
  expect(remaining, hasLength(1));
  expect(remaining[0].name, 'Bob');
});
```

### When to Use Fakes vs Mocks

```
MOCKS (when):
✅ Testing isolated behavior
✅ Verifying method calls
✅ Need simple, specific behavior

FAKES (when):
✅ Testing multiple operations together
✅ Need realistic state management
✅ Complex interactions
✅ Integration-style tests
```

---

## Resetting Mocks

### Clear Mock Behavior Between Tests

```dart
void main() {
  late MockApiClient mockApi;

  setUp(() {
    mockApi = MockApiClient();
  });

  tearDown(() {
    // Reset all interactions
    reset(mockApi);
  });

  test('first test', () {
    when(mockApi.get(any)).thenAnswer((_) async => {'data': 'test1'});
    // ... test code ...
  });

  test('second test starts fresh', () {
    // Previous stub is gone!
    when(mockApi.get(any)).thenAnswer((_) async => {'data': 'test2'});
    // ... test code ...
  });
}
```

---

## Answer Callbacks with Complex Logic

### Dynamic Responses Based on Input

```dart
test('API search returns filtered results', () async {
  final mockApi = MockApiClient();

  // All possible users
  final allUsers = [
    {'name': 'Alice', 'age': 25},
    {'name': 'Bob', 'age': 30},
    {'name': 'Charlie', 'age': 25},
  ];

  // Return users filtered by query
  when(mockApi.search(any)).thenAnswer((invocation) async {
    final query = invocation.positionalArguments[0] as String;

    if (query.isEmpty) return {'users': allUsers};

    final filtered = allUsers.where((user) =>
      (user['name'] as String).toLowerCase().contains(query.toLowerCase())
    ).toList();

    return {'users': filtered};
  });

  final service = SearchService(mockApi);

  // Search for 'Ali'
  var results = await service.search('Ali');
  expect(results, hasLength(1));
  expect(results[0].name, 'Alice');

  // Search for all
  results = await service.search('');
  expect(results, hasLength(3));
});
```

### Counting Calls and Changing Behavior

```dart
test('API fails after 3 retries', () async {
  final mockApi = MockApiClient();
  int callCount = 0;

  when(mockApi.get(any)).thenAnswer((_) async {
    callCount++;
    if (callCount < 3) {
      throw Exception('Network error');
    }
    return {'data': 'success'};
  });

  final service = DataService(mockApi, maxRetries: 3);
  final result = await service.loadWithRetry();

  expect(result, 'success');
  expect(callCount, 3);  // Succeeded on 3rd try
});
```

---

## Testing Streams with Mocks

### Mocking Stream Methods

```dart
class MockChatService extends Mock implements ChatService {}

test('listens to message stream', () async {
  final mockChat = MockChatService();

  // Create a stream of messages
  final messagesStream = Stream.fromIterable([
    Message(id: 1, text: 'Hello'),
    Message(id: 2, text: 'How are you?'),
    Message(id: 3, text: 'Goodbye'),
  ]);

  when(mockChat.getMessages()).thenAnswer((_) => messagesStream);

  final service = ChatDisplayService(mockChat);
  await service.loadMessages();

  expect(service.messages, hasLength(3));
  expect(service.messages[0].text, 'Hello');
  expect(service.messages[2].text, 'Goodbye');
});
```

### Stream Controllers for More Control

```dart
test('handles real-time message updates', () async {
  final mockChat = MockChatService();
  final streamController = StreamController<Message>();

  when(mockChat.getMessages())
      .thenAnswer((_) => streamController.stream);

  final service = ChatDisplayService(mockChat);
  service.listenToMessages();

  // Add messages one by one
  streamController.add(Message(id: 1, text: 'First'));
  await Future.delayed(Duration(milliseconds: 10));
  expect(service.messages, hasLength(1));

  streamController.add(Message(id: 2, text: 'Second'));
  await Future.delayed(Duration(milliseconds: 10));
  expect(service.messages, hasLength(2));

  streamController.close();
});
```

---

## Complete Advanced Example: Social Media Service

```dart
// lib/services/social_service.dart
class SocialService {
  final ApiClient apiClient;
  final LocalDatabase database;

  SocialService(this.apiClient, this.database);

  Future<void> postStatus(String text) async {
    // Validate
    if (text.trim().isEmpty || text.length > 280) {
      throw ValidationException('Invalid post length');
    }

    // Save locally first
    await database.savePost(Post(text: text, status: 'pending'));

    // Upload to server
    try {
      final response = await apiClient.post('/posts', {'text': text});
      await database.updatePostStatus(response['id'], 'uploaded');
    } catch (e) {
      await database.updatePostStatus(0, 'failed');
      rethrow;
    }
  }

  Future<List<Post>> getFeed({int page = 1}) async {
    // Try cache first
    if (page == 1) {
      final cached = await database.getCachedPosts();
      if (cached.isNotEmpty) {
        return cached;
      }
    }

    // Load from server
    final response = await apiClient.get('/feed?page=$page');
    final posts = (response['posts'] as List)
        .map((json) => Post.fromJson(json))
        .toList();

    // Cache first page
    if (page == 1) {
      await database.cachePosts(posts);
    }

    return posts;
  }
}
```

### Complete Test Suite

```dart
// test/services/social_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ApiClient, LocalDatabase])
import 'social_service_test.mocks.dart';

void main() {
  late MockApiClient mockApi;
  late MockLocalDatabase mockDb;
  late SocialService service;

  setUp(() {
    mockApi = MockApiClient();
    mockDb = MockLocalDatabase();
    service = SocialService(mockApi, mockDb);
  });

  group('postStatus', () {
    test('saves locally then uploads to server', () async {
      // Arrange
      when(mockDb.savePost(any))
          .thenAnswer((_) async => Future.value());
      when(mockApi.post(any, any))
          .thenAnswer((_) async => {'id': 123});
      when(mockDb.updatePostStatus(any, any))
          .thenAnswer((_) async => Future.value());

      // Act
      await service.postStatus('Hello world!');

      // Assert - verify order
      verifyInOrder([
        mockDb.savePost(any),
        mockApi.post('/posts', {'text': 'Hello world!'}),
        mockDb.updatePostStatus(123, 'uploaded'),
      ]);
    });

    test('marks as failed if upload fails', () async {
      // Arrange
      when(mockDb.savePost(any))
          .thenAnswer((_) async => Future.value());
      when(mockApi.post(any, any))
          .thenThrow(Exception('Network error'));
      when(mockDb.updatePostStatus(any, any))
          .thenAnswer((_) async => Future.value());

      // Act & Assert
      expect(
        () => service.postStatus('Hello!'),
        throwsException,
      );

      verify(mockDb.updatePostStatus(0, 'failed')).called(1);
    });

    test('rejects empty posts', () async {
      // Act & Assert
      expect(
        () => service.postStatus('   '),
        throwsA(isA<ValidationException>()),
      );

      // Should never touch database or API
      verifyNever(mockDb.savePost(any));
      verifyNever(mockApi.post(any, any));
    });

    test('rejects posts over 280 characters', () async {
      final longPost = 'a' * 281;

      expect(
        () => service.postStatus(longPost),
        throwsA(isA<ValidationException>()),
      );
    });
  });

  group('getFeed', () {
    test('returns cached posts for page 1', () async {
      // Arrange
      final cachedPosts = [
        Post(id: 1, text: 'Cached 1'),
        Post(id: 2, text: 'Cached 2'),
      ];

      when(mockDb.getCachedPosts())
          .thenAnswer((_) async => cachedPosts);

      // Act
      final posts = await service.getFeed();

      // Assert
      expect(posts, hasLength(2));
      expect(posts, same(cachedPosts));
      verifyNever(mockApi.get(any));  // Didn't hit API
    });

    test('loads from server and caches if no cache', () async {
      // Arrange
      when(mockDb.getCachedPosts())
          .thenAnswer((_) async => []);
      when(mockApi.get('/feed?page=1'))
          .thenAnswer((_) async => {
            'posts': [
              {'id': 1, 'text': 'New 1'},
              {'id': 2, 'text': 'New 2'},
            ]
          });
      when(mockDb.cachePosts(any))
          .thenAnswer((_) async => Future.value());

      // Act
      final posts = await service.getFeed();

      // Assert
      expect(posts, hasLength(2));
      verify(mockApi.get('/feed?page=1')).called(1);

      // Verify caching
      final captured = verify(mockDb.cachePosts(captureAny)).captured;
      expect(captured.single, hasLength(2));
    });

    test('skips cache for pages beyond 1', () async {
      // Arrange
      when(mockApi.get('/feed?page=2'))
          .thenAnswer((_) async => {'posts': []});

      // Act
      await service.getFeed(page: 2);

      // Assert
      verifyNever(mockDb.getCachedPosts());
      verifyNever(mockDb.cachePosts(any));
    });
  });
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│             ADVANCED MOCKITO TECHNIQUES                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  STUBBING:                                               │
│  • Multiple return values (.thenAnswer chaining)         │
│  • Simulating delays (Future.delayed)                    │
│  • Different responses per call                          │
│                                                          │
│  VERIFICATION:                                           │
│  • Capturing arguments (captureAny)                      │
│  • Custom matchers (argThat)                             │
│  • Verify call order (verifyInOrder)                     │
│                                                          │
│  ADVANCED:                                               │
│  • Partial mocks (thenCallRealMethod)                    │
│  • Smart fakes (fake implementations)                    │
│  • Dynamic answers (thenAnswer with logic)               │
│  • Stream mocking                                        │
│  • Reset mocks (reset())                                 │
│                                                          │
│  WHEN TO USE:                                            │
│  • Mocks: Isolated testing, verifying calls              │
│  • Fakes: Complex state, integration-style tests         │
│  • Partial: Test some parts, use real others             │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** How do you make a mock return different values on each call?

<details>
<summary>Answer</summary>

Chain `.thenAnswer()` calls:

```dart
when(mock.method())
    .thenAnswer((_) async => 'first')
    .thenAnswer((_) async => 'second')
    .thenAnswer((_) async => 'third');
```

</details>

**Q2:** What's the difference between a mock and a fake?

<details>
<summary>Answer</summary>

- **Mock**: Created by Mockito, you explicitly define behavior with `when()`. Good for verifying calls.
- **Fake**: You write the implementation yourself (like in-memory database). Good for realistic behavior and complex tests.

</details>

**Q3:** How do you capture the data sent to a mocked method?

<details>
<summary>Answer</summary>

```dart
final captured = verify(mock.method(captureAny)).captured;
expect(captured.single, expectedData);
```

</details>

---

**Next:** Learn about Flutter DevTools for debugging and performance profiling.

---

## Navigation

## Assignment

### Problem 1: Verify a call

You want to prove your code called `repo.save(user)` exactly once. Which Mockito feature do you use?

### Problem 2: Stub vs verify

In one line, what is the difference between `when(...)` and `verify(...)`?

### Problem 3: Async stub

A repository method returns a `Future`. Which method stubs its result?

---

## Assignment Answers

### Problem 1: Verify a call

`verify(repo.save(user)).called(1);`.

### Problem 2: Stub vs verify

`when(...)` sets up what a mock returns when called; `verify(...)` checks afterward that a method was actually called (and how often).

### Problem 3: Async stub

`thenAnswer((_) async => value)` (use `thenAnswer` for Futures, since the result is asynchronous).

---

⬅️ **Previous:** [Mockito Basics](06-MockitoBasics.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [DevTools Introduction](08-DevToolsIntro.md)
