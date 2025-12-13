/// Exercise 4 Solution: Drift Type-Safe SQL - Expense Tracker
/// Note: This is a simplified version. Full Drift implementation requires code generation.

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [Expenses])
class ExpenseDatabase extends _$ExpenseDatabase {
  ExpenseDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> addExpense(ExpensesCompanion entry) {
    return into(expenses).insert(entry);
  }

  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  Future<List<Expense>> getExpensesByCategory(String category) {
    return (select(expenses)..where((t) => t.category.equals(category))).get();
  }

  Future<double> getTotalByMonth(int year, int month) async {
    final result = await customSelect('SELECT SUM(amount) as total FROM expenses WHERE strftime("%Y", date) = ? AND strftime("%m", date) = ?', variables: [Variable.withString(year.toString()), Variable.withString(month.toString().padLeft(2, '0'))]).getSingleOrNull();
    return result?.read<double>('total') ?? 0.0;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'expenses.db'));
    return NativeDatabase(file);
  });
}
