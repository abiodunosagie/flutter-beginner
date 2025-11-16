# Week 6, Day 5-7: Mixins - Reusable Behaviors

## The Problem: Multiple Inheritance

What if you want features from multiple classes?

```dart
// Want to create FlyingFish
// - Can swim (from Fish)
// - Can fly (from Bird)
// But Dart doesn't allow: class FlyingFish extends Fish, Bird  ❌
```

**Dart doesn't support multiple inheritance**, but it has something better: **Mixins**!

---

## What is a Mixin?

A **mixin** is a way to **reuse code** across multiple class hierarchies.

**Real-world analogy:**
- **Smartphone** = has Camera + GPS + Music Player capabilities
- These are **behaviors** you can mix in, not inheritance
- Many devices share these behaviors (tablets, smartwatches)

**Think of mixins as:**
- Traits or abilities you can add to a class
- Like plugins or modules
- Reusable chunks of behavior

---

## Basic Mixin Syntax

```dart
mixin MixinName {
  // Properties and methods
}

class ClassName with MixinName {
  // Now has everything from MixinName
}
```

### Example: Flying and Swimming

```dart
mixin Flyable {
  void fly() {
    print('Flying through the air!');
  }

  void land() {
    print('Landing...');
  }
}

mixin Swimmable {
  void swim() {
    print('Swimming in water!');
  }

  void dive() {
    print('Diving deep!');
  }
}

// Bird can fly
class Bird with Flyable {
  String name;

  Bird(this.name);

  void chirp() {
    print('$name chirps!');
  }
}

// Fish can swim
class Fish with Swimmable {
  String name;

  Fish(this.name);

  void bubble() {
    print('$name makes bubbles');
  }
}

// Duck can do BOTH!
class Duck with Flyable, Swimmable {
  String name;

  Duck(this.name);

  void quack() {
    print('$name quacks!');
  }
}

void main() {
  Bird bird = Bird('Tweety');
  bird.fly();
  bird.chirp();

  Fish fish = Fish('Nemo');
  fish.swim();
  fish.bubble();

  Duck duck = Duck('Donald');
  duck.fly();     // From Flyable
  duck.swim();    // From Swimmable
  duck.quack();   // Own method
}
```

---

## Mixins with Inheritance

Can combine `extends` and `with`:

```dart
class Animal {
  String name;

  Animal(this.name);

  void eat() {
    print('$name is eating');
  }
}

mixin Flyable {
  void fly() {
    print('Flying!');
  }
}

mixin Swimmable {
  void swim() {
    print('Swimming!');
  }
}

// Inheritance + Mixins
class Duck extends Animal with Flyable, Swimmable {
  Duck(String name) : super(name);

  void quack() {
    print('$name quacks!');
  }
}

void main() {
  Duck duck = Duck('Donald');

  duck.eat();    // From Animal (inheritance)
  duck.fly();    // From Flyable (mixin)
  duck.swim();   // From Swimmable (mixin)
  duck.quack();  // Own method
}
```

**Order matters:**
```dart
class ClassName extends Parent with Mixin1, Mixin2, Mixin3 {
  // Order: Parent → Mixin1 → Mixin2 → Mixin3 → ClassName
}
```

---

## Mixin Constraints

Restrict which classes can use a mixin:

```dart
mixin Musical on Performer {  // Can only be used on Performer or its children
  void playInstrument() {
    print('Playing music');
  }
}

class Performer {
  void perform() {
    print('Performing');
  }
}

class Musician extends Performer with Musical {
  // OK! Musician extends Performer
}

// class Singer with Musical {  // ERROR! Must extend Performer
// }
```

---

## Real-World Example: User Permissions

```dart
mixin Readable {
  void read(String filename) {
    print('Reading $filename');
  }
}

mixin Writable {
  void write(String filename, String content) {
    print('Writing to $filename: $content');
  }
}

mixin Deletable {
  void delete(String filename) {
    print('Deleting $filename');
  }
}

mixin Executable {
  void execute(String filename) {
    print('Executing $filename');
  }
}

class User {
  String username;

  User(this.username);
}

// Regular user - can only read
class RegularUser extends User with Readable {
  RegularUser(String username) : super(username);
}

// Editor - can read and write
class Editor extends User with Readable, Writable {
  Editor(String username) : super(username);
}

// Admin - can do everything
class Admin extends User with Readable, Writable, Deletable, Executable {
  Admin(String username) : super(username);
}

void main() {
  RegularUser user = RegularUser('john');
  user.read('document.txt');
  // user.write('file.txt', 'content');  // ERROR! No write permission

  Editor editor = Editor('jane');
  editor.read('document.txt');
  editor.write('document.txt', 'New content');
  // editor.delete('file.txt');  // ERROR! No delete permission

  Admin admin = Admin('alice');
  admin.read('config.txt');
  admin.write('config.txt', 'settings');
  admin.delete('old.txt');
  admin.execute('script.sh');
}
```

---

## Mixin State and Properties

Mixins can have properties:

```dart
mixin Timestamped {
  DateTime? createdAt;
  DateTime? updatedAt;

  void markCreated() {
    createdAt = DateTime.now();
  }

  void markUpdated() {
    updatedAt = DateTime.now();
  }

  void showTimestamps() {
    print('Created: $createdAt');
    print('Updated: $updatedAt');
  }
}

class Post with Timestamped {
  String title;
  String content;

  Post(this.title, this.content) {
    markCreated();
  }

  void edit(String newContent) {
    content = newContent;
    markUpdated();
  }
}

void main() {
  Post post = Post('My First Post', 'Hello World');
  post.showTimestamps();

  // Wait a moment
  Future.delayed(Duration(seconds: 2), () {
    post.edit('Hello Dart!');
    post.showTimestamps();
  });
}
```

---

## Method Override in Mixins

When mixins and class have same method, **class wins**:

```dart
mixin Logger {
  void log(String message) {
    print('[LOG] $message');
  }
}

class MyClass with Logger {
  @override
  void log(String message) {
    print('[CUSTOM] $message');  // This wins!
  }
}

void main() {
  MyClass obj = MyClass();
  obj.log('Hello');  // [CUSTOM] Hello
}
```

**Multiple mixins with same method:**

```dart
mixin MixinA {
  void greet() {
    print('Hello from A');
  }
}

mixin MixinB {
  void greet() {
    print('Hello from B');
  }
}

class MyClass with MixinA, MixinB {
  // MixinB wins (last one)
}

void main() {
  MyClass obj = MyClass();
  obj.greet();  // Hello from B
}
```

---

## Real-World Example: Social Media Features

```dart
mixin Likeable {
  int _likes = 0;

  void like() {
    _likes++;
    print('Liked! Total: $_likes');
  }

  void unlike() {
    if (_likes > 0) {
      _likes--;
      print('Unliked! Total: $_likes');
    }
  }

  int getLikes() => _likes;
}

mixin Commentable {
  List<String> _comments = [];

  void addComment(String comment) {
    _comments.add(comment);
    print('Comment added: $comment');
  }

  void showComments() {
    print('Comments (${_comments.length}):');
    for (int i = 0; i < _comments.length; i++) {
      print('${i + 1}. ${_comments[i]}');
    }
  }
}

mixin Shareable {
  int _shares = 0;

  void share() {
    _shares++;
    print('Shared! Total: $_shares');
  }

  int getShares() => _shares;
}

class Post with Likeable, Commentable, Shareable {
  String author;
  String content;

  Post(this.author, this.content);

  void display() {
    print('\n=== POST ===');
    print('Author: $author');
    print('Content: $content');
    print('Likes: ${getLikes()}');
    print('Shares: ${getShares()}');
  }
}

class Photo with Likeable, Commentable {
  String url;
  String caption;

  Photo(this.url, this.caption);

  void display() {
    print('\n=== PHOTO ===');
    print('URL: $url');
    print('Caption: $caption');
    print('Likes: ${getLikes()}');
  }
}

void main() {
  Post post = Post('Alice', 'Learning Dart is awesome!');
  post.like();
  post.like();
  post.addComment('Great post!');
  post.addComment('Very helpful!');
  post.share();
  post.display();
  post.showComments();

  Photo photo = Photo('photo.jpg', 'Sunset');
  photo.like();
  photo.addComment('Beautiful!');
  photo.display();
  photo.showComments();
}
```

---

## When to Use Mixins

### ✅ Use Mixins When:

1. **Behavior can be shared across unrelated classes**
   - Multiple classes need same functionality
   - Not an "is-a" relationship

2. **Avoid deep inheritance hierarchies**
   - Instead of: A → B → C → D
   - Use: A with BehaviorMixin, CMixin, DMixin

3. **Composing abilities**
   - Duck = Flyable + Swimmable
   - Smartphone = Camera + GPS + Music

### ❌ Don't Use Mixins When:

1. **Clear inheritance relationship**
   - Dog is Animal → Use inheritance
   - Not mixin

2. **Single shared behavior**
   - Just inherit from parent class

3. **Complex state management**
   - Mixins with lots of state can be confusing

---

## Mixins vs Inheritance vs Composition

| Feature | Inheritance | Mixin | Composition |
|---------|------------|-------|-------------|
| Relationship | is-a | has-ability | has-a |
| Example | Dog is Animal | Duck can Fly | Car has Engine |
| Multiple | ✗ No | ✓ Yes | ✓ Yes |
| When | Clear hierarchy | Shared behaviors | Objects as parts |

**Example of all three:**

```dart
// Inheritance - is-a
class Vehicle {
  void start() {}
}

class Car extends Vehicle {  // Car IS A Vehicle
}

// Mixin - can-do
mixin GPS {
  void navigate() {}
}

class SmartCar extends Vehicle with GPS {  // SmartCar CAN navigate
}

// Composition - has-a
class Engine {
  void run() {}
}

class ComplexCar {
  Engine engine = Engine();  // ComplexCar HAS AN Engine

  void drive() {
    engine.run();
  }
}
```

---

## Exercises

### Exercise 1: Animal Abilities
Create mixins for different animal abilities (Flyable, Swimmable, Runnable) and create animals with different combinations.

<details>
<summary>Solution</summary>

```dart
mixin Flyable {
  void fly() => print('Flying!');
}

mixin Swimmable {
  void swim() => print('Swimming!');
}

mixin Runnable {
  void run() => print('Running!');
}

class Animal {
  String name;
  Animal(this.name);
}

class Dog extends Animal with Runnable, Swimmable {
  Dog(String name) : super(name);
}

class Eagle extends Animal with Flyable, Runnable {
  Eagle(String name) : super(name);
}

class Duck extends Animal with Flyable, Swimmable, Runnable {
  Duck(String name) : super(name);
}

void main() {
  Dog dog = Dog('Rex');
  dog.run();
  dog.swim();

  Eagle eagle = Eagle('Freedom');
  eagle.fly();
  eagle.run();

  Duck duck = Duck('Donald');
  duck.fly();
  duck.swim();
  duck.run();
}
```
</details>

---

### Exercise 2: Logging System
Create logging mixins (FileLogger, ConsoleLogger, DatabaseLogger) and apply to different classes.

<details>
<summary>Solution</summary>

```dart
mixin ConsoleLogger {
  void logToConsole(String message) {
    print('[CONSOLE] $message');
  }
}

mixin FileLogger {
  void logToFile(String message) {
    print('[FILE] Writing to log.txt: $message');
  }
}

mixin DatabaseLogger {
  void logToDatabase(String message) {
    print('[DB] Inserting log: $message');
  }
}

class BasicApp with ConsoleLogger {
  void doSomething() {
    logToConsole('Basic app action');
  }
}

class ProductionApp with ConsoleLogger, FileLogger, DatabaseLogger {
  void doSomething() {
    logToConsole('Production action');
    logToFile('Production action');
    logToDatabase('Production action');
  }
}

void main() {
  BasicApp basic = BasicApp();
  basic.doSomething();

  ProductionApp prod = ProductionApp();
  prod.doSomething();
}
```
</details>

---

## Key Takeaways

1. **Mixins** = Reusable behaviors across classes
2. **`mixin` keyword** defines a mixin
3. **`with` keyword** applies mixins
4. **Multiple mixins** = `with Mixin1, Mixin2, Mixin3`
5. **`on` keyword** = Constrain which classes can use mixin
6. **Order matters** = Last mixin wins for conflicting methods
7. **Use for** shared abilities, not inheritance

---

## What's Next?

You've completed Week 6 - Advanced OOP!

**Next week:**
- **Flutter Introduction** - Your first visual apps!
- **Widgets** - Building blocks of Flutter
- **Layouts** - Arranging UI elements

You've mastered Dart OOP! Ready for Flutter! 🎨🚀
