# Week 06: Advanced OOP Exercises

## Overview
This week focuses on advanced Object-Oriented Programming concepts in Dart, including inheritance, polymorphism, abstract classes, and mixins.

**Topics Covered:**
- Inheritance and class hierarchies
- Method overriding and the super keyword
- Polymorphism and abstract classes
- Interfaces with implements
- Mixins and multiple inheritance
- Type checking and casting

## Exercise Structure

Each exercise builds on the previous one, progressing from basic inheritance to complex systems combining all OOP concepts.

---

## Exercise 1: Shape Hierarchy (Beginner)
**Topic:** Inheritance Basics

**What You'll Learn:**
- Creating parent and child classes
- Using the `extends` keyword
- Calling parent constructors with `super`
- Overriding methods with `@override`

**Challenge:**
Create a shape hierarchy with Shape as the parent class and Rectangle, Circle, and Triangle as children. Each shape calculates its area differently.

**Files:**
- `exercise_1_template.dart` - Start here
- `exercise_1_solution.dart` - Reference solution

**Key Concepts:**
- Abstract classes
- Method overriding
- Constructor inheritance

---

## Exercise 2: Bank Account System (Beginner-Intermediate)
**Topic:** Inheritance with Method Overriding

**What You'll Learn:**
- Building more complex class hierarchies
- Overriding methods with custom logic
- Calling parent methods with `super.method()`
- Managing state in inherited classes

**Challenge:**
Create a banking system with different account types (Savings, Checking, Business). Each account type has unique rules for deposits, withdrawals, and interest calculations.

**Files:**
- `exercise_2_template.dart` - Start here
- `exercise_2_solution.dart` - Reference solution

**Key Concepts:**
- Inheritance hierarchies
- Method overriding with additional logic
- State management across parent and child classes

---

## Exercise 3: E-Commerce Product System (Intermediate)
**Topic:** Polymorphism and Abstract Classes

**What You'll Learn:**
- Creating and using abstract classes
- Abstract methods that children must implement
- Polymorphism - treating different objects uniformly
- Type checking with `is` operator
- Working with lists of polymorphic objects

**Challenge:**
Build an e-commerce system with different product types (Physical, Digital, Subscription). Create a shopping cart that can handle all product types polymorphically.

**Files:**
- `exercise_3_template.dart` - Start here
- `exercise_3_solution.dart` - Reference solution

**Key Concepts:**
- Abstract classes and methods
- Polymorphism
- Collections of abstract types
- Type-specific behavior

---

## Exercise 4: User Role System (Intermediate-Advanced)
**Topic:** Mixins and Composition

**What You'll Learn:**
- Creating and using mixins
- Applying multiple mixins to a single class
- Combining inheritance with mixins
- Using `is` operator for capability checking
- Composing behavior from multiple sources

**Challenge:**
Create a user permission system where different user roles (Guest, Regular, Editor, Administrator) have different capabilities using mixins for each permission type.

**Files:**
- `exercise_4_template.dart` - Start here
- `exercise_4_solution.dart` - Reference solution

**Key Concepts:**
- Mixin definition and usage
- Multiple mixins on one class
- Capability-based design
- Type checking for mixins

---

## Exercise 5: Social Media Platform (Advanced)
**Topic:** Complete OOP - All Concepts Combined

**What You'll Learn:**
- Combining inheritance, polymorphism, abstract classes, and mixins
- Building a complex system with multiple interacting components
- Real-world application of all OOP concepts
- Managing relationships between objects

**Challenge:**
Build a complete social media platform with users, posts, photos, videos, and stories. Implement features like likes, comments, shares, and engagement tracking. This exercise combines everything you've learned.

**Files:**
- `exercise_5_template.dart` - Start here
- `exercise_5_solution.dart` - Reference solution

**Key Concepts:**
- Abstract content classes
- Mixins for social interactions
- Polymorphic collections
- Complex object relationships
- Real-world system design

---

## Running the Exercises

### Option 1: Work with Templates
1. Open the template file (e.g., `exercise_1_template.dart`)
2. Read the instructions carefully
3. Implement the required classes and methods
4. Test your implementation in the `main()` function
5. Run: `dart exercise_1_template.dart`

### Option 2: Study Solutions
1. Open the solution file (e.g., `exercise_1_solution.dart`)
2. Read through the implementation
3. Run: `dart exercise_1_solution.dart`
4. Experiment by modifying the code

### Option 3: Compare Your Work
1. Complete the template first
2. Run your implementation
3. Compare with the solution
4. Identify areas for improvement

---

## Tips for Success

### Understanding Inheritance
- Use inheritance for "is-a" relationships (Dog IS A Animal)
- Always call parent constructor with `super()`
- Use `@override` annotation for clarity
- Call parent methods with `super.method()` when extending behavior

### Working with Abstract Classes
- Use abstract classes when you want to provide some implementation
- Abstract methods force children to provide specific implementations
- You cannot instantiate an abstract class directly
- Perfect for defining templates and contracts

### Mastering Mixins
- Use mixins for "has-ability" relationships (Duck HAS ABILITY TO fly)
- Mixins allow multiple inheritance of behavior
- Order matters: `class MyClass extends Parent with Mixin1, Mixin2`
- Last mixin wins if there are naming conflicts
- Use mixins for cross-cutting concerns (logging, timestamps, permissions)

### Polymorphism Best Practices
- Store different types in a common parent type
- Let each object implement behavior in its own way
- Use polymorphic collections: `List<Animal> zoo = [Dog(), Cat(), Bird()]`
- Leverage polymorphism to write flexible, extensible code

---

## Common Mistakes to Avoid

1. **Forgetting super():** Always call parent constructor
   ```dart
   // Wrong
   Child(this.age);

   // Correct
   Child(String name, this.age) : super(name);
   ```

2. **Wrong override signature:** Must match parent method exactly
   ```dart
   // Parent
   void greet(String name) { }

   // Wrong override
   void greet() { }  // Missing parameter!

   // Correct override
   @override
   void greet(String name) { }
   ```

3. **Using inheritance for "has-a":** Use composition instead
   ```dart
   // Wrong: Car IS A Engine? No!
   class Car extends Engine { }

   // Correct: Car HAS AN Engine
   class Car {
     Engine engine = Engine();
   }
   ```

4. **Not using @override:** Always use it for clarity
   ```dart
   // OK but not recommended
   void makeSound() { }

   // Better - shows intent
   @override
   void makeSound() { }
   ```

---

## Testing Your Understanding

After completing the exercises, you should be able to:

- [ ] Create class hierarchies using inheritance
- [ ] Override methods appropriately
- [ ] Use abstract classes to define templates
- [ ] Apply polymorphism to treat different objects uniformly
- [ ] Create and use mixins for reusable behaviors
- [ ] Combine multiple OOP concepts in a single system
- [ ] Choose between inheritance, composition, and mixins appropriately

---

## Additional Resources

**Dart Documentation:**
- [Classes](https://dart.dev/language/classes)
- [Extend a class](https://dart.dev/language/extend)
- [Mixins](https://dart.dev/language/mixins)
- [Abstract classes](https://dart.dev/language/class-modifiers#abstract)

**Related Lessons:**
- `lessons/phase_2_dart_intermediate_flutter_basics/week_06_oop_advanced/01_inheritance.md`
- `lessons/phase_2_dart_intermediate_flutter_basics/week_06_oop_advanced/02_polymorphism_and_abstraction.md`
- `lessons/phase_2_dart_intermediate_flutter_basics/week_06_oop_advanced/03_mixins.md`

---

## Next Steps

Once you've completed these exercises:
1. Review the solutions and compare with your implementations
2. Experiment by adding new features to each exercise
3. Try combining concepts from different exercises
4. Move on to Week 07: Flutter Introduction

**Great job mastering advanced OOP concepts!** These are fundamental skills you'll use throughout your Flutter development journey.

Happy coding! 🚀
