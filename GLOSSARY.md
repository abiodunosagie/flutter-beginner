# Flutter & Dart Glossary

A beginner-friendly dictionary of terms you'll encounter while learning Flutter and Dart. Every definition is explained like you're five years old!

---

## A

### Abstract Class
**Simple:** A blueprint that says "here's what you MUST have" but doesn't tell you exactly how to do it.

**Like:** A coloring book outline - it shows you what shape to draw, but you decide what colors to use.

```dart
abstract class Animal {
  void makeSound();  // "You must have this, but YOU decide what it does"
}
```

### API (Application Programming Interface)
**Simple:** A waiter who takes your order to the kitchen and brings back your food.

**Like:** You don't go into the kitchen yourself - you tell the waiter what you want, and they bring it to you.

### Argument
**Simple:** The actual value you put INTO a function when you use it.

**Like:** If a function is a vending machine, the argument is the actual dollar bill you put in.

```dart
greet('Alice');  // 'Alice' is the argument
```

### Async/Await
**Simple:** A way to say "start this task, do other things, and come back when it's ready."

**Like:** Ordering pizza delivery - you place the order, do other things, and the pizza arrives later.

```dart
await fetchData();  // "Wait here until the data arrives"
```

---

## B

### Boolean (bool)
**Simple:** A yes/no, true/false value.

**Like:** A light switch - it's either ON or OFF, nothing in between.

```dart
bool isRaining = true;
bool hasUmbrella = false;
```

### Build (Method)
**Simple:** The recipe Flutter follows to draw your screen.

**Like:** Every time you want to see your app, Flutter reads this recipe and cooks up the screen.

### BuildContext
**Simple:** Your widget's address book - it knows where you are in the app and how to find things.

**Like:** A map that shows where you are in a mall and how to get to other stores.

---

## C

### Callback
**Simple:** A function you give to someone else to call later.

**Like:** Leaving your phone number so someone can call you back.

```dart
onPressed: () { print('Called back!'); }
```

### Class
**Simple:** A cookie cutter - a template for making things.

**Like:** The cookie cutter is the class; each cookie you make is an object.

```dart
class Dog { }  // This is the cookie cutter
var myDog = Dog();  // This is a cookie made from it
```

### Collection
**Simple:** A container that holds multiple things.

**Like:** A box that can hold many toys (List, Set, Map are all collections).

### Compile
**Simple:** Translating your code into something the computer understands.

**Like:** Translating a book from English to Spanish so Spanish speakers can read it.

### const
**Simple:** A value that is decided BEFORE the app runs and NEVER changes.

**Like:** Your birthday - it was set before you were born and never changes.

```dart
const pi = 3.14159;  // Decided at compile time, never changes
```

### Constructor
**Simple:** The instructions for creating a new object from a class.

**Like:** The recipe you follow to bake a cake - it tells you what ingredients to put in.

```dart
class Person {
  String name;
  Person(this.name);  // Constructor - "To make a Person, you need a name"
}
```

---

## D

### Dart
**Simple:** The programming language Flutter uses.

**Like:** If Flutter is a car, Dart is the engine that makes it run.

### Dependency
**Simple:** Something your code needs to work.

**Like:** A cake depends on flour - without flour, you can't make the cake.

### Dispose
**Simple:** Cleanup - throwing away things you don't need anymore.

**Like:** Turning off the TV when you leave the room to save electricity.

```dart
@override
void dispose() {
  controller.dispose();  // "I'm done, clean up after me"
  super.dispose();
}
```

### double
**Simple:** A number that can have decimal points.

**Like:** Money amounts - $19.99 is a double because of the .99

```dart
double price = 29.99;
```

---

## E

### Enum
**Simple:** A list of named options to choose from.

**Like:** A multiple choice question - you can only pick from the given options.

```dart
enum Size { small, medium, large }
var mySize = Size.medium;
```

### Exception
**Simple:** An error that happens while the app is running.

**Like:** Tripping on a rock while walking - unexpected problem!

### extends
**Simple:** Inheriting from another class.

**Like:** A child inheriting traits from a parent - you get what they have plus your own stuff.

```dart
class Dog extends Animal { }  // Dog inherits from Animal
```

---

## F

### final
**Simple:** A value set once at runtime and never changed after.

**Like:** Your birth certificate - it's filled in when you're born and never changes.

```dart
final now = DateTime.now();  // Set when the app runs, never changes
```

### Firebase
**Simple:** Google's backend-as-a-service - gives you a database, login system, and more without building it yourself.

**Like:** A fully-furnished apartment - you just move in instead of building a house.

### Flutter
**Simple:** A toolkit for building beautiful apps that run on many platforms from one codebase.

**Like:** A magical paintbrush that can paint on any surface - phones, computers, web.

### Function
**Simple:** A reusable block of code that does something.

**Like:** A recipe - you can follow it over and over to make the same dish.

```dart
void sayHello() {
  print('Hello!');
}
```

### Future
**Simple:** A promise that a value will be available later.

**Like:** An IOU note - "I promise to give you the data when it's ready."

```dart
Future<String> fetchName() async { ... }
```

---

## G

### Generic
**Simple:** A way to write code that works with any type.

**Like:** A box that can hold anything - toys, books, or clothes.

```dart
List<String> names = [];  // List that holds Strings
List<int> numbers = [];   // Same List structure, holds ints
```

### Getter
**Simple:** A way to read a value from an object.

**Like:** A window that lets you look inside a house without going in.

```dart
String get fullName => '$firstName $lastName';
```

### Git
**Simple:** A system that saves versions of your code so you can go back in time.

**Like:** A video game save system - you can load an old save if you mess up.

---

## H

### Hot Reload
**Simple:** Seeing your code changes instantly without restarting the app.

**Like:** Changing the paint color on a wall and seeing it change immediately.

### HTTP
**Simple:** The language that web browsers and servers use to talk to each other.

**Like:** The postal system of the internet - how messages get delivered.

---

## I

### immutable
**Simple:** Something that cannot be changed after it's created.

**Like:** A printed photograph - once it's printed, you can't change it.

### import
**Simple:** Bringing in code from another file or package.

**Like:** Borrowing a book from the library to use in your project.

```dart
import 'package:flutter/material.dart';
```

### Inheritance
**Simple:** Getting features from a parent class.

**Like:** Getting your parent's eye color - you inherit it automatically.

### initState
**Simple:** Setup code that runs once when a StatefulWidget first appears.

**Like:** Setting up your desk before starting work - you do it once at the beginning.

```dart
@override
void initState() {
  super.initState();
  loadData();  // "Do this once when I first appear"
}
```

### int (Integer)
**Simple:** A whole number without decimals.

**Like:** Counting apples - you can't have 2.5 apples, only 1, 2, 3...

```dart
int age = 25;
```

### Interface
**Simple:** A contract that says "you must have these methods."

**Like:** A job description - "To be a chef, you must be able to cook."

---

## J

### JSON
**Simple:** A text format for storing and sending data.

**Like:** A shipping label - organized information that computers can read.

```json
{"name": "Alice", "age": 25}
```

---

## K

### Key (Widget Key)
**Simple:** A unique ID for a widget so Flutter can tell widgets apart.

**Like:** Name tags at a party - helps Flutter know which widget is which.

```dart
ListTile(key: Key('item-1'), ...)
```

---

## L

### late
**Simple:** "I promise this will have a value before I use it."

**Like:** Promising to bring snacks to the party - you haven't brought them yet, but you will.

```dart
late String name;  // "I'll give this a value soon, I promise"
```

### List
**Simple:** An ordered collection where items stay in order and can repeat.

**Like:** A playlist - songs are in a specific order, and you can have the same song twice.

```dart
List<String> colors = ['red', 'green', 'blue'];
```

---

## M

### Map
**Simple:** A collection of key-value pairs.

**Like:** A dictionary - look up a word (key) to find its meaning (value).

```dart
Map<String, int> ages = {'Alice': 25, 'Bob': 30};
```

### Method
**Simple:** A function that belongs to a class.

**Like:** A dog's ability to bark - it's a function that belongs to the Dog class.

```dart
class Dog {
  void bark() => print('Woof!');  // bark is a method
}
```

### Mixin
**Simple:** A way to add abilities to a class without inheritance.

**Like:** Power-ups in a video game - you can add abilities without changing what you are.

```dart
mixin Flying {
  void fly() => print('Flying!');
}

class Bird with Flying { }  // Bird can now fly
```

---

## N

### Navigator
**Simple:** Flutter's GPS for moving between screens.

**Like:** The back and forward buttons in a web browser.

```dart
Navigator.push(context, route);  // Go to new screen
Navigator.pop(context);          // Go back
```

### null
**Simple:** Nothing. No value. Empty.

**Like:** An empty box - there's nothing inside.

```dart
String? name = null;  // "name has no value right now"
```

### Null Safety
**Simple:** Dart's way of preventing errors from null values.

**Like:** Safety rails that stop you from falling off a cliff.

---

## O

### Object
**Simple:** A thing made from a class blueprint.

**Like:** A cookie made from a cookie cutter - the class is the cutter, the object is the cookie.

```dart
var myCat = Cat();  // myCat is an object
```

### Override
**Simple:** Replacing a parent's method with your own version.

**Like:** A child doing their homework differently than how their parent would do it.

```dart
@override
void speak() => print('Woof!');  // Replace parent's speak method
```

---

## P

### Package
**Simple:** Code someone else wrote that you can use in your project.

**Like:** A LEGO set you buy - someone made the pieces, you just put them together.

### Parameter
**Simple:** A variable in a function definition - the empty slot waiting for a value.

**Like:** A blank on a form - "Name: ____"

```dart
void greet(String name) { }  // name is the parameter
```

### Provider
**Simple:** A way to share data across many widgets.

**Like:** A water fountain in a park - everyone can access it.

### pubspec.yaml
**Simple:** Your project's shopping list - what packages it needs.

**Like:** A recipe's ingredients list.

---

## R

### Refactor
**Simple:** Reorganizing code without changing what it does.

**Like:** Rearranging furniture - same stuff, better organization.

### Repository
**Simple:** A class that handles data storage and retrieval.

**Like:** A librarian who knows where all the books are.

### Return
**Simple:** Giving back a value from a function.

**Like:** A vending machine giving you a snack after you put in money.

```dart
int add(int a, int b) {
  return a + b;  // "Here's your answer"
}
```

### Route
**Simple:** A path to a screen in your app.

**Like:** An address that tells Flutter which screen to show.

---

## S

### Scaffold
**Simple:** A basic app structure with app bar, body, and bottom bar.

**Like:** The frame of a house - walls, roof, and foundation ready to decorate.

### SDK (Software Development Kit)
**Simple:** A toolbox with everything you need to build apps.

**Like:** An art kit with paints, brushes, and canvas.

### Set
**Simple:** A collection with no duplicates.

**Like:** A bag of unique marbles - you can't have two of the same color.

```dart
Set<String> colors = {'red', 'green', 'blue'};
```

### setState
**Simple:** Telling Flutter "something changed, please redraw the screen."

**Like:** Hitting refresh on a web page.

```dart
setState(() {
  count = count + 1;  // "I changed something, redraw please!"
});
```

### Stateful Widget
**Simple:** A widget that can change over time.

**Like:** A chameleon that can change its color.

### Stateless Widget
**Simple:** A widget that never changes.

**Like:** A painted rock - it looks the same forever.

### Stream
**Simple:** A sequence of values over time.

**Like:** A river - data keeps flowing, you can catch what you need.

```dart
Stream<int> countDown = Stream.fromIterable([3, 2, 1]);
```

### String
**Simple:** Text - letters, words, sentences.

**Like:** A name tag with your name written on it.

```dart
String greeting = 'Hello, World!';
```

---

## T

### Theme
**Simple:** Your app's visual style - colors, fonts, sizes.

**Like:** The interior design of your app - modern, classic, colorful.

### Type
**Simple:** What kind of data something is.

**Like:** Categories - is it a number? text? yes/no?

### typedef
**Simple:** A nickname for a function type.

**Like:** Calling your friend by a nickname instead of their full name.

---

## U

### UI (User Interface)
**Simple:** What the user sees and touches.

**Like:** The buttons, screens, and menus on your phone.

---

## V

### var
**Simple:** A variable where Dart figures out the type for you.

**Like:** A mystery box - Dart opens it and sees what's inside.

```dart
var name = 'Alice';  // Dart knows this is a String
```

### void
**Simple:** A function that doesn't give anything back.

**Like:** A one-way street - information goes in, but nothing comes out.

```dart
void sayHello() {
  print('Hello!');  // Does something, but returns nothing
}
```

---

## W

### Widget
**Simple:** A building block of your Flutter UI.

**Like:** A LEGO brick - small pieces that combine to build bigger things.

### Widget Tree
**Simple:** How widgets are organized - parents and children.

**Like:** A family tree, but for widgets.

---

## Symbols

### `?` (Nullable)
**Simple:** "This might be null."

```dart
String? name;  // name could be null or a String
```

### `!` (Not Null Assertion)
**Simple:** "I promise this is NOT null."

```dart
print(name!.length);  // "Trust me, name is not null"
```

### `??` (If Null)
**Simple:** "Use this if the other thing is null."

```dart
String display = name ?? 'Guest';  // Use 'Guest' if name is null
```

### `?.` (Null-Aware Access)
**Simple:** "Only access this if it's not null."

```dart
print(name?.length);  // Only get length if name isn't null
```

### `=>` (Arrow Syntax)
**Simple:** Short way to write a one-line function.

```dart
int double(int x) => x * 2;  // Same as { return x * 2; }
```

### `...` (Spread Operator)
**Simple:** "Unwrap this collection and put its items here."

```dart
var all = [...list1, ...list2];  // Combine two lists
```

---

**Can't find a term?** This glossary grows with each level. Check back as you progress!
