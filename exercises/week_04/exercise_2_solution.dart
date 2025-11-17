// Exercise 2: Bank Account (SOLUTION)

class BankAccount {
  final String accountNumber;
  final String ownerName;
  double _balance;
  List<String> _transactionHistory;

  BankAccount(this.accountNumber, this.ownerName, [double initialBalance = 0])
      : _balance = initialBalance,
        _transactionHistory = [] {
    if (initialBalance > 0) {
      _transactionHistory.add('Initial deposit: \$${initialBalance.toStringAsFixed(2)}');
    }
  }

  void deposit(double amount) {
    if (amount <= 0) {
      print('❌ Deposit amount must be positive');
      return;
    }
    _balance += amount;
    _transactionHistory.add('Deposit: +\$${amount.toStringAsFixed(2)} | Balance: \$${_balance.toStringAsFixed(2)}');
    print('✓ Deposited \$${amount.toStringAsFixed(2)}');
  }

  bool withdraw(double amount) {
    if (amount <= 0) {
      print('❌ Withdrawal amount must be positive');
      return false;
    }
    if (amount > _balance) {
      print('❌ Insufficient funds! Balance: \$${_balance.toStringAsFixed(2)}');
      return false;
    }
    _balance -= amount;
    _transactionHistory.add('Withdrawal: -\$${amount.toStringAsFixed(2)} | Balance: \$${_balance.toStringAsFixed(2)}');
    print('✓ Withdrew \$${amount.toStringAsFixed(2)}');
    return true;
  }

  double getBalance() {
    return _balance;
  }

  void printTransactionHistory() {
    print('\nTransaction History for $ownerName (Account: $accountNumber):');
    if (_transactionHistory.isEmpty) {
      print('No transactions yet');
    } else {
      for (int i = 0; i < _transactionHistory.length; i++) {
        print('${i + 1}. ${_transactionHistory[i]}');
      }
    }
  }
}

void main() {
  print('=== Bank Account System ===\n');

  // Create account with initial balance
  BankAccount account = BankAccount('ACC001', 'John Doe', 1000);
  print('Account created for ${account.ownerName}');
  print('Initial balance: \$${account.getBalance().toStringAsFixed(2)}\n');

  // Deposit
  account.deposit(500);
  account.deposit(250);

  // Withdraw
  print('');
  account.withdraw(300);

  // Try to overdraw
  print('');
  account.withdraw(2000);

  // Check balance
  print('\nCurrent balance: \$${account.getBalance().toStringAsFixed(2)}');

  // Display transaction history
  account.printTransactionHistory();
}
