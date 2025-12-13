// ===========================================
// Example 05: Pattern Printing
// Using nested loops
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Simple Square
  // -----------------------------------------

  print('--- Square (5x5) ---');

  for (int row = 0; row < 5; row++) {
    String line = '';
    for (int col = 0; col < 5; col++) {
      line += '* ';
    }
    print(line);
  }

  // -----------------------------------------
  // PART 2: Right Triangle
  // -----------------------------------------

  print('\n--- Right Triangle ---');

  for (int row = 1; row <= 5; row++) {
    print('*' * row);
  }

  // -----------------------------------------
  // PART 3: Inverted Triangle
  // -----------------------------------------

  print('\n--- Inverted Triangle ---');

  for (int row = 5; row >= 1; row--) {
    print('*' * row);
  }

  // -----------------------------------------
  // PART 4: Pyramid
  // -----------------------------------------

  print('\n--- Pyramid ---');

  int height = 5;

  for (int row = 1; row <= height; row++) {
    String spaces = ' ' * (height - row);
    String stars = '*' * (2 * row - 1);
    print(spaces + stars);
  }

  // -----------------------------------------
  // PART 5: Inverted Pyramid
  // -----------------------------------------

  print('\n--- Inverted Pyramid ---');

  for (int row = height; row >= 1; row--) {
    String spaces = ' ' * (height - row);
    String stars = '*' * (2 * row - 1);
    print(spaces + stars);
  }

  // -----------------------------------------
  // PART 6: Diamond
  // -----------------------------------------

  print('\n--- Diamond ---');

  int size = 5;

  // Top half
  for (int row = 1; row <= size; row++) {
    String spaces = ' ' * (size - row);
    String stars = '*' * (2 * row - 1);
    print(spaces + stars);
  }

  // Bottom half
  for (int row = size - 1; row >= 1; row--) {
    String spaces = ' ' * (size - row);
    String stars = '*' * (2 * row - 1);
    print(spaces + stars);
  }

  // -----------------------------------------
  // PART 7: Hollow Square
  // -----------------------------------------

  print('\n--- Hollow Square ---');

  int squareSize = 5;

  for (int row = 0; row < squareSize; row++) {
    String line = '';
    for (int col = 0; col < squareSize; col++) {
      // Print * only on edges
      if (row == 0 ||
          row == squareSize - 1 ||
          col == 0 ||
          col == squareSize - 1) {
        line += '* ';
      } else {
        line += '  ';
      }
    }
    print(line);
  }

  // -----------------------------------------
  // PART 8: Number Triangle
  // -----------------------------------------

  print('\n--- Number Triangle ---');

  for (int row = 1; row <= 5; row++) {
    String line = '';
    for (int col = 1; col <= row; col++) {
      line += '$col ';
    }
    print(line);
  }

  // -----------------------------------------
  // PART 9: Multiplication Table
  // -----------------------------------------

  print('\n--- Multiplication Table (1-5) ---');

  // Header
  String header = '    ';
  for (int col = 1; col <= 5; col++) {
    header += '${col.toString().padLeft(3)} ';
  }
  print(header);
  print('    ' + '-' * 20);

  // Table body
  for (int row = 1; row <= 5; row++) {
    String line = '${row.toString().padLeft(2)} |';
    for (int col = 1; col <= 5; col++) {
      int product = row * col;
      line += '${product.toString().padLeft(3)} ';
    }
    print(line);
  }

  // -----------------------------------------
  // PART 10: Pascal's Triangle
  // -----------------------------------------

  print('\n--- Pascal\'s Triangle ---');

  int rows = 6;
  List<List<int>> pascal = [];

  for (int row = 0; row < rows; row++) {
    List<int> currentRow = [];

    for (int col = 0; col <= row; col++) {
      if (col == 0 || col == row) {
        currentRow.add(1);
      } else {
        currentRow.add(pascal[row - 1][col - 1] + pascal[row - 1][col]);
      }
    }

    pascal.add(currentRow);

    // Print with spacing
    String spaces = ' ' * (rows - row - 1) * 2;
    String values = currentRow.map((n) => n.toString().padLeft(3)).join(' ');
    print(spaces + values);
  }

  // -----------------------------------------
  // PART 11: Checkerboard
  // -----------------------------------------

  print('\n--- Checkerboard ---');

  for (int row = 0; row < 8; row++) {
    String line = '';
    for (int col = 0; col < 8; col++) {
      if ((row + col) % 2 == 0) {
        line += '■ ';
      } else {
        line += '□ ';
      }
    }
    print(line);
  }

  // -----------------------------------------
  // PART 12: Spiral Numbers (Small)
  // -----------------------------------------

  print('\n--- Number Grid ---');

  int counter = 1;
  for (int row = 0; row < 4; row++) {
    String line = '';
    for (int col = 0; col < 4; col++) {
      line += '${counter.toString().padLeft(3)} ';
      counter++;
    }
    print(line);
  }

  // -----------------------------------------
  // PART 13: Break in Nested Loops
  // -----------------------------------------

  print('\n--- Finding a Value (Break Demo) ---');

  List<List<int>> matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  int target = 5;
  bool found = false;

  search:
  for (int row = 0; row < matrix.length; row++) {
    for (int col = 0; col < matrix[row].length; col++) {
      print('Checking position [$row][$col] = ${matrix[row][col]}');
      if (matrix[row][col] == target) {
        print('Found $target at row $row, column $col!');
        found = true;
        break search; // Break out of BOTH loops
      }
    }
  }

  if (!found) {
    print('$target not found in matrix');
  }

  // -----------------------------------------
  // PART 14: Continue in Nested Loops
  // -----------------------------------------

  print('\n--- Skip Multiples of 3 (Continue Demo) ---');

  for (int row = 1; row <= 3; row++) {
    String line = 'Row $row: ';
    for (int col = 1; col <= 5; col++) {
      int value = row * col;
      if (value % 3 == 0) {
        continue; // Skip multiples of 3
      }
      line += '$value ';
    }
    print(line);
  }
}

// ===========================================
// Try it yourself:
// 1. Create a hollow diamond
// 2. Make a number pyramid (centered numbers)
// 3. Create a letter triangle (A, AB, ABC, ABCD...)
// 4. Make a bordered rectangle with custom size
// ===========================================
