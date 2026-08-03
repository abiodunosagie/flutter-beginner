# Bloc Deep Dive: Events, Handlers, and Transformers

## The Big Idea In One Sentence

> A **Bloc** is a Cubit with a mailbox: instead of calling methods you `add` an event, a registered handler processes it, and you gain control over how a burst of events is handled.

---

## Cubit vs Bloc, Side By Side

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   CUBIT                        BLOC                  │
│   ─────                        ────                  │
│   cubit.increment()            bloc.add(Increment()) │
│                                                      │
│   void increment() =>          on<Increment>((e, emit) {
│     emit(state + 1);             emit(state + 1);    │
│                                });                   │
│                                                      │
│   Less code                    More code             │
│   No history                   Every event recorded  │
│   No flow control              debounce, throttle,   │
│                                droppable, restartable│
│                                                      │
└──────────────────────────────────────────────────────┘
```

Same output, same widgets, same tests. The difference is the mailbox.

---

## The Three Files Of A Bloc Feature

Real projects split a bloc into three files. Interviewers expect the layout.

```
lib/features/search/
├── bloc/
│   ├── search_bloc.dart      the handlers
│   ├── search_event.dart     what can happen
│   └── search_state.dart     what the UI can show
└── view/
    └── search_page.dart
```

### search_event.dart

```dart
part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => const [];
}

final class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);
  final String query;

  @override
  List<Object?> get props => [query];
}

final class SearchCleared extends SearchEvent {
  const SearchCleared();
}

final class SearchNextPageRequested extends SearchEvent {
  const SearchNextPageRequested();
}
```

Name events after **what happened**, in the past tense, from the user's point of view: `SearchQueryChanged`, `LoginSubmitted`, `CartItemRemoved`. Do not name them after what the bloc should do (`FetchResults`, `SetLoading`). That naming discipline is a real signal of Bloc experience.

### search_state.dart

```dart
part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

final class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.results = const [],
    this.hasMore = true,
    this.errorMessage,
  });

  final SearchStatus status;
  final String query;
  final List<Product> results;
  final bool hasMore;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<Product>? results,
    bool? hasMore,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, query, results, hasMore, errorMessage];
}
```

This is the **single state class with a status enum** style. The other style is one class per state (the `sealed class` approach from the Cubit lesson). Both are correct. The next lesson compares them properly; for now, note that pagination is much easier with a single class because you keep the old results while loading more.

### search_bloc.dart

```dart
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._repository) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: restartable(),
    );
    on<SearchCleared>(_onCleared);
    on<SearchNextPageRequested>(
      _onNextPage,
      transformer: droppable(),
    );
  }

  final ProductRepository _repository;

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchState());
      return;
    }

    emit(state.copyWith(status: SearchStatus.loading, query: event.query));

    try {
      final results = await _repository.search(event.query, page: 1);
      emit(state.copyWith(
        status: SearchStatus.success,
        results: results,
        hasMore: results.isNotEmpty,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: 'Search failed. Check your connection.',
      ));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchState());
  }

  Future<void> _onNextPage(
    SearchNextPageRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (!state.hasMore || state.status == SearchStatus.loading) return;

    final nextPage = (state.results.length ~/ 20) + 1;
    final more = await _repository.search(state.query, page: nextPage);

    emit(state.copyWith(
      results: [...state.results, ...more],
      hasMore: more.isNotEmpty,
    ));
  }
}
```

---

## Registering Handlers: The Rules

```dart
on<EventType>(handler);          // one registration per event type
```

- Register every event type in the constructor, once. Registering the same type twice throws.
- Handlers can be `void` or `Future<void>`.
- The handler receives `(event, emit)`. Use `emit` only inside it; do not store it and use it later.
- Reference a private method (`_onQueryChanged`) rather than a long inline closure. It reads better and it is easier to test.

---

## Event Transformers: The Real Reason Bloc Exists

Without a transformer, events are processed **concurrently**: five keystrokes fire five requests and whichever finishes last wins, which can be the wrong one.

```yaml
dependencies:
  bloc_concurrency: ^0.3.0
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   User types "shoes" -> 5 events fire                │
│                                                      │
│   concurrent() (default)                             │
│   s ──────────────────────────► (returns 3rd)        │
│   sh ──────────────────► (returns 1st)               │
│   sho ───────────────────────► (returns 4th)         │
│   shoe ──────────► (returns 2nd)                     │
│   shoes ───────────────► WRONG RESULT MAY WIN        │
│                                                      │
│   restartable()                                      │
│   s ──X (cancelled)                                  │
│   sh ─X (cancelled)                                  │
│   shoes ──────────────► only this one completes      │
│                                                      │
│   droppable()                                        │
│   s ─────────────────► completes                     │
│   sh, sho, shoe, shoes  IGNORED while busy           │
│                                                      │
│   sequential()                                       │
│   s ──► then sh ──► then sho ──► one after another   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Which to use:

| Transformer | Use it for |
|---|---|
| `restartable()` | Search as you type, live filters. Only the newest matters. |
| `droppable()` | Submit buttons, "load more". Ignore taps while busy. |
| `sequential()` | Ordered writes: a queue of edits that must apply in order. |
| `concurrent()` | Independent work with no shared result (the default). |

### Debounce: waiting for the user to stop typing

`bloc_concurrency` has no debounce, because debounce is a stream operation. You compose it:

```dart
import 'package:rxdart/rxdart.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) =>
      events.debounceTime(duration).switchMap(mapper);
}

// In the constructor:
on<SearchQueryChanged>(
  _onQueryChanged,
  transformer: debounce(const Duration(milliseconds: 300)),
);
```

Debouncing a search box cut a real app's API calls by roughly 80 percent. It is a great thing to mention when asked "how would you optimise a search screen".

---

## `emit.forEach` and `emit.onEach`: Blocs That Listen To Streams

When a bloc's state comes from a stream (Firestore, a websocket, connectivity), do not subscribe manually. Use `emit.forEach` so the subscription lives and dies with the handler.

```dart
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._repo) : super(const ChatState()) {
    on<ChatSubscribed>(_onSubscribed);
  }

  final ChatRepository _repo;

  Future<void> _onSubscribed(
    ChatSubscribed event,
    Emitter<ChatState> emit,
  ) {
    return emit.forEach<List<Message>>(
      _repo.watchMessages(event.roomId),
      onData: (messages) => state.copyWith(messages: messages),
      onError: (error, _) => state.copyWith(error: error.toString()),
    );
  }
}
```

`emit.forEach` keeps the handler alive while the stream runs, and cancels the subscription when the bloc closes or a `restartable()` transformer replaces it. Manual `listen()` calls leak.

---

## Bloc To Bloc Communication

Blocs should not reach into each other. Two acceptable patterns:

### 1. Share a repository (preferred)

Both blocs depend on the same repository; the repository exposes a stream. This keeps blocs unaware of each other.

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repo) : super(const AuthUnknown()) {
    on<AuthSubscribed>((e, emit) => emit.forEach(
          _repo.statusStream,
          onData: (status) =>
              status == AuthStatus.signedIn ? const AuthIn() : const AuthOut(),
        ));
  }
  final AuthRepository _repo;
}
```

### 2. Listen in the widget layer

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthOut) {
      context.read<CartBloc>().add(const CartCleared());
    }
  },
  child: child,
)
```

Never inject `BlocA` into `BlocB`'s constructor. It creates a dependency cycle the moment the relationship goes both ways, and it makes both blocs untestable alone.

---

## BlocObserver: One Place To See Everything

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    debugPrint('EVENT ${bloc.runtimeType}: $event');
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint('TRANSITION ${bloc.runtimeType}: $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Report to Crashlytics or Sentry here.
  }
}

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}
```

A `Change` is "state A became state B". A `Transition` is "event E turned state A into state B". Cubits only have changes; blocs have both. That distinction is a classic interview question.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • bloc.add(Event) -> on<Event>(handler) -> emit    │
│   • Name events in the past tense, after the user    │
│   • Three files: bloc, event, state (part of)        │
│   • restartable = search, droppable = submit,        │
│     sequential = ordered writes                      │
│   • debounce with rxdart when typing                 │
│   • emit.forEach for stream backed state             │
│   • Blocs talk through repositories, not each other  │
│   • Bloc.observer logs every event and transition    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What does an event transformer control?

<details>
<summary>Answer</summary>
How a burst of incoming events is turned into handler executions: run them all at once (`concurrent`), cancel the older ones (`restartable`), ignore new ones while busy (`droppable`), or queue them (`sequential`).
</details>

**Q2.** A search box fires a request per keystroke and old results sometimes overwrite new ones. Fix it in two ways.

<details>
<summary>Answer</summary>
Use `transformer: restartable()` so in-flight requests are cancelled when a newer keystroke arrives, and add a debounce so requests only fire after the user pauses typing.
</details>

**Q3.** What is the difference between a `Change` and a `Transition`?

<details>
<summary>Answer</summary>
A `Change` is the pair (current state, next state) and exists for both Cubit and Bloc. A `Transition` also includes the event that caused it, so it only exists for Bloc.
</details>

---

## Assignment

### Problem 1: Name the events

A login screen has an email field, a password field, a submit button, and a "show password" toggle. Name the four events.

### Problem 2: Choose the transformer

Pick one for each: an infinite scroll "load more", a live filter text field, a queue of offline edits being synced.

### Problem 3: Fix the leak

```dart
ChatBloc(this._repo) : super(const ChatState()) {
  _repo.watchMessages().listen((messages) {
    emit(state.copyWith(messages: messages));
  });
}
```

Name two problems and rewrite it.

### Problem 4: Bloc or Cubit

For each, choose one and justify in one line: a theme toggle, a checkout flow with analytics on every step, a form with validation, a search screen with debouncing.

---

## Assignment Answers

### Problem 1: Name the events

`LoginEmailChanged`, `LoginPasswordChanged`, `LoginSubmitted`, `LoginPasswordVisibilityToggled`. Past tense, describing what the user did.

### Problem 2: Choose the transformer

- Infinite scroll "load more": `droppable()`, so scrolling fast does not fire ten page requests.
- Live filter field: `restartable()` (plus debounce), so only the latest query survives.
- Queue of offline edits: `sequential()`, so edits apply in order.

### Problem 3: Fix the leak

Problems: the subscription is never cancelled, so it leaks and can emit after `close()`; and `emit` is being used outside a handler, which bloc forbids.

```dart
ChatBloc(this._repo) : super(const ChatState()) {
  on<ChatSubscribed>((event, emit) => emit.forEach<List<Message>>(
        _repo.watchMessages(),
        onData: (messages) => state.copyWith(messages: messages),
      ));
}
```

### Problem 4: Bloc or Cubit

- Theme toggle: Cubit. One method, no history needed.
- Checkout with analytics per step: Bloc. Every event is a named, loggable thing.
- Form with validation: Cubit. Simple method per field is enough.
- Search with debouncing: Bloc. You need an event transformer.

---

## Navigation

⬅️ **Previous:** [Cubit Deep Dive](02a-CubitDeepDive.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Modeling States](02c-ModelingStates.md)
