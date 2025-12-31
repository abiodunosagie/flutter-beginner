# Mockito Basics: Testing with Mock Objects

## The Simple Explanation

Imagine you're testing a toy car, but you don't have a real road. Instead, you use a pretend road made of cardboard! That's what mocking is - using pretend (fake) objects to test your code.

```
┌─────────────────────────────────────────────────────────┐
│                    REAL vs MOCK                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  REAL TESTING (Hard!):                                   │
│  ┌─────────────┐      ┌──────────────┐                  │
│  │  Your Code  │─────▶│ Real Server  │                  │
│  │             │      │ (might be    │                  │
│  │             │      │  slow/down)  │                  │
│  └─────────────┘      └──────────────┘                  │
│                                                          │
│  MOCK TESTING (Easy!):                                   │
│  ┌─────────────┐      ┌──────────────┐                  │
│  │  Your Code  │─────▶│  Fake Server │                  │
│  │             │      │  (instant!   │                  │
│  │             │      │   reliable!) │                  │
│  └─────────────┘      └──────────────┘                  │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Mocking = Using fake objects in tests!**

---

## Why Use Mocking?

### Problem Without Mocking

```dart
// Your code depends on a real database
class UserService {
  final Database database;

  Future<User> getUser(int id) async {
    return await database.fetchUser(id);  // Needs REAL database!
  }
}

// Testing is HARD:
test('gets user', () async {
  // ❌ Need to set up real database
  // ❌ Need to add test data
  // ❌ Slow (database queries take time)
  // ❌ Flaky (what if database is down?)
});
```

### Solution With Mocking

```dart
// Same code, but test with FAKE database
test('gets user', () async {
  // ✅ Create fake database
  final mockDatabase = MockDatabase();

  // ✅ Tell it what to return
  when(mockDatabase.fetchUser(1))
      .thenAnswer((_) async => User(id: 1, name: 'Alice'));

  // ✅ Test is fast, reliable, easy!
  final service = UserService(mockDatabase);
  final user = await service.getUser(1);

  expect(user.name, 'Alice');
});
```

---

## Setting Up Mockito

### Step 1: Add Dependencies

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

### Step 2: Run pub get

```bash
flutter pub get
```

---

## Creating Your First Mock

### The Code We Want to Test

```dart
// lib/services/weather_service.dart
class WeatherService {
  final ApiClient apiClient;

  WeatherService(this.apiClient);

  Future<String> getWeather(String city) async {
    final response = await apiClient.get('/weather?city=$city');
    return response['temperature'];
  }
}

// lib/services/api_client.dart
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);
}
```

### Creating the Mock

#### Manual Mock (Simple Way)

```dart
// test/mocks/mock_api_client.dart
import 'package:mockito/mockito.dart';
import 'package:your_app/services/api_client.dart';

class MockApiClient extends Mock implements ApiClient {}
```

#### Generated Mock (Recommended Way)

```dart
// test/weather_service_test.dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/services/api_client.dart';
import 'package:your_app/services/weather_service.dart';

// This tells mockito to generate a mock
@GenerateMocks([ApiClient])
import 'weather_service_test.mocks.dart';  // Generated file

void main() {
  // Tests go here
}
```

### Step 3: Generate Mocks

```bash
dart run build_runner build
```

This creates `weather_service_test.mocks.dart` with `MockApiClient` class!

---

## The when() and thenReturn() Pattern

### Basic Syntax

```
when(mockObject.method(arguments))
    .thenReturn(fakeResult);
```

### Example: Simple Return

```dart
test('returns weather for city', () async {
  // Create mock
  final mockApi = MockApiClient();

  // Define behavior: when get() is called, return this
  when(mockApi.get('/weather?city=London'))
      .thenAnswer((_) async => {'temperature': '20°C'});

  // Use mock in your code
  final service = WeatherService(mockApi);
  final weather = await service.getWeather('London');

  // Verify result
  expect(weather, '20°C');
});
```

---

## thenReturn vs thenAnswer

### thenReturn: For Simple Values

```dart
// Use when returning simple, non-Future values
when(mock.getCount()).thenReturn(5);
```

### thenAnswer: For Futures and Complex Logic

```dart
// Use for Future values
when(mock.fetchData())
    .thenAnswer((_) async => Data());

// Use when you need the arguments
when(mock.calculate(any))
    .thenAnswer((invocation) {
      final number = invocation.positionalArguments[0] as int;
      return number * 2;
    });
```

---

## Argument Matchers

Sometimes you don't care about exact arguments:

### any - Match Any Value

```dart
// Accept ANY string
when(mockApi.get(any))
    .thenAnswer((_) async => {'data': 'ok'});

// Now these ALL work:
mockApi.get('/weather');
mockApi.get('/users');
mockApi.get('/anything');
```

### anyNamed - For Named Parameters

```dart
when(mock.search(
  query: anyNamed('query'),
  limit: anyNamed('limit'),
)).thenReturn(results);
```

### Specific Type Matchers

```dart
// Only match integers
when(mock.process(any)).thenReturn(result);

// Only match non-null values
when(mock.save(argThat(isNotNull))).thenReturn(true);

// Custom matcher
when(mock.filter(argThat(greaterThan(10)))).thenReturn(filtered);
```

---

## Verifying Method Calls

Check if methods were called correctly:

### verify() - Was it Called?

```dart
test('calls API when getting weather', () async {
  final mockApi = MockApiClient();
  when(mockApi.get(any))
      .thenAnswer((_) async => {'temperature': '20°C'});

  final service = WeatherService(mockApi);
  await service.getWeather('London');

  // Verify get() was called with correct endpoint
  verify(mockApi.get('/weather?city=London')).called(1);
});
```

### verifyNever() - Was it NOT Called?

```dart
test('does not call API for empty city', () async {
  final mockApi = MockApiClient();
  final service = WeatherService(mockApi);

  // Don't get weather for empty string
  await service.getWeather('');

  // Verify API was never called
  verifyNever(mockApi.get(any));
});
```

### verifyInOrder() - Called in Correct Order?

```dart
test('saves then uploads in order', () async {
  final mockDb = MockDatabase();
  final mockApi = MockApiClient();

  final service = DataService(mockDb, mockApi);
  await service.saveAndUpload(data);

  // Verify order: save first, then upload
  verifyInOrder([
    mockDb.save(any),
    mockApi.upload(any),
  ]);
});
```

---

## Complete Example: Testing a Todo Service

### The Service

```dart
// lib/services/todo_service.dart
class TodoService {
  final ApiClient apiClient;

  TodoService(this.apiClient);

  Future<List<Todo>> getTodos() async {
    final response = await apiClient.get('/todos');
    return (response['todos'] as List)
        .map((json) => Todo.fromJson(json))
        .toList();
  }

  Future<bool> addTodo(String title) async {
    if (title.isEmpty) return false;

    final response = await apiClient.post('/todos', {
      'title': title,
      'completed': false,
    });

    return response['success'] == true;
  }

  Future<void> deleteTodo(int id) async {
    await apiClient.delete('/todos/$id');
  }
}

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    completed: json['completed'],
  );
}

// lib/services/api_client.dart
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);
  Future<void> delete(String endpoint);
}
```

### The Complete Test File

```dart
// test/services/todo_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/services/api_client.dart';
import 'package:your_app/services/todo_service.dart';

@GenerateMocks([ApiClient])
import 'todo_service_test.mocks.dart';

void main() {
  late MockApiClient mockApi;
  late TodoService service;

  // Run before each test
  setUp(() {
    mockApi = MockApiClient();
    service = TodoService(mockApi);
  });

  group('getTodos', () {
    test('returns list of todos from API', () async {
      // Arrange
      final fakeTodos = {
        'todos': [
          {'id': 1, 'title': 'Buy milk', 'completed': false},
          {'id': 2, 'title': 'Walk dog', 'completed': true},
        ]
      };

      when(mockApi.get('/todos'))
          .thenAnswer((_) async => fakeTodos);

      // Act
      final todos = await service.getTodos();

      // Assert
      expect(todos, hasLength(2));
      expect(todos[0].title, 'Buy milk');
      expect(todos[1].completed, true);
    });

    test('returns empty list when no todos', () async {
      // Arrange
      when(mockApi.get('/todos'))
          .thenAnswer((_) async => {'todos': []});

      // Act
      final todos = await service.getTodos();

      // Assert
      expect(todos, isEmpty);
    });
  });

  group('addTodo', () {
    test('adds todo and returns true', () async {
      // Arrange
      when(mockApi.post(any, any))
          .thenAnswer((_) async => {'success': true});

      // Act
      final result = await service.addTodo('New task');

      // Assert
      expect(result, true);
      verify(mockApi.post('/todos', {
        'title': 'New task',
        'completed': false,
      })).called(1);
    });

    test('returns false for empty title', () async {
      // Act
      final result = await service.addTodo('');

      // Assert
      expect(result, false);
      verifyNever(mockApi.post(any, any));
    });
  });

  group('deleteTodo', () {
    test('calls delete endpoint with correct id', () async {
      // Arrange
      when(mockApi.delete(any))
          .thenAnswer((_) async => Future.value());

      // Act
      await service.deleteTodo(5);

      // Assert
      verify(mockApi.delete('/todos/5')).called(1);
    });
  });
}
```

### Run the Tests

```bash
flutter test test/services/todo_service_test.dart
```

---

## Common Patterns

### Pattern 1: Default Mock Behavior

```dart
setUp(() {
  mockApi = MockApiClient();

  // Set up default behavior for all tests
  when(mockApi.get(any))
      .thenAnswer((_) async => {'data': 'default'});

  // Individual tests can override this
});
```

### Pattern 2: Capturing Arguments

```dart
test('sends correct data', () async {
  when(mockApi.post(any, any))
      .thenAnswer((_) async => {'success': true});

  await service.addTodo('Test');

  // Capture what was sent
  final captured = verify(mockApi.post(any, captureAny)).captured;
  expect(captured.single, {'title': 'Test', 'completed': false});
});
```

### Pattern 3: Throwing Errors

```dart
test('handles API errors', () async {
  // Make mock throw an error
  when(mockApi.get(any))
      .thenThrow(Exception('Network error'));

  // Verify your code handles it
  expect(
    () => service.getTodos(),
    throwsException,
  );
});
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                  MOCKITO BASICS SUMMARY                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: Mockito creates fake objects for testing          │
│                                                          │
│  SETUP:                                                  │
│  1. Add mockito dependency                               │
│  2. Create mock with @GenerateMocks                      │
│  3. Run build_runner                                     │
│                                                          │
│  BASIC SYNTAX:                                           │
│  • when(mock.method()).thenReturn(value)                 │
│  • when(mock.method()).thenAnswer((_) async => value)    │
│  • verify(mock.method()).called(n)                       │
│  • verifyNever(mock.method())                            │
│                                                          │
│  ARGUMENT MATCHERS:                                      │
│  • any - match anything                                  │
│  • anyNamed('param') - for named parameters              │
│  • argThat(matcher) - custom matching                    │
│                                                          │
│  BENEFITS:                                               │
│  ✅ Fast tests (no real network/database)                │
│  ✅ Reliable tests (no external dependencies)            │
│  ✅ Easy setup (no complex test data)                    │
│  ✅ Test edge cases (simulate errors easily)             │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What's the difference between thenReturn() and thenAnswer()?

<details>
<summary>Answer</summary>

- **thenReturn()**: Use for simple, non-Future values
  ```dart
  when(mock.getCount()).thenReturn(5);
  ```

- **thenAnswer()**: Use for Futures or when you need access to arguments
  ```dart
  when(mock.fetchData()).thenAnswer((_) async => data);
  ```

</details>

**Q2:** How do you verify a method was called exactly 3 times?

<details>
<summary>Answer</summary>

```dart
verify(mock.method()).called(3);
```

</details>

**Q3:** How do you make a mock throw an exception?

<details>
<summary>Answer</summary>

```dart
when(mock.method()).thenThrow(Exception('Error message'));

// Or for async methods:
when(mock.asyncMethod())
    .thenAnswer((_) async => throw Exception('Error'));
```

</details>

---

**Next:** Learn advanced mockito techniques like stubbing, capturing arguments, and testing complex scenarios.

---

## Navigation

⬅️ **Previous:** [Test Driven Development](05-TestDrivenDevelopment.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Mockito Advanced](07-MockitoAdvanced.md)
