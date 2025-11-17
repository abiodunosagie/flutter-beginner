// Exercise 1: Variables and Data Types (SOLUTION)
// This is an example solution - try to solve it yourself first!

void main() {
  // Declare variables
  String name = 'John Doe';
  int age = 25;
  double height = 1.75;
  bool likesFlutter = true;
  
  // Print with descriptive messages
  print('Name: $name');
  print('Age: $age years old');
  print('Height: ${height}m');
  print('Likes Flutter: $likesFlutter');
  
  // Bonus: String interpolation
  print('\nProfile Summary:');
  print('$name is $age years old, ${height}m tall, and ${likesFlutter ? "loves" : "doesn\'t like"} Flutter!');
}
