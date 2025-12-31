# Level 1 Exercises: Dart Fundamentals

Welcome! These exercises teach you Dart basics step-by-step. Each part builds on the previous one!

**How these exercises work:**
- Each PART focuses on ONE concept
- Within each part, exercises build on each other progressively
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll understand Dart fundamentals!

---

## PART 1: Print & Your First Variables

Learn to display text and create your first variables.

### Exercise 1.1: Hello You ⭐

**Goal:** Print your basic information.

**Your Task:** Print three lines about yourself.

```dart
void main() {
  // TODO: Print your name
  // TODO: Print your age
  // TODO: Print your favorite color
}
```

**Expected Output:**
```
My name is [your name]
I am [your age] years old
My favorite color is [your color]
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  print('My name is Alex');
  print('I am 25 years old');
  print('My favorite color is blue');
}
```
</details>

---

### Exercise 1.2: Create Your First Variable ⭐

**Goal:** Store information in variables instead of printing directly.

**Your Task:** Create three String variables and print them.

```dart
void main() {
  // TODO: Create a String variable called 'name' with your name
  // TODO: Create a String variable called 'age' with your age
  // TODO: Create a String variable called 'color' with your favorite color

  // TODO: Print each variable
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String name = 'Alex';
  String age = '25';
  String color = 'blue';

  print('My name is $name');
  print('I am $age years old');
  print('My favorite color is $color');
}
```
</details>

---

### Exercise 1.3: Use the Right Types ⭐

**Goal:** Use the correct data type for each piece of information.

**Your Task:** Create variables with proper types (String, int, bool).

```dart
void main() {
  // TODO: Create String variable 'name' with your name
  // TODO: Create int variable 'age' with your age (use actual number, not text!)
  // TODO: Create bool variable 'likesP programming' set to true

  // TODO: Print all three using string interpolation ($variableName)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String name = 'Alex';
  int age = 25;
  bool likesProgramming = true;

  print('My name is $name');
  print('I am $age years old');
  print('Likes programming: $likesProgramming');
}
```
</details>

---

### Exercise 1.4: Book Information Challenge ⭐⭐

**Goal:** Create a complete book profile - NO scaffolding!

**Requirements:**
1. Create variables for a book:
   - Title (String)
   - Author (String)
   - Pages (int)
   - Price (double)
   - Is available (bool)
2. Print all information in a nice format

**Expected Output:**
```
Book: The Great Gatsby
Author: F. Scott Fitzgerald
Pages: 180
Price: $12.99
Available: Yes
```

Try building this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String title = 'The Great Gatsby';
  String author = 'F. Scott Fitzgerald';
  int pages = 180;
  double price = 12.99;
  bool isAvailable = true;

  print('Book: $title');
  print('Author: $author');
  print('Pages: $pages');
  print('Price: \$$price');
  print('Available: ${isAvailable ? 'Yes' : 'No'}');
}
```
</details>

---

## PART 2: Working with Strings

Learn to manipulate and transform text.

### Exercise 2.1: Convert Case ⭐

**Goal:** Change text to uppercase and lowercase.

**Your Task:** Convert a name to different cases.

```dart
void main() {
  String name = 'John Smith';

  // TODO: Print the name in UPPERCASE using toUpperCase()
  // TODO: Print the name in lowercase using toLowerCase()
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String name = 'John Smith';

  print('Uppercase: ${name.toUpperCase()}');
  print('Lowercase: ${name.toLowerCase()}');
}
```
</details>

---

### Exercise 2.2: String Properties ⭐

**Goal:** Use string properties to get information about text.

**Your Task:** Find the length and first letter of a string.

```dart
void main() {
  String fullName = 'John Smith';

  // TODO: Print the length of fullName using .length
  // TODO: Print the first letter using [0]
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String fullName = 'John Smith';

  print('Length: ${fullName.length}');
  print('First letter: ${fullName[0]}');
}
```
</details>

---

### Exercise 2.3: String Checks ⭐

**Goal:** Check if text contains certain characters.

**Your Task:** Check if a string contains specific text.

```dart
void main() {
  String fullName = 'John Smith';

  // TODO: Check if fullName contains 'Smith' using .contains()
  // TODO: Print the result
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String fullName = 'John Smith';

  print('Contains Smith: ${fullName.contains('Smith')}');
}
```
</details>

---

### Exercise 2.4: String Manipulation Challenge ⭐⭐

**Goal:** Use all string methods together - NO scaffolding!

**Requirements:**
Given: `String fullName = 'John Smith';`

Print:
1. Original
2. Uppercase
3. Lowercase
4. Length
5. First letter
6. Contains "Smith"

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String fullName = 'John Smith';

  print('Original: $fullName');
  print('Uppercase: ${fullName.toUpperCase()}');
  print('Lowercase: ${fullName.toLowerCase()}');
  print('Length: ${fullName.length}');
  print('First letter: ${fullName[0]}');
  print('Contains Smith: ${fullName.contains('Smith')}');
}
```
</details>

---

## PART 3: Working with Numbers

Learn arithmetic and number operations.

### Exercise 3.1: Basic Math ⭐

**Goal:** Perform basic arithmetic operations.

**Your Task:** Add and subtract two numbers.

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  // TODO: Calculate and print sum (num1 + num2)
  // TODO: Calculate and print difference (num1 - num2)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  print('Sum: ${num1 + num2}');
  print('Difference: ${num1 - num2}');
}
```
</details>

---

### Exercise 3.2: More Operations ⭐

**Goal:** Use multiplication and division.

**Your Task:** Calculate product and quotient.

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  // TODO: Calculate and print product (num1 * num2)
  // TODO: Calculate and print quotient (num1 / num2) with 2 decimal places
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  print('Product: ${num1 * num2}');
  print('Quotient: ${(num1 / num2).toStringAsFixed(2)}');
}
```
</details>

---

### Exercise 3.3: Remainder ⭐

**Goal:** Find the remainder using modulo.

**Your Task:** Use the % operator.

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  // TODO: Print remainder (num1 % num2)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  print('Remainder: ${num1 % num2}');
}
```
</details>

---

### Exercise 3.4: Calculator Challenge ⭐⭐

**Goal:** Build a simple calculator - NO scaffolding!

**Requirements:**
Given: `int num1 = 17;` and `int num2 = 5;`

Print:
1. Numbers being used
2. Sum
3. Difference
4. Product
5. Quotient (2 decimals)
6. Remainder

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int num1 = 17;
  int num2 = 5;

  print('Numbers: $num1 and $num2');
  print('Sum: ${num1 + num2}');
  print('Difference: ${num1 - num2}');
  print('Product: ${num1 * num2}');
  print('Quotient: ${(num1 / num2).toStringAsFixed(2)}');
  print('Remainder: ${num1 % num2}');
}
```
</details>

---

## PART 4: Calculations & Formulas

Apply what you learned to real-world calculations.

### Exercise 4.1: Rectangle Area ⭐

**Goal:** Calculate the area of a rectangle.

**Your Task:** Use the formula: area = width × height

```dart
void main() {
  int width = 10;
  int height = 5;

  // TODO: Calculate area
  // TODO: Print result
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int width = 10;
  int height = 5;

  int area = width * height;
  print('Rectangle Area: $area');
}
```
</details>

---

### Exercise 4.2: Rectangle Perimeter ⭐

**Goal:** Calculate the perimeter of a rectangle.

**Your Task:** Use the formula: perimeter = 2 × (width + height)

```dart
void main() {
  int width = 10;
  int height = 5;

  // TODO: Calculate perimeter
  // TODO: Print result
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  int width = 10;
  int height = 5;

  int perimeter = 2 * (width + height);
  print('Rectangle Perimeter: $perimeter');
}
```
</details>

---

### Exercise 4.3: Circle Area ⭐⭐

**Goal:** Calculate the area of a circle.

**Your Task:** Use the formula: area = π × radius²

```dart
void main() {
  double radius = 4;
  double pi = 3.14159;

  // TODO: Calculate area (pi * radius * radius)
  // TODO: Print with 2 decimal places
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  double radius = 4;
  double pi = 3.14159;

  double area = pi * radius * radius;
  print('Circle Area: ${area.toStringAsFixed(2)}');
}
```
</details>

---

### Exercise 4.4: Temperature Converter Challenge ⭐⭐

**Goal:** Convert temperatures - NO scaffolding!

**Requirements:**
1. Convert 100°F to Celsius: (F - 32) × 5/9
2. Convert 0°C to Fahrenheit: (C × 9/5) + 32
3. Convert 37°C to Fahrenheit (body temperature)

**Expected Output:**
```
100°F = 37.8°C
0°C = 32.0°F
37°C = 98.6°F
```

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  // Fahrenheit to Celsius
  double fahrenheit = 100;
  double celsius = (fahrenheit - 32) * 5 / 9;
  print('$fahrenheit°F = ${celsius.toStringAsFixed(1)}°C');

  // Celsius to Fahrenheit
  double celsius2 = 0;
  double fahrenheit2 = (celsius2 * 9 / 5) + 32;
  print('$celsius2°C = ${fahrenheit2.toStringAsFixed(1)}°F');

  // Body temperature
  double bodyTemp = 37;
  double bodyTempF = (bodyTemp * 9 / 5) + 32;
  print('$bodyTemp°C = ${bodyTempF.toStringAsFixed(1)}°F');
}
```
</details>

---

## PART 5: Building Complete Programs

Combine everything to create real programs.

### Exercise 5.1: Mad Libs ⭐⭐

**Goal:** Create a story using variables.

**Your Task:** Build a funny story with variables.

```dart
void main() {
  // TODO: Create variables: noun, adjective, verb, place, number
  // TODO: Print a story using these variables
}
```

**Example Output:**
```
One day, a giant elephant decided to dance
in the middle of Paris.
It happened exactly 42 times!
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  String noun = 'elephant';
  String adjective = 'giant';
  String verb = 'dance';
  String place = 'Paris';
  int number = 42;

  print('One day, a $adjective $noun decided to $verb');
  print('in the middle of $place.');
  print('It happened exactly $number times!');
  print('Everyone was amazed.');
}
```
</details>

---

### Exercise 5.2: Area Calculator ⭐⭐

**Goal:** Calculate multiple shapes - NO scaffolding!

**Requirements:**
Calculate and print:
1. Rectangle (width: 10, height: 5) - Area and Perimeter
2. Square (side: 7) - Area and Perimeter
3. Circle (radius: 4, pi: 3.14159) - Area and Circumference (2 × π × radius)

**Expected Output:**
```
Rectangle: Area = 50, Perimeter = 30
Square: Area = 49, Perimeter = 28
Circle: Area = 50.27, Circumference = 25.13
```

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  // Rectangle
  int width = 10;
  int height = 5;
  int rectArea = width * height;
  int rectPerimeter = 2 * (width + height);
  print('Rectangle: Area = $rectArea, Perimeter = $rectPerimeter');

  // Square
  int side = 7;
  int squareArea = side * side;
  int squarePerimeter = 4 * side;
  print('Square: Area = $squareArea, Perimeter = $squarePerimeter');

  // Circle
  double radius = 4;
  double pi = 3.14159;
  double circleArea = pi * radius * radius;
  double circumference = 2 * pi * radius;
  print('Circle: Area = ${circleArea.toStringAsFixed(2)}, Circumference = ${circumference.toStringAsFixed(2)}');
}
```
</details>

---

## FINAL PROJECT: User Profile Card ⭐⭐⭐

**Goal:** Create a complete, formatted user profile!

**Your Task:** Build this entirely on your own - NO scaffolding!

### Requirements:

**User Data:**
- Name, username, email (String)
- Age, followers, following (int)
- Rating 1-5 (double)
- Account balance (double)
- Is verified, is online (bool)

**Output:** Create a nicely formatted profile card like this:

```
╔════════════════════════════════════╗
║         USER PROFILE               ║
╠════════════════════════════════════╣
║ Name: Sarah Connor                 ║
║ Username: @sarah_c                 ║
║ Email: sarah@future.com            ║
╠════════════════════════════════════╣
║ Age: 32          Verified: ✓       ║
║ Followers: 5420  Following: 230    ║
║ Rating: ★★★★☆ (4.2)               ║
║ Balance: $1,250.00                 ║
╠════════════════════════════════════╣
║ Status: 🟢 Online                  ║
╚════════════════════════════════════╝
```

**Hints:**
- Use string interpolation
- Use ternary operator for verified: `${isVerified ? '✓' : '✗'}`
- Use toStringAsFixed(2) for money
- Stars can be simple text or calculated

**Build this completely on your own!**

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  // User data
  String name = 'Sarah Connor';
  String username = '@sarah_c';
  String email = 'sarah@future.com';
  int age = 32;
  int followers = 5420;
  int following = 230;
  double rating = 4.2;
  double balance = 1250.00;
  bool isVerified = true;
  bool isOnline = true;

  // Calculate stars
  int fullStars = rating.floor();
  String stars = '★' * fullStars + '☆' * (5 - fullStars);

  // Print profile
  print('╔════════════════════════════════════╗');
  print('║         USER PROFILE               ║');
  print('╠════════════════════════════════════╣');
  print('║ Name: $name                 ║');
  print('║ Username: $username                 ║');
  print('║ Email: $email            ║');
  print('╠════════════════════════════════════╣');
  print('║ Age: $age          Verified: ${isVerified ? '✓' : '✗'}       ║');
  print('║ Followers: $followers  Following: $following    ║');
  print('║ Rating: $stars ($rating)               ║');
  print('║ Balance: \$${balance.toStringAsFixed(2)}                 ║');
  print('╠════════════════════════════════════╣');
  print('║ Status: ${isOnline ? '🟢 Online' : '⚫ Offline'}                  ║');
  print('╚════════════════════════════════════╝');
}
```
</details>

---

## Submission Checklist

Before moving to Level 2, make sure you can:

- [ ] Write and run a basic Dart program
- [ ] Create variables of different types (String, int, double, bool)
- [ ] Use string interpolation ($variable and ${expression})
- [ ] Perform basic arithmetic operations (+, -, *, /, %, ~/)
- [ ] Convert between types (int, double, String)
- [ ] Use string methods (toUpperCase, toLowerCase, contains, etc.)
- [ ] Format numbers with toStringAsFixed()
- [ ] Write programs without looking at solutions first

---

## Bonus Challenge: BMI Calculator ⭐⭐⭐

Build a BMI (Body Mass Index) calculator:
- Input: weight (kg), height (m)
- Calculate: BMI = weight / (height × height)
- Print BMI with 1 decimal place

**Example:**
```
Weight: 70.0 kg
Height: 1.75 m
BMI: 22.9
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  double weightKg = 70.0;
  double heightM = 1.75;

  double bmi = weightKg / (heightM * heightM);

  print('Weight: $weightKg kg');
  print('Height: $heightM m');
  print('BMI: ${bmi.toStringAsFixed(1)}');
}
```
</details>

---

**Congratulations!** You've completed Level 1!

You now understand Dart fundamentals. Time to learn control flow!

---

**Continue to:** `../../Level-02-Control-Flow/README.md`
