# Dashboard Part 3: Data Tables with Sorting & Filtering

## What You'll Learn

In this lesson, you'll build a professional data table with:
- Sorting by any column (ascending/descending)
- Search/filter functionality
- Pagination for large datasets
- Row selection
- Custom actions (edit, delete)
- Responsive design (cards on mobile, table on desktop)

By the end, you'll have a fully functional user management table!

## Understanding Data Tables

Think of a data table like a spreadsheet - it has:
- **Columns**: Categories of information (Name, Email, Role)
- **Rows**: Individual items (each user)
- **Sorting**: Click column header to sort A→Z or Z→A
- **Filtering**: Search to find specific items
- **Pagination**: Show 10 items per page instead of 1000

## Step 1: Create User Model

First, let's create a model to represent table data.

Create `lib/core/models/user.dart`:

```dart
class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final DateTime joinedDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.joinedDate,
  });

  // Helper to create from JSON (for API integration later)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
    );
  }

  // Helper to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'joinedDate': joinedDate.toIso8601String(),
    };
  }

  // CopyWith for immutability
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? status,
    DateTime? joinedDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}
```

## Step 2: Create Table State Management

We'll use a simple state class to manage sorting, filtering, and pagination.

Create `lib/widgets/data_table/table_state.dart`:

```dart
import 'package:flutter/foundation.dart';
import '../../core/models/user.dart';

enum SortDirection {
  ascending,
  descending,
  none,
}

class TableState extends ChangeNotifier {
  List<User> _allUsers = [];
  List<User> _filteredUsers = [];

  String _searchQuery = '';
  String? _sortColumn;
  SortDirection _sortDirection = SortDirection.none;

  int _currentPage = 0;
  int _rowsPerPage = 10;

  // Getters
  List<User> get allUsers => _allUsers;
  List<User> get filteredUsers => _filteredUsers;
  String get searchQuery => _searchQuery;
  String? get sortColumn => _sortColumn;
  SortDirection get sortDirection => _sortDirection;
  int get currentPage => _currentPage;
  int get rowsPerPage => _rowsPerPage;

  int get totalPages {
    if (_filteredUsers.isEmpty) return 0;
    return (_filteredUsers.length / _rowsPerPage).ceil();
  }

  List<User> get currentPageUsers {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, _filteredUsers.length);

    if (startIndex >= _filteredUsers.length) return [];
    return _filteredUsers.sublist(startIndex, endIndex);
  }

  // Initialize with data
  void setUsers(List<User> users) {
    _allUsers = users;
    _filteredUsers = users;
    _currentPage = 0;
    notifyListeners();
  }

  // Search/Filter
  void search(String query) {
    _searchQuery = query.toLowerCase();
    _currentPage = 0; // Reset to first page

    if (_searchQuery.isEmpty) {
      _filteredUsers = _allUsers;
    } else {
      _filteredUsers = _allUsers.where((user) {
        return user.name.toLowerCase().contains(_searchQuery) ||
               user.email.toLowerCase().contains(_searchQuery) ||
               user.role.toLowerCase().contains(_searchQuery) ||
               user.status.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Re-apply sorting if active
    if (_sortColumn != null && _sortDirection != SortDirection.none) {
      _applySorting();
    }

    notifyListeners();
  }

  // Sort by column
  void sortByColumn(String column) {
    if (_sortColumn == column) {
      // Cycle through: none → ascending → descending → none
      switch (_sortDirection) {
        case SortDirection.none:
          _sortDirection = SortDirection.ascending;
          break;
        case SortDirection.ascending:
          _sortDirection = SortDirection.descending;
          break;
        case SortDirection.descending:
          _sortDirection = SortDirection.none;
          _sortColumn = null;
          _filteredUsers = List.from(_allUsers);
          break;
      }
    } else {
      _sortColumn = column;
      _sortDirection = SortDirection.ascending;
    }

    if (_sortDirection != SortDirection.none) {
      _applySorting();
    }

    notifyListeners();
  }

  void _applySorting() {
    _filteredUsers.sort((a, b) {
      int comparison = 0;

      switch (_sortColumn) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'email':
          comparison = a.email.compareTo(b.email);
          break;
        case 'role':
          comparison = a.role.compareTo(b.role);
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'joinedDate':
          comparison = a.joinedDate.compareTo(b.joinedDate);
          break;
      }

      return _sortDirection == SortDirection.ascending ? comparison : -comparison;
    });
  }

  // Pagination
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void setRowsPerPage(int rows) {
    _rowsPerPage = rows;
    _currentPage = 0; // Reset to first page
    notifyListeners();
  }

  // Delete user
  void deleteUser(String userId) {
    _allUsers = _allUsers.where((u) => u.id != userId).toList();
    search(_searchQuery); // Re-apply filter
  }
}
```

**What's happening here?**

1. **State Management**: We use `ChangeNotifier` to notify widgets when data changes
2. **Filtering**: Search checks if query appears in name, email, role, or status
3. **Sorting**: We compare values and reverse for descending order
4. **Pagination**: Calculate which slice of data to show (rows 0-9, 10-19, etc.)
5. **Immutability**: We create new lists instead of modifying existing ones

## Step 3: Create Table Header with Sorting

Create `lib/widgets/data_table/table_header.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import 'table_state.dart';

class SortableTableHeader extends StatefulWidget {
  final String label;
  final String columnKey;
  final TableState tableState;

  const SortableTableHeader({
    Key? key,
    required this.label,
    required this.columnKey,
    required this.tableState,
  }) : super(key: key);

  @override
  State<SortableTableHeader> createState() => _SortableTableHeaderState();
}

class _SortableTableHeaderState extends State<SortableTableHeader> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.tableState.sortColumn == widget.columnKey;
    final sortDirection = widget.tableState.sortDirection;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => widget.tableState.sortByColumn(widget.columnKey),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered
                ? DashboardColors.surfaceHover
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? DashboardColors.primary
                      : DashboardColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 16,
                child: isActive
                    ? Icon(
                        sortDirection == SortDirection.ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 14,
                        color: DashboardColors.primary,
                      )
                    : _isHovered
                        ? const Icon(
                            Icons.unfold_more,
                            size: 14,
                            color: DashboardColors.textSecondary,
                          )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Step 4: Create Search Bar

Create `lib/widgets/data_table/table_search.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import 'table_state.dart';

class TableSearchBar extends StatefulWidget {
  final TableState tableState;

  const TableSearchBar({
    Key? key,
    required this.tableState,
  }) : super(key: key);

  @override
  State<TableSearchBar> createState() => _TableSearchBarState();
}

class _TableSearchBarState extends State<TableSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DashboardColors.border),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (value) => widget.tableState.search(value),
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: const TextStyle(
            color: DashboardColors.textSecondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: DashboardColors.textSecondary,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                    color: DashboardColors.textSecondary,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.tableState.search('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
```

## Step 5: Create Pagination Controls

Create `lib/widgets/data_table/table_pagination.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import 'table_state.dart';

class TablePagination extends StatelessWidget {
  final TableState tableState;

  const TablePagination({
    Key? key,
    required this.tableState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rows per page selector
        Row(
          children: [
            const Text(
              'Rows per page:',
              style: TextStyle(
                fontSize: 14,
                color: DashboardColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: DashboardColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButton<int>(
                value: tableState.rowsPerPage,
                underline: const SizedBox.shrink(),
                items: [5, 10, 25, 50].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    tableState.setRowsPerPage(value);
                  }
                },
              ),
            ),
          ],
        ),

        // Page info and navigation
        Row(
          children: [
            Text(
              'Page ${tableState.currentPage + 1} of ${tableState.totalPages}',
              style: const TextStyle(
                fontSize: 14,
                color: DashboardColors.textSecondary,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: tableState.currentPage > 0
                  ? tableState.previousPage
                  : null,
              color: DashboardColors.textPrimary,
              disabledColor: DashboardColors.textSecondary.withOpacity(0.3),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: tableState.currentPage < tableState.totalPages - 1
                  ? tableState.nextPage
                  : null,
              color: DashboardColors.textPrimary,
              disabledColor: DashboardColors.textSecondary.withOpacity(0.3),
            ),
          ],
        ),
      ],
    );
  }
}
```

## Step 6: Create Status Badge

Create `lib/widgets/data_table/status_badge.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status.toLowerCase());

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: config.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  StatusConfig _getStatusConfig(String status) {
    switch (status) {
      case 'active':
        return StatusConfig(
          backgroundColor: DashboardColors.success.withOpacity(0.1),
          textColor: DashboardColors.success,
        );
      case 'inactive':
        return StatusConfig(
          backgroundColor: DashboardColors.textSecondary.withOpacity(0.1),
          textColor: DashboardColors.textSecondary,
        );
      case 'pending':
        return StatusConfig(
          backgroundColor: DashboardColors.warning.withOpacity(0.1),
          textColor: DashboardColors.warning,
        );
      case 'suspended':
        return StatusConfig(
          backgroundColor: DashboardColors.error.withOpacity(0.1),
          textColor: DashboardColors.error,
        );
      default:
        return StatusConfig(
          backgroundColor: DashboardColors.info.withOpacity(0.1),
          textColor: DashboardColors.info,
        );
    }
  }
}

class StatusConfig {
  final Color backgroundColor;
  final Color textColor;

  StatusConfig({
    required this.backgroundColor,
    required this.textColor,
  });
}
```

## Step 7: Create the Main Data Table

Create `lib/widgets/data_table/users_data_table.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/models/user.dart';
import '../../core/utils/responsive.dart';
import 'table_state.dart';
import 'table_header.dart';
import 'table_search.dart';
import 'table_pagination.dart';
import 'status_badge.dart';

class UsersDataTable extends StatefulWidget {
  final List<User> users;

  const UsersDataTable({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  State<UsersDataTable> createState() => _UsersDataTableState();
}

class _UsersDataTableState extends State<UsersDataTable> {
  late TableState _tableState;

  @override
  void initState() {
    super.initState();
    _tableState = TableState();
    _tableState.setUsers(widget.users);
    _tableState.addListener(_onTableStateChanged);
  }

  @override
  void dispose() {
    _tableState.removeListener(_onTableStateChanged);
    _tableState.dispose();
    super.dispose();
  }

  void _onTableStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and search
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: DashboardColors.textPrimary,
                  ),
                ),
                TableSearchBar(tableState: _tableState),
              ],
            ),
          ),

          const Divider(height: 1),

          // Table content (responsive)
          ResponsiveBuilder(
            builder: (context, deviceSize) {
              final isDesktop = deviceSize.index >= DeviceSize.md.index;

              if (isDesktop) {
                return _buildDesktopTable();
              } else {
                return _buildMobileCards();
              }
            },
          ),

          const Divider(height: 1),

          // Pagination
          Padding(
            padding: const EdgeInsets.all(24),
            child: TablePagination(tableState: _tableState),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateProperty.all(
          DashboardColors.background,
        ),
        columns: [
          DataColumn(
            label: SortableTableHeader(
              label: 'Name',
              columnKey: 'name',
              tableState: _tableState,
            ),
          ),
          DataColumn(
            label: SortableTableHeader(
              label: 'Email',
              columnKey: 'email',
              tableState: _tableState,
            ),
          ),
          DataColumn(
            label: SortableTableHeader(
              label: 'Role',
              columnKey: 'role',
              tableState: _tableState,
            ),
          ),
          DataColumn(
            label: SortableTableHeader(
              label: 'Status',
              columnKey: 'status',
              tableState: _tableState,
            ),
          ),
          DataColumn(
            label: SortableTableHeader(
              label: 'Joined',
              columnKey: 'joinedDate',
              tableState: _tableState,
            ),
          ),
          const DataColumn(
            label: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Actions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
        rows: _tableState.currentPageUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: DashboardColors.primary.withOpacity(0.1),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: DashboardColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(Text(user.email)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.role,
                    style: TextStyle(
                      color: _getRoleColor(user.role),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(StatusBadge(status: user.status)),
              DataCell(
                Text(
                  DateFormat('MMM dd, yyyy').format(user.joinedDate),
                  style: const TextStyle(
                    color: DashboardColors.textSecondary,
                  ),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      color: DashboardColors.primary,
                      onTap: () => _editUser(user),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.delete,
                      color: DashboardColors.error,
                      onTap: () => _deleteUser(user),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileCards() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _tableState.currentPageUsers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = _tableState.currentPageUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: DashboardColors.primary.withOpacity(0.1),
                child: Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: DashboardColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: DashboardColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: user.status),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildInfoChip('Role', user.role, _getRoleColor(user.role)),
              const SizedBox(width: 12),
              _buildInfoChip(
                'Joined',
                DateFormat('MMM dd, yyyy').format(user.joinedDate),
                DashboardColors.textSecondary,
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editUser(user),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _deleteUser(user),
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DashboardColors.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return DashboardColors.error;
      case 'editor':
        return DashboardColors.warning;
      case 'viewer':
        return DashboardColors.info;
      default:
        return DashboardColors.textSecondary;
    }
  }

  void _editUser(User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit user: ${user.name}')),
    );
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _tableState.deleteUser(user.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DashboardColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

**Note:** This table uses the `intl` package for date formatting. Add it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.18.0
```

## Step 8: Create Users Page

Create `lib/pages/users_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/user.dart';
import '../widgets/data_table/users_data_table.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: UsersDataTable(
        users: _generateSampleUsers(),
      ),
    );
  }

  List<User> _generateSampleUsers() {
    return [
      User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        role: 'Admin',
        status: 'Active',
        joinedDate: DateTime(2023, 1, 15),
      ),
      User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        role: 'Editor',
        status: 'Active',
        joinedDate: DateTime(2023, 2, 20),
      ),
      User(
        id: '3',
        name: 'Bob Johnson',
        email: 'bob.j@example.com',
        role: 'Viewer',
        status: 'Inactive',
        joinedDate: DateTime(2023, 3, 10),
      ),
      User(
        id: '4',
        name: 'Alice Williams',
        email: 'alice.w@example.com',
        role: 'Editor',
        status: 'Active',
        joinedDate: DateTime(2023, 4, 5),
      ),
      User(
        id: '5',
        name: 'Charlie Brown',
        email: 'charlie.b@example.com',
        role: 'Viewer',
        status: 'Pending',
        joinedDate: DateTime(2023, 5, 12),
      ),
      User(
        id: '6',
        name: 'Diana Prince',
        email: 'diana.p@example.com',
        role: 'Admin',
        status: 'Active',
        joinedDate: DateTime(2023, 6, 18),
      ),
      User(
        id: '7',
        name: 'Ethan Hunt',
        email: 'ethan.h@example.com',
        role: 'Editor',
        status: 'Suspended',
        joinedDate: DateTime(2023, 7, 22),
      ),
      User(
        id: '8',
        name: 'Fiona Green',
        email: 'fiona.g@example.com',
        role: 'Viewer',
        status: 'Active',
        joinedDate: DateTime(2023, 8, 8),
      ),
      User(
        id: '9',
        name: 'George Miller',
        email: 'george.m@example.com',
        role: 'Editor',
        status: 'Active',
        joinedDate: DateTime(2023, 9, 14),
      ),
      User(
        id: '10',
        name: 'Hannah Montana',
        email: 'hannah.m@example.com',
        role: 'Viewer',
        status: 'Inactive',
        joinedDate: DateTime(2023, 10, 3),
      ),
      User(
        id: '11',
        name: 'Ian Malcolm',
        email: 'ian.m@example.com',
        role: 'Admin',
        status: 'Active',
        joinedDate: DateTime(2023, 11, 7),
      ),
      User(
        id: '12',
        name: 'Julia Roberts',
        email: 'julia.r@example.com',
        role: 'Editor',
        status: 'Active',
        joinedDate: DateTime(2023, 12, 1),
      ),
      // Add more users to test pagination...
      User(
        id: '13',
        name: 'Kevin Hart',
        email: 'kevin.h@example.com',
        role: 'Viewer',
        status: 'Active',
        joinedDate: DateTime(2024, 1, 10),
      ),
      User(
        id: '14',
        name: 'Laura Croft',
        email: 'laura.c@example.com',
        role: 'Editor',
        status: 'Pending',
        joinedDate: DateTime(2024, 2, 14),
      ),
      User(
        id: '15',
        name: 'Mike Tyson',
        email: 'mike.t@example.com',
        role: 'Viewer',
        status: 'Suspended',
        joinedDate: DateTime(2024, 3, 20),
      ),
    ];
  }
}
```

## Step 9: Add Users Route

Update your `main.dart` to add the users route:

```dart
Widget _buildCurrentPage() {
  switch (_currentRoute) {
    case '/dashboard':
      return const DashboardPage();
    case '/users':
      return const UsersPage();
    case '/products/all':
      return const Center(child: Text('All Products'));
    // ... other routes
    default:
      return const DashboardPage();
  }
}
```

## Step 10: Test Your Data Table

Run the app:

```bash
flutter run -d chrome
```

**Try these actions:**

1. **Click column headers** to sort (Name, Email, Role, Status, Joined)
   - First click: Sort ascending (A→Z)
   - Second click: Sort descending (Z→A)
   - Third click: Remove sorting

2. **Search for users**:
   - Type "john" - should filter to John Doe
   - Type "admin" - should show all admins
   - Type "active" - should show all active users

3. **Change pagination**:
   - Change "Rows per page" from 10 to 5
   - Click next/previous page buttons

4. **Resize window**:
   - Desktop (>900px): Shows table view
   - Mobile (<900px): Shows card view

5. **Actions**:
   - Click Edit - shows snackbar
   - Click Delete - shows confirmation dialog

## Understanding the Concepts

### 1. State Management with ChangeNotifier

```dart
class TableState extends ChangeNotifier {
  void search(String query) {
    // Update state
    _searchQuery = query;

    // Notify all listeners
    notifyListeners();
  }
}

// In widget
_tableState.addListener(() {
  setState(() {}); // Rebuild when state changes
});
```

### 2. Sorting Algorithm

```dart
list.sort((a, b) {
  int comparison = a.name.compareTo(b.name);

  // Reverse for descending
  return isAscending ? comparison : -comparison;
});
```

### 3. Pagination Math

```dart
// Total pages = total items ÷ items per page (rounded up)
final totalPages = (100 / 10).ceil(); // = 10 pages

// Current page items
final startIndex = 2 * 10; // Page 2, 10 per page = index 20
final endIndex = startIndex + 10; // = index 30
final items = allItems.sublist(20, 30); // Items 20-29
```

### 4. Filtering with Where

```dart
final filtered = users.where((user) {
  return user.name.contains(query) ||
         user.email.contains(query);
}).toList();
```

## Exercises

### Exercise 1: Add Select All Checkbox
Add a checkbox in the header to select/deselect all users.

**Hint:** Add a `Set<String> selectedIds` to TableState.

### Exercise 2: Add Bulk Delete
When users are selected, show a "Delete Selected" button.

### Exercise 3: Add Export to CSV
Add a button to export the current filtered data to CSV format.

**Hint:**
```dart
String toCsv(List<User> users) {
  final header = 'Name,Email,Role,Status,Joined\n';
  final rows = users.map((u) {
    return '${u.name},${u.email},${u.role},${u.status},${u.joinedDate}';
  }).join('\n');
  return header + rows;
}
```

### Exercise 4: Add Advanced Filters
Add dropdowns to filter by role and status.

### Exercise 5: Add Column Visibility Toggle
Let users hide/show columns they don't need.

## What You've Learned

✅ Managing complex table state with ChangeNotifier
✅ Implementing sortable columns
✅ Building search/filter functionality
✅ Creating pagination with page controls
✅ Responsive tables (table on desktop, cards on mobile)
✅ Custom action buttons with confirmation dialogs
✅ Using DataTable widget effectively
✅ Date formatting with intl package

## Next Steps

In the next lesson, we'll create a **Weather Web App** to demonstrate:
- Making real API calls in Flutter web
- Handling loading and error states
- Displaying API data beautifully
- Caching API responses
- Weather icons and animations

You're mastering professional web development with Flutter! 🚀
