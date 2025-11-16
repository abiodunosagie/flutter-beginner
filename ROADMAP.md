# Flutter Fundamentals: Complete 24-Week Roadmap

## How to Use This Roadmap

- Each week builds on the previous
- Complete ALL exercises before moving forward
- Projects are cumulative - you'll keep improving the same apps
- Don't skip topics - every concept matters

---

# PHASE 1: DART FUNDAMENTALS (Weeks 1-4)

## Week 1: Getting Started with Programming
**Goal:** Understand what programming is and write your first Dart code

### Day 1-2: Introduction to Programming
- What is programming? What are apps made of?
- Introduction to Dart language
- Setting up DartPad (online editor)
- Setting up VS Code with Dart
- Your first program: Hello World
- Understanding the `main()` function
- **Exercise:** Write 5 different greeting programs

### Day 3-4: Output and Comments
- The `print()` function in depth
- String basics
- Comments: why they matter (single-line, multi-line, doc comments)
- Code readability
- **Exercise:** Create a self-documenting program that tells your story

### Day 5-7: Variables and Data Types
- What is a variable? (Think: labeled boxes)
- `var`, `final`, and `const` - when to use each
- Data types: `int`, `double`, `String`, `bool`
- Type inference vs explicit types
- Naming conventions (camelCase)
- **Exercise:** Create a personal profile program with different data types
- **Mini Project:** Build a "About Me" card generator

---

## Week 2: Working with Data
**Goal:** Manipulate data like a pro

### Day 1-2: Strings Deep Dive
- String creation and manipulation
- String interpolation (`$variable` and `${expression}`)
- Multi-line strings
- Raw strings
- String methods (substring, contains, split, etc.)
- **Exercise:** Build a text formatting tool

### Day 3-4: Numbers and Math
- Integers vs Doubles
- Arithmetic operators (+, -, *, /, %, ~/)
- Assignment operators (=, +=, -=, etc.)
- Math operations and precision
- The `dart:math` library basics
- **Exercise:** Create a calculator program
- **Exercise:** Build a tip calculator

### Day 5-7: Comparison and Logic
- Comparison operators (==, !=, >, <, >=, <=)
- Logical operators (&&, ||, !)
- Boolean logic and truth tables
- Type test operators (`is`, `is!`)
- Ternary operator (condition ? true : false)
- **Exercise:** Build a grade evaluator
- **Mini Project:** Age calculator with eligibility checker

---

## Week 3: Controlling the Flow
**Goal:** Make your programs smart and dynamic

### Day 1-2: Conditional Statements
- `if` statements - making decisions
- `else if` - multiple conditions
- `else` - the fallback
- Nested conditionals
- Best practices for readable conditionals
- **Exercise:** Build a weather advisor app (based on temperature)
- **Exercise:** Create a login validator

### Day 3-4: Switch Statements
- When to use `switch` vs `if-else`
- Switch statement syntax
- `case` and `break`
- `default` case
- **Exercise:** Build a menu selection system
- **Exercise:** Create a day-of-week advisor

### Day 5-7: Loops - Repetition Mastery
- `for` loops - when you know the count
- `while` loops - when you check first
- `do-while` loops - when you act first
- `break` and `continue`
- Nested loops
- Loop best practices
- **Exercise:** Pattern printing programs
- **Exercise:** Build a countdown timer
- **Mini Project:** Multiplication table generator

---

## Week 4: Functions and Collections
**Goal:** Organize code and manage groups of data

### Day 1-3: Functions - Code Reusability
- Why functions matter
- Creating functions
- Parameters and arguments
- Return values and types
- Named parameters
- Optional parameters (positional and named)
- Default parameter values
- Arrow functions (=>) for one-liners
- Scope and lifetime
- **Exercise:** Create a library of utility functions
- **Exercise:** Build a BMI calculator with functions

### Day 4-5: Lists - Ordered Collections
- What are lists? (Think: numbered containers)
- Creating lists
- Accessing elements (indexing)
- Adding and removing elements
- List methods (length, add, remove, contains, etc.)
- Iterating through lists
- List.generate()
- **Exercise:** Build a todo list (console version)
- **Exercise:** Create a gradebook

### Day 6-7: Maps and Sets
- Maps - key-value pairs (think: dictionary)
- Creating and accessing maps
- Map methods
- Sets - unique collections
- Set operations
- When to use List vs Map vs Set
- **Exercise:** Build a phone book app
- **Exercise:** Create an inventory system
- **Mini Project:** Student database with search

---

# PHASE 2: DART INTERMEDIATE + FLUTTER BASICS (Weeks 5-8)

## Week 5: Object-Oriented Programming Foundations
**Goal:** Think in objects, not just functions

### Day 1-2: Classes and Objects
- What is OOP and why it matters
- Classes - the blueprint
- Objects - the instances
- Properties (fields)
- Methods (functions in classes)
- The `this` keyword
- **Exercise:** Create a Person class
- **Exercise:** Build a Book class with methods

### Day 3-4: Constructors
- Default constructors
- Named constructors
- Constructor parameters
- Initializer lists
- Redirecting constructors
- **Exercise:** Create a BankAccount class
- **Exercise:** Build a Product class with multiple constructors

### Day 5-7: Encapsulation and Access
- Public vs private (underscore convention)
- Getters and setters
- Computed properties
- Why encapsulation matters
- **Exercise:** Create a secure User class
- **Exercise:** Build a Temperature class (Celsius/Fahrenheit)
- **Mini Project:** Library management system with books and members

---

## Week 6: OOP Advanced Concepts
**Goal:** Master inheritance, polymorphism, and abstraction

### Day 1-2: Inheritance
- Parent and child classes
- The `extends` keyword
- Calling parent constructors with `super`
- Method overriding
- `@override` annotation
- **Exercise:** Create an Animal hierarchy
- **Exercise:** Build a Vehicle inheritance tree

### Day 3-4: Polymorphism and Abstraction
- What is polymorphism? (Many forms)
- Abstract classes
- Abstract methods
- Interfaces (implicit in Dart)
- `implements` keyword
- When to use abstract vs concrete
- **Exercise:** Create a Shape hierarchy with area calculation
- **Exercise:** Build a Payment system (multiple payment methods)

### Day 5-7: Mixins and Static Members
- What are mixins? (Reusable behaviors)
- Creating and using mixins
- `with` keyword
- Mixin constraints
- Static variables and methods
- When to use static
- **Exercise:** Create mixins for Flyable, Swimmable
- **Exercise:** Build a utility class with static methods
- **Mini Project:** RPG character system (classes, races, abilities)

---

## Week 7: Introduction to Flutter
**Goal:** Build your first visual app

### Day 1-2: Flutter Fundamentals
- What is Flutter?
- Flutter vs other frameworks
- Setting up Flutter SDK
- Creating your first Flutter project
- Understanding the project structure
- `pubspec.yaml` explained
- Running on emulator/simulator
- **Exercise:** Create and run a blank Flutter app
- **Exercise:** Explore the default counter app

### Day 3-4: Widgets - Everything is a Widget
- What are widgets?
- StatelessWidget vs StatefulWidget
- The widget tree
- Material Design basics
- `MaterialApp` and `Scaffold`
- Common widgets: Container, Text, Column, Row
- **Exercise:** Build a static profile card
- **Exercise:** Create a business card app

### Day 5-7: Layout Basics
- Understanding constraints
- `Container` - the Swiss Army knife
- `Column` and `Row` - stacking widgets
- `MainAxisAlignment` and `CrossAxisAlignment`
- `Expanded` and `Flexible`
- Padding and margin
- **Exercise:** Build a calculator UI (no logic yet)
- **Exercise:** Create a social media post card
- **Mini Project:** Recipe card app with images and text

---

## Week 8: Basic Interactivity
**Goal:** Make your apps respond to user input

### Day 1-2: Stateful Widgets
- Understanding state
- `StatefulWidget` anatomy
- `setState()` - triggering rebuilds
- Managing state properly
- Widget lifecycle
- **Exercise:** Build a counter app from scratch
- **Exercise:** Create a light switch toggle

### Day 3-4: User Input Widgets
- `TextButton`, `ElevatedButton`, `IconButton`
- `TextField` and `TextFormField`
- `Checkbox`, `Switch`, `Radio`
- `Slider` and `DropdownButton`
- **Exercise:** Build a form with validation
- **Exercise:** Create a settings page

### Day 5-7: Basic Navigation
- Why navigation matters
- `Navigator.push()` and `Navigator.pop()`
- Passing data between screens
- Named routes
- **Exercise:** Build a multi-page app
- **Exercise:** Create a product detail viewer
- **Mini Project:** Todo app with add/edit/delete (full UI)

---

# PHASE 3: FLUTTER UI MASTERY + STATE MANAGEMENT (Weeks 9-12)

## Week 9: Advanced Layouts
**Goal:** Build complex, responsive UIs

### Day 1-2: ListView and GridView
- `ListView` - scrollable lists
- `ListView.builder()` for performance
- `GridView` - grid layouts
- `GridView.builder()`
- ScrollController
- **Exercise:** Build a contacts list
- **Exercise:** Create a photo gallery

### Day 3-4: Stack and Positioned
- `Stack` - layering widgets
- `Positioned` - absolute positioning
- Z-index and order
- `Align` widget
- Creating overlays
- **Exercise:** Build a profile header with avatar
- **Exercise:** Create a card with badge

### Day 5-7: Responsive Design
- MediaQuery - getting screen dimensions
- LayoutBuilder - adaptive layouts
- Orientation handling
- Platform-specific code
- **Exercise:** Build a responsive dashboard
- **Exercise:** Create an adaptive login screen
- **Mini Project:** Instagram-like feed with stories

---

## Week 10: Styling and Theming
**Goal:** Make beautiful, consistent UIs

### Day 1-2: Theming Deep Dive
- `ThemeData` and theme structure
- ColorScheme
- Text themes
- Custom themes
- Dark mode and light mode
- **Exercise:** Create a custom theme
- **Exercise:** Build a theme switcher

### Day 3-4: Custom Widgets
- When to create custom widgets
- Composition over inheritance
- Reusable components
- Widget parameters
- **Exercise:** Build a custom button
- **Exercise:** Create a reusable card component

### Day 5-7: Advanced Styling
- `BoxDecoration` - gradients, shadows, borders
- `ShapeDecoration`
- Custom painters (introduction)
- Google Fonts integration
- **Exercise:** Build a glass morphism card
- **Exercise:** Create a neumorphic button
- **Mini Project:** E-commerce product card with all styling techniques

---

## Week 11: State Management Fundamentals
**Goal:** Manage complex state professionally

### Day 1-2: Understanding State
- What is state?
- Local vs global state
- State lifting
- InheritedWidget basics
- Problems with setState at scale
- **Exercise:** Build a cart system with lifted state
- **Exercise:** Create a theme provider with InheritedWidget

### Day 3-4: Provider Pattern
- Installing Provider package
- ChangeNotifier
- Provider, Consumer, Selector
- MultiProvider
- Best practices
- **Exercise:** Rebuild cart with Provider
- **Exercise:** Create a user session manager

### Day 5-7: Advanced Provider
- ProxyProvider
- StreamProvider and FutureProvider
- Provider patterns and architecture
- Testing with Provider
- **Exercise:** Build a complete shopping app state
- **Exercise:** Create a notes app with Provider
- **Mini Project:** Weather app with city management (Provider)

---

## Week 12: Forms and Validation
**Goal:** Handle user input professionally

### Day 1-2: Form Widgets Deep Dive
- `Form` widget and `GlobalKey`
- `TextFormField` advanced
- Validators
- Input formatters
- Focus management
- **Exercise:** Build a registration form
- **Exercise:** Create a credit card input

### Day 3-4: Advanced Validation
- Custom validators
- Cross-field validation
- Async validation
- Real-time vs on-submit validation
- **Exercise:** Build a password strength checker
- **Exercise:** Create a signup form with all validations

### Day 5-7: Form Patterns
- Saving form state
- Auto-validation
- Form error handling
- Accessibility in forms
- **Exercise:** Build a multi-step form
- **Exercise:** Create a survey app
- **Mini Project:** Job application form (complete with all techniques)

---

# PHASE 4: API INTEGRATION DEEP DIVE (Weeks 13-16)

## Week 13: JSON and Data Serialization
**Goal:** Understand data formats and parsing

### Day 1-2: JSON Fundamentals
- What is JSON? (Think: structured text data)
- JSON syntax and structure
- Objects, arrays, primitives in JSON
- JSON vs Dart objects
- `dart:convert` library
- `jsonEncode()` and `jsonDecode()`
- **Exercise:** Parse simple JSON manually
- **Exercise:** Convert Dart objects to JSON

### Day 3-4: Data Models
- Why models matter
- Creating model classes
- `fromJson()` factory constructors
- `toJson()` methods
- Null safety in JSON
- Handling optional fields
- **Exercise:** Create a User model
- **Exercise:** Build a Product model with nested data

### Day 5-7: Complex JSON Structures
- Nested objects
- Arrays of objects
- Handling lists in models
- JSON serialization libraries (introduction to json_serializable)
- **Exercise:** Parse a complex API response
- **Exercise:** Create a movie database model (nested genres, cast, etc.)
- **Mini Project:** Parse and display a recipe JSON with ingredients, steps, etc.

---

## Week 14: HTTP and REST APIs
**Goal:** Communicate with the world

### Day 1-2: HTTP Fundamentals
- What are APIs? (Think: restaurant menu and kitchen)
- REST principles
- HTTP methods: GET, POST, PUT, DELETE
- Status codes (200, 404, 500, etc.)
- Headers and body
- **Exercise:** Use curl or Postman to explore an API
- **Exercise:** Document a public API's endpoints

### Day 3-4: http Package
- Installing `http` package
- Making GET requests
- `http.get()`, `.post()`, `.put()`, `.delete()`
- Async/await review
- Handling responses
- Error handling (try-catch)
- **Exercise:** Fetch data from JSONPlaceholder
- **Exercise:** Create a weather API client

### Day 5-7: API Integration Patterns
- Separation of concerns (API service classes)
- Repository pattern
- Error handling strategies
- Timeout handling
- Retry logic
- **Exercise:** Build a complete API service for a todo API
- **Exercise:** Create a news API client with error handling
- **Mini Project:** Quote of the day app (fetch and display random quotes)

---

## Week 15: Real-World API Integration
**Goal:** Build production-ready API integrations

### Day 1-2: Loading States and UX
- FutureBuilder widget
- Loading indicators
- Error states
- Empty states
- Pull-to-refresh
- **Exercise:** Build a posts list with FutureBuilder
- **Exercise:** Add loading, error, and empty states

### Day 3-4: Advanced HTTP
- Query parameters
- Request headers
- Authentication headers (Bearer tokens)
- Form data and multipart requests
- Uploading files
- **Exercise:** Build an authenticated API client
- **Exercise:** Create an image upload feature

### Day 5-7: API Response Handling
- Pagination
- Infinite scroll
- Caching strategies
- Optimistic updates
- **Exercise:** Implement paginated list
- **Exercise:** Build a cache layer
- **Mini Project:** GitHub user search app (search, view profile, repos)

---

## Week 16: Advanced API Patterns
**Goal:** Master real-time data and complex scenarios

### Day 1-2: Streams and Real-Time Data
- Introduction to Streams
- StreamBuilder widget
- Server-Sent Events (SSE)
- Polling vs streaming
- **Exercise:** Build a live data dashboard
- **Exercise:** Create a real-time notification system

### Day 3-4: WebSockets
- What are WebSockets? (Two-way communication)
- `web_socket_channel` package
- Connecting to WebSocket
- Sending and receiving messages
- **Exercise:** Build a live chat proof-of-concept
- **Exercise:** Create a stock price ticker

### Day 5-7: GraphQL Introduction
- GraphQL vs REST
- Queries and mutations
- `graphql_flutter` package basics
- **Exercise:** Query a GraphQL API
- **Exercise:** Perform mutations
- **Mini Project:** Complete app with REST + WebSocket (crypto price tracker)

---

# PHASE 5: ADVANCED DART + FLUTTER PATTERNS (Weeks 17-20)

## Week 17: Advanced Dart - Async Mastery
**Goal:** Master asynchronous programming

### Day 1-2: Future Deep Dive
- How async/await really works
- Future chaining
- `Future.wait()` - parallel execution
- `Future.any()` - race conditions
- Error handling in async code
- **Exercise:** Build a data aggregator (multiple API calls)
- **Exercise:** Create a parallel image downloader

### Day 3-4: Streams Deep Dive
- Stream types (single vs broadcast)
- StreamController
- Stream transformation (map, where, etc.)
- Stream.periodic
- Combining streams
- **Exercise:** Build a custom stream
- **Exercise:** Create a search debouncer with streams

### Day 5-7: Isolates - True Multithreading
- What are isolates?
- Why isolates vs async
- Creating isolates
- SendPort and ReceivePort
- `compute()` function in Flutter
- **Exercise:** Offload heavy computation to isolate
- **Exercise:** Build a background data processor
- **Mini Project:** Image processing app (apply filters using isolates)

---

## Week 18: Advanced Dart - Generics and Functional Programming
**Goal:** Write reusable, elegant code

### Day 1-2: Generics Mastery
- Why generics matter
- Generic classes
- Generic methods
- Generic constraints (extends)
- Covariance and contravariance
- **Exercise:** Build a generic Repository
- **Exercise:** Create a Result type (Success/Error)

### Day 3-4: Functional Programming in Dart
- First-class functions
- Higher-order functions
- Map, filter, reduce
- Closures
- Function composition
- **Exercise:** Build a data pipeline
- **Exercise:** Create a query builder with method chaining

### Day 5-7: Advanced Language Features
- Extension methods
- Operator overloading
- Late variables
- Required parameters
- Factory constructors
- **Exercise:** Extend String with custom methods
- **Exercise:** Create a Money class with operators
- **Mini Project:** Build a type-safe SQL-like query system

---

## Week 19: Advanced Flutter - Animations
**Goal:** Bring your UIs to life

### Day 1-2: Implicit Animations
- `AnimatedContainer`
- `AnimatedOpacity`
- `AnimatedPositioned`
- `TweenAnimationBuilder`
- **Exercise:** Build animated cards
- **Exercise:** Create a loading animation

### Day 3-4: Explicit Animations
- `AnimationController`
- `Tween`
- `CurvedAnimation`
- Animation listeners
- **Exercise:** Build a custom progress indicator
- **Exercise:** Create an animated menu

### Day 5-7: Advanced Animations
- Staggered animations
- Hero animations
- Physics-based animations
- Custom transitions
- **Exercise:** Build a page transition
- **Exercise:** Create a spring animation
- **Mini Project:** Onboarding flow with beautiful animations

---

## Week 20: Architecture and Best Practices
**Goal:** Write maintainable, scalable apps

### Day 1-2: Clean Architecture
- Layers: presentation, domain, data
- Dependency inversion
- Use cases
- Entities and models
- **Exercise:** Restructure a previous project
- **Exercise:** Create a layered feature

### Day 3-4: Design Patterns
- Repository pattern
- Factory pattern
- Singleton pattern
- Observer pattern (in Flutter context)
- **Exercise:** Implement repositories for data
- **Exercise:** Build a notification system

### Day 5-7: Error Handling and Logging
- Custom exceptions
- Result/Either types
- Logging strategies
- Analytics integration
- **Exercise:** Build a robust error handling system
- **Exercise:** Add logging to an app
- **Mini Project:** Refactor previous app with clean architecture

---

# PHASE 6: EXPERT MASTERY + PRODUCTION (Weeks 21-24)

## Week 21: Testing - Building Confidence
**Goal:** Test like a professional

### Day 1-2: Unit Testing
- Why testing matters
- Test structure (Arrange, Act, Assert)
- `test` package
- Matchers
- Testing async code
- **Exercise:** Write tests for models
- **Exercise:** Test business logic

### Day 3-4: Widget Testing
- `flutter_test` package
- Finding widgets
- Simulating interactions
- Golden tests
- **Exercise:** Test a custom widget
- **Exercise:** Test a form

### Day 5-7: Integration Testing
- End-to-end testing
- Test flows
- Mocking dependencies
- **Exercise:** Test a complete user flow
- **Exercise:** Test API integration
- **Mini Project:** Add comprehensive tests to a previous app

---

## Week 22: Performance and Optimization
**Goal:** Make apps fast and efficient

### Day 1-2: Performance Profiling
- DevTools overview
- Performance overlay
- Timeline view
- Memory profiling
- **Exercise:** Profile an app
- **Exercise:** Find and fix performance issues

### Day 3-4: Optimization Techniques
- const constructors
- RepaintBoundary
- ListView.builder efficiency
- Image optimization
- Code splitting
- **Exercise:** Optimize a slow list
- **Exercise:** Reduce app size

### Day 5-7: Advanced Performance
- Tree shaking
- Deferred loading
- Platform channels (when needed)
- **Exercise:** Implement lazy loading
- **Exercise:** Optimize build methods
- **Mini Project:** Performance audit and optimization of a complex app

---

## Week 23: Advanced Topics
**Goal:** Master expert-level concepts

### Day 1-2: Custom Painting
- CustomPainter class
- Canvas API
- Drawing shapes, paths, text
- **Exercise:** Build a signature pad
- **Exercise:** Create a custom chart

### Day 3-4: Platform Channels
- Communicating with native code
- MethodChannel
- EventChannel
- **Exercise:** Call a native API
- **Exercise:** Create a platform-specific feature

### Day 5-7: Advanced State Management
- Riverpod introduction
- Bloc pattern
- Redux pattern
- Choosing the right solution
- **Exercise:** Build a feature with Riverpod
- **Exercise:** Implement Bloc pattern
- **Mini Project:** Compare state management approaches in one app

---

## Week 24: Production and Deployment
**Goal:** Ship real apps

### Day 1-2: App Icons and Splash Screens
- `flutter_launcher_icons`
- `flutter_native_splash`
- Branding
- **Exercise:** Create app icon
- **Exercise:** Design splash screen

### Day 3-4: Building and Signing
- Build modes (debug, profile, release)
- Android signing
- iOS certificates and provisioning
- **Exercise:** Build release APK
- **Exercise:** Prepare iOS build

### Day 5-7: Deployment
- Google Play Console
- App Store Connect
- App review guidelines
- Continuous deployment
- Analytics and crash reporting
- **Exercise:** Submit to internal testing
- **Exercise:** Set up analytics
- **Final Project:** Build, test, and prepare a portfolio app for submission

---

# Continuous Learning

After completing this course:
- Build your own apps
- Contribute to open source Flutter projects
- Explore advanced topics: backend integration, Firebase, offline-first architecture
- Join Flutter communities
- Stay updated with Flutter releases

**Congratulations on committing to this journey. See you at the finish line, Master Developer.**
