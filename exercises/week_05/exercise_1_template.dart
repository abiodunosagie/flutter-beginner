// Exercise 1: Animal Hierarchy (Beginner)
// TODO: Create animal class hierarchy

abstract class Animal {
  String name;

  Animal(this.name);

  // TODO: Create abstract makeSound() method

  // TODO: Create eat() method
}

class Dog extends Animal {
  // TODO: Add dog-specific properties (breed)

  Dog(String name) : super(name);

  // TODO: Override makeSound()
}

class Cat extends Animal {
  // TODO: Add cat-specific properties (color)

  Cat(String name) : super(name);

  // TODO: Override makeSound()
}

class Bird extends Animal {
  // TODO: Add bird-specific properties (canFly)

  Bird(String name) : super(name);

  // TODO: Override makeSound()
}

void main() {
  // TODO: Create instances of each animal
  // TODO: Call methods on each
}
