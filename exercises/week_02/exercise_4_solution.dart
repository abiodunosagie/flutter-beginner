// Exercise 4: List Operations (SOLUTION)

double findMax(List<double> numbers) {
  if (numbers.isEmpty) return 0.0;

  double max = numbers[0];
  for (double num in numbers) {
    if (num > max) {
      max = num;
    }
  }
  return max;
}

double calculateAverage(List<double> numbers) {
  if (numbers.isEmpty) return 0.0;

  double sum = 0;
  for (double num in numbers) {
    sum += num;
  }
  return sum / numbers.length;
}

List<T> removeDuplicates<T>(List<T> items) {
  return items.toSet().toList();
}

List<double> sortDescending(List<double> numbers) {
  List<double> sorted = List.from(numbers);
  sorted.sort((a, b) => b.compareTo(a));
  return sorted;
}

void main() {
  List<double> numbers = [45.5, 12.3, 78.9, 23.4, 56.7, 12.3, 45.5];

  print('=== List Operations ===');
  print('Numbers: $numbers');
  print('Maximum: ${findMax(numbers)}');
  print('Average: ${calculateAverage(numbers).toStringAsFixed(2)}');
  print('Without duplicates: ${removeDuplicates(numbers)}');
  print('Descending: ${sortDescending(numbers)}');

  // Test with different data
  print('\n=== More Examples ===');
  List<double> scores = [95.5, 87.3, 92.1, 88.8, 95.5];
  print('Test scores: $scores');
  print('Highest score: ${findMax(scores)}');
  print('Class average: ${calculateAverage(scores).toStringAsFixed(2)}');
}
