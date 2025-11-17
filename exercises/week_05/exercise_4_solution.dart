// Exercise 4: Vehicle Management
// Create a vehicle rental system with different vehicle types

void main() {
  print('=== Vehicle Rental System Demo ===\n');

  // Create instances of different vehicles
  var car = Car('Toyota', 'Camry', 2022, 50.0, 8000, 5);
  var motorcycle = Motorcycle('Harley-Davidson', 'Street 750', 2021, 35.0, 6000, 750);
  var truck = Truck('Ford', 'F-150', 2023, 80.0, 12000, 2.5);

  // Display information for each vehicle
  car.displayInfo();
  motorcycle.displayInfo();
  truck.displayInfo();

  print('=== Rental Price Calculations ===');

  // Calculate rental price for different durations
  int carDays = 3;
  print('Car rental for $carDays days: \$${car.calculateRentalPrice(carDays).toStringAsFixed(2)}');

  int motorcycleDays = 5;
  print('Motorcycle rental for $motorcycleDays days: \$${motorcycle.calculateRentalPrice(motorcycleDays).toStringAsFixed(2)}');

  int truckDays = 7;
  print('Truck rental for $truckDays days: \$${truck.calculateRentalPrice(truckDays).toStringAsFixed(2)}');

  // Test discount scenarios
  print('\n=== Discount Scenarios ===');
  int carLongRental = 10;
  print('Car rental for $carLongRental days (with 10% discount): \$${car.calculateRentalPrice(carLongRental).toStringAsFixed(2)}');

  int motorcycleLongRental = 4;
  print('Motorcycle rental for $motorcycleLongRental days (with 5% discount): \$${motorcycle.calculateRentalPrice(motorcycleLongRental).toStringAsFixed(2)}');

  // Check maintenance schedules
  print('\n=== Maintenance Check ===');
  checkMaintenance(car);
  checkMaintenance(motorcycle);
  checkMaintenance(truck);

  // Create a list and calculate total rental income
  List<Vehicle> vehicles = [car, motorcycle, truck];

  print('\n=== Weekly Rental Income ===');
  double totalIncome = 0;
  for (var vehicle in vehicles) {
    double weeklyPrice = vehicle.calculateRentalPrice(7);
    print('${vehicle.brand} ${vehicle.model}: \$${weeklyPrice.toStringAsFixed(2)}');
    totalIncome += weeklyPrice;
  }
  print('Total weekly income: \$${totalIncome.toStringAsFixed(2)}');

  // Find the most expensive vehicle to rent per day
  print('\n=== Most Expensive Daily Rate ===');
  Vehicle mostExpensive = vehicles[0];
  for (var vehicle in vehicles) {
    if (vehicle.dailyRate > mostExpensive.dailyRate) {
      mostExpensive = vehicle;
    }
  }
  print('Most expensive: ${mostExpensive.brand} ${mostExpensive.model} at \$${mostExpensive.dailyRate}/day');
}

// Helper function to check maintenance
void checkMaintenance(Vehicle vehicle) {
  print('${vehicle.brand} ${vehicle.model}: ${vehicle.needsMaintenance() ? "Maintenance Required!" : "No maintenance needed"}');
}

// Base Vehicle class
class Vehicle {
  String brand;
  String model;
  int year;
  double dailyRate;
  int mileage;

  Vehicle(this.brand, this.model, this.year, this.dailyRate, this.mileage);

  // Display vehicle information
  void displayInfo() {
    print('Vehicle: $brand $model ($year)');
    print('Daily Rate: \$$dailyRate');
    print('Mileage: $mileage km');
    print('Type: ${runtimeType}\n');
  }

  // Calculate rental price - to be overridden by subclasses
  double calculateRentalPrice(int days) {
    return dailyRate * days;
  }

  // Check if vehicle needs maintenance
  bool needsMaintenance() {
    return mileage > 10000;
  }
}

// Car class
class Car extends Vehicle {
  int passengerCapacity;

  Car(String brand, String model, int year, double dailyRate, int mileage, this.passengerCapacity)
      : super(brand, model, year, dailyRate, mileage);

  @override
  void displayInfo() {
    print('Vehicle: $brand $model ($year)');
    print('Daily Rate: \$$dailyRate');
    print('Mileage: $mileage km');
    print('Type: Car');
    print('Passenger Capacity: $passengerCapacity\n');
  }

  @override
  double calculateRentalPrice(int days) {
    double basePrice = dailyRate * days;
    // Apply 10% discount for rentals longer than 7 days
    if (days > 7) {
      return basePrice * 0.9;
    }
    return basePrice;
  }
}

// Motorcycle class
class Motorcycle extends Vehicle {
  int engineSize; // in cc

  Motorcycle(String brand, String model, int year, double dailyRate, int mileage, this.engineSize)
      : super(brand, model, year, dailyRate, mileage);

  @override
  void displayInfo() {
    print('Vehicle: $brand $model ($year)');
    print('Daily Rate: \$$dailyRate');
    print('Mileage: $mileage km');
    print('Type: Motorcycle');
    print('Engine Size: ${engineSize}cc\n');
  }

  @override
  double calculateRentalPrice(int days) {
    double basePrice = dailyRate * days;
    // Apply 5% discount for rentals longer than 3 days
    if (days > 3) {
      return basePrice * 0.95;
    }
    return basePrice;
  }

  @override
  bool needsMaintenance() {
    // Motorcycles need maintenance more frequently
    return mileage > 5000;
  }
}

// Truck class
class Truck extends Vehicle {
  double cargoCapacity; // in tons

  Truck(String brand, String model, int year, double dailyRate, int mileage, this.cargoCapacity)
      : super(brand, model, year, dailyRate, mileage);

  @override
  void displayInfo() {
    print('Vehicle: $brand $model ($year)');
    print('Daily Rate: \$$dailyRate');
    print('Mileage: $mileage km');
    print('Type: Truck');
    print('Cargo Capacity: $cargoCapacity tons\n');
  }

  @override
  double calculateRentalPrice(int days) {
    // 20% surcharge for commercial vehicles
    return (dailyRate * days) * 1.2;
  }

  @override
  bool needsMaintenance() {
    // Trucks can go longer between maintenance
    return mileage > 15000;
  }
}
