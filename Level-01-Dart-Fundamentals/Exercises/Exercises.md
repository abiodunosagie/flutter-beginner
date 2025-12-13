# Level 1 Exercises

Complete these exercises to master Dart fundamentals.

---

## Exercise 1: Hello You ⭐

**Difficulty:** Beginner | **Time:** 5 minutes

### Task
Write a program that prints:
1. Your name
2. Your age
3. Your favorite color

### Expected Output
```
My name is [your name]
I am [your age] years old
My favorite color is [your color]
```

<details>
<summary>Solution</summary>

```dart
void main() {
  print('My name is Alex');
  print('I am 25 years old');
  print('My favorite color is blue');
}
```
</details>

---

## Exercise 2: Variables Practice ⭐

**Difficulty:** Beginner | **Time:** 10 minutes

### Task
Create variables for a book:
- Title (String)
- Author (String)
- Pages (int)
- Price (double)
- Is available (bool)

Print all the information in a nice format.

### Expected Output
```
Book: The Great Gatsby
Author: F. Scott Fitzgerald
Pages: 180
Price: $12.99
Available: Yes
```

<details>
<summary>Solution</summary>

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

## Exercise 3: String Manipulation ⭐⭐

**Difficulty:** Beginner-Intermediate | **Time:** 15 minutes

### Task
Given a full name string:
1. Print it in uppercase
2. Print it in lowercase
3. Print the number of characters
4. Print the first letter
5. Check if it contains "Smith"

### Start With
```dart
String fullName = 'John Smith';
```

### Expected Output
```
Original: John Smith
Uppercase: JOHN SMITH
Lowercase: john smith
Length: 10
First letter: J
Contains Smith: true
```

<details>
<summary>Solution</summary>

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

## Exercise 4: Simple Calculator ⭐⭐

**Difficulty:** Beginner-Intermediate | **Time:** 15 minutes

### Task
Create two number variables and print:
1. Their sum
2. Their difference
3. Their product
4. Their quotient (with 2 decimal places)
5. The remainder when divided

### Start With
```dart
int num1 = 17;
int num2 = 5;
```

### Expected Output
```
Numbers: 17 and 5
Sum: 22
Difference: 12
Product: 85
Quotient: 3.40
Remainder: 2
```

<details>
<summary>Solution</summary>

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

## Exercise 5: Temperature Converter ⭐⭐

**Difficulty:** Intermediate | **Time:** 15 minutes

### Task
Convert temperatures:
1. Convert 100°F to Celsius
2. Convert 0°C to Fahrenheit
3. Convert 37°C to Fahrenheit (body temperature)

**Formula:**
- F to C: (F - 32) × 5/9
- C to F: (C × 9/5) + 32

### Expected Output
```
100°F = 37.8°C
0°C = 32.0°F
37°C = 98.6°F
```

<details>
<summary>Solution</summary>

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

## Exercise 6: Area Calculator ⭐⭐

**Difficulty:** Intermediate | **Time:** 15 minutes

### Task
Calculate the area and perimeter of:
1. A rectangle (width: 10, height: 5)
2. A square (side: 7)
3. A circle (radius: 4) - use 3.14159 for pi

### Expected Output
```
Rectangle: Area = 50, Perimeter = 30
Square: Area = 49, Perimeter = 28
Circle: Area = 50.27, Circumference = 25.13
```

<details>
<summary>Solution</summary>

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

## Exercise 7: Mad Libs ⭐⭐

**Difficulty:** Intermediate | **Time:** 20 minutes

### Task
Create a Mad Libs story using variables:
- A noun (thing)
- An adjective (describing word)
- A verb (action word)
- A place
- A number

Then print a funny story using these variables.

### Example Output
```
One day, a giant elephant decided to dance
in the middle of Paris.
It happened exactly 42 times!
Everyone was amazed.
```

<details>
<summary>Solution</summary>

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

## Exercise 8: User Profile Card ⭐⭐⭐

**Difficulty:** Intermediate-Advanced | **Time:** 25 minutes

### Task
Create a complete user profile with:
- Name, username, email
- Age, followers, following
- Rating (1-5), account balance
- Is verified, is online

Print a formatted profile card.

### Expected Output
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

<details>
<summary>Solution</summary>

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
  int emptyStars = 5 - fullStars;
  String stars = '★' * fullStars + '☆' * emptyStars;

  // Print profile
  print('╔════════════════════════════════════╗');
  print('║         USER PROFILE               ║');
  print('╠════════════════════════════════════╣');
  print('║ Name: $name');
  print('║ Username: $username');
  print('║ Email: $email');
  print('╠════════════════════════════════════╣');
  print('║ Age: $age          Verified: ${isVerified ? '✓' : '✗'}');
  print('║ Followers: $followers  Following: $following');
  print('║ Rating: $stars ($rating)');
  print('║ Balance: \$${balance.toStringAsFixed(2)}');
  print('╠════════════════════════════════════╣');
  print('║ Status: ${isOnline ? '🟢 Online' : '⚫ Offline'}');
  print('╚════════════════════════════════════╝');
}
```
</details>

---

## Exercise 9: Receipt Generator ⭐⭐⭐

**Difficulty:** Advanced | **Time:** 25 minutes

### Task
Create a shopping receipt:
- 3 items with names and prices
- Calculate subtotal
- Apply 8% tax
- Calculate total
- Show payment and change

### Expected Output
```
========== RECEIPT ==========
Coffee Mug        $12.99
Notebook          $8.50
Pen Set           $15.00
-----------------------------
Subtotal:         $36.49
Tax (8%):         $2.92
-----------------------------
TOTAL:            $39.41
-----------------------------
Payment:          $50.00
Change:           $10.59
=============================
Thank you for shopping!
```

<details>
<summary>Solution</summary>

```dart
void main() {
  // Items
  String item1 = 'Coffee Mug';
  double price1 = 12.99;

  String item2 = 'Notebook';
  double price2 = 8.50;

  String item3 = 'Pen Set';
  double price3 = 15.00;

  // Calculations
  double subtotal = price1 + price2 + price3;
  double taxRate = 0.08;
  double tax = subtotal * taxRate;
  double total = subtotal + tax;

  double payment = 50.00;
  double change = payment - total;

  // Print receipt
  print('========== RECEIPT ==========');
  print('$item1        \$${price1.toStringAsFixed(2)}');
  print('$item2          \$${price2.toStringAsFixed(2)}');
  print('$item3           \$${price3.toStringAsFixed(2)}');
  print('-----------------------------');
  print('Subtotal:         \$${subtotal.toStringAsFixed(2)}');
  print('Tax (8%):         \$${tax.toStringAsFixed(2)}');
  print('-----------------------------');
  print('TOTAL:            \$${total.toStringAsFixed(2)}');
  print('-----------------------------');
  print('Payment:          \$${payment.toStringAsFixed(2)}');
  print('Change:           \$${change.toStringAsFixed(2)}');
  print('=============================');
  print('Thank you for shopping!');
}
```
</details>

---

## Self-Assessment Checklist

Before moving to Level 2, make sure you can:

- [ ] Write and run a basic Dart program
- [ ] Create variables of different types (String, int, double, bool)
- [ ] Use string interpolation ($variable and ${expression})
- [ ] Perform basic arithmetic operations
- [ ] Convert between types (int, double, String)
- [ ] Use comparison operators (==, !=, <, >, <=, >=)
- [ ] Use logical operators (&&, ||, !)
- [ ] Use the ternary operator (condition ? ifTrue : ifFalse)
- [ ] Format numbers with toStringAsFixed()

---

## Bonus Challenge: BMI Calculator ⭐⭐⭐

Build a BMI (Body Mass Index) calculator:
- Input: weight (kg), height (m)
- Calculate: BMI = weight / (height * height)
- Print BMI and category:
  - Under 18.5: Underweight
  - 18.5 - 24.9: Normal
  - 25 - 29.9: Overweight
  - 30+: Obese

<details>
<summary>Solution</summary>

```dart
void main() {
  double weightKg = 70.0;
  double heightM = 1.75;

  double bmi = weightKg / (heightM * heightM);

  String category = bmi < 18.5 ? 'Underweight' :
                    bmi < 25 ? 'Normal' :
                    bmi < 30 ? 'Overweight' : 'Obese';

  print('Weight: $weightKg kg');
  print('Height: $heightM m');
  print('BMI: ${bmi.toStringAsFixed(1)}');
  print('Category: $category');
}
```
</details>

---

**Congratulations!** You've completed Level 1!

You now understand Dart fundamentals. Time to learn control flow!

---

**Continue to:** `../../Level-02-Control-Flow/README.md`
