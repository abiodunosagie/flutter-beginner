// Exercise 1: Shape Hierarchy (Beginner)
// Topic: Inheritance Basics

// Parent class
abstract class Shape {
  String color;

  Shape(this.color);

  void describe() {
    print('A $color shape');
  }

  // Abstract method - children must implement
  double calculateArea();
}

// Rectangle class
class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(String color, this.width, this.height) : super(color);

  @override
  double calculateArea() {
    return width * height;
  }

  @override
  void describe() {
    super.describe();
    print('Dimensions: ${width}w x ${height}h');
  }
}

// Circle class
class Circle extends Shape {
  double radius;

  Circle(String color, this.radius) : super(color);

  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }

  @override
  void describe() {
    super.describe();
    print('Radius: $radius');
  }
}

// Triangle class
class Triangle extends Shape {
  double base;
  double height;

  Triangle(String color, this.base, this.height) : super(color);

  @override
  double calculateArea() {
    return (base * height) / 2;
  }

  @override
  void describe() {
    super.describe();
    print('Base: $base, Height: $height');
  }
}

void main() {
  print('=== RECTANGLE ===');
  Rectangle rect = Rectangle('blue', 5, 3);
  rect.describe();
  print('Area: ${rect.calculateArea()}');

  print('\n=== CIRCLE ===');
  Circle circle = Circle('red', 4);
  circle.describe();
  print('Area: ${circle.calculateArea().toStringAsFixed(2)}');

  print('\n=== TRIANGLE ===');
  Triangle triangle = Triangle('green', 6, 4);
  triangle.describe();
  print('Area: ${triangle.calculateArea()}');

  // Polymorphism example
  print('\n=== POLYMORPHISM ===');
  List<Shape> shapes = [rect, circle, triangle];
  for (Shape shape in shapes) {
    print('Area: ${shape.calculateArea().toStringAsFixed(2)}');
  }
}
