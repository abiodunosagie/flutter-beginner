// Exercise 4: List Operations (Intermediate-Advanced)
// TODO: Create functions that work with lists

// TODO: Find maximum value in a list
double findMax(List<double> numbers) {
  // Your code here
  return 0.0;
}

// TODO: Calculate average of numbers
double calculateAverage(List<double> numbers) {
  // Your code here
  return 0.0;
}

// TODO: Remove duplicates from a list
List<T> removeDuplicates<T>(List<T> items) {
  // Your code here
  return [];
}

// TODO: Sort list in descending order
List<double> sortDescending(List<double> numbers) {
  // Your code here
  return [];
}

void main() {
  List<double> numbers = [45.5, 12.3, 78.9, 23.4, 56.7, 12.3, 45.5];

  print('Numbers: $numbers');
  print('Maximum: ${findMax(numbers)}');
  print('Average: ${calculateAverage(numbers).toStringAsFixed(2)}');
  print('Without duplicates: ${removeDuplicates(numbers)}');
  print('Descending: ${sortDescending(numbers)}');
}
