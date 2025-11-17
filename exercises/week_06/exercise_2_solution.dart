// Exercise 2: Bank Account System (Beginner-Intermediate)
// Topic: Inheritance with Method Overriding

// Parent Account class
class Account {
  String accountNumber;
  double balance;
  String accountHolder;

  Account(this.accountNumber, this.accountHolder, this.balance);

  void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      print('Deposited: \$${amount.toStringAsFixed(2)}');
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && balance >= amount) {
      balance -= amount;
      print('Withdrew: \$${amount.toStringAsFixed(2)}');
      return true;
    } else {
      print('Insufficient funds!');
      return false;
    }
  }

  void displayInfo() {
    print('Account: $accountNumber');
    print('Holder: $accountHolder');
    print('Balance: \$${balance.toStringAsFixed(2)}');
  }

  double calculateInterest() {
    return 0.0;
  }
}

// SavingsAccount class
class SavingsAccount extends Account {
  double interestRate;
  static const double minimumBalance = 100.0;

  SavingsAccount(
    String accountNumber,
    String accountHolder,
    double balance, {
    this.interestRate = 0.03,
  }) : super(accountNumber, accountHolder, balance);

  @override
  double calculateInterest() {
    return balance * interestRate;
  }

  @override
  bool withdraw(double amount) {
    if (balance - amount < minimumBalance) {
      print('Cannot withdraw! Minimum balance of \$$minimumBalance required.');
      return false;
    }
    return super.withdraw(amount);
  }

  void addInterest() {
    double interest = calculateInterest();
    balance += interest;
    print('Interest added: \$${interest.toStringAsFixed(2)}');
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Type: Savings Account');
    print('Interest Rate: ${(interestRate * 100).toStringAsFixed(1)}%');
  }
}

// CheckingAccount class
class CheckingAccount extends Account {
  double overdraftLimit;
  double transactionFee;
  int transactionCount = 0;
  static const int freeTransactions = 5;

  CheckingAccount(
    String accountNumber,
    String accountHolder,
    double balance,
    this.overdraftLimit, {
    this.transactionFee = 2.0,
  }) : super(accountNumber, accountHolder, balance);

  @override
  void deposit(double amount) {
    super.deposit(amount);
    transactionCount++;

    if (transactionCount > freeTransactions) {
      balance -= transactionFee;
      print('Transaction fee deducted: \$${transactionFee.toStringAsFixed(2)}');
    }
  }

  @override
  bool withdraw(double amount) {
    transactionCount++;

    if (amount > 0 && (balance + overdraftLimit) >= amount) {
      balance -= amount;
      print('Withdrew: \$${amount.toStringAsFixed(2)}');

      if (transactionCount > freeTransactions) {
        balance -= transactionFee;
        print('Transaction fee deducted: \$${transactionFee.toStringAsFixed(2)}');
      }

      if (balance < 0) {
        print('WARNING: Overdraft used. Balance: \$${balance.toStringAsFixed(2)}');
      }
      return true;
    } else {
      print('Insufficient funds (including overdraft limit)!');
      return false;
    }
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Type: Checking Account');
    print('Overdraft Limit: \$${overdraftLimit.toStringAsFixed(2)}');
    print('Transactions: $transactionCount');
  }
}

// BusinessAccount class
class BusinessAccount extends Account {
  int transactionLimit;
  int dailyTransactions = 0;

  BusinessAccount(
    String accountNumber,
    String accountHolder,
    double balance,
    this.transactionLimit,
  ) : super(accountNumber, accountHolder, balance);

  @override
  void deposit(double amount) {
    if (dailyTransactions >= transactionLimit) {
      print('Daily transaction limit reached!');
      return;
    }
    super.deposit(amount);
    dailyTransactions++;
  }

  @override
  bool withdraw(double amount) {
    if (dailyTransactions >= transactionLimit) {
      print('Daily transaction limit reached!');
      return false;
    }
    bool success = super.withdraw(amount);
    if (success) dailyTransactions++;
    return success;
  }

  void resetDailyTransactions() {
    dailyTransactions = 0;
    print('Daily transaction count reset.');
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Type: Business Account');
    print('Daily Transactions: $dailyTransactions/$transactionLimit');
  }
}

void main() {
  print('=== SAVINGS ACCOUNT ===');
  SavingsAccount savings = SavingsAccount('SAV001', 'Alice Johnson', 1000);
  savings.displayInfo();
  savings.deposit(500);
  savings.addInterest();
  savings.withdraw(1350); // Should fail - minimum balance
  savings.withdraw(50);
  print('Final balance: \$${savings.balance.toStringAsFixed(2)}\n');

  print('=== CHECKING ACCOUNT ===');
  CheckingAccount checking = CheckingAccount('CHK001', 'Bob Smith', 500, 200);
  checking.displayInfo();
  checking.withdraw(100);
  checking.withdraw(150);
  checking.withdraw(200);
  checking.withdraw(300); // Uses overdraft
  checking.deposit(50); // Free transactions exhausted
  checking.displayInfo();
  print('');

  print('=== BUSINESS ACCOUNT ===');
  BusinessAccount business = BusinessAccount('BUS001', 'Tech Corp', 10000, 3);
  business.displayInfo();
  business.deposit(1000);
  business.withdraw(500);
  business.deposit(2000);
  business.deposit(500); // Should fail - limit reached
  business.resetDailyTransactions();
  business.deposit(500); // Should work now
  business.displayInfo();
}
