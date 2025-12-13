// ===========================================
// Example 05: Type Conversion
// Converting between different types
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: String to Number
  // -----------------------------------------

  print('--- String to Number ---');

  // String to int
  String ageText = '25';
  int age = int.parse(ageText);
  print('String "$ageText" → int $age');

  // String to double
  String priceText = '19.99';
  double price = double.parse(priceText);
  print('String "$priceText" → double $price');

  // -----------------------------------------
  // PART 2: Safe Parsing (won't crash)
  // -----------------------------------------

  print('\n--- Safe Parsing ---');

  String goodNumber = '42';
  String badNumber = 'hello';

  // tryParse returns null if it fails (doesn't crash)
  int? result1 = int.tryParse(goodNumber);
  int? result2 = int.tryParse(badNumber);

  print('Parse "$goodNumber": $result1');
  print('Parse "$badNumber": $result2');

  // Using ?? to provide a default
  int safeResult = int.tryParse(badNumber) ?? 0;
  print('Safe parse "$badNumber" with default: $safeResult');

  // -----------------------------------------
  // PART 3: Number to String
  // -----------------------------------------

  print('\n--- Number to String ---');

  int count = 42;
  double amount = 3.14159;

  String countText = count.toString();
  String amountText = amount.toString();

  print('int $count → String "$countText"');
  print('double $amount → String "$amountText"');

  // Formatting decimals
  String formatted = amount.toStringAsFixed(2);
  print('Formatted (2 decimals): "$formatted"');

  // -----------------------------------------
  // PART 4: Between int and double
  // -----------------------------------------

  print('\n--- int ↔ double ---');

  int whole = 42;
  double decimal = whole.toDouble();
  print('int $whole → double $decimal');

  double pi = 3.14159;
  int truncated = pi.toInt();
  int rounded = pi.round();
  print('double $pi → int (truncate) $truncated');
  print('double $pi → int (round) $rounded');

  // -----------------------------------------
  // PART 5: Practical Example - User Input
  // -----------------------------------------

  print('\n--- Practical: Processing User Input ---');

  // Imagine this came from a text field
  String userInput = '  42.5  ';

  // Step 1: Clean it up (remove spaces)
  String cleaned = userInput.trim();
  print('Cleaned input: "$cleaned"');

  // Step 2: Try to parse as double
  double? value = double.tryParse(cleaned);

  // Step 3: Check if it worked
  if (value != null) {
    print('Valid number: $value');
    print('Doubled: ${value * 2}');
  } else {
    print('Invalid input!');
  }

  // -----------------------------------------
  // PART 6: Bool to String and Back
  // -----------------------------------------

  print('\n--- Bool Conversion ---');

  bool isActive = true;
  String boolText = isActive.toString();
  print('bool $isActive → String "$boolText"');

  // String to bool (manual)
  String trueText = 'true';
  bool fromString = trueText.toLowerCase() == 'true';
  print('String "$trueText" → bool $fromString');
}

// ===========================================
// Try it yourself:
// 1. Parse a string "100" to int and double it
// 2. Try parsing "abc" - see what tryParse returns
// 3. Convert 3.99999 to int (what happens?)
// 4. Format 1234.5 to show exactly 3 decimal places
// ===========================================
