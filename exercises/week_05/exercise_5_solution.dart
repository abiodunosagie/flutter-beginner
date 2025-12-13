// Exercise 5: Payment Processing
// Create a payment processing system with multiple payment types

void main() {
  print('=== Payment Processing System Demo ===\n');

  // Create instances of different payment methods
  var creditCard = CreditCard(100.0, '4532123456789012', 'John Doe');
  var paypal = PayPal(75.0, 'user@example.com');
  var bankTransfer = BankTransfer(200.0, '1234567890', 'Chase Bank');

  // Process each payment
  print('=== Processing Payments ===');
  processPayment(creditCard);
  processPayment(paypal);
  processPayment(bankTransfer);

  // Calculate and display transaction fees
  print('\n=== Transaction Fees ===');
  displayTransactionFee(creditCard);
  displayTransactionFee(paypal);
  displayTransactionFee(bankTransfer);

  // Display payment history
  print('\n=== Payment History ===');
  creditCard.displayHistory();
  paypal.displayHistory();
  bankTransfer.displayHistory();

  // Test refund functionality
  print('\n=== Refund Processing ===');
  testRefund(creditCard);
  testRefund(paypal);
  testRefund(bankTransfer);

  // Create a list and calculate totals
  List<Payment> payments = [creditCard, paypal, bankTransfer];

  print('\n=== Financial Summary ===');
  double totalAmount = 0;
  double totalFees = 0;

  for (var payment in payments) {
    if (payment.isProcessed) {
      totalAmount += payment.amount;
      totalFees += payment.calculateTransactionFee();
    }
  }

  double netAmount = totalAmount - totalFees;

  print('Total Amount Processed: \$${totalAmount.toStringAsFixed(2)}');
  print('Total Transaction Fees: \$${totalFees.toStringAsFixed(2)}');
  print('Net Amount: \$${netAmount.toStringAsFixed(2)}');

  // Find payment method with lowest fee percentage
  print('\n=== Fee Comparison ===');
  Payment lowestFeePayment = payments[0];
  double lowestFeePercentage = (payments[0].calculateTransactionFee() / payments[0].amount) * 100;

  for (var payment in payments) {
    double feePercentage = (payment.calculateTransactionFee() / payment.amount) * 100;
    print('${payment.runtimeType}: ${feePercentage.toStringAsFixed(2)}%');

    if (feePercentage < lowestFeePercentage) {
      lowestFeePercentage = feePercentage;
      lowestFeePayment = payment;
    }
  }

  print('\nLowest fee payment method: ${lowestFeePayment.runtimeType} (${lowestFeePercentage.toStringAsFixed(2)}%)');
}

// Helper function to process payment
void processPayment(Payment payment) {
  print('Processing: $payment');
  bool success = payment.process();
  print('Status: ${success ? "Success" : "Failed"}\n');
}

// Helper function to display transaction fee
void displayTransactionFee(Payment payment) {
  double fee = payment.calculateTransactionFee();
  double feePercentage = (fee / payment.amount) * 100;
  print('${payment.runtimeType}: \$${fee.toStringAsFixed(2)} (${feePercentage.toStringAsFixed(2)}%)');
}

// Helper function to test refund
void testRefund(Payment payment) {
  print('Attempting refund for: $payment');
  bool success = payment.refund();
  print('Refund: ${success ? "Successful" : "Failed"}\n');
}

// Abstract Payment class
abstract class Payment {
  double amount;
  String transactionId;
  bool isProcessed;
  List<String> paymentHistory;

  // Generate a unique transaction ID
  static int _idCounter = 1000;

  Payment(this.amount)
      : transactionId = 'TXN${++_idCounter}',
        isProcessed = false,
        paymentHistory = [];

  // Process the payment - to be implemented by subclasses
  bool process();

  // Calculate transaction fee - to be implemented by subclasses
  double calculateTransactionFee();

  // Refund the payment - to be implemented by subclasses
  bool refund();

  // Add message to payment history
  void addToHistory(String message) {
    String timestamp = DateTime.now().toString().substring(0, 19);
    paymentHistory.add('[$timestamp] $message');
  }

  // Display payment history
  void displayHistory() {
    print('\n--- Payment History for $transactionId ---');
    if (paymentHistory.isEmpty) {
      print('No history available');
    } else {
      for (var entry in paymentHistory) {
        print(entry);
      }
    }
  }
}

// CreditCard payment class
class CreditCard extends Payment {
  String cardNumber;
  String cardHolderName;

  CreditCard(double amount, this.cardNumber, this.cardHolderName) : super(amount);

  @override
  bool process() {
    addToHistory('Initiating credit card payment');

    // Validate card number (basic length check)
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      addToHistory('Payment failed: Invalid card number');
      return false;
    }

    // Simulate processing
    isProcessed = true;
    addToHistory('Payment of \$${amount.toStringAsFixed(2)} processed successfully');
    return true;
  }

  @override
  double calculateTransactionFee() {
    // 2.5% transaction fee for credit cards
    return amount * 0.025;
  }

  @override
  bool refund() {
    if (!isProcessed) {
      addToHistory('Refund failed: Payment not processed');
      return false;
    }

    addToHistory('Refund of \$${amount.toStringAsFixed(2)} processed');
    addToHistory('Refund will appear in 3-5 business days');
    return true;
  }

  @override
  String toString() {
    String maskedCard = '****' + cardNumber.substring(cardNumber.length - 4);
    return 'CreditCard($maskedCard, $cardHolderName, \$${amount.toStringAsFixed(2)})';
  }
}

// PayPal payment class
class PayPal extends Payment {
  String email;

  PayPal(double amount, this.email) : super(amount);

  @override
  bool process() {
    addToHistory('Initiating PayPal payment');

    // Validate email (basic check)
    if (!email.contains('@') || !email.contains('.')) {
      addToHistory('Payment failed: Invalid email address');
      return false;
    }

    // Simulate processing
    isProcessed = true;
    addToHistory('Payment of \$${amount.toStringAsFixed(2)} processed successfully via PayPal');
    return true;
  }

  @override
  double calculateTransactionFee() {
    // 3% transaction fee for PayPal
    return amount * 0.03;
  }

  @override
  bool refund() {
    if (!isProcessed) {
      addToHistory('Refund failed: Payment not processed');
      return false;
    }

    addToHistory('Refund of \$${amount.toStringAsFixed(2)} processed');
    addToHistory('Refund will appear instantly in PayPal account');
    return true;
  }

  @override
  String toString() {
    return 'PayPal($email, \$${amount.toStringAsFixed(2)})';
  }
}

// BankTransfer payment class
class BankTransfer extends Payment {
  String accountNumber;
  String bankName;

  BankTransfer(double amount, this.accountNumber, this.bankName) : super(amount);

  @override
  bool process() {
    addToHistory('Initiating bank transfer');

    // Validate account number (basic length check)
    if (accountNumber.length < 8 || accountNumber.length > 17) {
      addToHistory('Payment failed: Invalid account number');
      return false;
    }

    // Simulate processing
    isProcessed = true;
    addToHistory('Bank transfer of \$${amount.toStringAsFixed(2)} to $bankName processed');
    addToHistory('Transfer will complete in 1-2 business days');
    return true;
  }

  @override
  double calculateTransactionFee() {
    // Flat $5 fee for bank transfers
    return 5.0;
  }

  @override
  bool refund() {
    if (!isProcessed) {
      addToHistory('Refund failed: Payment not processed');
      return false;
    }

    addToHistory('Refund of \$${amount.toStringAsFixed(2)} initiated');
    addToHistory('Refund will appear in 2-3 business days');
    return true;
  }

  @override
  String toString() {
    String maskedAccount = '****' + accountNumber.substring(accountNumber.length - 4);
    return 'BankTransfer($maskedAccount, $bankName, \$${amount.toStringAsFixed(2)})';
  }
}
