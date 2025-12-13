// Exercise 2: Employee System
// Create an employee management system with different employee types

void main() {
  // Create instances of different employee types
  var fullTime = FullTimeEmployee('Alice Johnson', 101, 5000.0);
  var partTime = PartTimeEmployee('Bob Smith', 102, 25.0, 80);
  var contractor = Contractor('Charlie Brown', 103, 30000.0, 6);

  print('=== Employee System Demo ===\n');

  // Display employee information
  fullTime.displayInfo();
  print('Monthly Salary: \$${fullTime.calculateMonthlySalary()}');
  print('Benefits: ${fullTime.hasBenefits() ? "Yes" : "No"}\n');

  partTime.displayInfo();
  print('Monthly Salary: \$${partTime.calculateMonthlySalary()}');
  print('Benefits: ${partTime.hasBenefits() ? "Yes" : "No"}\n');

  contractor.displayInfo();
  print('Monthly Salary: \$${contractor.calculateMonthlySalary().toStringAsFixed(2)}');
  print('Benefits: ${contractor.hasBenefits() ? "Yes" : "No"}\n');

  // Demonstrate polymorphism with list of employees
  print('=== All Employees Summary ===');
  List<Employee> employees = [fullTime, partTime, contractor];

  double totalMonthlyCost = 0;
  for (var employee in employees) {
    print('${employee.name} (ID: ${employee.id}): \$${employee.calculateMonthlySalary().toStringAsFixed(2)}');
    totalMonthlyCost += employee.calculateMonthlySalary();
  }

  print('\nTotal Monthly Cost: \$${totalMonthlyCost.toStringAsFixed(2)}');

  // Count employees with benefits
  int employeesWithBenefits = employees.where((e) => e.hasBenefits()).length;
  print('Employees with benefits: $employeesWithBenefits out of ${employees.length}');
}

// Base Employee class
class Employee {
  String name;
  int id;

  Employee(this.name, this.id);

  // Display employee information
  void displayInfo() {
    print('Employee: $name');
    print('ID: $id');
    print('Type: ${runtimeType}');
  }

  // Calculate monthly salary - to be overridden by subclasses
  double calculateMonthlySalary() {
    return 0.0;
  }

  // Check if employee has benefits - default is false
  bool hasBenefits() {
    return false;
  }
}

// FullTimeEmployee class
class FullTimeEmployee extends Employee {
  double monthlySalary;

  FullTimeEmployee(String name, int id, this.monthlySalary) : super(name, id);

  @override
  double calculateMonthlySalary() {
    return monthlySalary;
  }

  @override
  bool hasBenefits() {
    return true; // Full-time employees get benefits
  }
}

// PartTimeEmployee class
class PartTimeEmployee extends Employee {
  double hourlyRate;
  int hoursWorked;

  PartTimeEmployee(String name, int id, this.hourlyRate, this.hoursWorked)
      : super(name, id);

  @override
  double calculateMonthlySalary() {
    return hourlyRate * hoursWorked;
  }

  @override
  bool hasBenefits() {
    return false; // Part-time employees don't get benefits
  }
}

// Contractor class
class Contractor extends Employee {
  double contractAmount;
  int projectDurationMonths;

  Contractor(String name, int id, this.contractAmount, this.projectDurationMonths)
      : super(name, id);

  @override
  double calculateMonthlySalary() {
    return contractAmount / projectDurationMonths;
  }

  @override
  bool hasBenefits() {
    return false; // Contractors don't get benefits
  }
}
