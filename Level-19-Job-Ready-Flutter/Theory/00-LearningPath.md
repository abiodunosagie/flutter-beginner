# Level 19: Job Ready Flutter - Learning Path

This level covers the six things production Flutter job adverts ask for, in the
order a real feature is built. Every code sample here was compiled and run
against Flutter 3.38.4 / Dart 3.10.3 before it was written down.

---

## How To Use This Learning Path

Read the files **in order**. Each one is 20 to 30 minutes.

After finishing a PART, do that PART's exercises in
[Exercises.md](../Exercises/Exercises.md), then run the matching example in
[Examples](../Examples).

If you are preparing for an interview this week, follow the sprint plan at the
bottom of this file.

---

## PART 1: Widget Composition and Responsive UI

### Step 1a: Composition Over Inheritance
📖 **[01a-CompositionOverInheritance.md](01a-CompositionOverInheritance.md)**
- Why Flutter composes instead of inheriting
- The class explosion, and how parameters prevent it
- The three moves: wrap, slots, builder
- When extending a class is actually right

**Time:** 20 minutes
**Then Practice:** Exercise 1.1

---

### Step 1b: Building Composite Widgets
📖 **[01b-BuildingCompositeWidgets.md](01b-BuildingCompositeWidgets.md)**
- Widget classes vs helper methods, and why `const` matters
- Pushing state down so rebuilds stay small
- Protecting a subtree with a `child` parameter
- Keys: when you need them and when you do not
- Lazy lists

**Time:** 25 minutes
**Then Practice:** Exercise 1.2

---

### Step 1c: Responsive Foundations
📖 **[01c-ResponsiveFoundations.md](01c-ResponsiveFoundations.md)**
- Constraints go down, sizes go up, the parent positions
- Why unbounded height errors happen, and three fixes
- `MediaQuery.sizeOf` vs `MediaQuery.of`, and the other focused accessors
- Material breakpoints, flex widgets, text scaling, safe areas

**Time:** 30 minutes
**Then Practice:** Exercise 1.3

---

### Step 1d: Adaptive Layouts
📖 **[01d-AdaptiveLayouts.md](01d-AdaptiveLayouts.md)**
- Responsive vs adaptive, stated precisely
- Bottom bar to rail to extended rail
- List and detail on one codebase
- Platform adaptive controls, hover, cursors, shortcuts
- Testing every screen size without a device

**Time:** 25 minutes
**Then Practice:** Exercise 1.3, then run Example 01

---

## PART 2: Cubit and Bloc

### Step 2a: Cubit Deep Dive
📖 **[02a-CubitDeepDive.md](02a-CubitDeepDive.md)**
- `emit`, `state`, and the three parts of every Cubit
- Provider, builder, `read` vs `watch`
- Sealed states and exhaustive switches
- The mutation trap and the closed-cubit trap

**Time:** 25 minutes
**Then Practice:** Exercises 2.1 and 2.2

---

### Step 2b: Bloc Deep Dive
📖 **[02b-BlocDeepDive.md](02b-BlocDeepDive.md)**
- Events, handlers, and the three file layout
- Naming events after what the user did
- Event transformers: restartable, droppable, sequential, debounce
- `emit.forEach` for stream backed state
- BlocObserver

**Time:** 30 minutes
**Then Practice:** Exercise 2.3

---

### Step 2c: Modeling States
📖 **[02c-ModelingStates.md](02c-ModelingStates.md)**
- Boolean soup and impossible states
- Sealed hierarchy vs single class with a status enum
- Equatable props, and the bug of forgetting one
- The `copyWith` null trap
- Side effects belong in listeners

**Time:** 25 minutes
**Then Practice:** Exercise 2.4

---

### Step 2d: The Bloc Widget Toolbox
📖 **[02d-BlocWidgetToolbox.md](02d-BlocWidgetToolbox.md)**
- Provider, Builder, Selector, Listener, Consumer
- `buildWhen` and `listenWhen`
- The "Provider not found" error, explained
- `BlocProvider.value` for pushed routes

**Time:** 25 minutes
**Then Practice:** Run Examples 02 and 03

---

### Step 2e: Bloc Architecture
📖 **[02e-BlocArchitecture.md](02e-BlocArchitecture.md)**
- The three layers and the one way arrows
- Feature first folder structure
- Repositories, and mapping transport errors to failures
- Exceptions vs a Result type
- Dependency injection without a framework

**Time:** 30 minutes

---

## PART 3: go_router

### Step 3a: The go_router Mental Model
📖 **[03a-GoRouterMentalModel.md](03a-GoRouterMentalModel.md)**
- Declarative routing: the URL is the state
- Setup, and the two mistakes that break everything
- `go` vs `push`, with the stack drawn out
- Named routes

**Time:** 25 minutes
**Then Practice:** Exercise 3.1

---

### Step 3b: Routes and Parameters
📖 **[03b-RoutesAndParameters.md](03b-RoutesAndParameters.md)**
- Path, query, and `extra`, and when each survives
- Parsing safely, because a URL can contain anything
- Typed routes with `go_router_builder`
- Returning data, custom transitions

**Time:** 25 minutes
**Then Practice:** Exercise 3.3

---

### Step 3c: Shell Routes
📖 **[03c-ShellRoutes.md](03c-ShellRoutes.md)**
- ShellRoute for shared UI
- StatefulShellRoute for a history per tab
- `parentNavigatorKey` for full screen pages
- An adaptive shell: bar on phones, rail on tablets

**Time:** 25 minutes
**Then Practice:** Exercise 3.2

---

### Step 3d: Redirects, Guards, and Deep Links
📖 **[03d-RedirectsAndGuards.md](03d-RedirectsAndGuards.md)**
- The auth guard, including the `unknown` status
- `refreshListenable`, and bridging a bloc stream
- Returning the user to where they were going
- Deep link setup on Android and iOS, clean URLs on web

**Time:** 30 minutes
**Then Practice:** Run Example 04

---

## PART 4: Platform Specific Code

### Step 4a: Platform Aware Code
📖 **[04a-PlatformAwareCode.md](04a-PlatformAwareCode.md)**
- `kIsWeb`, `Platform`, `defaultTargetPlatform`, and which to use
- One file that names capabilities, not platforms
- Where Android and iOS settings live
- Permissions, minSdk, targetSdk

**Time:** 25 minutes
**Then Practice:** Exercise 4.1

---

### Step 4b: Method Channels
📖 **[04b-MethodChannels.md](04b-MethodChannels.md)**
- The Dart, Kotlin, and Swift sides, all three compiled and verified
- Which types cross the boundary
- `PlatformException` vs `MissingPluginException`
- Testing a channel with no device

**Time:** 30 minutes
**Then Practice:** Exercise 4.2

---

### Step 4c: Event Channels and Pigeon
📖 **[04c-EventChannelsAndPigeon.md](04c-EventChannelsAndPigeon.md)**
- Streams from native, and the `onCancel` leak
- Pigeon: one definition, three generated files
- `@HostApi` vs `@FlutterApi`
- When to choose which

**Time:** 25 minutes

---

### Step 4d: Flutter On The Web
📖 **[04d-FlutterOnWeb.md](04d-FlutterOnWeb.md)**
- What the browser actually runs, and why SEO is limited
- What breaks: `dart:io`, channels, plugins, CORS
- Conditional imports, the pattern that solves it
- `dart:js_interop`, url strategy, PWA, performance

**Time:** 25 minutes
**Then Practice:** Exercise 4.3, then run Example 05

---

## PART 5: Freezed, Retrofit, JSON, Code Generation

### Step 5a: The Code Generation Workflow
📖 **[05a-CodeGenerationWorkflow.md](05a-CodeGenerationWorkflow.md)**
- Annotation packages vs generator packages
- Part files, and why your editor shows errors first
- The commands, including what was removed in build_runner 2.15
- Troubleshooting in order, and `build.yaml`

**Time:** 20 minutes

---

### Step 5b: JSON Serialization In Depth
📖 **[05b-JsonSerializable.md](05b-JsonSerializable.md)**
- Field renaming at three levels
- The `explicitToJson` trap, demonstrated
- Nulls, defaults, skipped fields
- Enums that survive a backend change, converters, generics, `compute`

**Time:** 30 minutes
**Then Practice:** Exercise 5.1

---

### Step 5c: Freezed Deep Dive
📖 **[05c-FreezedDeepDive.md](05c-FreezedDeepDive.md)**
- Freezed 3 syntax: `abstract` for data, `sealed` for unions
- The private constructor that unlocks your own methods
- Unions, pattern matching, and the generated callbacks
- Union JSON, and Freezed for bloc states

**Time:** 30 minutes
**Then Practice:** Exercise 5.2

---

### Step 5d: Retrofit API Clients
📖 **[05d-Retrofit.md](05d-Retrofit.md)**
- The full annotation vocabulary
- The `Headers` name clash, and the fix
- Where Dio's interceptors belong
- Mapping errors in the repository, and mocking the API in tests

**Time:** 25 minutes
**Then Practice:** Exercise 5.3, then generate Example 06

---

## PART 6: Testing

### Step 6a: Unit Testing
📖 **[06a-UnitTesting.md](06a-UnitTesting.md)**
- Arrange, Act, Assert, and naming tests as sentences
- Matchers worth memorising
- Async tests and `fakeAsync`
- Fakes, stubs, mocks, and mocktail

**Time:** 25 minutes
**Then Practice:** Exercise 6.1

---

### Step 6b: Widget Testing
📖 **[06b-WidgetTesting.md](06b-WidgetTesting.md)**
- The four verbs, and `pump` vs `pumpAndSettle`
- Finders, and why keys beat labels
- Testing a widget that needs a bloc
- Golden tests, responsive tests, and what the failures mean

**Time:** 30 minutes
**Then Practice:** Exercise 6.3

---

### Step 6c: Integration Testing
📖 **[06c-IntegrationTesting.md](06c-IntegrationTesting.md)**
- The pyramid and where integration sits
- Setup, running, and a realistic flow test
- Real backend vs fake backend
- Performance traces, screenshots, CI

**Time:** 25 minutes

---

### Step 6d: Testing The Whole Stack
📖 **[06d-TestingTheStack.md](06d-TestingTheStack.md)**
- Every `bloc_test` parameter, including `seed`
- Testing blocs, repositories, and router guards
- Organising a suite, and the `pumpApp` helper
- Coverage that means something

**Time:** 30 minutes
**Then Practice:** Exercises 6.2 and 6.4, then run Example 07

---

## Total Time For Level 19

**Estimated:** 11 to 13 hours of reading, plus the exercises.

---

## The Four Day Interview Sprint

If the interview is on Friday and you are starting on Monday:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   DAY 1  PART 2 (Cubit and Bloc), all five lessons   │
│          Run Examples 02 and 03. Say the             │
│          Event -> Bloc -> State flow out loud.       │
│                                                      │
│   DAY 2  PART 3 (go_router) + PART 5 (Freezed,       │
│          Retrofit, codegen). Run Example 04, then    │
│          generate Example 06 yourself.               │
│                                                      │
│   DAY 3  PART 6 (Testing), all four lessons.         │
│          Run Example 07 and break the code on        │
│          purpose to watch tests fail.                │
│                                                      │
│   DAY 4  PART 1 (composition and responsive) +       │
│          PART 4 (platform code). Then read           │
│          InterviewQuestions.md end to end and say    │
│          the answers ALOUD, not in your head.        │
│                                                      │
│   The night before: re-read CommonMistakes.md and    │
│   the Checkpoint. Sleep.                             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## After Completing Level 19

Self assessment. You are ready when you can do all of these without notes:

- Explain composition over inheritance using Flutter's own widgets as evidence
- Say what makes a rebuild cheap, and prove it with `const` and widget classes
- Choose between `MediaQuery.sizeOf` and `LayoutBuilder` and defend it
- Write a cubit and a bloc from a blank file, including the failure path
- Explain when you would reach for Bloc instead of Cubit
- Design a state so that impossible states cannot be written
- Explain `go` vs `push` and what a deep link does to the back stack
- Write an auth guard with `refreshListenable`
- Write a method channel on all three sides
- Explain why `Platform.isIOS` crashes on web
- Generate a Freezed model with JSON and read a union with `switch`
- Declare a Retrofit client and say where auth headers belong
- Write a `blocTest` with `seed` and a widget test with a mocked cubit
- Say what you would test and what you would not

---

## Next Steps

📋 **[Interview Questions](../InterviewQuestions.md)** - the six topics as
questions and answers you can say out loud

⚠️ **[Common Mistakes](../CommonMistakes.md)** - the errors this level's tools
produce, and what each one means

✅ **[Checkpoint](../Checkpoint.md)** - prove to yourself the level is done

---

**Ready to start?**

👉 Begin with [01a-CompositionOverInheritance.md](01a-CompositionOverInheritance.md)
