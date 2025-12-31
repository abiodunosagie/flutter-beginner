# Choosing State Management: Which One to Use?

Now that you've learned Provider, Riverpod, and BLoC, let's figure out which one is right for your project!

---

## Quick Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│              PROVIDER      RIVERPOD        BLOC                 │
│              ────────      ────────        ────                 │
│                                                                 │
│  Learning     Easy         Medium          Harder               │
│  Curve                                                          │
│                                                                 │
│  Boiler-      Low          Low             Higher               │
│  plate                                                          │
│                                                                 │
│  Type         Good         Excellent       Excellent            │
│  Safety                                                         │
│                                                                 │
│  Testing      Good         Excellent       Excellent            │
│                                                                 │
│  Flutter      Official     Community       Community            │
│  Team                      (by Riverpod    (very popular)       │
│                            creator)                             │
│                                                                 │
│  Best For     Small-med    Any size        Large/complex        │
│               apps                         apps                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## When to Use Provider

### ✅ Good For:
- **Small to medium apps**
- **Beginners** learning state management
- **Quick prototypes**
- **Apps that don't need complex state**
- **Teams already familiar with it**

### ❌ Not Ideal For:
- Very large apps with complex state
- Apps that need easy testing
- When you need compile-time safety

### Example Projects:
- Simple todo apps
- Basic e-commerce
- Portfolio apps
- Small business apps

```dart
// Provider is straightforward
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

---

## When to Use Riverpod

### ✅ Good For:
- **Any size app** (scales well)
- **Apps needing compile-time safety**
- **Easy testing requirements**
- **Complex dependency injection**
- **When you want Provider but better**

### ❌ Not Ideal For:
- Very simple apps (might be overkill)
- Teams unfamiliar with the syntax
- Quick throwaway prototypes

### Example Projects:
- Medium to large apps
- Apps with lots of async data
- Apps requiring thorough testing
- Feature-rich applications

```dart
// Riverpod is type-safe and testable
final counterProvider = StateProvider<int>((ref) => 0);

// Computed values are easy
final doubledProvider = Provider<int>((ref) {
  return ref.watch(counterProvider) * 2;
});
```

---

## When to Use BLoC

### ✅ Good For:
- **Large, complex applications**
- **Teams that like structure**
- **Apps with complex business logic**
- **When you need event tracing/debugging**
- **Enterprise applications**

### ❌ Not Ideal For:
- Very simple apps (too much boilerplate)
- Small teams wanting speed
- Quick MVPs

### Example Projects:
- Banking/finance apps
- Complex e-commerce
- Enterprise software
- Apps with complex flows

```dart
// BLoC provides clear structure
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
    on<Decrement>((event, emit) => emit(state - 1));
  }
}
```

---

## Decision Flowchart

```
START
  │
  ▼
Is your app simple (1-3 screens, basic state)?
  │
  ├── YES ──► Use Provider or setState
  │
  └── NO
      │
      ▼
Do you need compile-time safety and easy testing?
      │
      ├── YES ──► Use Riverpod
      │
      └── NO
          │
          ▼
Is your app large with complex business logic?
          │
          ├── YES ──► Use BLoC
          │
          └── NO
              │
              ▼
Do you prefer event-driven architecture?
              │
              ├── YES ──► Use BLoC
              │
              └── NO ──► Use Riverpod or Provider
```

---

## Side-by-Side Code Comparison

Let's see the same counter app in all three:

### Provider Version

```dart
// State class
class Counter extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}

// Setup
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Counter(),
      child: MyApp(),
    ),
  );
}

// Usage
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = context.watch<Counter>().count;

    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => context.read<Counter>().increment(),
          child: Text('Add'),
        ),
      ],
    );
  }
}
```

### Riverpod Version

```dart
// State (just a provider!)
final counterProvider = StateProvider<int>((ref) => 0);

// Setup
void main() {
  runApp(
    ProviderScope(child: MyApp()),
  );
}

// Usage
class CounterPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('Add'),
        ),
      ],
    );
  }
}
```

### BLoC Version

```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}

// BLoC
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}

// Setup
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterBloc(),
      child: MyApp(),
    ),
  );
}

// Usage
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CounterBloc, int>(
      builder: (context, count) {
        return Column(
          children: [
            Text('$count'),
            ElevatedButton(
              onPressed: () => context.read<CounterBloc>().add(Increment()),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
```

---

## Pros and Cons Summary

### Provider

| Pros | Cons |
|------|------|
| Easy to learn | Runtime errors possible |
| Official Flutter package | Needs BuildContext |
| Simple syntax | Testing requires more setup |
| Good documentation | Can get messy in large apps |

### Riverpod

| Pros | Cons |
|------|------|
| Compile-time safety | Learning curve |
| No BuildContext needed | Different syntax to learn |
| Easy testing | Smaller community |
| Works anywhere | Migration from Provider |
| Great for async | |

### BLoC

| Pros | Cons |
|------|------|
| Clear architecture | More boilerplate |
| Event tracing | Steeper learning curve |
| Great for complex logic | Can be overkill for simple apps |
| Easy testing | More files to manage |
| Predictable | |

---

## Real-World Scenarios

### Scenario 1: Personal Project / Learning

**Best Choice: Provider**

Why? It's simple, well-documented, and teaches the fundamentals of state management.

### Scenario 2: Startup MVP

**Best Choice: Riverpod**

Why? Good balance of features and simplicity. Scales well when your app grows.

### Scenario 3: Enterprise App

**Best Choice: BLoC**

Why? Clear structure, easy to maintain, great for large teams.

### Scenario 4: App with Lots of API Calls

**Best Choice: Riverpod**

Why? AsyncValue handles loading/error states elegantly. FutureProvider is convenient.

### Scenario 5: App with Complex Business Rules

**Best Choice: BLoC**

Why? Event-driven architecture makes complex flows manageable and traceable.

---

## Mixing State Management

You don't have to use just one! Some teams mix:

```dart
// Use Provider for simple global state (theme, user)
// Use BLoC for complex features (checkout flow)
// Use setState for local UI state

MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    BlocProvider(create: (_) => CheckoutBloc()),
  ],
  child: MyApp(),
)
```

### Guidelines for Mixing:

1. **Keep it consistent within features**
2. **Document your choices**
3. **Don't overcomplicate**
4. **Train the whole team**

---

## Migration Path

### From Provider to Riverpod

```dart
// Provider
class Counter extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }
}

// Riverpod equivalent
class Counter extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }
}

final counterProvider = ChangeNotifierProvider((ref) => Counter());

// Or simpler:
final counterProvider = StateProvider((ref) => 0);
```

### From Riverpod to BLoC

```dart
// Riverpod
final counterProvider = StateProvider<int>((ref) => 0);

// BLoC equivalent
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((e, emit) => emit(state + 1));
  }
}
```

---

## My Recommendations

### For Beginners:
1. Start with **Provider** to learn concepts
2. Move to **Riverpod** for better patterns
3. Learn **BLoC** for complex projects

### For Experienced Developers:
1. Use **Riverpod** as default choice
2. Use **BLoC** for complex features
3. Use **Provider** for quick prototypes

### For Teams:
1. Pick ONE as primary (consistency!)
2. Document patterns and guidelines
3. Create examples for common scenarios

---

## Final Thoughts

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   There's NO "best" state management solution!                  │
│                                                                 │
│   The best one is:                                              │
│   • The one your team knows                                     │
│   • The one that fits your project                              │
│   • The one you'll actually use correctly                       │
│                                                                 │
│   All three (Provider, Riverpod, BLoC) are great choices!       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Summary Cheat Sheet

| Question | Provider | Riverpod | BLoC |
|----------|----------|----------|------|
| How hard? | Easy | Medium | Harder |
| For beginners? | ✅ Yes | ⚠️ Maybe | ❌ Not first |
| For large apps? | ⚠️ Maybe | ✅ Yes | ✅ Yes |
| Testing? | Good | Excellent | Excellent |
| Async? | Manual | Built-in | Manual |
| Type safety? | Runtime | Compile | Compile |

---

## Quick Quiz

**Q1:** Which would you choose for a simple todo app you're building to learn Flutter?

<details>
<summary>Answer</summary>

**Provider** - It's the simplest to learn and perfect for small apps. You'll understand state management concepts without getting overwhelmed by boilerplate or complex patterns.

</details>

**Q2:** Your company is building a banking app with complex transaction flows. Which would you recommend?

<details>
<summary>Answer</summary>

**BLoC** - Banking apps have complex business logic and need clear, traceable state changes. BLoC's event-driven architecture makes it easy to track what happened, debug issues, and maintain complex flows. The extra boilerplate is worth it for reliability.

</details>

**Q3:** You're building a social media app with lots of API calls and real-time updates. Which would work best?

<details>
<summary>Answer</summary>

**Riverpod** - Its AsyncValue elegantly handles loading/error/data states. FutureProvider and StreamProvider make API calls and real-time data simple. It scales well and has excellent testing support.

</details>

---

## What's Next?

Congratulations! You now understand three major state management solutions. Next:

1. **Practice** - Build the same app with each to feel the differences
2. **Pick one** - Choose based on your project needs
3. **Master it** - Go deep before switching

---

## Navigation

⬅️ **Previous:** [BLoC Testing](07c-BlocTesting.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
