// ===========================================
// Example 03: Multiplication Table
// Using for loops
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Simple Counting
  // -----------------------------------------

  print('--- Counting 1 to 5 ---');
  for (int i = 1; i <= 5; i++) {
    print(i);
  }

  // -----------------------------------------
  // PART 2: Counting Down
  // -----------------------------------------

  print('\n--- Countdown ---');
  for (int i = 5; i >= 1; i--) {
    print(i);
  }
  print('Blast off!');

  // -----------------------------------------
  // PART 3: Single Multiplication Table
  // -----------------------------------------

  int number = 7;

  print('\n--- $number Times Table ---');
  for (int i = 1; i <= 10; i++) {
    print('$number × $i = ${number * i}');
  }

  // -----------------------------------------
  // PART 4: Sum of Numbers
  // -----------------------------------------

  int sum = 0;
  for (int i = 1; i <= 100; i++) {
    sum += i;
  }
  print('\n--- Sum ---');
  print('Sum of 1 to 100: $sum');

  // -----------------------------------------
  // PART 5: Even Numbers
  // -----------------------------------------

  print('\n--- Even Numbers 1-20 ---');
  for (int i = 2; i <= 20; i += 2) {
    print(i);
  }

  // -----------------------------------------
  // PART 6: Loop Through a List
  // -----------------------------------------

  List<String> fruits = ['Apple', 'Banana', 'Cherry', 'Date'];

  print('\n--- Using Index ---');
  for (int i = 0; i < fruits.length; i++) {
    print('${i + 1}. ${fruits[i]}');
  }

  print('\n--- Using For-In ---');
  for (String fruit in fruits) {
    print('I like $fruit');
  }

  // -----------------------------------------
  // PART 7: Nested Loops - Full Table
  // -----------------------------------------

  print('\n--- Multiplication Table 1-5 ---');
  for (int i = 1; i <= 5; i++) {
    String row = '';
    for (int j = 1; j <= 5; j++) {
      int product = i * j;
      // Pad numbers for alignment
      row += '${product.toString().padLeft(3)} ';
    }
    print(row);
  }

  // -----------------------------------------
  // PART 8: Pattern - Triangle
  // -----------------------------------------

  print('\n--- Star Triangle ---');
  for (int i = 1; i <= 5; i++) {
    print('*' * i);
  }

  // -----------------------------------------
  // PART 9: Pattern - Pyramid
  // -----------------------------------------

  int height = 5;
  print('\n--- Pyramid ---');
  for (int i = 1; i <= height; i++) {
    String spaces = ' ' * (height - i);
    String stars = '*' * (2 * i - 1);
    print(spaces + stars);
  }

  // -----------------------------------------
  // PART 10: Factorial
  // -----------------------------------------

  int n = 6;
  int factorial = 1;

  for (int i = 1; i <= n; i++) {
    factorial *= i;
  }

  print('\n--- Factorial ---');
  print('$n! = $factorial');
}

// ===========================================
// Try it yourself:
// 1. Make a table for any number
// 2. Print only odd numbers from 1-50
// 3. Create an inverted pyramid
// 4. Calculate the sum of squares (1² + 2² + 3² + ...)
// ===========================================
