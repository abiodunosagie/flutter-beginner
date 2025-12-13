// Exercise 5: Payment Processing
// Create a payment processing system with multiple payment types

void main() {
  // TODO: Create instances of different payment methods
  // - Create a CreditCard with amount 100, card number, and cardholder name
  // - Create a PayPal with amount 75 and email address
  // - Create a BankTransfer with amount 200, account number, and bank name

  // TODO: Process each payment and display results

  // TODO: Calculate and display transaction fees for each payment

  // TODO: Add payments to history

  // TODO: Display payment history for each payment method

  // TODO: Test refund functionality for each payment type

  // TODO: Create a list of all payments and calculate:
  // - Total amount processed
  // - Total transaction fees
  // - Net amount (total - fees)

  // TODO: Find the payment method with the lowest transaction fee percentage
}

// TODO: Create abstract Payment class
// Properties:
// - amount (double)
// - transactionId (String) - generate unique ID
// - isProcessed (bool) - default false
// - paymentHistory (List<String>)
// Methods:
// - process() - abstract method, returns bool
// - calculateTransactionFee() - abstract method, returns double
// - refund() - abstract method, returns bool
// - addToHistory(String message) - adds message to history
// - displayHistory() - displays all history entries

// TODO: Create CreditCard class that extends Payment
// Additional properties:
// - cardNumber (String)
// - cardHolderName (String)
// Implement:
// - process() - validates card (length check), sets isProcessed to true
// - calculateTransactionFee() - returns 2.5% of amount
// - refund() - can refund if processed, returns true if successful
// - Override toString() to display card info

// TODO: Create PayPal class that extends Payment
// Additional properties:
// - email (String)
// Implement:
// - process() - validates email (contains @), sets isProcessed to true
// - calculateTransactionFee() - returns 3% of amount
// - refund() - can refund if processed, returns true if successful
// - Override toString() to display PayPal info

// TODO: Create BankTransfer class that extends Payment
// Additional properties:
// - accountNumber (String)
// - bankName (String)
// Implement:
// - process() - validates account (length check), sets isProcessed to true
// - calculateTransactionFee() - returns flat fee of $5
// - refund() - can refund if processed, takes 2-3 business days, returns true
// - Override toString() to display bank transfer info
