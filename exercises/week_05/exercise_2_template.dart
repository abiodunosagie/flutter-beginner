// Exercise 2: Employee System
// Create an employee management system with different employee types

void main() {
  // TODO: Create instances of different employee types
  // - Create a FullTimeEmployee with name, id, monthly salary
  // - Create a PartTimeEmployee with name, id, hourly rate, hours worked
  // - Create a Contractor with name, id, contract amount, project duration

  // TODO: Display employee information for all employees

  // TODO: Calculate and display monthly salary for each employee

  // TODO: Check and display benefits eligibility for each employee

  // TODO: Create a list of all employees and iterate through them
  // demonstrating polymorphism
}

// TODO: Create base Employee class
// Properties:
// - name (String)
// - id (int)
// Methods:
// - displayInfo() - displays employee information
// - calculateMonthlySalary() - returns monthly salary (to be overridden)
// - hasBenefits() - returns false by default

// TODO: Create FullTimeEmployee class that extends Employee
// Additional properties:
// - monthlySalary (double)
// Override:
// - calculateMonthlySalary() - returns monthlySalary
// - hasBenefits() - returns true

// TODO: Create PartTimeEmployee class that extends Employee
// Additional properties:
// - hourlyRate (double)
// - hoursWorked (int)
// Override:
// - calculateMonthlySalary() - returns hourlyRate * hoursWorked
// - hasBenefits() - returns false

// TODO: Create Contractor class that extends Employee
// Additional properties:
// - contractAmount (double)
// - projectDurationMonths (int)
// Override:
// - calculateMonthlySalary() - returns contractAmount / projectDurationMonths
// - hasBenefits() - returns false
