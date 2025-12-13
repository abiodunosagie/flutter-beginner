/// Exercise 5: Use TDD to Build a Grade Calculator
///
/// Level: Advanced
///
/// Task:
/// Use Test-Driven Development (TDD) to build a GradeCalculator class.
/// This means: WRITE TESTS FIRST, then implement the code to make tests pass!
///
/// Requirements:
/// 1. Follow the Red-Green-Refactor cycle:
///    RED: Write a failing test
///    GREEN: Write minimum code to pass the test
///    REFACTOR: Improve the code while keeping tests green
///
/// 2. Create GradeCalculator class with methods:
///    - String getLetterGrade(int score)
///    - double calculateGPA(List<int> scores)
///    - bool isPassing(int score)
///    - Map<String, int> getGradeDistribution(List<int> scores)
///
/// 3. Grading scale:
///    - 90-100: A (4.0)
///    - 80-89:  B (3.0)
///    - 70-79:  C (2.0)
///    - 60-69:  D (1.0)
///    - 0-59:   F (0.0)
///    - Passing grade: >= 60
///
/// 4. TDD Process:
///    Step 1: Write test for getLetterGrade with score 95 -> expect "A"
///    Step 2: Implement getLetterGrade to return "A" for 95
///    Step 3: Write test for score 85 -> expect "B"
///    Step 4: Update getLetterGrade to handle B grades
///    ... continue for all grades and edge cases
///
/// 5. Write tests FIRST in test/week_22/exercise_5_test.dart
///    Then implement code here to make tests pass

class GradeCalculator {
  // TODO: Implement getLetterGrade (write tests FIRST!)
  String getLetterGrade(int score) {
    throw UnimplementedError('Write tests first!');
  }

  // TODO: Implement calculateGPA (write tests FIRST!)
  // Returns average GPA of all scores
  double calculateGPA(List<int> scores) {
    throw UnimplementedError('Write tests first!');
  }

  // TODO: Implement isPassing (write tests FIRST!)
  bool isPassing(int score) {
    throw UnimplementedError('Write tests first!');
  }

  // TODO: Implement getGradeDistribution (write tests FIRST!)
  // Returns map like: {"A": 2, "B": 3, "C": 1, "D": 0, "F": 1}
  Map<String, int> getGradeDistribution(List<int> scores) {
    throw UnimplementedError('Write tests first!');
  }
}

// Example usage (after implementing):
void main() {
  final calculator = GradeCalculator();

  print('Grade for 95: ${calculator.getLetterGrade(95)}');
  print('Grade for 85: ${calculator.getLetterGrade(85)}');
  print('Grade for 75: ${calculator.getLetterGrade(75)}');
  print('Grade for 65: ${calculator.getLetterGrade(65)}');
  print('Grade for 55: ${calculator.getLetterGrade(55)}');

  final scores = [95, 87, 78, 92, 65, 58, 88];
  print('\nGPA: ${calculator.calculateGPA(scores)}');
  print('Distribution: ${calculator.getGradeDistribution(scores)}');
}
