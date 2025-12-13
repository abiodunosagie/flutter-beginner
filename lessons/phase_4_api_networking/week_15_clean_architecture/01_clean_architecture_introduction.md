# Week 15: Clean Architecture - Professional App Structure

## The Problem: Messy Code

**Scenario:** Your app grows to 50+ screens. Code becomes a tangled mess:

```dart
// Everything in one file!
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // API call mixed with UI
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);

    try {
      // HTTP logic in widget!
      final response = await http.get(
        Uri.parse('https://api.example.com/users'),
      );

      // JSON parsing in widget!
      final List<dynamic> data = jsonDecode(response.body);
      users = data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error: $e');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(/* messy UI mixed with logic */);
  }
}
```

**Problems:**
- ❌ UI mixed with business logic
- ❌ Hard to test
- ❌ Can't reuse code
- ❌ Changes break everything
- ❌ Team members confused

**Solution:** **Clean Architecture**

---

## What is Clean Architecture?

**Clean Architecture** = Organized code into layers with clear responsibilities.

**Real-world analogy:**
- **Restaurant:**
  - **UI (Presentation)** = Waiter (takes orders, serves food)
  - **Business Logic (Domain)** = Chef (makes food)
  - **Data** = Kitchen storage (ingredients, recipes)

**Each layer:**
- ✓ Has single responsibility
- ✓ Independent of others
- ✓ Testable in isolation
- ✓ Easy to modify

---

## The Layers

### 1. Presentation Layer (UI)

**What:** Widgets, screens, state management

**Responsibilities:**
- Display UI
- Handle user input
- Trigger business logic
- Show loading/error states

**Does NOT:**
- Make API calls
- Parse JSON
- Contain business rules

```dart
// presentation/screens/users_screen.dart
class UsersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);

    return usersState.when(
      data: (users) => ListView.builder(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 2. Domain Layer (Business Logic)

**What:** Business rules, entities, use cases

**Responsibilities:**
- Core business logic
- Define entities (User, Post, etc.)
- Define use cases (GetUsers, CreatePost)

**Does NOT:**
- Know about UI
- Know about databases
- Know about APIs

```dart
// domain/entities/user.dart
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// domain/usecases/get_users.dart
class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() {
    return repository.getUsers();
  }
}
```

### 3. Data Layer (External Data)

**What:** API calls, database, local storage

**Responsibilities:**
- Fetch data from API
- Save to database
- Cache data
- Convert JSON to entities

**Does NOT:**
- Know about UI
- Contain business rules

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<List<User>> getUsers() async {
    final response = await apiService.get('/users');
    return (response as List).map((json) => User.fromJson(json)).toList();
  }
}
```

---

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── error/
│   │   └── failures.dart
│   ├── network/
│   │   └── api_service.dart
│   └── utils/
│       └── constants.dart
├── features/
│   └── users/
│       ├── data/
│       │   ├── models/
│       │   │   └── user_model.dart
│       │   ├── datasources/
│       │   │   └── user_remote_datasource.dart
│       │   └── repositories/
│       │       └── user_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user.dart
│       │   ├── repositories/
│       │   │   └── user_repository.dart
│       │   └── usecases/
│       │       ├── get_users.dart
│       │       └── get_user_by_id.dart
│       └── presentation/
│           ├── providers/
│           │   └── users_provider.dart
│           ├── screens/
│           │   └── users_screen.dart
│           └── widgets/
│               └── user_card.dart
└── shared/
    └── widgets/
        └── loading_indicator.dart
```

---

## Dependency Flow

**Rule:** Dependencies point inward, never outward.

```
Presentation → Domain ← Data
    ↓            ↓        ↓
   UI         Entities  API/DB
```

**Example:**
- ✓ **Presentation** depends on **Domain**
- ✓ **Data** depends on **Domain**
- ❌ **Domain** does NOT depend on **Presentation** or **Data**

---

## Step-by-Step Example: User Feature

### Step 1: Define Entity (Domain)

```dart
// domain/entities/user.dart
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

### Step 2: Define Repository Interface (Domain)

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
  Future<void> createUser(User user);
}
```

**Why interface?**
- Domain doesn't know HOW to get data
- Data layer implements HOW

### Step 3: Define Use Case (Domain)

```dart
// domain/usecases/get_users.dart
class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}
```

**Use case** = Single business operation

### Step 4: Create Data Model (Data)

```dart
// data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required int id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  // From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```

### Step 5: Create Remote Data Source (Data)

```dart
// data/datasources/user_remote_datasource.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/users/$id'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
```

### Step 6: Implement Repository (Data)

```dart
// data/repositories/user_repository_impl.dart
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<User>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<User> getUserById(int id) async {
    return await remoteDataSource.getUserById(id);
  }

  @override
  Future<void> createUser(User user) async {
    // Implementation
    throw UnimplementedError();
  }
}
```

### Step 7: Create Provider (Presentation)

```dart
// presentation/providers/users_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

// Dependencies
final httpClientProvider = Provider((ref) => http.Client());

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(ref.read(httpClientProvider));
});

final userRepositoryProvider = Provider((ref) {
  return UserRepositoryImpl(ref.read(userRemoteDataSourceProvider));
});

final getUsersUseCaseProvider = Provider((ref) {
  return GetUsers(ref.read(userRepositoryProvider));
});

// Users state
final usersProvider = FutureProvider<List<User>>((ref) async {
  final useCase = ref.read(getUsersUseCaseProvider);
  return await useCase.call();
});
```

### Step 8: Create Screen (Presentation)

```dart
// presentation/screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/users_provider.dart';
import '../widgets/user_card.dart';

class UsersScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(usersProvider);
            },
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return UserCard(user: users[index]);
            },
          );
        },
        loading: () {
          return Center(child: CircularProgressIndicator());
        },
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text('Error: $error'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(usersProvider);
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Step 9: Create Widget (Presentation)

```dart
// presentation/widgets/user_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.name[0]),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to detail screen
        },
      ),
    );
  }
}
```

---

## Benefits of Clean Architecture

### 1. Testability

```dart
// Easy to test use case in isolation
test('GetUsers returns list of users', () async {
  // Mock repository
  final mockRepo = MockUserRepository();
  when(mockRepo.getUsers()).thenAnswer((_) async => [
    User(id: 1, name: 'Alice', email: 'alice@test.com'),
  ]);

  // Test use case
  final useCase = GetUsers(mockRepo);
  final result = await useCase.call();

  expect(result.length, 1);
  expect(result[0].name, 'Alice');
});
```

### 2. Replaceability

```dart
// Switch from API to local database - just swap implementation!
final userRepositoryProvider = Provider((ref) {
  // return UserRepositoryImpl(apiDataSource);  // Old
  return UserLocalRepositoryImpl(localDataSource);  // New
});
```

### 3. Scalability

```dart
// Add new feature independently
features/
├── users/
├── posts/       // New feature!
├── comments/    // Another feature!
└── auth/        // Each independent!
```

### 4. Team Collaboration

- **Backend developer** = Works on Data layer
- **Business analyst** = Works on Domain layer
- **UI designer** = Works on Presentation layer

**No conflicts!**

---

## Key Takeaways

1. **3 Layers** = Presentation, Domain, Data
2. **Domain** = Core business logic (no dependencies)
3. **Presentation** = UI and state management
4. **Data** = API, database, external sources
5. **Dependencies** point inward
6. **Testable** = Each layer isolated
7. **Scalable** = Add features without breaking existing code

---

## What's Next?

Tomorrow: **Implementing Clean Architecture**
- Error handling with Either
- Dependency injection
- Complete real-world app
- Testing strategies

You've learned Clean Architecture principles! 🏗️✨
