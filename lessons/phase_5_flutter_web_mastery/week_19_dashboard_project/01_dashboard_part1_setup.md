# Week 19: Complete Dashboard - Part 1 (Setup & Layout)

## What We're Building

A **professional admin dashboard** with:
- 📊 Dashboard overview with stats
- 📈 Charts and graphs (no packages!)
- 📋 Data tables with sorting/filtering
- 👥 User management
- 🎨 Multi-level sidebar navigation
- 📱 Fully responsive
- 🔔 Notifications panel
- 👤 User profile dropdown

**Think of it like:** Building a backend admin panel for managing an e-commerce store or SaaS application.

---

## Project Setup

### Step 1: Create New Project

```bash
flutter create admin_dashboard
cd admin_dashboard
flutter run -d chrome
```

### Step 2: Project Structure

```
lib/
├── main.dart
├── core/
│   ├── responsive/
│   │   ├── breakpoints.dart
│   │   ├── responsive_builder.dart
│   │   └── responsive_values.dart
│   ├── theme/
│   │   ├── dashboard_colors.dart
│   │   └── dashboard_typography.dart
│   ├── constants/
│   │   └── dashboard_constants.dart
│   └── models/
│       ├── user.dart
│       ├── stat_card_data.dart
│       └── menu_item.dart
├── widgets/
│   ├── sidebar/
│   │   ├── dashboard_sidebar.dart
│   │   └── sidebar_menu_item.dart
│   ├── topbar/
│   │   ├── dashboard_topbar.dart
│   │   ├── search_bar.dart
│   │   └── user_menu.dart
│   ├── cards/
│   │   ├── stat_card.dart
│   │   └── chart_card.dart
│   └── common/
│       ├── custom_button.dart
│       └── loading_indicator.dart
└── pages/
    ├── dashboard_page.dart
    ├── users_page.dart
    ├── analytics_page.dart
    └── settings_page.dart
```

---

## Design System

### Step 3: Dashboard Colors

**lib/core/theme/dashboard_colors.dart**
```dart
import 'package:flutter/material.dart';

class DashboardColors {
  // Sidebar colors
  static const Color sidebarBg = Color(0xFF1E293B);
  static const Color sidebarHover = Color(0xFF334155);
  static const Color sidebarActive = Color(0xFF3B82F6);

  // Primary colors
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);

  // Background colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFF1F5F9);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF3B82F6), // Blue
    Color(0xFF8B5CF6), // Purple
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Green
    Color(0xFFEF4444), // Red
    Color(0xFF06B6D4), // Cyan
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );
}
```

---

## Core Models

### Step 4: Menu Item Model

**lib/core/models/menu_item.dart**
```dart
import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<MenuItem>? children;
  final bool isExpanded;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.children,
    this.isExpanded = false,
  });

  MenuItem copyWith({
    String? title,
    IconData? icon,
    String? route,
    List<MenuItem>? children,
    bool? isExpanded,
  }) {
    return MenuItem(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
```

### Step 5: Stat Card Data Model

**lib/core/models/stat_card_data.dart**
```dart
import 'package:flutter/material.dart';

class StatCardData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double changePercent;
  final bool isIncrease;

  StatCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.changePercent,
    required this.isIncrease,
  });
}
```

---

## Responsive System

Copy from landing page project:

**lib/core/responsive/breakpoints.dart**
```dart
class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}
```

**lib/core/responsive/responsive_builder.dart**
```dart
import 'package:flutter/material.dart';
import 'breakpoints.dart';

enum DeviceSize { xs, sm, md, lg, xl }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, DeviceSize) builder;

  const ResponsiveBuilder({Key? key, required this.builder}) : super(key: key);

  static DeviceSize getDeviceSize(double width) {
    if (width < Breakpoints.sm) return DeviceSize.xs;
    if (width < Breakpoints.md) return DeviceSize.sm;
    if (width < Breakpoints.lg) return DeviceSize.md;
    if (width < Breakpoints.xl) return DeviceSize.lg;
    return DeviceSize.xl;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSize = getDeviceSize(constraints.maxWidth);
        return builder(context, deviceSize);
      },
    );
  }
}
```

**lib/core/responsive/responsive_values.dart**
```dart
import 'package:flutter/material.dart';
import 'responsive_builder.dart';

T responsive<T>(
  BuildContext context, {
  required T xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
}) {
  final width = MediaQuery.of(context).size.width;
  final size = ResponsiveBuilder.getDeviceSize(width);

  switch (size) {
    case DeviceSize.xs:
      return xs;
    case DeviceSize.sm:
      return sm ?? xs;
    case DeviceSize.md:
      return md ?? sm ?? xs;
    case DeviceSize.lg:
      return lg ?? md ?? sm ?? xs;
    case DeviceSize.xl:
      return xl ?? lg ?? md ?? sm ?? xs;
  }
}
```

---

## Dashboard Sidebar

### Step 6: Sidebar Menu Item Widget

**lib/widgets/sidebar/sidebar_menu_item.dart**
```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/models/menu_item.dart';

class SidebarMenuItem extends StatefulWidget {
  final MenuItem menuItem;
  final bool isActive;
  final VoidCallback onTap;
  final Function(MenuItem)? onExpandToggle;

  const SidebarMenuItem({
    Key? key,
    required this.menuItem,
    required this.isActive,
    required this.onTap,
    this.onExpandToggle,
  }) : super(key: key);

  @override
  _SidebarMenuItemState createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<SidebarMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main menu item
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (widget.menuItem.children != null) {
                widget.onExpandToggle?.call(widget.menuItem);
              } else {
                widget.onTap();
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? DashboardColors.sidebarActive
                    : (_isHovered ? DashboardColors.sidebarHover : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.menuItem.icon,
                    color: DashboardColors.textWhite,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.menuItem.title,
                      style: TextStyle(
                        color: DashboardColors.textWhite,
                        fontSize: 14,
                        fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (widget.menuItem.children != null)
                    Icon(
                      widget.menuItem.isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: DashboardColors.textWhite,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),

        // Submenu items
        if (widget.menuItem.children != null && widget.menuItem.isExpanded)
          ...widget.menuItem.children!.map((child) {
            return Padding(
              padding: EdgeInsets.only(left: 24),
              child: SidebarMenuItem(
                menuItem: child,
                isActive: false,
                onTap: widget.onTap,
              ),
            );
          }).toList(),
      ],
    );
  }
}
```

### Step 7: Complete Sidebar

**lib/widgets/sidebar/dashboard_sidebar.dart**
```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/models/menu_item.dart';
import 'sidebar_menu_item.dart';

class DashboardSidebar extends StatefulWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const DashboardSidebar({
    Key? key,
    required this.currentRoute,
    required this.onNavigate,
  }) : super(key: key);

  @override
  _DashboardSidebarState createState() => _DashboardSidebarState();
}

class _DashboardSidebarState extends State<DashboardSidebar> {
  List<MenuItem> _menuItems = [];

  @override
  void initState() {
    super.initState();
    _menuItems = _getMenuItems();
  }

  List<MenuItem> _getMenuItems() {
    return [
      MenuItem(
        title: 'Dashboard',
        icon: Icons.dashboard,
        route: '/dashboard',
      ),
      MenuItem(
        title: 'Analytics',
        icon: Icons.analytics,
        route: '/analytics',
      ),
      MenuItem(
        title: 'Users',
        icon: Icons.people,
        route: '/users',
      ),
      MenuItem(
        title: 'Products',
        icon: Icons.inventory,
        route: '/products',
        children: [
          MenuItem(
            title: 'All Products',
            icon: Icons.list,
            route: '/products/all',
          ),
          MenuItem(
            title: 'Add Product',
            icon: Icons.add,
            route: '/products/add',
          ),
          MenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: '/products/categories',
          ),
        ],
      ),
      MenuItem(
        title: 'Orders',
        icon: Icons.shopping_cart,
        route: '/orders',
      ),
      MenuItem(
        title: 'Reports',
        icon: Icons.assessment,
        route: '/reports',
      ),
      MenuItem(
        title: 'Settings',
        icon: Icons.settings,
        route: '/settings',
      ),
    ];
  }

  void _toggleExpanded(MenuItem item) {
    setState(() {
      final index = _menuItems.indexWhere((m) => m.route == item.route);
      if (index != -1) {
        _menuItems[index] = item.copyWith(isExpanded: !item.isExpanded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: double.infinity,
      color: DashboardColors.sidebarBg,
      child: Column(
        children: [
          // Logo section
          Container(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: DashboardColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.dashboard,
                    color: DashboardColors.textWhite,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: DashboardColors.textWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: DashboardColors.textWhite.withOpacity(0.1),
            height: 1,
          ),

          SizedBox(height: 16),

          // Menu items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return SidebarMenuItem(
                  menuItem: item,
                  isActive: widget.currentRoute == item.route,
                  onTap: () => widget.onNavigate(item.route),
                  onExpandToggle: _toggleExpanded,
                );
              },
            ),
          ),

          // User profile
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DashboardColors.sidebarHover,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: DashboardColors.primary,
            child: Text(
              'AD',
              style: TextStyle(
                color: DashboardColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    color: DashboardColors.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'admin@example.com',
                  style: TextStyle(
                    color: DashboardColors.textWhite.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Dashboard Topbar

### Step 8: Search Bar Widget

**lib/widgets/topbar/search_bar.dart**
```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class DashboardSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: DashboardColors.textLight),
          prefixIcon: Icon(Icons.search, color: DashboardColors.textLight),
          filled: true,
          fillColor: DashboardColors.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: DashboardColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}
```

### Step 9: Complete Topbar

**lib/widgets/topbar/dashboard_topbar.dart**
```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/responsive/responsive_builder.dart';
import 'search_bar.dart';

class DashboardTopbar extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final String pageTitle;

  const DashboardTopbar({
    Key? key,
    this.onMenuTap,
    required this.pageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: DashboardColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Mobile menu button
          ResponsiveBuilder(
            builder: (context, size) {
              if (size.index < DeviceSize.lg.index) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: onMenuTap,
                );
              }
              return SizedBox.shrink();
            },
          ),

          // Page title
          Text(
            pageTitle,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: DashboardColors.textPrimary,
            ),
          ),

          SizedBox(width: 32),

          // Search bar (hide on mobile)
          ResponsiveBuilder(
            builder: (context, size) {
              if (size.index >= DeviceSize.md.index) {
                return DashboardSearchBar();
              }
              return SizedBox.shrink();
            },
          ),

          Spacer(),

          // Notifications
          _buildIconButton(
            Icons.notifications_outlined,
            badge: 3,
            onTap: () {
              print('Notifications clicked');
            },
          ),

          SizedBox(width: 16),

          // Settings
          _buildIconButton(
            Icons.settings_outlined,
            onTap: () {
              print('Settings clicked');
            },
          ),

          SizedBox(width: 16),

          // User profile
          _buildUserProfile(),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {int? badge, VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DashboardColors.surfaceHover,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: DashboardColors.textSecondary,
                size: 20,
              ),
            ),
            if (badge != null && badge > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: DashboardColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    badge.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: DashboardColors.textWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print('User profile clicked');
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: DashboardColors.primary,
              child: Text(
                'AD',
                style: TextStyle(
                  color: DashboardColors.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: DashboardColors.textPrimary,
                  ),
                ),
                Text(
                  'Administrator',
                  style: TextStyle(
                    fontSize: 12,
                    color: DashboardColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: DashboardColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Main Dashboard Layout

### Step 10: Dashboard Shell

**lib/main.dart**
```dart
import 'package:flutter/material.dart';
import 'core/theme/dashboard_colors.dart';
import 'core/responsive/responsive_builder.dart';
import 'widgets/sidebar/dashboard_sidebar.dart';
import 'widgets/topbar/dashboard_topbar.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: DashboardColors.primary,
        scaffoldBackgroundColor: DashboardColors.background,
      ),
      home: DashboardShell(),
    );
  }
}

class DashboardShell extends StatefulWidget {
  @override
  _DashboardShellState createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  String _currentRoute = '/dashboard';
  bool _isSidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, deviceSize) {
          final isDesktop = deviceSize.index >= DeviceSize.lg.index;

          return Stack(
            children: [
              Row(
                children: [
                  // Desktop sidebar (always visible)
                  if (isDesktop)
                    DashboardSidebar(
                      currentRoute: _currentRoute,
                      onNavigate: (route) {
                        setState(() => _currentRoute = route);
                      },
                    ),

                  // Main content
                  Expanded(
                    child: Column(
                      children: [
                        DashboardTopbar(
                          pageTitle: _getPageTitle(),
                          onMenuTap: () {
                            setState(() => _isSidebarOpen = !_isSidebarOpen);
                          },
                        ),
                        Expanded(
                          child: _buildCurrentPage(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Mobile sidebar (drawer)
              if (!isDesktop && _isSidebarOpen)
                GestureDetector(
                  onTap: () {
                    setState(() => _isSidebarOpen = false);
                  },
                  child: Container(
                    color: Colors.black54,
                  ),
                ),

              if (!isDesktop && _isSidebarOpen)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: DashboardSidebar(
                    currentRoute: _currentRoute,
                    onNavigate: (route) {
                      setState(() {
                        _currentRoute = route;
                        _isSidebarOpen = false;
                      });
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _getPageTitle() {
    switch (_currentRoute) {
      case '/dashboard':
        return 'Dashboard';
      case '/analytics':
        return 'Analytics';
      case '/users':
        return 'Users';
      case '/orders':
        return 'Orders';
      case '/settings':
        return 'Settings';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildCurrentPage() {
    switch (_currentRoute) {
      case '/dashboard':
        return DashboardPage();
      default:
        return Center(
          child: Text(
            'Page: $_currentRoute',
            style: TextStyle(fontSize: 24),
          ),
        );
    }
  }
}
```

---

## Temporary Dashboard Page

**lib/pages/dashboard_page.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/dashboard_colors.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Text(
          'Dashboard content coming in Part 2!',
          style: TextStyle(
            fontSize: 24,
            color: DashboardColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
```

---

## Test the Layout

```bash
flutter run -d chrome
```

**What you should see:**
1. Professional sidebar with logo
2. Expandable menu items (Products)
3. Top bar with search, notifications, user profile
4. Responsive: sidebar converts to drawer on mobile
5. Smooth hover effects
6. Active route highlighting

**Test these:**
- Click menu items (route changes in title)
- Hover over menu items
- Click Products to expand submenu
- Resize browser (sidebar becomes drawer < 1200px)
- Click hamburger menu on mobile

---

## Key Takeaways

1. **Dashboard shell** = Sidebar + Topbar + Content area
2. **Responsive layout** = Row on desktop, drawer on mobile
3. **Menu navigation** = Route-based with active highlighting
4. **Expandable menus** = Multi-level navigation support
5. **Professional styling** = Consistent colors and spacing
6. **Hover states** = Better UX for web

---

## What's Next?

**Part 2:** Dashboard Content
- Stat cards with animations
- Charts and graphs (custom!)
- Recent activity feed
- Quick actions
- Revenue overview

You've built the dashboard layout! Looking professional! 📊✨
