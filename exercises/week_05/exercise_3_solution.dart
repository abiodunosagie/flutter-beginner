// Exercise 3: Shape Calculator
// Create a polymorphic shape calculation system

import 'dart:math';

void main() {
  print('=== Shape Calculator Demo ===\n');

  // Create instances of different shapes
  var circle = Circle(5.0);
  var rectangle = Rectangle(4.0, 6.0);
  var triangle = Triangle(3.0, 4.0, 3.0, 4.0, 5.0);

  // Display information for each shape
  displayShapeInfo(circle);
  displayShapeInfo(rectangle);
  displayShapeInfo(triangle);

  // Create a list of all shapes
  List<Shape> shapes = [circle, rectangle, triangle];

  // Calculate and display total area
  print('=== Total Area Calculation ===');
  double totalArea = 0;
  for (var shape in shapes) {
    print('${shape.getName()}: ${shape.area().toStringAsFixed(2)}');
    totalArea += shape.area();
  }
  print('Total Area: ${totalArea.toStringAsFixed(2)}\n');

  // Find the shape with the largest area
  Shape largestByArea = shapes[0];
  for (var shape in shapes) {
    if (shape.area() > largestByArea.area()) {
      largestByArea = shape;
    }
  }
  print('Largest shape by area: ${largestByArea.getName()} (${largestByArea.area().toStringAsFixed(2)})');

  // Find the shape with the largest perimeter
  Shape largestByPerimeter = shapes[0];
  for (var shape in shapes) {
    if (shape.perimeter() > largestByPerimeter.perimeter()) {
      largestByPerimeter = shape;
    }
  }
  print('Largest shape by perimeter: ${largestByPerimeter.getName()} (${largestByPerimeter.perimeter().toStringAsFixed(2)})');
}

// Helper function to display shape information
void displayShapeInfo(Shape shape) {
  print('Shape: ${shape.getName()}');
  print('Area: ${shape.area().toStringAsFixed(2)}');
  print('Perimeter: ${shape.perimeter().toStringAsFixed(2)}\n');
}

// Abstract Shape class
abstract class Shape {
  // Calculate the area of the shape
  double area();

  // Calculate the perimeter of the shape
  double perimeter();

  // Get the name of the shape
  String getName();
}

// Circle class
class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  double area() {
    return pi * radius * radius;
  }

  @override
  double perimeter() {
    return 2 * pi * radius;
  }

  @override
  String getName() {
    return 'Circle';
  }
}

// Rectangle class
class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  double area() {
    return width * height;
  }

  @override
  double perimeter() {
    return 2 * (width + height);
  }

  @override
  String getName() {
    return 'Rectangle';
  }
}

// Triangle class
class Triangle extends Shape {
  double base;
  double height;
  double side1;
  double side2;
  double side3;

  Triangle(this.base, this.height, this.side1, this.side2, this.side3);

  @override
  double area() {
    return 0.5 * base * height;
  }

  @override
  double perimeter() {
    return side1 + side2 + side3;
  }

  @override
  String getName() {
    return 'Triangle';
  }
}
