/// Exercise 4: Drift Type-Safe SQL - Expense Tracker
/// Build an expense tracker with Drift for type-safe SQL operations

// TODO: Define Expense table with Drift annotations
// TODO: Create ExpenseDatabase with DAO
// TODO: Implement complex queries (filter by date, category, etc.)

class Expense {
  int? id;
  String description;
  double amount;
  String category;
  DateTime date;

  Expense({this.id, required this.description, required this.amount, required this.category, required this.date});
}

class ExpenseRepository {
  Future<void> init() async => throw UnimplementedError();
  Future<int> addExpense(Expense expense) async => throw UnimplementedError();
  Future<List<Expense>> getAllExpenses() async => throw UnimplementedError();
  Future<List<Expense>> getExpensesByCategory(String category) async => throw UnimplementedError();
  Future<double> getTotalByMonth(int year, int month) async => throw UnimplementedError();
}
