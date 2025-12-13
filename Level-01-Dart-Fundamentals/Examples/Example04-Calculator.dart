// ===========================================
// Example 04: Simple Calculator
// Working with numbers and math
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Basic Arithmetic
  // -----------------------------------------

  int a = 20;
  int b = 7;

  print('--- Basic Arithmetic ---');
  print('a = $a, b = $b');
  print('');
  print('Addition:       $a + $b = ${a + b}');
  print('Subtraction:    $a - $b = ${a - b}');
  print('Multiplication: $a * $b = ${a * b}');
  print('Division:       $a / $b = ${a / b}');
  print('Int Division:   $a ~/ $b = ${a ~/ b}');
  print('Remainder:      $a % $b = ${a % b}');

  // -----------------------------------------
  // PART 2: Working with Decimals
  // -----------------------------------------

  double price = 19.99;
  double taxRate = 0.08;
  double tax = price * taxRate;
  double total = price + tax;

  print('\n--- Working with Decimals ---');
  print('Price: \$${price.toStringAsFixed(2)}');
  print('Tax (8%): \$${tax.toStringAsFixed(2)}');
  print('Total: \$${total.toStringAsFixed(2)}');

  // -----------------------------------------
  // PART 3: Increment and Decrement
  // -----------------------------------------

  int counter = 0;

  print('\n--- Increment/Decrement ---');
  print('Start: $counter');

  counter++;
  print('After ++: $counter');

  counter++;
  print('After ++: $counter');

  counter--;
  print('After --: $counter');

  // -----------------------------------------
  // PART 4: Compound Assignment
  // -----------------------------------------

  int score = 100;

  print('\n--- Compound Assignment ---');
  print('Start: $score');

  score += 10;  // Add 10
  print('After += 10: $score');

  score -= 25;  // Subtract 25
  print('After -= 25: $score');

  score *= 2;   // Multiply by 2
  print('After *= 2: $score');

  // -----------------------------------------
  // PART 5: Number Properties
  // -----------------------------------------

  int number = -42;
  double decimal = 3.7;

  print('\n--- Number Properties ---');
  print('Number: $number');
  print('Is negative: ${number.isNegative}');
  print('Is even: ${number.isEven}');
  print('Absolute value: ${number.abs()}');

  print('\nDecimal: $decimal');
  print('Round: ${decimal.round()}');
  print('Floor: ${decimal.floor()}');
  print('Ceil: ${decimal.ceil()}');

  // -----------------------------------------
  // PART 6: Practical Calculations
  // -----------------------------------------

  // Temperature conversion
  double celsius = 25.0;
  double fahrenheit = (celsius * 9 / 5) + 32;

  print('\n--- Temperature Conversion ---');
  print('$celsius°C = $fahrenheit°F');

  // Calculate average
  int test1 = 85;
  int test2 = 92;
  int test3 = 78;
  double average = (test1 + test2 + test3) / 3;

  print('\n--- Calculate Average ---');
  print('Tests: $test1, $test2, $test3');
  print('Average: ${average.toStringAsFixed(1)}');

  // Tip calculator
  double bill = 45.00;
  double tipPercent = 0.18;
  double tip = bill * tipPercent;
  double totalBill = bill + tip;

  print('\n--- Tip Calculator ---');
  print('Bill: \$${bill.toStringAsFixed(2)}');
  print('Tip (18%): \$${tip.toStringAsFixed(2)}');
  print('Total: \$${totalBill.toStringAsFixed(2)}');
}

// ===========================================
// Try it yourself:
// 1. Calculate your age in days (age * 365)
// 2. Convert a temperature from F to C
// 3. Calculate the area of a rectangle
// 4. Split a bill between 3 people
// ===========================================
