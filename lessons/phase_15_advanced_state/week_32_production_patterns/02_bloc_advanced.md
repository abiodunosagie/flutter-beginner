# BLoC Advanced Patterns

## Understanding BLoC: A 5-Year-Old's Guide

Imagine you have a toy mailbox game:
- You write **letters** (events) asking for toys
- You put the letter in the **mailbox** (BLoC)
- A helper inside the mailbox **reads your letter** (event handler)
- The helper **gets your toy** from the toy room (repository/API)
- The helper puts the toy in the **display window** (state)
- You see your toy appear! (UI updates)

**The cool part?** You never go to the toy room yourself. You just write letters, and toys appear in the window. The mailbox helper does ALL the work!

That's BLoC: You send events, BLoC handles everything, and new states appear in your app.

## Table of Contents
1. [Event Transformers & Concurrency](#event-transformers--concurrency)
2. [BLoC to BLoC Communication](#bloc-to-bloc-communication)
3. [Advanced Error Handling](#advanced-error-handling)
4. [Testing BLoCs](#testing-blocs)
5. [Production Patterns](#production-patterns)
6. [Performance Optimization](#performance-optimization)
7. [Debugging Strategies](#debugging-strategies)
8. [Complete Multi-BLoC App](#complete-multi-bloc-app)

## Event Transformers & Concurrency

### What Are Event Transformers?

Event transformers control **HOW** events are processed. Think of them as traffic controllers for your events.

### Example 1: Debouncing Search Events

**Problem:** User types "flutter" - that's 7 events! We don't want to search 7 times.

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

// Events
abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchCleared extends SearchEvent {}

// States
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final String query;
  SearchLoading(this.query);
}

class SearchLoaded extends SearchState {
  final String query;
  final List<SearchResult> results;
  SearchLoaded(this.query, this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// BLoC with Debouncing
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    // Debounce: Wait 300ms after user stops typing
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: (events, mapper) {
        return events
            .debounce(const Duration(milliseconds: 300))
            .switchMap(mapper);
      },
    );

    on<SearchCleared>(_onSearchCleared);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading(event.query));

    try {
      final results = await repository.search(event.query);
      emit(SearchLoaded(event.query, results));
    } catch (e) {
      emit(SearchError('Search failed: ${e.toString()}'));
    }
  }

  void _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }
}
```

**Key Points:**
- `debounce(300ms)`: Waits 300ms after the last event
- `switchMap`: Cancels previous searches when a new one starts
- This prevents 7 API calls for "flutter" - only 1 final call!

### Example 2: Throttling Button Taps

**Problem:** User mashes the "Like" button 10 times. We only want one like!

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';

// Events
abstract class LikeEvent {}

class PostLiked extends LikeEvent {
  final String postId;
  PostLiked(this.postId);
}

// States
class LikeState {
  final Set<String> likedPosts;
  final bool isProcessing;

  LikeState({
    this.likedPosts = const {},
    this.isProcessing = false,
  });

  LikeState copyWith({Set<String>? likedPosts, bool? isProcessing}) {
    return LikeState(
      likedPosts: likedPosts ?? this.likedPosts,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

// BLoC with Throttling
class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository repository;

  LikeBloc(this.repository) : super(LikeState()) {
    // Process only ONE event per second
    on<PostLiked>(
      _onPostLiked,
      transformer: throttleDroppable(const Duration(seconds: 1)),
    );
  }

  Future<void> _onPostLiked(
    PostLiked event,
    Emitter<LikeState> emit,
  ) async {
    emit(state.copyWith(isProcessing: true));

    try {
      await repository.likePost(event.postId);
      final newLikedPosts = Set<String>.from(state.likedPosts)
        ..add(event.postId);

      emit(state.copyWith(
        likedPosts: newLikedPosts,
        isProcessing: false,
      ));
    } catch (e) {
      emit(state.copyWith(isProcessing: false));
    }
  }
}
```

### Example 3: Sequential vs Concurrent Processing

```dart
// Events
abstract class DataEvent {}

class FetchData extends DataEvent {
  final String id;
  FetchData(this.id);
}

// SEQUENTIAL: Process events one at a time (wait for each to finish)
class SequentialBloc extends Bloc<DataEvent, DataState> {
  SequentialBloc(repository) : super(DataInitial()) {
    on<FetchData>(
      _onFetchData,
      transformer: sequential(), // From bloc_concurrency
    );
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    // If event(1) takes 5 seconds, event(2) waits 5 seconds to start
    final data = await repository.fetch(event.id);
    emit(DataLoaded(data));
  }
}

// CONCURRENT: Process all events simultaneously
class ConcurrentBloc extends Bloc<DataEvent, DataState> {
  ConcurrentBloc(repository) : super(DataInitial()) {
    on<FetchData>(
      _onFetchData,
      transformer: concurrent(), // From bloc_concurrency
    );
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    // All events run at the same time!
    final data = await repository.fetch(event.id);
    emit(DataLoaded(data));
  }
}

// RESTART: Cancel previous, start new
class RestartableBloc extends Bloc<DataEvent, DataState> {
  RestartableBloc(repository) : super(DataInitial()) {
    on<FetchData>(
      _onFetchData,
      transformer: restartable(), // From bloc_concurrency
    );
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    // If new event arrives, cancel the current operation and start fresh
    final data = await repository.fetch(event.id);
    emit(DataLoaded(data));
  }
}
```

## BLoC to BLoC Communication

### Pattern 1: Listen to Another BLoC

```dart
import 'dart:async';

// User BLoC manages authentication
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserLoggedOut()) {
    on<UserLoggedIn>(_onUserLoggedIn);
    on<UserLoggedOut>(_onUserLoggedOut);
  }

  void _onUserLoggedIn(UserLoggedIn event, Emitter<UserState> emit) {
    emit(UserAuthenticated(event.user));
  }

  void _onUserLoggedOut(UserLoggedOut event, Emitter<UserState> emit) {
    emit(UserLoggedOut());
  }
}

// Cart BLoC listens to UserBloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final UserBloc userBloc;
  late StreamSubscription<UserState> _userSubscription;

  CartBloc({required this.userBloc}) : super(CartEmpty()) {
    // Listen to user state changes
    _userSubscription = userBloc.stream.listen((userState) {
      if (userState is UserLoggedOut) {
        add(ClearCart()); // Clear cart when user logs out
      } else if (userState is UserAuthenticated) {
        add(LoadCart(userState.user.id)); // Load cart for logged-in user
      }
    });

    on<LoadCart>(_onLoadCart);
    on<ClearCart>(_onClearCart);
    on<AddToCart>(_onAddToCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await repository.getCartItems(event.userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartEmpty());
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is! CartLoaded) return;

    // Optimistic update
    final updatedItems = [...currentState.items, event.item];
    emit(CartLoaded(updatedItems));

    try {
      await repository.addItem(event.item);
    } catch (e) {
      // Revert on error
      emit(CartLoaded(currentState.items));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel(); // CRITICAL: Cancel subscription!
    return super.close();
  }
}
```

### Pattern 2: BLoC as Dependency

```dart
// Order BLoC depends on Cart BLoC's current state
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CartBloc cartBloc;
  final OrderRepository repository;

  OrderBloc({
    required this.cartBloc,
    required this.repository,
  }) : super(OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<OrderState> emit,
  ) async {
    // Read current cart state
    final cartState = cartBloc.state;

    if (cartState is! CartLoaded || cartState.items.isEmpty) {
      emit(OrderError('Cart is empty'));
      return;
    }

    emit(OrderProcessing());

    try {
      final order = await repository.createOrder(
        items: cartState.items,
        shippingAddress: event.address,
      );

      emit(OrderSuccess(order));

      // Clear cart after successful order
      cartBloc.add(ClearCart());
    } catch (e) {
      emit(OrderError('Failed to place order: ${e.toString()}'));
    }
  }
}
```

## Advanced Error Handling

### Example 4: Comprehensive Error Handling

```dart
// Custom Error Types
abstract class AppError {
  final String message;
  final String? details;
  final DateTime timestamp;

  AppError(this.message, {this.details})
    : timestamp = DateTime.now();
}

class NetworkError extends AppError {
  NetworkError(String message, {String? details})
    : super(message, details: details);
}

class ValidationError extends AppError {
  final Map<String, String> fieldErrors;

  ValidationError(String message, this.fieldErrors)
    : super(message);
}

class AuthError extends AppError {
  AuthError(String message, {String? details})
    : super(message, details: details);
}

// States with Error Details
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final bool isRefreshing;
  ProductLoading({this.isRefreshing = false});
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final DateTime lastUpdated;

  ProductLoaded(this.products) : lastUpdated = DateTime.now();
}

class ProductError extends ProductState {
  final AppError error;
  final ProductState? previousState; // Keep previous state!

  ProductError(this.error, {this.previousState});

  bool get canRetry => previousState != null;
}

// BLoC with Advanced Error Handling
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  final ErrorReporter errorReporter; // For logging errors

  ProductBloc({
    required this.repository,
    required this.errorReporter,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<RetryLastAction>(_onRetryLastAction);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    await _loadProductsWithErrorHandling(emit, state);
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading(isRefreshing: true));

    await _loadProductsWithErrorHandling(emit, state);
  }

  Future<void> _onRetryLastAction(
    RetryLastAction event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductError && currentState.canRetry) {
      emit(ProductLoading());
      await _loadProductsWithErrorHandling(emit, currentState.previousState);
    }
  }

  Future<void> _loadProductsWithErrorHandling(
    Emitter<ProductState> emit,
    ProductState? previousState,
  ) async {
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products));
    } on NetworkException catch (e) {
      final error = NetworkError(
        'Network connection failed',
        details: e.toString(),
      );
      errorReporter.log(error);
      emit(ProductError(error, previousState: previousState));
    } on AuthException catch (e) {
      final error = AuthError(
        'Authentication required',
        details: e.toString(),
      );
      errorReporter.log(error);
      emit(ProductError(error, previousState: previousState));
    } catch (e, stackTrace) {
      final error = AppError(
        'Unexpected error occurred',
        details: e.toString(),
      );
      errorReporter.logWithStackTrace(error, stackTrace);
      emit(ProductError(error, previousState: previousState));
    }
  }
}
```

## Testing BLoCs

### Example 5: Comprehensive BLoC Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  group('TodoBloc', () {
    late TodoRepository repository;
    late TodoBloc bloc;

    setUp(() {
      repository = MockTodoRepository();
      bloc = TodoBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is TodoInitial', () {
      expect(bloc.state, isA<TodoInitial>());
    });

    group('LoadTodos', () {
      final mockTodos = [
        Todo(id: '1', title: 'Test 1'),
        Todo(id: '2', title: 'Test 2'),
      ];

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoLoaded] when successful',
        build: () {
          when(() => repository.getTodos())
              .thenAnswer((_) async => mockTodos);
          return bloc;
        },
        act: (bloc) => bloc.add(LoadTodos()),
        expect: () => [
          isA<TodoLoading>(),
          isA<TodoLoaded>()
              .having((state) => state.todos, 'todos', mockTodos),
        ],
        verify: (_) {
          verify(() => repository.getTodos()).called(1);
        },
      );

      blocTest<TodoBloc, TodoState>(
        'emits [TodoLoading, TodoError] when fails',
        build: () {
          when(() => repository.getTodos())
              .thenThrow(Exception('Network error'));
          return bloc;
        },
        act: (bloc) => bloc.add(LoadTodos()),
        expect: () => [
          isA<TodoLoading>(),
          isA<TodoError>()
              .having(
                (state) => state.message,
                'message',
                contains('Network error'),
              ),
        ],
      );
    });

    group('AddTodo', () {
      final existingTodos = [
        Todo(id: '1', title: 'Existing'),
      ];
      final newTodo = Todo(id: '2', title: 'New Todo');

      blocTest<TodoBloc, TodoState>(
        'adds todo optimistically and keeps it on success',
        build: () {
          when(() => repository.addTodo(any()))
              .thenAnswer((_) async => Future.value());
          return bloc;
        },
        seed: () => TodoLoaded(existingTodos),
        act: (bloc) => bloc.add(AddTodo('New Todo')),
        expect: () => [
          isA<TodoLoaded>()
              .having((state) => state.todos.length, 'length', 2),
        ],
      );

      blocTest<TodoBloc, TodoState>(
        'reverts optimistic update on error',
        build: () {
          when(() => repository.addTodo(any()))
              .thenThrow(Exception('Failed'));
          return bloc;
        },
        seed: () => TodoLoaded(existingTodos),
        act: (bloc) => bloc.add(AddTodo('New Todo')),
        expect: () => [
          isA<TodoLoaded>()
              .having((state) => state.todos.length, 'length', 2),
          isA<TodoLoaded>()
              .having((state) => state.todos.length, 'length', 1),
        ],
      );
    });
  });
}
```

## Production Patterns

### Example 6: State with Equatable for Efficient Rebuilds

```dart
import 'package:equatable/equatable.dart';

// Use Equatable to prevent unnecessary rebuilds
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final List<Post> posts;
  final int followerCount;

  UserLoaded({
    required this.user,
    required this.posts,
    required this.followerCount,
  });

  @override
  List<Object?> get props => [user, posts, followerCount];

  // Only rebuild if these values actually change!
  UserLoaded copyWith({
    User? user,
    List<Post>? posts,
    int? followerCount,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      followerCount: followerCount ?? this.followerCount,
    );
  }
}
```

### Example 7: BLoC with Dependency Injection

```dart
// Service Locator (using get_it)
final getIt = GetIt.instance;

void setupDependencies() {
  // Repositories (Singletons)
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt()),
  );

  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt()),
  );

  // BLoCs (Factories - new instance each time)
  getIt.registerFactory<UserBloc>(
    () => UserBloc(repository: getIt()),
  );

  getIt.registerFactory<PostBloc>(
    () => PostBloc(
      repository: getIt(),
      userBloc: getIt(),
    ),
  );
}

// Usage in app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => getIt<UserBloc>()..add(LoadUser()),
        ),
        BlocProvider<PostBloc>(
          create: (_) => getIt<PostBloc>(),
        ),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

## Performance Optimization

### Tip 1: Use buildWhen to Prevent Unnecessary Rebuilds

```dart
BlocBuilder<TodoBloc, TodoState>(
  // Only rebuild when todos list actually changes
  buildWhen: (previous, current) {
    if (previous is TodoLoaded && current is TodoLoaded) {
      return previous.todos != current.todos;
    }
    return true;
  },
  builder: (context, state) {
    if (state is TodoLoaded) {
      return TodoList(todos: state.todos);
    }
    return LoadingIndicator();
  },
)
```

### Tip 2: Use BlocSelector for Specific Properties

```dart
// Instead of rebuilding entire widget when ANY user data changes,
// only rebuild when username changes
BlocSelector<UserBloc, UserState, String>(
  selector: (state) {
    if (state is UserLoaded) return state.user.username;
    return 'Guest';
  },
  builder: (context, username) {
    return Text('Hello, $username!');
  },
)
```

### Tip 3: Dispose Resources Properly

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  final StreamController _controller = StreamController();
  late StreamSubscription _subscription;

  MyBloc() : super(MyInitial()) {
    _subscription = _controller.stream.listen(_handleData);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _controller.close();
    return super.close();
  }
}
```

## Debugging Strategies

### Strategy 1: BLoC Observer

```dart
class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('✅ CREATED: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('📥 EVENT: ${bloc.runtimeType} - $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('🔄 TRANSITION: ${bloc.runtimeType}');
    print('   Current: ${transition.currentState}');
    print('   Event: ${transition.event}');
    print('   Next: ${transition.nextState}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print('❌ ERROR: ${bloc.runtimeType} - $error');
    print('   Stack: $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('🔚 CLOSED: ${bloc.runtimeType}');
  }
}

// In main.dart
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
```

### Strategy 2: Add Debug Methods to BLoCs

```dart
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  // ... regular code ...

  // Debug helper
  void printDebugInfo() {
    print('=== TodoBloc Debug Info ===');
    print('Current State: $state');
    print('Is Closed: $isClosed');

    if (state is TodoLoaded) {
      final loaded = state as TodoLoaded;
      print('Todo Count: ${loaded.todos.length}');
      print('Todos: ${loaded.todos.map((t) => t.title).join(', ')}');
    }
  }
}

// Usage
context.read<TodoBloc>().printDebugInfo();
```

## Complete Multi-BLoC App

### Example 8: E-Commerce App with Multiple BLoCs

```dart
// ========================================
// AUTH BLOC
// ========================================

abstract class AuthEvent {}
class AuthCheckRequested extends AuthEvent {}
class AuthLoggedIn extends AuthEvent {
  final String email, password;
  AuthLoggedIn(this.email, this.password);
}
class AuthLoggedOut extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoggedIn(
    AuthLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoggedOut(
    AuthLoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}

// ========================================
// PRODUCT CATALOG BLOC
// ========================================

abstract class CatalogEvent {}
class CatalogLoaded extends CatalogEvent {}
class CatalogFilterChanged extends CatalogEvent {
  final String category;
  CatalogFilterChanged(this.category);
}

class CatalogState {
  final List<Product> products;
  final String? selectedCategory;
  final bool isLoading;

  CatalogState({
    this.products = const [],
    this.selectedCategory,
    this.isLoading = false,
  });

  List<Product> get filteredProducts {
    if (selectedCategory == null) return products;
    return products.where((p) => p.category == selectedCategory).toList();
  }

  CatalogState copyWith({
    List<Product>? products,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return CatalogState(
      products: products ?? this.products,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ProductRepository repository;

  CatalogBloc({required this.repository}) : super(CatalogState()) {
    on<CatalogLoaded>(_onCatalogLoaded);
    on<CatalogFilterChanged>(_onCatalogFilterChanged);
  }

  Future<void> _onCatalogLoaded(
    CatalogLoaded event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final products = await repository.getProducts();
      emit(state.copyWith(products: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onCatalogFilterChanged(
    CatalogFilterChanged event,
    Emitter<CatalogState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }
}

// ========================================
// SHOPPING CART BLOC
// ========================================

abstract class CartEvent {}
class CartItemAdded extends CartEvent {
  final Product product;
  CartItemAdded(this.product);
}
class CartItemRemoved extends CartEvent {
  final String productId;
  CartItemRemoved(this.productId);
}
class CartCleared extends CartEvent {}

class CartState {
  final Map<String, CartItem> items;

  CartState({this.items = const {}});

  int get totalItems => items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => items.values.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );

  CartState copyWith({Map<String, CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final AuthBloc authBloc;
  late StreamSubscription _authSubscription;

  CartBloc({required this.authBloc}) : super(CartState()) {
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthUnauthenticated) {
        add(CartCleared());
      }
    });

    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartCleared>(_onCartCleared);
  }

  void _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final items = Map<String, CartItem>.from(state.items);
    final productId = event.product.id;

    if (items.containsKey(productId)) {
      items[productId] = items[productId]!.copyWith(
        quantity: items[productId]!.quantity + 1,
      );
    } else {
      items[productId] = CartItem(product: event.product);
    }

    emit(state.copyWith(items: items));
  }

  void _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final items = Map<String, CartItem>.from(state.items);
    items.remove(event.productId);
    emit(state.copyWith(items: items));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(CartState());
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}

// ========================================
// APP WIDGET
// ========================================

class ShoppingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(repository: getIt())
            ..add(AuthCheckRequested()),
        ),
        BlocProvider<CatalogBloc>(
          create: (context) => CatalogBloc(repository: getIt())
            ..add(CatalogLoaded()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(
            authBloc: context.read<AuthBloc>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return HomeScreen();
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          // Cart Icon with Badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              return Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartScreen()),
                      );
                    },
                  ),
                  if (cartState.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartState.totalItems}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, catalogState) {
          if (catalogState.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: catalogState.filteredProducts.length,
            itemBuilder: (context, index) {
              final product = catalogState.filteredProducts[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(child: Image.network(product.imageUrl)),
          Text(product.name),
          Text('\$${product.price}'),
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(CartItemAdded(product));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added to cart!')),
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
```

## Key Takeaways

1. **Event Transformers**: Control how events are processed (debounce, throttle, sequential)
2. **BLoC Communication**: Use streams and subscriptions, always cancel them!
3. **Error Handling**: Keep previous state, allow retries, log errors properly
4. **Testing**: Use bloc_test for comprehensive testing
5. **Performance**: Use buildWhen, BlocSelector, and Equatable
6. **Debugging**: Implement BlocObserver for visibility
7. **Production**: Use dependency injection, proper state management, and clean architecture

Master these patterns and your Flutter apps will be rock-solid!
