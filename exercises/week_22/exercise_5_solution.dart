/// Exercise 5 Solution: Use TDD to Build a Grade Calculator
///
/// This solution was built using Test-Driven Development:
/// 1. Tests were written first (see test file)
/// 2. Code was implemented to pass tests
/// 3. Code was refactored while keeping tests green
///
/// This demonstrates proper TDD workflow and comprehensive grade calculation logic

class GradeCalculator {
  // Grade boundaries
  static const int gradeA = 90;
  static const int gradeB = 80;
  static const int gradeC = 70;
  static const int gradeD = 60;
  static const int passingScore = 60;

  String getLetterGrade(int score) {
    if (score < 0 || score > 100) {
      throw ArgumentError('Score must be between 0 and 100');
    }

    if (score >= gradeA) return 'A';
    if (score >= gradeB) return 'B';
    if (score >= gradeC) return 'C';
    if (score >= gradeD) return 'D';
    return 'F';
  }

  double calculateGPA(List<int> scores) {
    if (scores.isEmpty) {
      throw ArgumentError('Cannot calculate GPA for empty list');
    }

    double totalGPA = 0.0;

    for (final score in scores) {
      totalGPA += _getGradePoint(score);
    }

    return totalGPA / scores.length;
  }

  double _getGradePoint(int score) {
    final grade = getLetterGrade(score);

    switch (grade) {
      case 'A':
        return 4.0;
      case 'B':
        return 3.0;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'F':
        return 0.0;
      default:
        return 0.0;
    }
  }

  bool isPassing(int score) {
    if (score < 0 || score > 100) {
      throw ArgumentError('Score must be between 0 and 100');
    }

    return score >= passingScore;
  }

  Map<String, int> getGradeDistribution(List<int> scores) {
    final distribution = {
      'A': 0,
      'B': 0,
      'C': 0,
      'D': 0,
      'F': 0,
    };

    for (final score in scores) {
      final grade = getLetterGrade(score);
      distribution[grade] = (distribution[grade] ?? 0) + 1;
    }

    return distribution;
  }

  // Bonus methods

  /// Gets the highest score from the list
  int getHighestScore(List<int> scores) {
    if (scores.isEmpty) {
      throw ArgumentError('Cannot find highest score in empty list');
    }
    return scores.reduce((a, b) => a > b ? a : b);
  }

  /// Gets the lowest score from the list
  int getLowestScore(List<int> scores) {
    if (scores.isEmpty) {
      throw ArgumentError('Cannot find lowest score in empty list');
    }
    return scores.reduce((a, b) => a < b ? a : b);
  }

  /// Calculates the average score
  double getAverageScore(List<int> scores) {
    if (scores.isEmpty) {
      throw ArgumentError('Cannot calculate average of empty list');
    }
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  /// Gets the median score
  double getMedianScore(List<int> scores) {
    if (scores.isEmpty) {
      throw ArgumentError('Cannot calculate median of empty list');
    }

    final sorted = List<int>.from(scores)..sort();
    final middle = sorted.length ~/ 2;

    if (sorted.length % 2 == 0) {
      return (sorted[middle - 1] + sorted[middle]) / 2.0;
    } else {
      return sorted[middle].toDouble();
    }
  }

  /// Checks if a grade is on the honor roll (all A's and B's)
  bool isHonorRoll(List<int> scores) {
    if (scores.isEmpty) return false;

    return scores.every((score) {
      final grade = getLetterGrade(score);
      return grade == 'A' || grade == 'B';
    });
  }
}

// Example usage:
void main() {
  final calculator = GradeCalculator();

  print('=== Letter Grades ===');
  final sampleScores = [95, 85, 75, 65, 55, 100, 90, 80, 70, 60, 59, 0];
  for (final score in sampleScores) {
    print('Score $score: ${calculator.getLetterGrade(score)}');
  }

  print('\n=== GPA Calculation ===');
  final classScores = [95, 87, 78, 92, 65, 58, 88, 91, 73, 82];
  print('Scores: $classScores');
  print('GPA: ${calculator.calculateGPA(classScores).toStringAsFixed(2)}');
  print('Average: ${calculator.getAverageScore(classScores).toStringAsFixed(2)}');
  print('Median: ${calculator.getMedianScore(classScores).toStringAsFixed(2)}');
  print('Highest: ${calculator.getHighestScore(classScores)}');
  print('Lowest: ${calculator.getLowestScore(classScores)}');

  print('\n=== Grade Distribution ===');
  final distribution = calculator.getGradeDistribution(classScores);
  distribution.forEach((grade, count) {
    print('$grade: $count students');
  });

  print('\n=== Passing Status ===');
  for (final score in [65, 60, 59, 55]) {
    print('Score $score: ${calculator.isPassing(score) ? "PASS" : "FAIL"}');
  }

  print('\n=== Honor Roll ===');
  final honorRollScores = [95, 87, 92, 88, 91];
  final mixedScores = [95, 87, 75, 92, 88];
  print('Scores $honorRollScores: ${calculator.isHonorRoll(honorRollScores) ? "YES" : "NO"}');
  print('Scores $mixedScores: ${calculator.isHonorRoll(mixedScores) ? "YES" : "NO"}');
}
