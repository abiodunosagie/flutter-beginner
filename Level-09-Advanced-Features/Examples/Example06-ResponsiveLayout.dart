// Example 06: Responsive Layout
// Making apps that look great on any screen size

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Layout Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const ResponsiveDemoPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BREAKPOINTS - Like clothing sizes for screens!
// ═══════════════════════════════════════════════════════════════

class ScreenSize {
  // Screen width breakpoints
  static const double mobile = 600; // Small phones
  static const double tablet = 900; // Tablets
  static const double desktop = 1200; // Desktop screens

  // Helper method to get current screen type
  static String getScreenType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < mobile) return 'mobile';
    if (width < tablet) return 'tablet';
    return 'desktop';
  }

  // Check if mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  // Check if tablet
  static bool isTablet(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width >= mobile && width < tablet;
  }

  // Check if desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tablet;
  }
}

// ═══════════════════════════════════════════════════════════════
// RESPONSIVE DEMO PAGE
// ═══════════════════════════════════════════════════════════════

class ResponsiveDemoPage extends StatelessWidget {
  const ResponsiveDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Layout'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Use drawer on mobile, permanent side panel on desktop
      drawer: ScreenSize.isMobile(context) ? _buildDrawer(context) : null,
      body: Row(
        children: [
          // Side navigation - Only show on tablet/desktop
          if (!ScreenSize.isMobile(context))
            NavigationRail(
              selectedIndex: 0,
              onDestinationSelected: (index) {},
              labelType: ScreenSize.isDesktop(context)
                  ? NavigationRailLabelType.all
                  : NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Explore'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Profile'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
            ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                ScreenSize.isMobile(context) ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen info card
                  _buildScreenInfoCard(context),
                  const SizedBox(height: 24),

                  // Responsive grid
                  _buildResponsiveGrid(context),
                  const SizedBox(height: 24),

                  // Responsive text
                  _buildResponsiveText(context),
                  const SizedBox(height: 24),

                  // Responsive cards
                  _buildResponsiveCards(context),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom nav only on mobile
      bottomNavigationBar: ScreenSize.isMobile(context)
          ? BottomNavigationBar(
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // DRAWER (for mobile)
  // ─────────────────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Explore'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SCREEN INFO CARD
  // ─────────────────────────────────────────────────────────────

  Widget _buildScreenInfoCard(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenType = ScreenSize.getScreenType(context);

    Color typeColor;
    IconData typeIcon;

    switch (screenType) {
      case 'mobile':
        typeColor = Colors.orange;
        typeIcon = Icons.phone_android;
        break;
      case 'tablet':
        typeColor = Colors.blue;
        typeIcon = Icons.tablet_android;
        break;
      default:
        typeColor = Colors.purple;
        typeIcon = Icons.desktop_windows;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcon, size: 48, color: typeColor),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Screen: ${screenType.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: typeColor,
                      ),
                    ),
                    Text(
                      '${size.width.toInt()} x ${size.height.toInt()} pixels',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            const Text(
              'Resize your window to see the layout change!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBreakpointChip('Mobile', '< 600px', Colors.orange,
                    screenType == 'mobile'),
                _buildBreakpointChip('Tablet', '600-900px', Colors.blue,
                    screenType == 'tablet'),
                _buildBreakpointChip('Desktop', '> 900px', Colors.purple,
                    screenType == 'desktop'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakpointChip(
      String label, String range, Color color, bool isActive) {
    return Chip(
      avatar: isActive
          ? Icon(Icons.check_circle, color: color, size: 18)
          : Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
      label: Text('$label ($range)'),
      backgroundColor: isActive ? color.withValues(alpha: 0.2) : null,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // RESPONSIVE GRID
  // ─────────────────────────────────────────────────────────────

  Widget _buildResponsiveGrid(BuildContext context) {
    // Different column counts for different screens
    int crossAxisCount;
    if (ScreenSize.isMobile(context)) {
      crossAxisCount = 2;
    } else if (ScreenSize.isTablet(context)) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 4;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Responsive Grid ($crossAxisCount columns)',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            final colors = [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.teal,
              Colors.pink,
              Colors.indigo,
            ];

            return Container(
              decoration: BoxDecoration(
                color: colors[index].shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors[index], width: 2),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.widgets, color: colors[index], size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Item ${index + 1}',
                      style: TextStyle(
                        color: colors[index],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // RESPONSIVE TEXT
  // ─────────────────────────────────────────────────────────────

  Widget _buildResponsiveText(BuildContext context) {
    // Different font sizes for different screens
    double titleSize;
    double bodySize;

    if (ScreenSize.isMobile(context)) {
      titleSize = 24;
      bodySize = 14;
    } else if (ScreenSize.isTablet(context)) {
      titleSize = 32;
      bodySize = 16;
    } else {
      titleSize = 40;
      bodySize = 18;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Typography',
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This text automatically adjusts its size based on screen width. '
              'On mobile devices, text is smaller to fit more content. '
              'On larger screens, text is bigger for better readability. '
              'This creates a better user experience across all devices!',
              style: TextStyle(
                fontSize: bodySize,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Title: ${titleSize}px | Body: ${bodySize}px',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // RESPONSIVE CARDS
  // ─────────────────────────────────────────────────────────────

  Widget _buildResponsiveCards(BuildContext context) {
    final cards = [
      _CardData('Learn Flutter', 'Start your journey', Icons.school,
          Colors.blue),
      _CardData(
          'Build Apps', 'Create amazing apps', Icons.phone_android, Colors.green),
      _CardData(
          'Deploy', 'Share with the world', Icons.cloud_upload, Colors.orange),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Responsive Cards',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // LayoutBuilder - Builds different layouts based on available space
        LayoutBuilder(
          builder: (context, constraints) {
            // If wide enough, show side by side
            if (constraints.maxWidth > 600) {
              return Row(
                children: cards
                    .map((card) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: _buildCard(card),
                          ),
                        ))
                    .toList(),
              );
            }
            // Otherwise, stack vertically
            return Column(
              children: cards
                  .map((card) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCard(card),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCard(_CardData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: data.color.shade100,
              radius: 30,
              child: Icon(data.icon, color: data.color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.subtitle,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class for card data
class _CardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final MaterialColor color;

  _CardData(this.title, this.subtitle, this.icon, this.color);
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. MediaQuery
 *    - Gets screen size and device info
 *    - MediaQuery.of(context).size.width
 *    - MediaQuery.of(context).size.height
 *
 * 2. Breakpoints
 *    - Define sizes for mobile, tablet, desktop
 *    - Common breakpoints:
 *      • Mobile: < 600px
 *      • Tablet: 600-900px
 *      • Desktop: > 900px
 *
 * 3. LayoutBuilder
 *    - Builds different layouts based on available space
 *    - More flexible than MediaQuery
 *    - Uses constraints.maxWidth
 *
 * 4. Conditional Widgets
 *    ```dart
 *    if (ScreenSize.isMobile(context))
 *      MobileWidget()
 *    else
 *      DesktopWidget()
 *    ```
 *
 * 5. Flexible Grid
 *    - Different column counts per screen size
 *    - GridView with SliverGridDelegate
 *
 * ═══════════════════════════════════════════════════════════════
 * RESPONSIVE PATTERNS:
 * ═══════════════════════════════════════════════════════════════
 *
 * Pattern 1: Show/Hide Widgets
 * ```dart
 * if (isMobile)
 *   BottomNavigationBar()    // Mobile: bottom nav
 * else
 *   NavigationRail()         // Desktop: side nav
 * ```
 *
 * Pattern 2: Change Layout Direction
 * ```dart
 * if (isWide)
 *   Row(children: items)     // Wide: side by side
 * else
 *   Column(children: items)  // Narrow: stacked
 * ```
 *
 * Pattern 3: Adjust Values
 * ```dart
 * fontSize: isMobile ? 16 : 24
 * padding: isMobile ? 8 : 24
 * columns: isMobile ? 2 : 4
 * ```
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add an "extra large" breakpoint for very wide screens
 * 2. Create a responsive image gallery
 * 3. Build a responsive form (single column vs multi-column)
 * 4. Add orientation detection (portrait vs landscape)
 * 5. Create a responsive dashboard with different layouts
 *
 */
