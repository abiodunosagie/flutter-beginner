// ===========================================
// Example 02: Variables
// Storing and using data
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: The Four Basic Types
  // -----------------------------------------

  // String - for text
  String name = 'Alex';
  String city = 'New York';

  // int - for whole numbers
  int age = 25;
  int year = 2024;

  // double - for decimal numbers
  double price = 19.99;
  double temperature = 72.5;

  // bool - for true/false
  bool isStudent = true;
  bool hasJob = false;

  print('--- Basic Types ---');
  print('Name: $name');
  print('Age: $age');
  print('Price: $price');
  print('Is student: $isStudent');

  // -----------------------------------------
  // PART 2: Using var (type inference)
  // -----------------------------------------

  // Dart figures out the type automatically
  var firstName = 'John';    // Dart knows it's String
  var count = 10;            // Dart knows it's int
  var amount = 99.99;        // Dart knows it's double
  var active = true;         // Dart knows it's bool

  print('\n--- Using var ---');
  print('First name: $firstName');
  print('Count: $count');

  // -----------------------------------------
  // PART 3: Changing values
  // -----------------------------------------

  int score = 0;
  print('\n--- Changing Values ---');
  print('Score: $score');

  score = 10;
  print('Score: $score');

  score = 25;
  print('Score: $score');

  // -----------------------------------------
  // PART 4: Constants (can't change)
  // -----------------------------------------

  final String country = 'USA';   // Set once, never changes
  const double pi = 3.14159;      // Known at compile time

  print('\n--- Constants ---');
  print('Country: $country');
  print('Pi: $pi');

  // This would cause an error:
  // country = 'Canada';  // ERROR! Can't change final
  // pi = 3.14;           // ERROR! Can't change const

  // -----------------------------------------
  // PART 5: String Interpolation
  // -----------------------------------------

  String personName = 'Sarah';
  int personAge = 30;

  print('\n--- String Interpolation ---');

  // Simple variable
  print('Hello, $personName!');

  // Expression (needs curly braces)
  print('Next year you will be ${personAge + 1}');

  // Multiple variables
  print('$personName is $personAge years old');
}

// ===========================================
// Try it yourself:
// 1. Create variables for your own info
// 2. Print them using interpolation
// 3. Try changing a final variable (see the error)
// 4. Create a variable with var and try changing its type
// ===========================================
