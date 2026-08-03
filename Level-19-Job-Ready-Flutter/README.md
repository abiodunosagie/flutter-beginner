# Level 19: Job Ready Flutter

## The Level That Matches The Job Advert 💼

Levels 1 to 18 taught you Flutter. This level teaches you the **specific stack**
that production Flutter job adverts ask for, and how to talk about it in an
interview.

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   WHAT THE ADVERT SAYS          WHERE IT IS HERE        │
│   ────────────────────          ─────────────────       │
│                                                         │
│   "Strong widget composition                            │
│    and responsive UI skills"    PART 1                  │
│                                                         │
│   "Hands-on Cubit/Bloc and                              │
│    Flutter state management"    PART 2                  │
│                                                         │
│   "Navigation with go_router"   PART 3                  │
│                                                         │
│   "Comfort with platform-                               │
│    specific iOS, Android,                               │
│    and web code"                PART 4                  │
│                                                         │
│   "Freezed, Retrofit, JSON                              │
│    serialization, code gen"     PART 5                  │
│                                                         │
│   "Unit, widget, and                                    │
│    integration tests"           PART 6                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Why This Level Is Different

Every code sample in this level was **compiled and run before it was written
down**, against Flutter 3.38.4 and Dart 3.10.3:

- The Dart samples pass `flutter analyze` with no issues
- The Kotlin method channel and event channel compiled into a real APK
- The Swift versions compiled into a real iOS build
- Every generator (Freezed, json_serializable, Retrofit, go_router_builder) was
  run, and the generated output was read
- All the test examples pass with `flutter test`

That matters because several things most tutorials still teach are now wrong.
You will find those flagged as verified gotchas, for example that
`--delete-conflicting-outputs` was removed in build_runner 2.15, that Freezed 3
needs `abstract` or `sealed` on the class, and that `go_router_builder`
generates `$Route`, not `_$Route`.

---

## What You Will Learn

```
LEVEL 19 TOPICS:
├── PART 1. Widget Composition & Responsive UI
│   ├── Composition over inheritance
│   ├── const, keys, and cheap rebuilds
│   ├── Constraints, MediaQuery, LayoutBuilder
│   └── Adaptive navigation and list/detail
│
├── PART 2. Cubit & Bloc
│   ├── Cubit from scratch
│   ├── Bloc, events, and transformers
│   ├── Modeling states so bugs cannot exist
│   ├── Provider, Builder, Selector, Listener, Consumer
│   └── Layers, repositories, and failures
│
├── PART 3. go_router
│   ├── Declarative routing and the back stack
│   ├── Path, query, extra, and typed routes
│   ├── Shell routes and per tab history
│   └── Guards, refreshListenable, deep links
│
├── PART 4. Platform Specific Code
│   ├── kIsWeb, Platform, defaultTargetPlatform
│   ├── Method channels (Dart + Kotlin + Swift)
│   ├── Event channels and Pigeon
│   └── Flutter on the web
│
├── PART 5. Freezed, Retrofit, JSON, Codegen
│   ├── The build_runner workflow
│   ├── json_serializable in depth
│   ├── Freezed 3: data classes and unions
│   └── Retrofit API clients with Dio
│
└── PART 6. Testing
    ├── Unit tests, fakes, mocks
    ├── Widget tests and goldens
    ├── Integration tests on a device
    └── bloc_test, repositories, router guards
```

---

## Prerequisites

You should be comfortable with:

- Levels 5 to 8 (widgets, state management basics, navigation, APIs)
- Level 13 (testing basics)
- Level 16 (professional patterns)

If any of those feel shaky, do them first. This level moves fast because it
assumes the basics are in place.

---

## The Package Versions This Level Pins

Verified together on Flutter 3.38.4 / Dart 3.10.3:

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  bloc_concurrency: ^0.3.0
  equatable: ^2.1.0
  go_router: ^17.3.0
  dio: ^5.11.0
  retrofit: ^4.9.2
  json_annotation: ^4.9.0
  freezed_annotation: ^3.1.0

dev_dependencies:
  build_runner: ^2.15.1
  freezed: ^3.2.3
  json_serializable: ^6.11.2
  retrofit_generator: ^10.2.8
  go_router_builder: ^4.4.0
  bloc_test: ^10.0.0
  mocktail: ^1.0.5
  integration_test:
    sdk: flutter
```

Add `bloc_test` **before** `json_serializable` when setting up a project. Both
constrain the analyzer, and pub resolves the combination more easily in that
order.

---

## How This Level Is Organised

```
Level-19-Job-Ready-Flutter/
├── README.md                  you are here
├── Theory/                    25 lessons, in order
│   └── 00-LearningPath.md     start here
├── Examples/                  7 runnable files
├── Exercises/                 with worked solutions
├── InterviewQuestions.md      say the answers out loud
├── CommonMistakes.md          44 real errors and their fixes
└── Checkpoint.md              50 questions to test yourself
```

---

## The Examples

| File | What it demonstrates |
|---|---|
| `Example01-ResponsiveDashboard.dart` | Composition, breakpoints, adaptive navigation, reflowing grids |
| `Example02-CubitApp.dart` | Cubit, sealed states, optimistic updates with rollback |
| `Example03-BlocSearch.dart` | Bloc, event transformers, pagination, BlocConsumer |
| `Example04-GoRouterApp.dart` | StatefulShellRoute, auth guard, deep links, full screen routes |
| `Example05-PlatformAware.dart` | kIsWeb, capability naming, method channel, event channel |
| `Example06-FreezedRetrofit.dart` | Freezed models, unions, converters, Retrofit client, repository |
| `Example07-Tests.dart` | 16 passing tests: unit, mocks, bloc_test, widget, responsive, router, channel |

Examples 01 to 05 and 07 run as they are. Example 06 needs
`dart run build_runner build` first, because it is the code generation example.

---

## Estimated Time

- Theory: 11 to 13 hours
- Exercises: 4 to 6 hours
- Examples and the final challenge: 4 to 8 hours

**Total: 20 to 27 hours** for the whole level.

Interviewing this week? The learning path has a four day sprint plan that
covers the highest value material first.

---

## Ready?

👉 **[Start with the Learning Path](Theory/00-LearningPath.md)**

Or, if you are revising rather than learning:

📋 **[Interview Questions](InterviewQuestions.md)** · ⚠️ **[Common Mistakes](CommonMistakes.md)** · ✅ **[Checkpoint](Checkpoint.md)**

---

## Navigation

⬅️ **Previous:** [Level 18 - MCP & AI Integration](../Level-18-MCP-AI-Integration/README.md)
🏠 **Course home:** [README](../README.md)
