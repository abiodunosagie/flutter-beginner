/// Week 19, Exercise 3: Simple Data Table with Sorting
///
/// INTERMEDIATE LEVEL
///
/// Create a data table to display user data:
/// 1. Table with columns: Name, Email, Role, Status, Actions
/// 2. Sortable columns (click header to sort)
/// 3. Row highlighting on hover
/// 4. Action buttons (edit, delete)
/// 5. Responsive: show as cards on mobile
///
/// Learning objectives:
/// - Build data tables
/// - Implement sorting
/// - Handle table actions

import 'package:flutter/material.dart';

void main() {
  runApp(DataTableApp());
}

// TODO: Create User class
// Properties: id, name, email, role, status

class DataTableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      home: UserTablePage(),
    );
  }
}

class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  // TODO: Create list of sample users

  // TODO: Add sorting state variables
  // sortColumn, sortAscending

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // TODO: Add table header with search

            SizedBox(height: 16),

            // TODO: Build DataTable or custom table
            // Include sortable headers
          ],
        ),
      ),
    );
  }

  // TODO: Implement _sort method

  // TODO: Create _buildUserRow method
}
