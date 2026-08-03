// Example 07: unit tests, mocks, bloc_test, widget tests, and a router test.
//
// This is a TEST file. Copy it into your project's test/ folder and run:
//
//   flutter test test/Example07-Tests.dart
//
// It is self contained (the code under test is at the bottom) so it runs
// without any other file.
//
// pubspec.yaml:
//   dependencies:
//     flutter_bloc: ^9.1.1
//     go_router: ^17.3.0
//   dev_dependencies:
//     bloc_test: ^10.0.0
//     mocktail: ^1.0.5

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // -------------------------------------------------------------------------
  // 1. Plain unit tests: pure logic, no Flutter, no async
  // -------------------------------------------------------------------------

  group('Todo', () {
    test('toggle flips done and keeps everything else', () {
      const todo = Todo(id: '1', title: 'Write tests');

      final toggled = todo.toggle();

      expect(toggled.done, isTrue);
      expect(toggled.id, '1');
      expect(toggled.title, 'Write tests');
      expect(todo.done, isFalse, reason: 'the original must not change');
    });

    test('remaining counts only unfinished items', () {
      const state = TodoLoaded([
        Todo(id: '1', title: 'a', done: true),
        Todo(id: '2', title: 'b'),
        Todo(id: '3', title: 'c'),
      ]);

      expect(state.remaining, 2);
    });
  });

  // -------------------------------------------------------------------------
  // 2. Mocks: stubbing answers and verifying calls
  // -------------------------------------------------------------------------

  group('mocked repository', () {
    late MockTodoRepository repository;

    setUp(() => repository = MockTodoRepository());

    test('returns what the repository provides', () async {
      when(() => repository.fetchTodos())
          .thenAnswer((_) async => const [Todo(id: '1', title: 'from mock')]);

      final todos = await repository.fetchTodos();

      expect(todos, hasLength(1));
      expect(todos.first.title, 'from mock');
      verify(() => repository.fetchTodos()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });

  // -------------------------------------------------------------------------
  // 3. bloc_test: the happy path AND the failure path for every cubit
  // -------------------------------------------------------------------------

  group('TodoCubit', () {
    late MockTodoRepository repository;

    setUp(() => repository = MockTodoRepository());

    blocTest<TodoCubit, TodoState>(
      'emits loading then loaded on success',
      setUp: () {
        when(() => repository.fetchTodos())
            .thenAnswer((_) async => const [Todo(id: '1', title: 'a')]);
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<TodoLoading>(),
        isA<TodoLoaded>().having((s) => s.todos.length, 'todo count', 1),
      ],
    );

    blocTest<TodoCubit, TodoState>(
      'emits loading then failed when the repository throws',
      setUp: () {
        when(() => repository.fetchTodos()).thenThrow(Exception('offline'));
      },
      build: () => TodoCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => [isA<TodoLoading>(), isA<TodoFailed>()],
    );

    blocTest<TodoCubit, TodoState>(
      'seed starts mid flow, so toggle can be tested directly',
      setUp: () {
        when(() => repository.toggle(any())).thenAnswer((_) async {});
      },
      build: () => TodoCubit(repository),
      seed: () => const TodoLoaded([Todo(id: '1', title: 'a')]),
      act: (cubit) => cubit.toggle('1'),
      expect: () => [
        isA<TodoLoaded>().having((s) => s.todos.first.done, 'done', true),
      ],
      verify: (_) => verify(() => repository.toggle('1')).called(1),
    );

    blocTest<TodoCubit, TodoState>(
      'rolls back and reports the error without losing the list',
      setUp: () {
        when(() => repository.toggle(any())).thenThrow(Exception('nope'));
      },
      build: () => TodoCubit(repository),
      seed: () => const TodoLoaded([Todo(id: '1', title: 'a')]),
      act: (cubit) => cubit.toggle('1'),
      expect: () => [
        isA<TodoLoaded>().having((s) => s.todos.first.done, 'optimistic', true),
        // Still TodoLoaded, so the list stays on screen. The failure travels
        // as actionError for the listener to show.
        isA<TodoLoaded>()
            .having((s) => s.todos.first.done, 'rolled back', false)
            .having((s) => s.actionError, 'actionError', isNotNull),
      ],
    );
  });

  // -------------------------------------------------------------------------
  // 4. Widget tests: the screen, with a fake cubit
  // -------------------------------------------------------------------------

  group('TodoPage', () {
    late MockTodoRepository repository;

    setUp(() {
      repository = MockTodoRepository();
      when(() => repository.toggle(any())).thenAnswer((_) async {});
    });

    Widget buildSubject() => MaterialApp(
          home: BlocProvider(
            create: (_) => TodoCubit(repository),
            child: const TodoPage(),
          ),
        );

    testWidgets('shows a spinner then the list', (tester) async {
      // A small delay keeps the loading state on screen long enough to assert.
      // With an instantly completing stub the microtask can finish before the
      // first pump, and you would never see the spinner.
      when(() => repository.fetchTodos()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return const [Todo(id: '1', title: 'Write tests')];
      });

      await tester.pumpWidget(buildSubject());
      // The cubit is created lazily by BlocProvider, so trigger the load.
      tester.element(find.byType(TodoPage)).read<TodoCubit>().load();

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Write tests'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('tapping a checkbox toggles the item', (tester) async {
      when(() => repository.fetchTodos()).thenAnswer(
        (_) async => const [Todo(id: '1', title: 'Write tests')],
      );

      await tester.pumpWidget(buildSubject());
      tester.element(find.byType(TodoPage)).read<TodoCubit>().load();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      verify(() => repository.toggle('1')).called(1);
    });

    testWidgets('shows a retry button when loading fails', (tester) async {
      when(() => repository.fetchTodos()).thenThrow(Exception('offline'));

      await tester.pumpWidget(buildSubject());
      tester.element(find.byType(TodoPage)).read<TodoCubit>().load();
      await tester.pumpAndSettle();

      expect(find.text('Try again'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // 5. Responsive behaviour, tested by faking the screen size
  // -------------------------------------------------------------------------

  group('responsive', () {
    testWidgets('wide screens show the rail, not the bottom bar', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset); // or it leaks into later tests

      await tester.pumpWidget(const MaterialApp(home: AdaptiveShell()));

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('narrow screens show the bottom bar', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const MaterialApp(home: AdaptiveShell()));

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });
  });

  // -------------------------------------------------------------------------
  // 6. Router guards
  // -------------------------------------------------------------------------

  group('router', () {
    testWidgets('a signed out user is redirected to login', (tester) async {
      final auth = AuthNotifier();

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: buildRouter(auth)),
      );
      await tester.pumpAndSettle();

      expect(find.text('login'), findsOneWidget);
    });

    testWidgets('signing in moves the user to the profile', (tester) async {
      final auth = AuthNotifier();

      await tester.pumpWidget(
        MaterialApp.router(routerConfig: buildRouter(auth)),
      );
      await tester.pumpAndSettle();

      auth.setSignedIn(true); // refreshListenable re-runs the redirect
      await tester.pumpAndSettle();

      expect(find.text('profile'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // 7. Platform channels, faked
  // -------------------------------------------------------------------------

  group('BatteryService', () {
    const channel = MethodChannel('com.example.myapp/battery');

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });

    test('returns the level the platform reports', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        return call.method == 'getBatteryLevel' ? 42 : null;
      });

      expect(await BatteryService().getBatteryLevel(), 42);
    });

    test('returns null when the platform reports an error', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'UNAVAILABLE');
      });

      expect(await BatteryService().getBatteryLevel(), isNull);
    });
  });
}

// ===========================================================================
// The code under test. In a real project this lives in lib/.
// ===========================================================================

class Todo {
  const Todo({required this.id, required this.title, this.done = false});

  final String id;
  final String title;
  final bool done;

  Todo toggle() => Todo(id: id, title: title, done: !done);
}

class TodoRepository {
  Future<List<Todo>> fetchTodos() async => const [];
  Future<void> toggle(String id) async {}
}

sealed class TodoState {
  const TodoState();
}

final class TodoInitial extends TodoState {
  const TodoInitial();
}

final class TodoLoading extends TodoState {
  const TodoLoading();
}

final class TodoLoaded extends TodoState {
  const TodoLoaded(this.todos, {this.actionError});

  final List<Todo> todos;

  /// One action failed while the list itself is fine. The listener shows it,
  /// the builder ignores it, so a failed checkbox does not wipe the screen.
  final String? actionError;

  int get remaining => todos.where((t) => !t.done).length;
}

final class TodoFailed extends TodoState {
  const TodoFailed(this.message);

  final String message;
}

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repository) : super(const TodoInitial());

  final TodoRepository _repository;

  Future<void> load() async {
    emit(const TodoLoading());
    try {
      final todos = await _repository.fetchTodos();
      if (isClosed) return;
      emit(TodoLoaded(todos));
    } catch (_) {
      if (isClosed) return;
      emit(const TodoFailed('Could not load your list.'));
    }
  }

  Future<void> toggle(String id) async {
    final current = state;
    if (current is! TodoLoaded) return;

    emit(TodoLoaded([
      for (final todo in current.todos)
        if (todo.id == id) todo.toggle() else todo,
    ]));

    try {
      await _repository.toggle(id);
    } catch (_) {
      if (isClosed) return;
      emit(TodoLoaded(current.todos, actionError: 'That change did not save.'));
    }
  }
}

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) => switch (state) {
          TodoInitial() => const SizedBox.shrink(),
          TodoLoading() => const Center(child: CircularProgressIndicator()),
          TodoFailed() => Center(
              child: FilledButton(
                onPressed: () => context.read<TodoCubit>().load(),
                child: const Text('Try again'),
              ),
            ),
          TodoLoaded(:final todos) => ListView(
              children: [
                for (final todo in todos)
                  CheckboxListTile(
                    key: ValueKey(todo.id),
                    value: todo.done,
                    title: Text(todo.title),
                    onChanged: (_) => context.read<TodoCubit>().toggle(todo.id),
                  ),
              ],
            ),
        },
      ),
    );
  }
}

class AdaptiveShell extends StatelessWidget {
  const AdaptiveShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 600;

    if (!isWide) {
      return Scaffold(
        body: const Center(child: Text('content')),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 0,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(
                  icon: Icon(Icons.person), label: Text('Me')),
            ],
          ),
          const Expanded(child: Center(child: Text('content'))),
        ],
      ),
    );
  }
}

class AuthNotifier extends ChangeNotifier {
  bool signedIn = false;

  void setSignedIn(bool value) {
    signedIn = value;
    notifyListeners();
  }
}

GoRouter buildRouter(AuthNotifier auth) => GoRouter(
      initialLocation: '/profile',
      refreshListenable: auth,
      redirect: (context, state) {
        final goingToLogin = state.matchedLocation == '/login';
        if (!auth.signedIn && !goingToLogin) return '/login';
        if (auth.signedIn && goingToLogin) return '/profile';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const Scaffold(body: Text('login')),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Scaffold(body: Text('profile')),
        ),
      ],
    );

class BatteryService {
  static const MethodChannel _channel =
      MethodChannel('com.example.myapp/battery');

  Future<int?> getBatteryLevel() async {
    try {
      return await _channel.invokeMethod<int>('getBatteryLevel');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
