# Level 13: Testing & Quality - Learning Path

Welcome to Level 13! This level teaches you how to test your Flutter apps and ensure code quality.

---

## How to Use These Theory Files

Read these theory files **in order**, one at a time. Testing concepts build on each other.

After each theory file, practice with the matching PART exercises!

---

## Your Learning Path

### Step 1: Why Testing?
📖 **[01-WhyTesting.md](01-WhyTesting.md)**
- Why test your code?
- Types of testing
- Testing pyramid
- Benefits of testing
- When to test

**Time:** 20 minutes
**Then Practice:** PART 1 exercises (Understanding Testing)

---

### Step 2: Unit Testing
📖 **[02-UnitTesting.md](02-UnitTesting.md)**
- What is unit testing?
- Writing your first test
- test package
- Assertions and matchers
- Testing functions and classes

**Time:** 35 minutes
**Then Practice:** PART 2 exercises (Unit Tests)

---

### Step 3: Widget Testing
📖 **[03-WidgetTesting.md](03-WidgetTesting.md)**
- Testing widgets
- WidgetTester
- Finding widgets
- Simulating user interaction
- Pump and settle

**Time:** 35 minutes
**Then Practice:** PART 3 exercises (Widget Tests)

---

### Step 4: Integration Testing
📖 **[04-IntegrationTesting.md](04-IntegrationTesting.md)**
- End-to-end testing
- integration_test package
- Testing complete flows
- Running on devices
- Performance testing

**Time:** 30 minutes
**Then Practice:** PART 4 exercises (Integration Tests)

---

### Step 5: Test-Driven Development
📖 **[05-TestDrivenDevelopment.md](05-TestDrivenDevelopment.md)**
- TDD principles
- Red-Green-Refactor cycle
- Writing tests first
- TDD benefits
- TDD in practice

**Time:** 30 minutes
**Then Practice:** PART 5 exercises (TDD)

---

### PART 6: Mocking with Mockito (NEW!)

#### Step 6a: Mockito Basics
📖 **[06-MockitoBasics.md](06-MockitoBasics.md)**
- What is mocking?
- When to use mocks
- mockito package setup
- Creating mocks with @GenerateMocks
- when().thenReturn() pattern
- verify() method calls
- Complete cart service example

**Time:** 20 minutes
**Then Practice:** PART 6 exercises 1-8

---

#### Step 6b: Mockito Advanced
📖 **[07-MockitoAdvanced.md](07-MockitoAdvanced.md)**
- Argument matchers (any, argThat)
- Verification patterns (times, never)
- Async mocking (thenAnswer)
- Throwing exceptions in tests
- Capturing arguments
- Complete checkout integration tests

**Time:** 22 minutes
**Then Practice:** PART 6 exercises 9-16

---

### PART 7: DevTools & Performance (NEW!)

#### Step 7a: DevTools Introduction
📖 **[08-DevToolsIntro.md](08-DevToolsIntro.md)**
- What is Flutter DevTools?
- Installation and connection
- Widget Inspector
- Logging and debugging
- App size analysis
- Network view
- Complete debugging workflow

**Time:** 20 minutes
**Then Practice:** PART 7 exercises 1-6

---

#### Step 7b: Performance Profiling
📖 **[09-PerformanceProfiling.md](09-PerformanceProfiling.md)**
- Performance tab overview
- Frame rendering analysis
- Timeline events
- Memory profiling
- CPU profiling
- Identifying jank and performance issues
- Complete shopping app optimization

**Time:** 25 minutes
**Then Practice:** PART 7 exercises 7-14

---

#### Step 7c: Optimization Techniques
📖 **[10-OptimizationTechniques.md](10-OptimizationTechniques.md)**
- App size optimization
- Build time optimization
- Startup time improvements
- Memory optimization
- Image optimization
- Code splitting and deferred loading
- Complete optimization checklist

**Time:** 22 minutes
**Then Practice:** PART 7 exercises 15-20

---

## Total Time for Level 13 Theory

**Estimated:** 7 - 8 hours (including practice)

Testing prevents bugs and builds confidence! Plus **mocking** and **performance profiling** make you a pro!

---

## Learning Strategy

1. **Read one theory file**
2. **Write tests for existing code**
3. **Use mocks for external dependencies**
4. **Profile performance with DevTools**
5. **Optimize based on data**
6. **Move to next testing type**

---

## After Completing Level 13

Once you've finished all theory and exercises:

1. **Review the concepts:**
   - Can you write unit tests?
   - Do you understand widget testing?
   - Can you test user flows?
   - **Can you mock dependencies with Mockito?**
   - **Can you profile app performance?**
   - **Can you optimize based on DevTools data?**

2. **Complete the Final Project:**
   - Add comprehensive tests to a previous project
   - **Include mocked services**
   - **Profile and optimize performance**

3. **Self-Assessment Checklist:**
   - ✅ Can write unit tests
   - ✅ Can write widget tests
   - ✅ Can write integration tests
   - ✅ Understand TDD principles
   - ✅ **Can mock dependencies with Mockito**
   - ✅ **Can use Flutter DevTools**
   - ✅ **Can profile and optimize performance**

---

## Learning Tips

✅ **DO:**
- Write tests for critical logic
- Test edge cases
- Keep tests simple and focused
- Run tests frequently
- Use descriptive test names
- **Mock external dependencies (APIs, databases)**
- **Profile before optimizing**
- **Use DevTools to find real bottlenecks**
- **Measure optimization impact**

❌ **DON'T:**
- Skip testing (it saves time long-term!)
- Test implementation details
- Write flaky tests
- Ignore failing tests
- Over-mock everything
- **Mock internal logic (only mock boundaries)**
- **Optimize without profiling first**
- **Ignore DevTools warnings**
- **Sacrifice code quality for micro-optimizations**

---

**Ready to start?**

👉 Begin with [01-WhyTesting.md](01-WhyTesting.md)
