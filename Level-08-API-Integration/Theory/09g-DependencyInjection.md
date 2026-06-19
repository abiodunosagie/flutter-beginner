# Dependency Injection: A Step-by-Step Guide

This guide explains Dependency Injection (DI) from scratch - no assumptions, no jumping ahead.

---

## The Problem (Why DI Exists)

Let's start with code that DOESN'T use DI, and see the problems:

```dart
// WITHOUT Dependency Injection
class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create everything right here
    final apiClient = ApiClient(baseUrl: 'https://api.example.com');
    final repository = UserRepositoryImpl(apiClient: apiClient);
    final controller = UsersController(repository: repository);

    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) => Text(controller.users[index].name),
    );
  }
}
```

**What's wrong with this?**

```
PROBLEM 1: HARDCODED
Every screen creates its own ApiClient, Repository, Controller.
If you want to change the API URL, you change it in 50 places!

PROBLEM 2: CAN'T TEST
How do you test this screen without calling the real API?
You can't! It creates the real ApiClient inside.

PROBLEM 3: DUPLICATE INSTANCES
Each screen creates NEW instances.
Screen A has its own UsersController.
Screen B has its own UsersController.
They don't share data!

PROBLEM 4: TIGHT COUPLING
The screen KNOWS exactly how to create everything.
If UserRepositoryImpl changes its constructor, every screen breaks.
```

---

## What is Dependency Injection?

**Dependency** = Something a class needs to work.
**Injection** = Giving it from the outside instead of creating inside.

```dart
// WITHOUT Injection (creates its own dependency)
class UsersScreen {
  void load() {
    final repository = UserRepositoryImpl(...);  // Creates inside
    repository.getUsers();
  }
}

// WITH Injection (receives dependency from outside)
class UsersScreen {
  final UserRepository repository;  // Receives from outside

  UsersScreen({required this.repository});  // Injected through constructor

  void load() {
    repository.getUsers();  // Uses what was given
  }
}
```

**That's it!** DI just means: don't create dependencies inside, receive them from outside.

---

## Step 1: Identify Dependencies

Look at what your class NEEDS to work:

```dart
class UsersController {
  // This controller NEEDS a repository to get users
  // Repository is a DEPENDENCY

  Future<void> loadUsers() async {
    // How do I get users? I need a repository!
    final users = await ???.getUsers();  // Need something here!
  }
}
```

The `UserRepository` is a **dependency** of `UsersController`.

---

## Step 2: Accept Dependencies Through Constructor

Instead of creating the dependency inside, accept it as a parameter:

```dart
class UsersController {
  final UserRepository repository;  // Declare the dependency

  // Accept it through the constructor
  UsersController({required this.repository});

  Future<void> loadUsers() async {
    // Now I can use it!
    final users = await repository.getUsers();
  }
}
```

Now whoever creates `UsersController` must give it a repository:

```dart
// Someone else provides the repository
final controller = UsersController(
  repository: myRepository,  // Injected!
);
```

---

## Step 3: Chain the Dependencies

Each class gets its dependencies injected:

```dart
// ApiClient has no dependencies
class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});
}

// Repository DEPENDS ON ApiClient
class UserRepositoryImpl {
  final ApiClient apiClient;  // Dependency

  UserRepositoryImpl({required this.apiClient});  // Injected
}

// Controller DEPENDS ON Repository
class UsersController {
  final UserRepository repository;  // Dependency

  UsersController({required this.repository});  // Injected
}
```

---

## Step 4: Create a Central Place to Wire Everything

Now someone needs to actually CREATE all these objects and connect them.
This is often called a "Service Locator" or "DI Container":

```dart
// injection.dart - The central place that creates and wires everything

class ServiceLocator {
  // Private constructor (singleton pattern)
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Store instances so we don't create duplicates
  ApiClient? _apiClient;
  UserRepository? _userRepository;
  UsersController? _usersController;

  // GETTER for ApiClient
  ApiClient get apiClient {
    // Create only if doesn't exist yet
    _apiClient ??= ApiClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
    );
    return _apiClient!;
  }

  // GETTER for UserRepository
  UserRepository get userRepository {
    _userRepository ??= UserRepositoryImpl(
      apiClient: apiClient,  // <-- INJECT ApiClient!
    );
    return _userRepository!;
  }

  // GETTER for UsersController
  UsersController get usersController {
    _usersController ??= UsersController(
      repository: userRepository,  // <-- INJECT Repository!
    );
    return _usersController!;
  }
}

// Create a global instance for easy access
final sl = ServiceLocator();  // sl = "service locator"
```

**What this does:**
1. Creates objects ONCE (not every time you ask)
2. Connects them together (injects dependencies)
3. Provides easy access from anywhere in your app

---

## Step 5: Use It In Your App

Now your screens just ASK for what they need:

```dart
class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Just ask the service locator!
  final controller = sl.usersController;

  @override
  void initState() {
    super.initState();
    controller.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    // Use the controller
    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        return Text(controller.users[index].name);
      },
    );
  }
}
```

**Benefits:**
- Screen doesn't know HOW to create a controller
- Screen doesn't know about ApiClient or Repository
- All wiring happens in ONE place (ServiceLocator)
- Same controller instance is shared across screens

---

## Why Do We Use Abstract Classes?

Now let's talk about those abstract classes that confused you.

**First, without abstract class:**

```dart
class UsersController {
  final UserRepositoryImpl repository;  // Concrete class

  UsersController({required this.repository});
}
```

This works, BUT you can only use `UserRepositoryImpl`. What if you want to test with fake data?

**With abstract class:**

```dart
// Abstract class = "contract" or "interface"
// Says WHAT methods exist, not HOW they work
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUser(int id);
}

// Real implementation
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  @override
  Future<List<User>> getUsers() async {
    // Actually calls the API
    final response = await apiClient.get('/users');
    return (response as List).map((j) => User.fromJson(j)).toList();
  }

  @override
  Future<User> getUser(int id) async {
    final response = await apiClient.get('/users/$id');
    return User.fromJson(response);
  }
}

// Fake implementation for tests
class MockUserRepository implements UserRepository {
  @override
  Future<List<User>> getUsers() async {
    // Returns fake data - no API call!
    return [
      User(id: 1, name: 'Test User', email: 'test@test.com'),
    ];
  }

  @override
  Future<User> getUser(int id) async {
    return User(id: id, name: 'Test User', email: 'test@test.com');
  }
}
```

**Now the controller uses the ABSTRACT class:**

```dart
class UsersController {
  final UserRepository repository;  // Abstract! Could be real OR mock

  UsersController({required this.repository});

  Future<void> loadUsers() async {
    // Works with UserRepositoryImpl OR MockUserRepository
    final users = await repository.getUsers();
  }
}
```

**In production:**
```dart
final controller = UsersController(
  repository: UserRepositoryImpl(apiClient: apiClient),  // Real
);
```

**In tests:**
```dart
final controller = UsersController(
  repository: MockUserRepository(),  // Fake - no API calls!
);
```

---

## Visual: How Abstract Classes Enable Swapping

```
                    UserRepository
                   (abstract class)
                   ┌─────────────┐
                   │ getUsers()  │
                   │ getUser()   │
                   └─────────────┘
                         ▲
                         │
          ┌──────────────┴──────────────┐
          │                             │
          ▼                             ▼
  UserRepositoryImpl            MockUserRepository
  ┌─────────────────┐          ┌─────────────────┐
  │ Calls real API  │          │ Returns fake    │
  │ Uses ApiClient  │          │ data instantly  │
  └─────────────────┘          └─────────────────┘

UsersController only knows about UserRepository (the abstract one).
It doesn't care if it gets UserRepositoryImpl or MockUserRepository.
They both have getUsers() and getUser(), so they both work!
```

---

## When to Introduce Abstract Classes

**DON'T** start with abstract classes on day one. It's overengineering.

**DO** introduce them when:
1. You want to test without calling real APIs
2. You have multiple data sources (API + local database)
3. You're building a larger app (10+ screens)

**For small apps:** Just use concrete classes. You can refactor later.

```dart
// SIMPLE VERSION (fine for small apps)
class UsersController {
  final UserRepositoryImpl repository;  // Concrete, not abstract
  UsersController({required this.repository});
}

// ADVANCED VERSION (needed for testing/flexibility)
class UsersController {
  final UserRepository repository;  // Abstract
  UsersController({required this.repository});
}
```

---

## Complete Example

Here's everything wired together:

```dart
// 1. MODEL
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// 2. API CLIENT
class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed');
  }
}

// 3. REPOSITORY (Abstract)
abstract class UserRepository {
  Future<List<User>> getUsers();
}

// 4. REPOSITORY (Implementation)
class UserRepositoryImpl implements UserRepository {
  final ApiClient apiClient;

  UserRepositoryImpl({required this.apiClient});  // DI!

  @override
  Future<List<User>> getUsers() async {
    final response = await apiClient.get('/users');
    return (response as List).map((j) => User.fromJson(j)).toList();
  }
}

// 5. CONTROLLER
class UsersController extends ChangeNotifier {
  final UserRepository repository;

  UsersController({required this.repository});  // DI!

  List<User> users = [];
  bool isLoading = false;

  Future<void> loadUsers() async {
    isLoading = true;
    notifyListeners();

    users = await repository.getUsers();

    isLoading = false;
    notifyListeners();
  }
}

// 6. SERVICE LOCATOR (Wires everything)
class ServiceLocator {
  static final instance = ServiceLocator._();
  ServiceLocator._();

  ApiClient? _apiClient;
  UserRepository? _userRepository;
  UsersController? _usersController;

  ApiClient get apiClient {
    return _apiClient ??= ApiClient(baseUrl: 'https://api.example.com');
  }

  UserRepository get userRepository {
    return _userRepository ??= UserRepositoryImpl(apiClient: apiClient);
  }

  UsersController get usersController {
    return _usersController ??= UsersController(repository: userRepository);
  }
}

final sl = ServiceLocator.instance;

// 7. SCREEN (Uses everything)
class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final controller = sl.usersController;  // Get from DI!

  @override
  void initState() {
    super.initState();
    controller.addListener(() => setState(() {}));
    controller.loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}
```

---

## Summary

```
DEPENDENCY INJECTION IN 5 STEPS:
────────────────────────────────

1. IDENTIFY what your class needs (dependencies)

2. ACCEPT dependencies through constructor
   Instead of: final repo = UserRepositoryImpl()
   Do this:    final UserRepository repo;
               MyClass({required this.repo});

3. CREATE a ServiceLocator to wire everything

4. USE abstract classes if you need to swap implementations
   (for testing or multiple data sources)

5. ACCESS dependencies through the ServiceLocator
   final controller = sl.usersController;


WHY BOTHER?
───────────

Without DI:
- Hard to test (can't use fake data)
- Hard to change (URL in 50 places)
- Duplicate instances (each screen creates new ones)

With DI:
- Easy to test (inject mock)
- Easy to change (one place)
- Shared instances (same controller everywhere)


ABSTRACT CLASSES:
─────────────────

abstract class = "contract" that says what methods exist
implements = "I promise to provide these methods"

Use abstract classes when you need to swap implementations:
- Real implementation for production
- Mock implementation for tests
- Local implementation for offline mode
```

---

## Navigation

Previous: [Folder Structure Guide](09d-FolderStructureGuide.md)
Back to: [Learning Path](00-LearningPath.md)
