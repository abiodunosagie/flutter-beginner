// Exercise 3: Rectangle Class (SOLUTION)

class Rectangle {
  double width;
  double height;

  // Regular constructor with validation
  Rectangle(this.width, this.height) {
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be positive');
    }
  }

  // Named constructor for square
  Rectangle.square(double side) : this(side, side);

  double area() {
    return width * height;
  }

  double perimeter() {
    return 2 * (width + height);
  }

  @override
  String toString() {
    return 'Rectangle(width: $width, height: $height)';
  }
}

void main() {
  print('=== Geometry Calculator ===\n');

  // Create rectangles
  Rectangle rect1 = Rectangle(10, 5);
  print('$rect1');
  print('Area: ${rect1.area()}');
  print('Perimeter: ${rect1.perimeter()}\n');

  Rectangle rect2 = Rectangle(7.5, 12.3);
  print('$rect2');
  print('Area: ${rect2.area().toStringAsFixed(2)}');
  print('Perimeter: ${rect2.perimeter().toStringAsFixed(2)}\n');

  // Create square using named constructor
  Rectangle square = Rectangle.square(8);
  print('Square $square');
  print('Area: ${square.area()}');
  print('Perimeter: ${square.perimeter()}\n');

  // Test validation
  try {
    Rectangle invalid = Rectangle(-5, 10);
  } catch (e) {
    print('Validation error: $e');
  }
}
