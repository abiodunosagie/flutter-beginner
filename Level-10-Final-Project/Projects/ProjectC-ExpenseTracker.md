# Project C: Expense Tracker App

## Overview

Build a personal finance app where users can track their income and expenses, categorize transactions, and view spending summaries.

```
┌─────────────────────────────────────────────────────────┐
│                  EXPENSE TRACKER                         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  "Know where your money goes"                            │
│                                                          │
│  Features:                                               │
│  ├── Track income and expenses                          │
│  ├── Categorize transactions                            │
│  ├── View spending by category                          │
│  ├── Monthly summaries                                  │
│  └── Visual charts and stats                            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Core Features (Required)

### 1. Transaction Management

```
MUST HAVE:
□ Add new transactions (income or expense)
□ View list of all transactions
□ Edit transactions
□ Delete transactions
□ Transactions persist when app restarts
```

### 2. Transaction Details

```
Each transaction should have:
├── Amount (required)
├── Type (income or expense)
├── Category
├── Description (optional)
├── Date
└── Created timestamp
```

### 3. Categories

```
EXPENSE CATEGORIES:
├── Food & Dining
├── Transportation
├── Shopping
├── Bills & Utilities
├── Entertainment
└── Other

INCOME CATEGORIES:
├── Salary
├── Freelance
├── Gift
└── Other
```

### 4. Summary View

```
MUST HAVE:
□ Total income this month
□ Total expenses this month
□ Current balance
□ Spending by category
```

---

## Screens

### Screen 1: Home/Dashboard

```
┌─────────────────────────────────────┐
│  [≡]  Expense Tracker    [📊]      │
├─────────────────────────────────────┤
│                                     │
│  January 2024                       │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │      Balance                │   │
│  │      $1,250.00             │   │
│  │                             │   │
│  │  Income      Expenses       │   │
│  │  $3,000      $1,750        │   │
│  │  ↑           ↓             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Spending by Category               │
│  ┌─────────────────────────────┐   │
│  │ 🍔 Food         $450   26% │   │
│  │ ████████░░░░░░░░░░░░░░░░   │   │
│  │                             │   │
│  │ 🚗 Transport    $300   17% │   │
│  │ █████░░░░░░░░░░░░░░░░░░░   │   │
│  │                             │   │
│  │ 🛍️ Shopping     $500   29% │   │
│  │ █████████░░░░░░░░░░░░░░░   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Recent Transactions                │
│  ┌─────────────────────────────┐   │
│  │ 🍔 Lunch          -$15.00  │   │
│  │ Today • Food                │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 💰 Salary       +$3,000.00 │   │
│  │ Jan 1 • Income              │   │
│  └─────────────────────────────┘   │
│                                     │
│                          [+ Add]   │
└─────────────────────────────────────┘
```

### Screen 2: Add Transaction

```
┌─────────────────────────────────────┐
│  [←]  Add Transaction     [Save]   │
├─────────────────────────────────────┤
│                                     │
│  Transaction Type                   │
│  ┌─────────────┐ ┌─────────────┐   │
│  │  💰 Income  │ │  💸 Expense │   │
│  └─────────────┘ └─────────────┘   │
│                                     │
│  Amount *                           │
│  ┌─────────────────────────────┐   │
│  │ $ 0.00                      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Category                           │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │
│  │🍔 │ │🚗 │ │🛍️ │ │💡 │      │
│  │Food│ │Trns│ │Shop│ │Bill│      │
│  └────┘ └────┘ └────┘ └────┘      │
│  ┌────┐ ┌────┐                     │
│  │🎬 │ │📦 │                     │
│  │Fun │ │Othr│                     │
│  └────┘ └────┘                     │
│                                     │
│  Description                        │
│  ┌─────────────────────────────┐   │
│  │ What was this for?          │   │
│  └─────────────────────────────┘   │
│                                     │
│  Date                               │
│  ┌─────────────────────────────┐   │
│  │ 📅 January 15, 2024         │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Screen 3: Transaction History

```
┌─────────────────────────────────────┐
│  [←]  History           [Filter]   │
├─────────────────────────────────────┤
│                                     │
│  ┌─ All ─┬─ Income ─┬─ Expense ─┐  │
│  └───────┴──────────┴───────────┘  │
│                                     │
│  January 2024                       │
│  ────────────────────────────────   │
│                                     │
│  Today                              │
│  ┌─────────────────────────────┐   │
│  │ 🍔 Lunch           -$15.00 │   │
│  │ Food & Dining               │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ☕ Coffee           -$5.00 │   │
│  │ Food & Dining               │   │
│  └─────────────────────────────┘   │
│                                     │
│  Yesterday                          │
│  ┌─────────────────────────────┐   │
│  │ 🚗 Uber            -$25.00 │   │
│  │ Transportation              │   │
│  └─────────────────────────────┘   │
│                                     │
│  January 1                          │
│  ┌─────────────────────────────┐   │
│  │ 💰 Salary       +$3,000.00 │   │
│  │ Income                      │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Screen 4: Statistics

```
┌─────────────────────────────────────┐
│  [←]  Statistics                    │
├─────────────────────────────────────┤
│                                     │
│  ◄  January 2024  ►                 │
│                                     │
│  Summary                            │
│  ┌─────────────────────────────┐   │
│  │ Total Income    $3,000.00   │   │
│  │ Total Expenses  $1,750.00   │   │
│  │ ─────────────────────────   │   │
│  │ Net             $1,250.00   │   │
│  └─────────────────────────────┘   │
│                                     │
│  Expenses by Category               │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │      ┌───────┐              │   │
│  │    ┌─┤ Food  ├─┐            │   │
│  │    │ │  26%  │ │            │   │
│  │ Shop│ └──────┘ │Transport   │   │
│  │ 29% │         │ 17%        │   │
│  │     └────┬────┘             │   │
│  │        Bills               │   │
│  │        28%                  │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Top Expenses                       │
│  1. Shopping      $500             │
│  2. Bills         $490             │
│  3. Food          $450             │
│                                     │
└─────────────────────────────────────┘
```

---

## Data Model

```dart
// models/transaction.dart
enum TransactionType { income, expense }

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final String category;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
    required this.date,
    required this.createdAt,
  });

  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;

  // Add toMap, fromMap, copyWith methods
}

// models/category.dart
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isExpense; // true for expense, false for income

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isExpense,
  });
}
```

---

## Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── models/
│   ├── transaction.dart
│   └── category.dart
│
├── services/
│   └── database_service.dart
│
├── providers/
│   └── transaction_provider.dart
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── balance_card.dart
│   │       ├── category_breakdown.dart
│   │       └── recent_transactions.dart
│   ├── transaction/
│   │   ├── add_transaction_screen.dart
│   │   ├── edit_transaction_screen.dart
│   │   └── transaction_detail_screen.dart
│   ├── history/
│   │   └── history_screen.dart
│   ├── statistics/
│   │   └── statistics_screen.dart
│   └── splash_screen.dart
│
├── widgets/
│   ├── transaction_tile.dart
│   ├── category_chip.dart
│   ├── amount_input.dart
│   └── empty_state.dart
│
├── utils/
│   └── formatters.dart  # Currency, date formatting
│
└── config/
    ├── theme.dart
    ├── routes.dart
    └── categories.dart
```

---

## Implementation Steps

### Phase 1: Foundation

```
□ Create Flutter project
□ Set up folder structure
□ Add dependencies
□ Create Transaction model
□ Create Category model with defaults
□ Set up DatabaseService
□ Create transactions table
```

### Phase 2: Core Features

```
□ Create TransactionProvider
□ Implement loadTransactions()
□ Build HomeScreen with balance card
□ Create TransactionTile widget
□ Implement addTransaction()
□ Build AddTransactionScreen
□ Implement deleteTransaction()
□ Build transaction history screen
```

### Phase 3: Calculations

```
□ Calculate total income
□ Calculate total expenses
□ Calculate balance
□ Group transactions by category
□ Calculate category percentages
□ Build category breakdown widget
□ Filter by date range (month)
```

### Phase 4: Polish

```
□ Add loading states
□ Add empty states
□ Add error handling
□ Format currency properly
□ Format dates nicely
□ Add delete confirmation
□ Add success/error snackbars
□ Create splash screen
□ Test all features
```

---

## Bonus Features (Optional)

```
NICE TO HAVE:
□ Budget limits per category
□ Recurring transactions
□ Multiple currencies
□ Export to CSV
□ Charts (pie chart, bar chart)
□ Monthly comparisons
□ Yearly overview
□ Photo receipts
□ Multiple accounts
□ Bill reminders
```

---

## Currency Formatting

```dart
// utils/formatters.dart
import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _formatter.format(amount);
  }

  static String formatWithSign(double amount, bool isExpense) {
    final formatted = format(amount.abs());
    return isExpense ? '-$formatted' : '+$formatted';
  }
}

// Usage
Text(CurrencyFormatter.format(1234.56)); // $1,234.56
Text(CurrencyFormatter.formatWithSign(50, true)); // -$50.00
```

---

## Calculating Summaries

```dart
// In TransactionProvider
class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  // Total income for current month
  double get totalIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
          t.isIncome &&
          t.date.month == now.month &&
          t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Total expenses for current month
  double get totalExpenses {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
          t.isExpense &&
          t.date.month == now.month &&
          t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Current balance
  double get balance => totalIncome - totalExpenses;

  // Expenses by category
  Map<String, double> get expensesByCategory {
    final now = DateTime.now();
    final monthExpenses = _transactions.where((t) =>
      t.isExpense &&
      t.date.month == now.month &&
      t.date.year == now.year);

    final map = <String, double>{};
    for (final t in monthExpenses) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }
}
```

---

## Packages to Use

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.18.1  # Currency and date formatting
  uuid: ^4.2.1
  fl_chart: ^0.66.0  # Optional: for pie/bar charts

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## Grading Criteria

```
BASIC (Pass) - 60%
□ Can add income/expense
□ Can view transactions
□ Shows total income/expenses
□ Can delete transactions
□ Data persists

GOOD (B Grade) - 75%
□ All basic features
□ Categories work
□ Shows balance correctly
□ UI looks clean
□ Loading/empty states

EXCELLENT (A Grade) - 90%
□ All good features
□ Category breakdown works
□ Filter by type
□ History screen works
□ Currency formatted properly
□ Well organized code

OUTSTANDING (A+ Grade) - 100%
□ All excellent features
□ Statistics screen with charts
□ Monthly navigation
□ Edit transactions
□ Unit tests
□ Exceptional polish
```

---

## Tips for Success

```
1. NUMBERS ARE TRICKY
   Always use double for money, not int.
   Format with 2 decimal places.

2. DATES MATTER
   Store dates properly (DateTime).
   Filter by month for summaries.

3. TEST CALCULATIONS
   Add several transactions.
   Verify totals are correct.

4. COLOR CODE
   Green for income (+)
   Red for expenses (-)
   Makes scanning easier!

5. THINK ABOUT EDGE CASES
   What if there are no transactions?
   What if all transactions are income?
```

---

Good luck with your finances! 💰
