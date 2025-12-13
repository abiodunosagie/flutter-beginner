/// Week 19, Exercise 3: Simple Data Table with Sorting
///
/// INTERMEDIATE LEVEL - SOLUTION

import 'package:flutter/material.dart';

void main() => runApp(DataTableApp());

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });
}

class DataTableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Table',
      debugShowCheckedModeBanner: false,
      home: UserTablePage(),
    );
  }
}

class UserTablePage extends StatefulWidget {
  @override
  _UserTablePageState createState() => _UserTablePageState();
}

class _UserTablePageState extends State<UserTablePage> {
  List<User> users = [
    User(id: '1', name: 'John Doe', email: 'john@example.com', role: 'Admin', status: 'Active'),
    User(id: '2', name: 'Jane Smith', email: 'jane@example.com', role: 'User', status: 'Active'),
    User(id: '3', name: 'Bob Johnson', email: 'bob@example.com', role: 'User', status: 'Inactive'),
    User(id: '4', name: 'Alice Williams', email: 'alice@example.com', role: 'Manager', status: 'Active'),
    User(id: '5', name: 'Charlie Brown', email: 'charlie@example.com', role: 'User', status: 'Active'),
  ];

  int? sortColumnIndex;
  bool sortAscending = true;

  void _sort<T>(Comparable<T> Function(User user) getField, int columnIndex) {
    setState(() {
      sortColumnIndex = columnIndex;
      if (sortColumnIndex == columnIndex) {
        sortAscending = !sortAscending;
      } else {
        sortAscending = true;
      }

      users.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);
        return sortAscending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Users Management'),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Users',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                SizedBox(
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: DataTable(
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    columns: [
                      DataColumn(
                        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) =>
                            _sort<String>((user) => user.name, columnIndex),
                      ),
                      DataColumn(
                        label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) =>
                            _sort<String>((user) => user.email, columnIndex),
                      ),
                      DataColumn(
                        label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                        onSort: (columnIndex, ascending) =>
                            _sort<String>((user) => user.role, columnIndex),
                      ),
                      DataColumn(
                        label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.name)),
                          DataCell(Text(user.email)),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getRoleColor(user.role),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.role,
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: user.status == 'Active'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.status,
                                style: TextStyle(
                                  color: user.status == 'Active' ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, size: 20),
                                  onPressed: () => print('Edit ${user.name}'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 20, color: Colors.red),
                                  onPressed: () => print('Delete ${user.name}'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return Colors.red;
      case 'Manager':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
