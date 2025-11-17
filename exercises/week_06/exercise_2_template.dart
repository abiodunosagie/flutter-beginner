// Exercise 2: Bank Account System (Beginner-Intermediate)
// Topic: Inheritance with Method Overriding
//
// Create a bank account hierarchy:
// 1. Create an Account parent class with:
//    - Properties: accountNumber (String), balance (double), accountHolder (String)
//    - Constructor that initializes all properties
//    - Method: deposit(double amount) - adds to balance
//    - Method: withdraw(double amount) - subtracts from balance if sufficient funds
//    - Method: displayInfo() - prints account details
//    - Method: calculateInterest() - returns 0.0 (to be overridden)
//
// 2. Create SavingsAccount that extends Account:
//    - Additional property: interestRate (double) - default 0.03 (3%)
//    - Constructor that calls super and sets interestRate
//    - Override calculateInterest() to return balance * interestRate
//    - Override withdraw() to prevent withdrawal if balance would go below $100
//
// 3. Create CheckingAccount that extends Account:
//    - Additional properties: overdraftLimit (double), transactionFee (double)
//    - Constructor that calls super and sets overdraft limit and fee
//    - Override withdraw() to allow overdraft up to the limit
//    - Override deposit() to deduct transaction fee if more than 5 transactions
//    - Add property: transactionCount (int) to track transactions
//
// 4. Create BusinessAccount that extends Account:
//    - Additional property: transactionLimit (int) - max transactions per day
//    - Property: dailyTransactions (int) - current transaction count
//    - Override deposit() and withdraw() to check transaction limit
//    - Method: resetDailyTransactions() to reset count
//
// Test with various scenarios including deposits, withdrawals, and interest calculations.

void main() {
  // TODO: Create instances of different account types
  // TODO: Test deposits, withdrawals, and special features

}

// TODO: Implement Account class


// TODO: Implement SavingsAccount class


// TODO: Implement CheckingAccount class


// TODO: Implement BusinessAccount class
