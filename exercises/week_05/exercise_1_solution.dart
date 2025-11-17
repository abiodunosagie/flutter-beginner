// Exercise 1: Animal Hierarchy (SOLUTION)

abstract class Animal {
  String name;

  Animal(this.name);

  void makeSound();

  void eat() {
    print('$name is eating');
  }
}

class Dog extends Animal {
  String breed;

  Dog(String name, this.breed) : super(name);

  @override
  void makeSound() {
    print('$name the $breed says: Woof! Woof!');
  }

  void fetch() {
    print('$name is fetching the ball!');
  }
}

class Cat extends Animal {
  String color;

  Cat(String name, this.color) : super(name);

  @override
  void makeSound() {
    print('$name the $color cat says: Meow!');
  }

  void scratch() {
    print('$name is scratching the furniture');
  }
}

class Bird extends Animal {
  bool canFly;

  Bird(String name, this.canFly) : super(name);

  @override
  void makeSound() {
    print('$name the bird says: Tweet! Tweet!');
  }

  void fly() {
    if (canFly) {
      print('$name is flying!');
    } else {
      print('$name cannot fly');
    }
  }
}

void main() {
  print('=== Animal Hierarchy Demo ===\n');

  // Create animals
  Dog dog = Dog('Buddy', 'Golden Retriever');
  Cat cat = Cat('Whiskers', 'orange');
  Bird bird = Bird('Tweety', true);
  Bird penguin = Bird('Pingu', false);

  // Use polymorphism - treat all as Animals
  List<Animal> animals = [dog, cat, bird, penguin];

  print('--- All animals making sounds ---');
  for (Animal animal in animals) {
    animal.makeSound();
  }

  print('\n--- All animals eating ---');
  for (Animal animal in animals) {
    animal.eat();
  }

  // Use specific methods
  print('\n--- Specific behaviors ---');
  dog.fetch();
  cat.scratch();
  bird.fly();
  penguin.fly();
}
