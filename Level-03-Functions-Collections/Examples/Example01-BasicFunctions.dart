// ===========================================
// Example 01: Basic Functions
// Creating and calling functions
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Simple Function (No Parameters)
  // -----------------------------------------

  print('--- Simple Functions ---');

  sayHello();
  sayGoodbye();

  // -----------------------------------------
  // PART 2: Functions with Parameters
  // -----------------------------------------

  print('\n--- Functions with Parameters ---');

  greet('Alice');
  greet('Bob');
  greet('Charlie');

  // -----------------------------------------
  // PART 3: Functions with Multiple Parameters
  // -----------------------------------------

  print('\n--- Multiple Parameters ---');

  introduce('Alice', 25);
  introduce('Bob', 30);

  // -----------------------------------------
  // PART 4: Functions that Return Values
  // -----------------------------------------

  print('\n--- Return Values ---');

  int sum = add(5, 3);
  print('5 + 3 = $sum');

  int product = multiply(4, 7);
  print('4 × 7 = $product');

  // Can use directly in expressions
  print('10 + 20 = ${add(10, 20)}');
  print('Sum of sums: ${add(add(1, 2), add(3, 4))}');

  // -----------------------------------------
  // PART 5: Functions Returning Different Types
  // -----------------------------------------

  print('\n--- Different Return Types ---');

  String message = createGreeting('Alice');
  print(message);

  bool adult = isAdult(25);
  print('25 years old is adult: $adult');

  double avg = average(10, 20);
  print('Average of 10 and 20: $avg');

  // -----------------------------------------
  // PART 6: Early Return
  // -----------------------------------------

  print('\n--- Early Return ---');

  String grade1 = getGrade(85);
  String grade2 = getGrade(-5);
  String grade3 = getGrade(150);

  print('Score 85: $grade1');
  print('Score -5: $grade2');
  print('Score 150: $grade3');

  // -----------------------------------------
  // PART 7: Void vs Return
  // -----------------------------------------

  print('\n--- Void vs Return ---');

  // Void function - does something, returns nothing
  printSquare(5);

  // Return function - gives back a value
  int sq = calculateSquare(5);
  print('Square of 5 (returned): $sq');

  // -----------------------------------------
  // PART 8: Using Functions in Loops
  // -----------------------------------------

  print('\n--- Functions in Loops ---');

  for (int i = 1; i <= 5; i++) {
    print('$i squared = ${calculateSquare(i)}');
  }

  // -----------------------------------------
  // PART 9: Functions Calling Functions
  // -----------------------------------------

  print('\n--- Functions Calling Functions ---');

  printRectangleInfo(5, 3);
  printRectangleInfo(10, 4);

  // -----------------------------------------
  // PART 10: Real World Example - Temperature
  // -----------------------------------------

  print('\n--- Temperature Converter ---');

  double celsius = 25.0;
  double fahrenheit = celsiusToFahrenheit(celsius);
  print('$celsius°C = $fahrenheit°F');

  double f = 98.6;
  double c = fahrenheitToCelsius(f);
  print('$f°F = ${c.toStringAsFixed(1)}°C');
}

// ===========================================
// FUNCTION DEFINITIONS
// ===========================================

// Simple function - no parameters, no return
void sayHello() {
  print('Hello, World!');
}

void sayGoodbye() {
  print('Goodbye!');
}

// Function with one parameter
void greet(String name) {
  print('Hello, $name!');
}

// Function with multiple parameters
void introduce(String name, int age) {
  print('My name is $name and I am $age years old.');
}

// Function returning int
int add(int a, int b) {
  return a + b;
}

int multiply(int a, int b) {
  return a * b;
}

// Function returning String
String createGreeting(String name) {
  return 'Welcome, $name! Nice to meet you.';
}

// Function returning bool
bool isAdult(int age) {
  return age >= 18;
}

// Function returning double
double average(int a, int b) {
  return (a + b) / 2;
}

// Function with early return
String getGrade(int score) {
  // Early return for invalid scores
  if (score < 0) {
    return 'Invalid: Score cannot be negative';
  }
  if (score > 100) {
    return 'Invalid: Score cannot exceed 100';
  }

  // Normal grading
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}

// Void function - just prints
void printSquare(int n) {
  print('Square of $n (printed): ${n * n}');
}

// Return function - gives back value
int calculateSquare(int n) {
  return n * n;
}

// Functions calling other functions
int calculateArea(int length, int width) {
  return length * width;
}

int calculatePerimeter(int length, int width) {
  return 2 * (length + width);
}

void printRectangleInfo(int length, int width) {
  int area = calculateArea(length, width);
  int perimeter = calculatePerimeter(length, width);

  print('Rectangle ${length}x$width:');
  print('  Area: $area');
  print('  Perimeter: $perimeter');
}

// Temperature conversion functions
double celsiusToFahrenheit(double celsius) {
  return celsius * 9 / 5 + 32;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;
}

// ===========================================
// Try it yourself:
// 1. Create a function that calculates BMI
// 2. Create a function that checks if a year is a leap year
// 3. Create a function that returns the maximum of three numbers
// ===========================================
