# Level 6: State Management - Learning Path

Welcome to Level 6! This level teaches you how to manage state across your Flutter app using Provider.

---

## How to Use These Theory Files

Read these theory files **in order**, one at a time. State management builds on itself.

After each theory file, practice with the matching PART exercises!

---

## Your Learning Path (Bit by Bit!)

### PART 1: Understanding State

#### Step 1a: What is State?
📖 **[01a-WhatIsState.md](01a-WhatIsState.md)**
- Simple explanation (like a light switch!)
- State in Flutter apps
- What is and isn't state

**Time:** 10 minutes
**Then Practice:** Exercises 1-3

---

#### Step 1b: Two Types of State
📖 **[01b-TypesOfState.md](01b-TypesOfState.md)**
- Local state (one widget only)
- App state (shared by many)
- How to decide which to use

**Time:** 10 minutes
**Then Practice:** Exercises 4-6

---

#### Step 1c: The Problem
📖 **[01c-TheProblem.md](01c-TheProblem.md)**
- Why setState alone isn't enough
- Prop drilling explained
- Performance issues

**Time:** 15 minutes
**Then Practice:** Exercises 7-9

---

#### Step 1d: The Solution
📖 **[01d-TheSolution.md](01d-TheSolution.md)**
- How state management helps
- Provider vs Riverpod vs BLoC
- Which to learn first

**Time:** 15 minutes
**Then Practice:** Exercises 10-12

---

### PART 2: Provider Basics

#### Step 2a: What is Provider?
📖 **[02a-ProviderIntro.md](02a-ProviderIntro.md)**
- Provider simple explanation
- Setting up the package
- The three simple steps

**Time:** 10 minutes
**Then Practice:** Exercises 13-15

---

#### Step 2b: ChangeNotifier
📖 **[02b-ChangeNotifier.md](02b-ChangeNotifier.md)**
- Creating your data class
- The magic of notifyListeners()
- Private data + public methods

**Time:** 15 minutes
**Then Practice:** Exercises 16-19

---

#### Step 2c: Providing State
📖 **[02c-ProvidingState.md](02c-ProvidingState.md)**
- ChangeNotifierProvider
- Where to put providers
- MultiProvider for multiple states

**Time:** 15 minutes
**Then Practice:** Exercises 20-23

---

#### Step 2d: Consuming State
📖 **[02d-ConsumingState.md](02d-ConsumingState.md)**
- context.watch() for displaying
- context.read() for methods
- Consumer widget

**Time:** 20 minutes
**Then Practice:** Exercises 24-28

---

### PART 3: Provider Advanced

#### Step 3a: Multiple Providers
📖 **[03a-MultipleProviders.md](03a-MultipleProviders.md)**
- Using MultiProvider cleanly
- ProxyProvider (dependent providers)
- Different provider types
- Complete e-commerce example

**Time:** 15 minutes
**Then Practice:** Exercises 29-32

---

#### Step 3b: Optimization
📖 **[03b-Optimization.md](03b-Optimization.md)**
- Selector for specific field changes
- Consumer optimization
- Best practices
- Common mistakes and fixes

**Time:** 15 minutes
**Then Practice:** Exercises 33-35

---

### PART 4: Riverpod Basics

#### Step 4a: Riverpod Introduction
📖 **[04a-RiverpodIntro.md](04a-RiverpodIntro.md)**
- What is Riverpod?
- Provider vs Riverpod
- Setup and ProviderScope
- Global providers
- ref.watch vs ref.read

**Time:** 15 minutes
**Then Practice:** PART 4 exercises 1-5

---

#### Step 4b: Provider Types
📖 **[04b-ProviderTypes.md](04b-ProviderTypes.md)**
- StateProvider (simple mutable)
- Provider (read-only/computed)
- StateNotifierProvider (complex state)
- FutureProvider (async)
- StreamProvider (real-time)

**Time:** 20 minutes
**Then Practice:** PART 4 exercises 6-12

---

#### Step 4c: Consuming Riverpod
📖 **[04c-ConsumingRiverpod.md](04c-ConsumingRiverpod.md)**
- ConsumerWidget
- ConsumerStatefulWidget
- Consumer widget
- Modifying StateProvider
- Provider dependencies

**Time:** 20 minutes
**Then Practice:** PART 4 exercises 13-18

---

### PART 5: Riverpod Advanced

#### Step 5a: Async with Riverpod
📖 **[05a-AsyncValue.md](05a-AsyncValue.md)**
- FutureProvider and StreamProvider
- AsyncValue handling
- .when() and .maybeWhen()
- Loading, error, and data states

**Time:** 15 minutes
**Then Practice:** PART 5 exercises 1-6

---

#### Step 5b: Modifiers
📖 **[05b-Modifiers.md](05b-Modifiers.md)**
- .family (providers with parameters)
- .autoDispose (clean up resources)
- Notifier and AsyncNotifier
- When to use each modifier

**Time:** 15 minutes
**Then Practice:** PART 5 exercises 7-11

---

#### Step 5c: Advanced Patterns
📖 **[05c-AdvancedPatterns.md](05c-AdvancedPatterns.md)**
- Combining providers
- ref.listen for side effects
- .select for optimization
- Testing Riverpod
- Complete todo app

**Time:** 20 minutes
**Then Practice:** PART 5 exercises 12-18

---

### PART 6: BLoC Basics

#### Step 6a: BLoC Introduction
📖 **[06a-BlocIntro.md](06a-BlocIntro.md)**
- What is BLoC?
- Events, States, and BLoC flow
- The three parts of BLoC
- Setting up packages
- Defining Events

**Time:** 15 minutes
**Then Practice:** PART 6 exercises 1-5

---

#### Step 6b: Creating BLoCs
📖 **[06b-CreatingBloc.md](06b-CreatingBloc.md)**
- Defining States (simple vs complex)
- Creating the BLoC class
- Event handlers
- The emit function
- BLoC syntax breakdown

**Time:** 15 minutes
**Then Practice:** PART 6 exercises 6-10

---

#### Step 6c: Using BLoCs
📖 **[06c-UsingBloc.md](06c-UsingBloc.md)**
- BlocProvider
- BlocBuilder for display
- BlocListener for side effects
- BlocConsumer
- Complete counter example

**Time:** 20 minutes
**Then Practice:** PART 6 exercises 11-18

---

### PART 7: BLoC Advanced

#### Step 7a: Async with BLoC
📖 **[07a-AsyncBloc.md](07a-AsyncBloc.md)**
- Async events with BLoC
- Handling API calls
- Equatable for state comparison
- Loading, error, and data states

**Time:** 15 minutes
**Then Practice:** PART 7 exercises 1-6

---

#### Step 7b: BLoC Patterns
📖 **[07b-BlocPatterns.md](07b-BlocPatterns.md)**
- BLoC to BLoC communication
- Event transformers (debounce, throttle)
- Cubit: simplified BLoC
- BLoC vs Cubit

**Time:** 15 minutes
**Then Practice:** PART 7 exercises 7-12

---

#### Step 7c: BLoC Testing
📖 **[07c-BlocTesting.md](07c-BlocTesting.md)**
- Repository pattern with BLoC
- Separating data from logic
- Testing BLoCs with blocTest
- Complete todo app example

**Time:** 20 minutes
**Then Practice:** PART 7 exercises 13-18

---

### Step 8: Choosing State Management
📖 **[08-ChoosingStateManagement.md](08-ChoosingStateManagement.md)**
- Comparison of approaches
- When to use Provider
- When to use Riverpod
- When to use Bloc
- Making the right choice for your app

**Time:** 20 minutes
**Then Practice:** PART 8 exercises (Choosing State Management)

---

## Total Time for Level 6 Theory

**Estimated:** 5 - 6 hours (including practice)

State management is crucial for real apps! This level covers three major approaches.

---

## Learning Strategy

1. **Read one theory file**
2. **Build the state management examples**
3. **See state updates in real-time**
4. **Move to next concept**

Understanding state flow is key!

---

## After Completing Level 6

Once you've finished all theory and exercises:

1. **Review the concepts:**
   - Can you create ChangeNotifier classes?
   - Do you know when to use Provider vs Consumer?
   - Can you manage multiple providers?

2. **Complete the Final Project:**
   - Build an app with proper state management

3. **Self-Assessment Checklist**

---

## Learning Tips

✅ **DO:**
- Draw diagrams of state flow
- Use Provider DevTools to debug
- Keep providers focused (single responsibility)
- Think about where state lives

❌ **DON'T:**
- Put all state in one provider
- Overuse global state
- Skip understanding ChangeNotifier
- Rebuild unnecessarily (use Selector!)

---

**Ready to start?**

👉 Begin with [01a-WhatIsState.md](01a-WhatIsState.md)
