// ===========================================
// Example 04: Number Guessing Game
// Using while loops
// ===========================================

import 'dart:math';

void main() {
  // -----------------------------------------
  // PART 1: Basic While Loop
  // -----------------------------------------

  print('--- Basic Countdown ---');

  int countdown = 5;

  while (countdown > 0) {
    print('T-minus $countdown...');
    countdown--;
  }
  print('Liftoff!');

  // -----------------------------------------
  // PART 2: Sum Until Limit
  // -----------------------------------------

  print('\n--- Sum Until Limit ---');

  int sum = 0;
  int number = 1;
  int limit = 50;

  while (sum + number <= limit) {
    sum += number;
    print('Added $number, sum is now $sum');
    number++;
  }

  print('Final sum: $sum');

  // -----------------------------------------
  // PART 3: Find First Divisible
  // -----------------------------------------

  print('\n--- Find First Divisible ---');

  int start = 10;
  int divisor = 7;

  while (start % divisor != 0) {
    print('$start is not divisible by $divisor');
    start++;
  }

  print('Found it! $start is divisible by $divisor');

  // -----------------------------------------
  // PART 4: Password Attempts
  // -----------------------------------------

  print('\n--- Password Attempts ---');

  String correctPassword = 'secret123';
  List<String> attempts = ['wrong', 'password', 'secret123'];
  int attemptIndex = 0;
  int maxAttempts = 3;
  bool loggedIn = false;

  while (attemptIndex < maxAttempts && !loggedIn) {
    String attempt = attempts[attemptIndex];
    print('Attempt ${attemptIndex + 1}: "$attempt"');

    if (attempt == correctPassword) {
      loggedIn = true;
      print('Access granted!');
    } else {
      print('Wrong password!');
      attemptIndex++;
    }
  }

  if (!loggedIn) {
    print('Account locked after $maxAttempts failed attempts!');
  }

  // -----------------------------------------
  // PART 5: Do-While Example
  // -----------------------------------------

  print('\n--- Do-While: Menu ---');

  List<int> menuChoices = [1, 2, 3, 4]; // Simulated user choices
  int choiceIndex = 0;
  int choice;

  do {
    print('\n=== MENU ===');
    print('1. Play Game');
    print('2. View Score');
    print('3. Settings');
    print('4. Quit');

    choice = menuChoices[choiceIndex];
    print('Selected: $choice');

    switch (choice) {
      case 1:
        print('Starting game...');
        break;
      case 2:
        print('Your score: 100');
        break;
      case 3:
        print('Opening settings...');
        break;
      case 4:
        print('Goodbye!');
        break;
    }

    choiceIndex++;
  } while (choice != 4);

  // -----------------------------------------
  // PART 6: Number Guessing Game Simulation
  // -----------------------------------------

  print('\n--- Number Guessing Game ---');

  // The secret number
  Random random = Random();
  int secretNumber = random.nextInt(10) + 1; // 1 to 10

  // Simulated guesses
  List<int> guesses = [5, 3, 7, secretNumber];
  int guessIndex = 0;
  bool won = false;
  int attempts2 = 0;

  print('I\'m thinking of a number between 1 and 10...');

  while (!won && guessIndex < guesses.length) {
    int guess = guesses[guessIndex];
    attempts2++;
    print('\nGuess #$attempts2: $guess');

    if (guess == secretNumber) {
      won = true;
      print('Correct! You won in $attempts2 guesses!');
    } else if (guess < secretNumber) {
      print('Too low! Try higher.');
    } else {
      print('Too high! Try lower.');
    }

    guessIndex++;
  }

  if (!won) {
    print('\nGame over! The number was $secretNumber');
  }

  // -----------------------------------------
  // PART 7: Collatz Conjecture
  // -----------------------------------------

  print('\n--- Collatz Conjecture ---');
  print('Start with a number. If even, divide by 2. If odd, multiply by 3 and add 1.');
  print('Eventually you always reach 1!');

  int n = 27;
  int steps = 0;

  print('\nStarting with $n:');

  while (n != 1) {
    print(n);
    if (n % 2 == 0) {
      n = n ~/ 2;
    } else {
      n = 3 * n + 1;
    }
    steps++;

    // Safety limit for display
    if (steps > 50) {
      print('... (stopping display at 50 steps)');
      break;
    }
  }

  print('1');
  print('Reached 1 in $steps steps!');

  // -----------------------------------------
  // PART 8: Process Queue
  // -----------------------------------------

  print('\n--- Process Queue ---');

  List<String> queue = ['Task A', 'Task B', 'Task C', 'Task D'];

  print('Starting queue processing...');
  print('Queue: $queue\n');

  while (queue.isNotEmpty) {
    String task = queue.removeAt(0);
    print('Processing: $task');
    print('Remaining: ${queue.isEmpty ? "None" : queue.toString()}');
  }

  print('\nAll tasks completed!');
}

// ===========================================
// Try it yourself:
// 1. Make the guessing game interactive (if using a real console)
// 2. Add a "give up" option to the guessing game
// 3. Count how many even vs odd steps in Collatz
// 4. Create a shopping cart that processes until empty
// ===========================================
