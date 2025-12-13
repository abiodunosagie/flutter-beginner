// ===========================================
// Example 01: Grade Checker
// Using if-else statements
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Simple Grade Check
  // -----------------------------------------

  int score = 85;

  print('--- Simple Grade Check ---');
  print('Score: $score');

  if (score >= 90) {
    print('Grade: A - Excellent!');
  } else if (score >= 80) {
    print('Grade: B - Good job!');
  } else if (score >= 70) {
    print('Grade: C - Passed');
  } else if (score >= 60) {
    print('Grade: D - Needs work');
  } else {
    print('Grade: F - Failed');
  }

  // -----------------------------------------
  // PART 2: With Plus/Minus Grades
  // -----------------------------------------

  int score2 = 87;

  print('\n--- Plus/Minus Grades ---');
  print('Score: $score2');

  String grade;
  String modifier = '';

  // Get letter grade
  if (score2 >= 90) {
    grade = 'A';
  } else if (score2 >= 80) {
    grade = 'B';
  } else if (score2 >= 70) {
    grade = 'C';
  } else if (score2 >= 60) {
    grade = 'D';
  } else {
    grade = 'F';
  }

  // Get modifier (if not F)
  if (grade != 'F') {
    int lastDigit = score2 % 10;
    if (lastDigit >= 7) {
      modifier = '+';
    } else if (lastDigit <= 2) {
      modifier = '-';
    }
  }

  print('Grade: $grade$modifier');

  // -----------------------------------------
  // PART 3: Pass/Fail with Message
  // -----------------------------------------

  int score3 = 55;

  print('\n--- Pass/Fail ---');
  print('Score: $score3');

  if (score3 >= 60) {
    print('Result: PASSED');
    if (score3 >= 90) {
      print('Honors list!');
    }
  } else {
    print('Result: FAILED');
    int needed = 60 - score3;
    print('You needed $needed more points to pass.');
  }

  // -----------------------------------------
  // PART 4: Multiple Conditions
  // -----------------------------------------

  int testScore = 75;
  int homeworkScore = 90;
  int attendancePercent = 85;

  print('\n--- Multiple Requirements ---');
  print('Test: $testScore, Homework: $homeworkScore, Attendance: $attendancePercent%');

  bool passedTest = testScore >= 60;
  bool passedHomework = homeworkScore >= 70;
  bool goodAttendance = attendancePercent >= 80;

  if (passedTest && passedHomework && goodAttendance) {
    print('All requirements met!');
  } else {
    print('Missing requirements:');
    if (!passedTest) print('- Need higher test score');
    if (!passedHomework) print('- Need higher homework score');
    if (!goodAttendance) print('- Need better attendance');
  }

  // -----------------------------------------
  // PART 5: Using Ternary Operator
  // -----------------------------------------

  int finalScore = 78;

  print('\n--- Ternary Operator ---');

  String result = finalScore >= 60 ? 'Pass' : 'Fail';
  String emoji = finalScore >= 60 ? '✓' : '✗';

  print('Score: $finalScore → $result $emoji');
}

// ===========================================
// Try it yourself:
// 1. Change the scores and see different outputs
// 2. Add an A+ grade for scores 97 and above
// 3. Add extra credit handling (scores over 100)
// ===========================================
