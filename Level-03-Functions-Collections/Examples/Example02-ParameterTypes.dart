// ===========================================
// Example 02: Parameter Types
// Required, optional, and named parameters
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Required Positional Parameters
  // -----------------------------------------

  print('--- Required Positional ---');

  // Must provide ALL parameters in ORDER
  printFullName('John', 'Doe');
  printFullName('Jane', 'Smith');

  // -----------------------------------------
  // PART 2: Optional Positional Parameters
  // -----------------------------------------

  print('\n--- Optional Positional ---');

  // Can omit optional parameters
  greetPerson('Alice');
  greetPerson('Bob', 'Hi');
  greetPerson('Charlie', 'Hey');

  // Multiple optional parameters
  describeItem('Laptop');
  describeItem('Laptop', 'Electronics');
  describeItem('Laptop', 'Electronics', 999.99);

  // -----------------------------------------
  // PART 3: Named Parameters
  // -----------------------------------------

  print('\n--- Named Parameters ---');

  // Order doesn't matter with named parameters
  createUser(name: 'Alice', age: 25, email: 'alice@email.com');
  createUser(email: 'bob@email.com', name: 'Bob', age: 30);

  // Can skip optional named parameters
  createUser(name: 'Charlie', email: 'charlie@email.com');

  // -----------------------------------------
  // PART 4: Required Named Parameters
  // -----------------------------------------

  print('\n--- Required Named Parameters ---');

  // Must provide required named parameters
  registerAccount(
    email: 'user@email.com',
    password: 'secret123',
  );

  registerAccount(
    email: 'another@email.com',
    password: 'mypassword',
    displayName: 'Another User',
  );

  // -----------------------------------------
  // PART 5: Default Values
  // -----------------------------------------

  print('\n--- Default Values ---');

  connect();
  connect(port: 8080);
  connect(host: '192.168.1.1');
  connect(host: 'example.com', port: 443, secure: true);

  // -----------------------------------------
  // PART 6: Mixing Parameter Types
  // -----------------------------------------

  print('\n--- Mixed Parameters ---');

  // Positional first, then named
  sendMessage('Hello!', to: 'Alice');
  sendMessage('How are you?', to: 'Bob', urgent: true);
  sendMessage('Meeting at 3pm', to: 'Team', cc: 'Manager', urgent: true);

  // -----------------------------------------
  // PART 7: Arrow Functions with Parameters
  // -----------------------------------------

  print('\n--- Arrow Functions ---');

  print('5 doubled: ${double5(5)}');
  print('Sum: ${quickAdd(10, 20)}');
  print('Full name: ${fullName('John', 'Doe')}');

  // -----------------------------------------
  // PART 8: Nullable Parameters
  // -----------------------------------------

  print('\n--- Nullable Parameters ---');

  printInfo('Alice');
  printInfo('Bob', age: 25);
  printInfo('Charlie', age: 30, city: 'NYC');

  // -----------------------------------------
  // PART 9: Functions as Parameters
  // -----------------------------------------

  print('\n--- Functions as Parameters ---');

  // Pass functions as arguments
  processNumbers([1, 2, 3, 4, 5], (n) => n * 2);
  processNumbers([1, 2, 3, 4, 5], (n) => n * n);

  // -----------------------------------------
  // PART 10: Real World Example - API Request
  // -----------------------------------------

  print('\n--- Real World: API Request ---');

  makeApiRequest(
    'https://api.example.com/users',
  );

  makeApiRequest(
    'https://api.example.com/users',
    method: 'POST',
    body: '{"name": "Alice"}',
    headers: {'Content-Type': 'application/json'},
  );

  makeApiRequest(
    'https://api.example.com/users/123',
    method: 'DELETE',
    timeout: 60,
  );
}

// ===========================================
// FUNCTION DEFINITIONS
// ===========================================

// Required positional - must provide both
void printFullName(String firstName, String lastName) {
  print('Full name: $firstName $lastName');
}

// Optional positional with default
void greetPerson(String name, [String greeting = 'Hello']) {
  print('$greeting, $name!');
}

// Multiple optional positional
void describeItem(String name, [String? category, double? price]) {
  print('Item: $name');
  if (category != null) print('  Category: $category');
  if (price != null) print('  Price: \$${price.toStringAsFixed(2)}');
}

// Named parameters (all optional by default)
void createUser({String? name, int? age, String? email}) {
  print('Creating user:');
  print('  Name: ${name ?? 'Unknown'}');
  print('  Age: ${age ?? 'Not specified'}');
  print('  Email: ${email ?? 'Not provided'}');
}

// Required named parameters
void registerAccount({
  required String email,
  required String password,
  String? displayName,
}) {
  print('Registering account:');
  print('  Email: $email');
  print('  Password: ${'*' * password.length}');
  print('  Display: ${displayName ?? email.split('@')[0]}');
}

// Named parameters with defaults
void connect({
  String host = 'localhost',
  int port = 3000,
  bool secure = false,
}) {
  String protocol = secure ? 'https' : 'http';
  print('Connecting to $protocol://$host:$port');
}

// Mixed: positional + named
void sendMessage(
  String message, {
  required String to,
  String? cc,
  bool urgent = false,
}) {
  print('Message: "$message"');
  print('  To: $to');
  if (cc != null) print('  CC: $cc');
  if (urgent) print('  [URGENT]');
}

// Arrow functions
int double5(int n) => n * 2;
int quickAdd(int a, int b) => a + b;
String fullName(String first, String last) => '$first $last';

// Nullable named parameters
void printInfo(String name, {int? age, String? city}) {
  print('Name: $name');
  if (age != null) print('  Age: $age');
  if (city != null) print('  City: $city');
}

// Function taking function as parameter
void processNumbers(List<int> numbers, int Function(int) operation) {
  var results = numbers.map(operation);
  print('Results: ${results.toList()}');
}

// Real world example: API request
void makeApiRequest(
  String url, {
  String method = 'GET',
  Map<String, String>? headers,
  String? body,
  int timeout = 30,
}) {
  print('API Request:');
  print('  $method $url');
  print('  Timeout: ${timeout}s');
  if (headers != null) {
    print('  Headers:');
    headers.forEach((key, value) => print('    $key: $value'));
  }
  if (body != null) print('  Body: $body');
}

// ===========================================
// Try it yourself:
// 1. Create a function with 3 optional named parameters
// 2. Create a function that takes a list and a filter function
// 3. Create a config function with sensible defaults
// ===========================================
