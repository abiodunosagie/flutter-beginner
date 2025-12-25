# Level 13: Testing & Quality

## Welcome to Professional Testing! 🧪

Testing is like having a robot friend that checks your homework before you turn it in. It catches mistakes automatically so your users never see them!

```
┌─────────────────────────────────────────────────────────┐
│                    TESTING                               │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WITHOUT TESTING:           WITH TESTING:                │
│                                                          │
│  "I think it works..."      "I KNOW it works!"          │
│  😰 Nervous release         😊 Confident release        │
│  🐛 Users find bugs         ✅ Tests find bugs          │
│  😱 Scary changes           🎉 Safe refactoring         │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## What You'll Learn

```
LEVEL 13 TOPICS:
├── 1. Why Testing Matters
│   ├── Benefits of testing
│   ├── Types of tests
│   └── Testing pyramid
│
├── 2. Unit Testing
│   ├── Testing functions
│   ├── Testing classes
│   └── Mocking dependencies
│
├── 3. Widget Testing
│   ├── Testing UI components
│   ├── Finding widgets
│   ├── Simulating interactions
│   └── Testing navigation
│
├── 4. Integration Testing
│   ├── Testing complete flows
│   ├── End-to-end tests
│   └── Running on devices
│
└── 5. Test-Driven Development (TDD)
    ├── Red-Green-Refactor
    └── Writing tests first
```

---

## The Testing Pyramid

```
                    ┌───────────┐
                   ╱             ╲
                  ╱  Integration  ╲    ← Fewer, slower, expensive
                 ╱     Tests      ╲
                ╱─────────────────╲
               ╱                   ╲
              ╱    Widget Tests     ╲   ← Medium amount
             ╱                       ╲
            ╱─────────────────────────╲
           ╱                           ╲
          ╱       Unit Tests            ╲  ← Many, fast, cheap
         ╱                               ╲
        └─────────────────────────────────┘

        More tests at the bottom!
```

---

## Types of Tests

```
┌─────────────────────────────────────────────────────────┐
│                   TEST TYPES                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  UNIT TESTS                                              │
│  └── Test individual functions and classes              │
│      Example: Does calculateTotal() return correct sum?  │
│                                                          │
│  WIDGET TESTS                                            │
│  └── Test UI components in isolation                    │
│      Example: Does button show loading when tapped?      │
│                                                          │
│  INTEGRATION TESTS                                       │
│  └── Test complete user flows                           │
│      Example: Can user log in and see their profile?     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Folder Structure

```
Level-13-Testing-Quality/
│
├── README.md (this file)
│
├── Theory/
│   ├── 01-WhyTesting.md
│   ├── 02-UnitTesting.md
│   ├── 03-WidgetTesting.md
│   ├── 04-IntegrationTesting.md
│   └── 05-TestDrivenDevelopment.md
│
├── Examples/
│   ├── Example01-UnitTests.dart
│   ├── Example02-WidgetTests.dart
│   └── Example03-IntegrationTests.dart
│
└── Exercises/
    └── Exercises.md
```

---

## Quick Test Example

```dart
// The code we want to test
int add(int a, int b) => a + b;

// The test
void main() {
  test('add returns sum of two numbers', () {
    expect(add(2, 3), equals(5));
  });
}
```

```
RUN TEST:
$ flutter test

OUTPUT:
✓ add returns sum of two numbers
All tests passed!
```

---

## Test File Naming

```
lib/
├── models/
│   └── user.dart           ← Code
├── services/
│   └── auth_service.dart   ← Code
└── screens/
    └── login_screen.dart   ← Code

test/                        ← Mirror structure
├── models/
│   └── user_test.dart      ← Tests
├── services/
│   └── auth_service_test.dart
└── screens/
    └── login_screen_test.dart
```

---

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/user_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│               LEVEL 13 SUMMARY                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  UNIT TESTS                                              │
│  └── Test logic in isolation                            │
│                                                          │
│  WIDGET TESTS                                            │
│  └── Test UI components                                 │
│                                                          │
│  INTEGRATION TESTS                                       │
│  └── Test complete flows                                │
│                                                          │
│  KEY COMMANDS                                            │
│  ├── flutter test              Run all tests            │
│  └── flutter test --coverage   With coverage report     │
│                                                          │
│  BENEFITS                                                │
│  ├── Catch bugs early                                   │
│  ├── Refactor with confidence                           │
│  ├── Document expected behavior                         │
│  └── Ship with peace of mind                            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

**Let's start:** `Theory/01-WhyTesting.md` 🧪
