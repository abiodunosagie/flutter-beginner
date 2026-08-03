# Level 8: API Integration - Learning Path

Welcome to Level 8! This level teaches you how to fetch data from the internet and integrate APIs into your Flutter app.

---

## How to Use These Theory Files

Read these theory files **in order**, one at a time. Each builds on the previous.

After each theory file, practice with the matching PART exercises to work with real APIs!

---

## Your Learning Path

### PART 1: API Fundamentals

#### Step 1: What is an API?
📖 **[01-WhatIsAnAPI.md](01-WhatIsAnAPI.md)**
- Understanding APIs
- Client-server communication
- RESTful APIs
- Common API terms
- API documentation

**Time:** 20 minutes
**Then Practice:** PART 1 exercises 1-5

---

#### Step 2: HTTP Methods
📖 **[02-HTTPMethods.md](02-HTTPMethods.md)**
- GET requests
- POST requests
- PUT requests
- DELETE requests
- HTTP status codes

**Time:** 25 minutes
**Then Practice:** PART 1 exercises 6-12

---

### PART 2: Working with JSON

#### Step 2a: JSON Introduction
📖 **[03a-JSONIntro.md](03a-JSONIntro.md)**
- Understanding JSON
- JSON syntax
- JSON data types
- Why use JSON?

**Time:** 15 minutes
**Then Practice:** PART 2 exercises 1-5

---

#### Step 2b: JSON Parsing
📖 **[03b-JSONParsing.md](03b-JSONParsing.md)**
- jsonDecode and jsonEncode
- Working with Maps
- Type casting
- Safe parsing

**Time:** 20 minutes
**Then Practice:** PART 2 exercises 6-12

---

#### Step 2c: Nested JSON
📖 **[03c-NestedJSON.md](03c-NestedJSON.md)**
- Nested objects
- Arrays in JSON
- Complex structures
- Real-world examples

**Time:** 20 minutes
**Then Practice:** PART 2 exercises 13-18

---

### PART 3: Http Package

#### Step 3a: Http Setup
📖 **[04a-HttpSetup.md](04a-HttpSetup.md)**
- Installing http package
- Making first GET request
- Understanding responses
- Basic headers

**Time:** 20 minutes
**Then Practice:** PART 3 exercises 1-6

---

#### Step 3b: Http Methods
📖 **[04b-HttpMethods.md](04b-HttpMethods.md)**
- GET requests in detail
- POST requests with data
- Common patterns
- Query parameters

**Time:** 15 minutes
**Then Practice:** PART 3 exercises 7-12

---

#### Step 3c: Http Advanced
📖 **[04c-HttpAdvanced.md](04c-HttpAdvanced.md)**
- Custom headers
- Request timeout
- PUT and DELETE
- Response handling

**Time:** 20 minutes
**Then Practice:** PART 3 exercises 13-18

---

### PART 4: Dio Package

#### Step 4a: Dio Introduction
📖 **[05a-DioIntro.md](05a-DioIntro.md)**
- What is Dio?
- Installing Dio
- Basic setup
- First Dio request

**Time:** 20 minutes
**Then Practice:** PART 4 exercises 1-6

---

#### Step 4b: Dio Features
📖 **[05b-DioFeatures.md](05b-DioFeatures.md)**
- Dio vs http
- Interceptors
- Base options
- Response handling

**Time:** 25 minutes
**Then Practice:** PART 4 exercises 7-14

---

#### Step 4c: Dio Advanced
📖 **[05c-DioAdvanced.md](05c-DioAdvanced.md)**
- File uploads
- Download progress
- Cancellation
- Advanced interceptors

**Time:** 25 minutes
**Then Practice:** PART 4 exercises 15-20

---

### PART 5: Error Handling

#### Step 5a: Error Basics
📖 **[06a-ErrorBasics.md](06a-ErrorBasics.md)**
- Try-catch blocks
- Common exceptions
- HTTP error codes
- Network errors

**Time:** 25 minutes
**Then Practice:** PART 5 exercises 1-8

---

#### Step 5b: Error Patterns
📖 **[06b-ErrorPatterns.md](06b-ErrorPatterns.md)**
- Custom error types
- User-friendly messages
- Retry logic
- Error recovery

**Time:** 20 minutes
**Then Practice:** PART 5 exercises 9-15

---

### PART 6: Loading States

#### Step 6a: Loading Indicators
📖 **[07a-LoadingIndicators.md](07a-LoadingIndicators.md)**
- CircularProgressIndicator
- LinearProgressIndicator
- Custom spinners
- Skeleton screens

**Time:** 15 minutes
**Then Practice:** PART 6 exercises 1-5

---

#### Step 6b: FutureBuilder
📖 **[07b-FutureBuilder.md](07b-FutureBuilder.md)**
- FutureBuilder widget
- ConnectionState
- AsyncSnapshot
- Handling all states

**Time:** 20 minutes
**Then Practice:** PART 6 exercises 6-12

---

#### Step 6c: State Patterns
📖 **[07c-StatePatterns.md](07c-StatePatterns.md)**
- Empty states
- Error states
- Pull-to-refresh
- RefreshIndicator

**Time:** 20 minutes
**Then Practice:** PART 6 exercises 13-18

---

### PART 7: Data Models

#### Step 7a: Model Basics
📖 **[08a-ModelBasics.md](08a-ModelBasics.md)**
- Creating Dart classes for API data
- fromJson factory constructors
- Basic parsing
- Using models with APIs

**Time:** 20 minutes
**Then Practice:** PART 7 exercises 1-6

---

#### Step 7b: Serialization
📖 **[08b-Serialization.md](08b-Serialization.md)**
- toJson methods
- copyWith patterns
- Equality
- Nested objects and arrays

**Time:** 20 minutes
**Then Practice:** PART 7 exercises 7-12

---

#### Step 7c: Code Generation
📖 **[08c-CodeGeneration.md](08c-CodeGeneration.md)**
- json_serializable package
- freezed package
- build_runner
- Annotations and automation

**Time:** 25 minutes
**Then Practice:** PART 7 exercises 13-20

---

### PART 8: API Architecture (Progressive Order)

Read these in order - each builds on the previous!

#### Step 8a: Folder Structure Guide (Start Here!)
📖 **[09a-FolderStructureGuide.md](09a-FolderStructureGuide.md)**
- Overview: What goes in each folder
- models/, services/, repositories/, controllers/, screens/, widgets/
- Clear examples for each folder
- Common mistakes to avoid

**Time:** 20 minutes

---

#### Step 8b: API Client Deep Dive (Network Layer)
📖 **[09b-ApiClientDeepDive.md](09b-ApiClientDeepDive.md)**
- Building the network layer
- Making HTTP requests
- Handling responses and errors
- Custom exception classes

**Time:** 20 minutes

---

#### Step 8c: Repository Pattern (Data Layer)
📖 **[09c-RepositoryPattern.md](09c-RepositoryPattern.md)**
- What is a repository?
- Abstract classes and interfaces
- Converting JSON to models
- Multiple implementations (API, Mock, Cached)

**Time:** 20 minutes
**Then Practice:** PART 8 exercises 1-6

---

#### Step 8d: Controllers Deep Dive (State Layer)
📖 **[09d-ControllersDeepDive.md](09d-ControllersDeepDive.md)**
- Managing app state with ChangeNotifier
- Loading, error, and data states
- Search, pagination, and selection patterns
- Testing controllers

**Time:** 25 minutes

---

#### Step 8e: Widgets Deep Dive (UI Layer)
📖 **[09e-WidgetsDeepDive.md](09e-WidgetsDeepDive.md)**
- Building reusable UI components
- Screens vs Widgets
- Display, status, and interactive patterns
- When to extract widgets

**Time:** 20 minutes

---

#### Step 8f: Service Layer (Integration)
📖 **[09f-ServiceLayer.md](09f-ServiceLayer.md)**
- Connecting controllers to repositories
- Using controllers in widgets
- Provider integration
- The complete data flow

**Time:** 20 minutes
**Then Practice:** PART 8 exercises 7-12

---

#### Step 8g: Dependency Injection (Wiring)
📖 **[09g-DependencyInjection.md](09g-DependencyInjection.md)**
- What is dependency injection and WHY
- Step-by-step explanation
- Abstract classes explained simply
- Service Locator pattern
- Complete wiring example

**Time:** 25 minutes

---

#### Step 8h: Best Practices (Advanced)
📖 **[09h-BestPractices.md](09h-BestPractices.md)**
- Caching strategies
- Offline support
- Retry logic
- API best practices

**Time:** 25 minutes
**Then Practice:** PART 8 exercises 13-20

---

## Total Time for Level 8 Theory

**Estimated:** 8 - 10 hours (including practice)

APIs bring your app to life with real data! This level covers everything from basics to professional architecture.

---

## Learning Strategy

1. **Read one theory file**
2. **Complete matching exercises**
3. **See live data in your app**
4. **Handle errors gracefully**
5. **Move to next concept**

Working with real APIs is exciting!

---

## After Completing Level 8

Once you've finished all theory and exercises:

1. **Review the concepts:**
   - Can you make GET and POST requests?
   - Do you understand JSON parsing?
   - Can you handle loading and error states?
   - Can you structure API code properly?

2. **Complete the Final Project:**
   - Build an app that consumes a real API

3. **Self-Assessment Checklist**

---

## Learning Tips

✅ **DO:**
- Test with real APIs (JSONPlaceholder is great!)
- Always handle errors
- Show loading indicators
- Cache data when appropriate
- Use model classes for type safety
- Structure code with repository pattern

❌ **DON'T:**
- Ignore error handling
- Forget to show loading states
- Parse JSON manually (use models!)
- Make unnecessary API calls
- Expose API keys in code
- Mix API calls directly in widgets

---

**Ready to start?**

👉 Begin with [01-WhatIsAnAPI.md](01-WhatIsAnAPI.md)

---

## Going Deeper (Level 19)

When you are comfortable here, Level 19 takes this further with the production stack that job adverts ask for:

📖 **[Freezed, Retrofit, and the build_runner workflow](../../Level-19-Job-Ready-Flutter/Theory/05a-CodeGenerationWorkflow.md)**
