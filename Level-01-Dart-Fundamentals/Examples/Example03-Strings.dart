// ===========================================
// Example 03: Working with Strings
// All the ways to manipulate text
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Creating Strings
  // -----------------------------------------

  String single = 'Hello';        // Single quotes
  String double_ = "World";       // Double quotes (same thing)
  String empty = '';              // Empty string

  // Multi-line string
  String poem = '''
Roses are red,
Violets are blue,
Dart is great,
And so are you!
''';

  print('--- Creating Strings ---');
  print(single);
  print(double_);
  print('Empty string length: ${empty.length}');
  print(poem);

  // -----------------------------------------
  // PART 2: String Properties
  // -----------------------------------------

  String text = 'Hello, Dart!';

  print('--- String Properties ---');
  print('Text: $text');
  print('Length: ${text.length}');
  print('Is empty: ${text.isEmpty}');
  print('Is not empty: ${text.isNotEmpty}');

  // -----------------------------------------
  // PART 3: Changing Case
  // -----------------------------------------

  String name = 'Alex Smith';

  print('\n--- Changing Case ---');
  print('Original: $name');
  print('Uppercase: ${name.toUpperCase()}');
  print('Lowercase: ${name.toLowerCase()}');

  // -----------------------------------------
  // PART 4: Trimming Whitespace
  // -----------------------------------------

  String messy = '   Hello World   ';

  print('\n--- Trimming ---');
  print('Original: "$messy"');
  print('Trimmed: "${messy.trim()}"');

  // -----------------------------------------
  // PART 5: Checking Content
  // -----------------------------------------

  String email = 'alex@example.com';

  print('\n--- Checking Content ---');
  print('Email: $email');
  print('Contains @: ${email.contains('@')}');
  print('Starts with alex: ${email.startsWith('alex')}');
  print('Ends with .com: ${email.endsWith('.com')}');

  // -----------------------------------------
  // PART 6: Finding and Replacing
  // -----------------------------------------

  String sentence = 'I love cats. Cats are great.';

  print('\n--- Finding and Replacing ---');
  print('Original: $sentence');
  print('Index of "cats": ${sentence.indexOf('cats')}');
  print('Replace cats with dogs: ${sentence.replaceAll('cats', 'dogs').replaceAll('Cats', 'Dogs')}');

  // -----------------------------------------
  // PART 7: Splitting Strings
  // -----------------------------------------

  String csv = 'apple,banana,cherry';
  List<String> fruits = csv.split(',');

  print('\n--- Splitting ---');
  print('CSV: $csv');
  print('Split result: $fruits');
  print('First fruit: ${fruits[0]}');

  // -----------------------------------------
  // PART 8: Substring
  // -----------------------------------------

  String word = 'Flutter';
  // Index:      0123456

  print('\n--- Substring ---');
  print('Word: $word');
  print('First 4 chars: ${word.substring(0, 4)}');   // Flut
  print('From index 4: ${word.substring(4)}');       // ter

  // -----------------------------------------
  // PART 9: Accessing Characters
  // -----------------------------------------

  String letters = 'ABCDE';

  print('\n--- Accessing Characters ---');
  print('Word: $letters');
  print('Index 0: ${letters[0]}');  // A
  print('Index 2: ${letters[2]}');  // C
  print('Last: ${letters[letters.length - 1]}');  // E

  // -----------------------------------------
  // PART 10: Escape Characters
  // -----------------------------------------

  print('\n--- Escape Characters ---');
  print('New\nLine');           // New line
  print('Tab\there');           // Tab
  print('Quote: "Hello"');      // Quotes
  print('It\'s OK');            // Apostrophe
}

// ===========================================
// Try it yourself:
// 1. Create a string with your full name
// 2. Print it in uppercase and lowercase
// 3. Check if it contains a specific letter
// 4. Get just your first name using substring
// ===========================================
