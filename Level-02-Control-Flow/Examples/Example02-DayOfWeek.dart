// ===========================================
// Example 02: Day of Week
// Using switch statements
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Basic Switch
  // -----------------------------------------

  int dayNumber = 3;

  print('--- Basic Switch ---');
  print('Day number: $dayNumber');

  switch (dayNumber) {
    case 1:
      print('Monday');
      break;
    case 2:
      print('Tuesday');
      break;
    case 3:
      print('Wednesday');
      break;
    case 4:
      print('Thursday');
      break;
    case 5:
      print('Friday');
      break;
    case 6:
      print('Saturday');
      break;
    case 7:
      print('Sunday');
      break;
    default:
      print('Invalid day');
  }

  // -----------------------------------------
  // PART 2: Grouping Cases
  // -----------------------------------------

  int day = 6;

  print('\n--- Weekday vs Weekend ---');

  switch (day) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
      print('It\'s a weekday');
      break;
    case 6:
    case 7:
      print('It\'s the weekend!');
      break;
    default:
      print('Invalid day');
  }

  // -----------------------------------------
  // PART 3: With String
  // -----------------------------------------

  String dayName = 'Friday';

  print('\n--- String Switch ---');
  print('Day: $dayName');

  switch (dayName.toLowerCase()) {
    case 'monday':
      print('Start of the week');
      break;
    case 'tuesday':
    case 'wednesday':
    case 'thursday':
      print('Middle of the week');
      break;
    case 'friday':
      print('TGIF!');
      break;
    case 'saturday':
    case 'sunday':
      print('Weekend vibes');
      break;
    default:
      print('Not a valid day');
  }

  // -----------------------------------------
  // PART 4: Switch Expression (Dart 3.0+)
  // -----------------------------------------

  int monthNum = 7;

  print('\n--- Switch Expression ---');

  String monthName = switch (monthNum) {
    1 => 'January',
    2 => 'February',
    3 => 'March',
    4 => 'April',
    5 => 'May',
    6 => 'June',
    7 => 'July',
    8 => 'August',
    9 => 'September',
    10 => 'October',
    11 => 'November',
    12 => 'December',
    _ => 'Invalid',
  };

  print('Month $monthNum is $monthName');

  // -----------------------------------------
  // PART 5: Season Finder
  // -----------------------------------------

  int month = 4;

  print('\n--- Season Finder ---');
  print('Month: $month');

  String season = switch (month) {
    12 || 1 || 2 => 'Winter',
    3 || 4 || 5 => 'Spring',
    6 || 7 || 8 => 'Summer',
    9 || 10 || 11 => 'Fall',
    _ => 'Invalid',
  };

  print('Season: $season');

  // -----------------------------------------
  // PART 6: Calculator Operation
  // -----------------------------------------

  int a = 10;
  int b = 3;
  String operation = '*';

  print('\n--- Calculator ---');

  switch (operation) {
    case '+':
      print('$a + $b = ${a + b}');
      break;
    case '-':
      print('$a - $b = ${a - b}');
      break;
    case '*':
      print('$a × $b = ${a * b}');
      break;
    case '/':
      if (b != 0) {
        print('$a ÷ $b = ${a / b}');
      } else {
        print('Cannot divide by zero!');
      }
      break;
    default:
      print('Unknown operation: $operation');
  }
}

// ===========================================
// Try it yourself:
// 1. Add more months to part 4
// 2. Create a switch for traffic light colors
// 3. Make a switch for restaurant menu items
// ===========================================
