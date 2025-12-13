// Exercise 4: Vehicle Management
// Create a vehicle rental system with different vehicle types

void main() {
  // TODO: Create instances of different vehicles
  // - Create a Car with brand, model, year, daily rate, and passenger capacity
  // - Create a Motorcycle with brand, model, year, daily rate, and engine size
  // - Create a Truck with brand, model, year, daily rate, and cargo capacity

  // TODO: Display information for each vehicle

  // TODO: Calculate rental price for different durations
  // - 3 days for car
  // - 5 days for motorcycle
  // - 7 days for truck

  // TODO: Check maintenance schedules for all vehicles

  // TODO: Create a list of all vehicles and calculate total rental income
  // for a week-long rental of all vehicles

  // TODO: Find the most expensive vehicle to rent per day
}

// TODO: Create base Vehicle class
// Properties:
// - brand (String)
// - model (String)
// - year (int)
// - dailyRate (double)
// - mileage (int) - current mileage
// Methods:
// - displayInfo() - displays vehicle information
// - calculateRentalPrice(int days) - returns rental price (to be overridden)
// - needsMaintenance() - returns true if mileage > 10000

// TODO: Create Car class that extends Vehicle
// Additional properties:
// - passengerCapacity (int)
// Override:
// - calculateRentalPrice(int days) - returns dailyRate * days
//   If days > 7, apply 10% discount
// - displayInfo() - include passenger capacity

// TODO: Create Motorcycle class that extends Vehicle
// Additional properties:
// - engineSize (int) - in cc
// Override:
// - calculateRentalPrice(int days) - returns dailyRate * days
//   If days > 3, apply 5% discount
// - displayInfo() - include engine size
// - needsMaintenance() - returns true if mileage > 5000

// TODO: Create Truck class that extends Vehicle
// Additional properties:
// - cargoCapacity (double) - in tons
// Override:
// - calculateRentalPrice(int days) - returns (dailyRate * days) * 1.2
//   (20% surcharge for commercial vehicle)
// - displayInfo() - include cargo capacity
// - needsMaintenance() - returns true if mileage > 15000
