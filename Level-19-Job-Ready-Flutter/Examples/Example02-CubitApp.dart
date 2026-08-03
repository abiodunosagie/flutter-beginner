// Example 02: A complete Cubit feature.
//
// Shows: sealed state classes, a repository dependency, BlocProvider,
// BlocBuilder with an exhaustive switch, BlocSelector, BlocListener,
// read vs watch, and safe async emits.
//
// pubspec.yaml:
//   dependencies:
//     flutter_bloc: ^9.1.1

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const CubitApp());

// ---------------------------------------------------------------------------
// Model + repository (the data layer the cubit talks to)
// ---------------------------------------------------------------------------

class Todo {
  const Todo({required this.id, required this.title, this.done = false});

  final String id;
  final String title;
  final bool done;

  Todo toggle() => Todo(id: id, title: title, done: !done);
}

class TodoRepository {
  final _store = <Todo>[
    const Todo(id: '1', title: 'Read the composition lesson'),
    const Todo(id: '2', title: 'Write a cubit'),
    const Todo(id: '3', title: 'Test it with bloc_test'),
  ];

  Future<List<Todo>> fetchTodos() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_store);
  }

  Future<void> toggle(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _store.indexWhere((t) => t.id == id);
    if (index == -1) throw StateError('No todo with id $id');
    _store[index] = _store[index].toggle();
  }
}

// ---------------------------------------------------------------------------
// State: one class per situation, so impossible states cannot be written.
// ---------------------------------------------------------------------------

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

  /// A single action failed (a toggle that did not save) while the list is
  /// still perfectly good. The listener shows it; the builder ignores it.
  /// Keeping this here instead of emitting TodoFailed is what stops one
  /// failed checkbox from wiping the whole list off the screen.
  final String? actionError;

  int get remaining => todos.where((t) => !t.done).length;
}

/// The LIST could not be loaded at all, so there is nothing to show.
final class TodoFailed extends TodoState {
  const TodoFailed(this.message);

  final String message;
}

// ---------------------------------------------------------------------------
// Cubit: plain methods that emit new states. No BuildContext, no widgets.
// ---------------------------------------------------------------------------

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repository) : super(const TodoInitial());

  final TodoRepository _repository;

  Future<void> load() async {
    emit(const TodoLoading());
    try {
      final todos = await _repository.fetchTodos();
      if (isClosed) return; // the user may have left while we waited
      emit(TodoLoaded(todos));
    } catch (_) {
      if (isClosed) return;
      emit(const TodoFailed('Could not load your list. Pull to retry.'));
    }
  }

  Future<void> toggle(String id) async {
    final current = state;
    if (current is! TodoLoaded) return;

    // Optimistic update: a brand new list, never a mutation of the old one.
    emit(TodoLoaded([
      for (final todo in current.todos)
        if (todo.id == id) todo.toggle() else todo,
    ]));

    try {
      await _repository.toggle(id);
    } catch (_) {
      if (isClosed) return;
      // Roll back to exactly what we had, and attach the message. We do NOT
      // emit TodoFailed here: the list loaded fine, only this one action
      // failed, and TodoFailed would replace the whole screen with a retry
      // button the user does not need.
      emit(TodoLoaded(current.todos, actionError: 'That change did not save.'));
    }
  }
}

// ---------------------------------------------------------------------------
// UI
// ---------------------------------------------------------------------------

class CubitApp extends StatelessWidget {
  const CubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cubit Todos',
      theme: ThemeData(useMaterial3: true),
      home: RepositoryProvider(
        create: (_) => TodoRepository(),
        child: BlocProvider(
          // The cascade kicks off the first load exactly once.
          create: (context) => TodoCubit(context.read<TodoRepository>())..load(),
          child: const TodoPage(),
        ),
      ),
    );
  }
}

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: const [RemainingBadge()],
      ),
      body: BlocListener<TodoCubit, TodoState>(
        // A snackbar is a side effect, so it lives in a listener, not a builder.
        listenWhen: (previous, current) =>
            current is TodoFailed ||
            (current is TodoLoaded && current.actionError != null),
        listener: (context, state) {
          final message = switch (state) {
            TodoFailed(:final message) => message,
            TodoLoaded(:final actionError) => actionError,
            _ => null,
          };
          if (message == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) => switch (state) {
            TodoInitial() => const SizedBox.shrink(),
            TodoLoading() => const Center(child: CircularProgressIndicator()),
            TodoFailed(:final message) => _Retry(message: message),
            TodoLoaded(:final todos) => RefreshIndicator(
                onRefresh: () => context.read<TodoCubit>().load(),
                child: ListView.separated(
                  itemCount: todos.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, i) => TodoTile(
                    key: ValueKey(todos[i].id),
                    todo: todos[i],
                  ),
                ),
              ),
          },
        ),
      ),
    );
  }
}

class RemainingBadge extends StatelessWidget {
  const RemainingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocSelector: rebuilds only when this ONE number changes.
    return BlocSelector<TodoCubit, TodoState, int>(
      selector: (state) => state is TodoLoaded ? state.remaining : 0,
      builder: (context, remaining) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$remaining left'),
        ),
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: todo.done,
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.done ? TextDecoration.lineThrough : null,
        ),
      ),
      // read, because this is a callback, not a build dependency.
      onChanged: (_) => context.read<TodoCubit>().toggle(todo.id),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => context.read<TodoCubit>().load(),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
