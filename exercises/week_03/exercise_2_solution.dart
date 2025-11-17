// Exercise 2: Student Grades (SOLUTION)

void main() {
  print('=== Student Grade Manager ===\n');

  // Create Map for student grades
  Map<String, double> studentGrades = {
    'Alice': 92.5,
    'Bob': 87.0,
    'Charlie': 95.5,
    'Diana': 88.5,
    'Eve': 90.0,
  };

  print('✓ Added ${studentGrades.length} students\n');

  // Update a student's grade
  studentGrades['Bob'] = 89.5;
  print('✓ Updated Bob\'s grade to 89.5\n');

  // Calculate class average
  double sum = 0;
  for (double grade in studentGrades.values) {
    sum += grade;
  }
  double average = sum / studentGrades.length;
  print('Class Average: ${average.toStringAsFixed(2)}');

  // Find highest grade
  double highest = 0;
  String topStudent = '';
  studentGrades.forEach((name, grade) {
    if (grade > highest) {
      highest = grade;
      topStudent = name;
    }
  });
  print('Highest Grade: $highest ($topStudent)\n');

  // List all students
  print('All Students:');
  studentGrades.forEach((name, grade) {
    print('$name: $grade ${grade >= 90 ? "🌟" : ""}');
  });
}
