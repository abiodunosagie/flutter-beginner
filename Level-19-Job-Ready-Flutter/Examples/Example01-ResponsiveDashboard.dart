// Example 01: Composition + Responsive + Adaptive navigation in one screen.
//
// Run it, then resize the window (or rotate the device) and watch:
//   < 600  -> bottom NavigationBar, one column
//   600+   -> NavigationRail, grid reflows by cell width
//   840+   -> extended rail, content capped at 1200 wide
//
// Every piece is its own widget class with a const constructor, so only the
// part that changes rebuilds.

import 'package:flutter/material.dart';

void main() => runApp(const DashboardApp());

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5AFE)),
        useMaterial3: true,
      ),
      home: const DashboardShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// Window size classes: one place for every breakpoint in the app.
// ---------------------------------------------------------------------------

enum WindowSize { compact, medium, expanded }

WindowSize windowSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return WindowSize.compact;
  if (width < 840) return WindowSize.medium;
  return WindowSize.expanded;
}

// ---------------------------------------------------------------------------
// The shell: decides bottom bar vs rail. The pages never know which one is up.
// ---------------------------------------------------------------------------

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _index = 0;

  static const _destinations = <_Destination>[
    _Destination(icon: Icons.dashboard_outlined, label: 'Overview'),
    _Destination(icon: Icons.inventory_2_outlined, label: 'Products'),
    _Destination(icon: Icons.person_outline, label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    final size = windowSizeOf(context);
    final body = switch (_index) {
      0 => const OverviewPage(),
      1 => const ProductsPage(),
      _ => const AccountPage(),
    };

    if (size == WindowSize.compact) {
      return Scaffold(
        body: SafeArea(child: body),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final d in _destinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: size == WindowSize.expanded,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _Destination {
  const _Destination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

// ---------------------------------------------------------------------------
// Overview: stat cards that reflow with the available width, not the window.
// ---------------------------------------------------------------------------

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  static const _stats = <StatData>[
    StatData(label: 'Revenue', value: '\$12,430', delta: '+8.2%'),
    StatData(label: 'Orders', value: '318', delta: '+3.1%'),
    StatData(label: 'Refunds', value: '12', delta: '-1.4%'),
    StatData(label: 'Visitors', value: '9,204', delta: '+11.7%'),
  ];

  @override
  Widget build(BuildContext context) {
    return CenteredColumn(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Decide by the space THIS widget was given, not by the window.
          final columns = (constraints.maxWidth / 260).floor().clamp(1, 4);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.9,
            ),
            itemCount: _stats.length,
            itemBuilder: (context, i) => StatCard(data: _stats[i]),
          );
        },
      ),
    );
  }
}

class StatData {
  const StatData({
    required this.label,
    required this.value,
    required this.delta,
  });

  final String label;
  final String value;
  final String delta;
}

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.data});

  final StatData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = !data.delta.startsWith('-');

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data.label, style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          // FittedBox keeps a big number from overflowing a narrow card.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(data.value, style: theme.textTheme.headlineMedium),
          ),
          const SizedBox(height: 4),
          Text(
            data.delta,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isPositive ? Colors.green.shade700 : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Products: a grid that needs NO breakpoints, because the cell width decides.
// ---------------------------------------------------------------------------

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredColumn(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemCount: 24,
        itemBuilder: (context, i) => ProductCard(
          key: ValueKey('product_$i'),
          name: 'Product ${i + 1}',
          price: 19.99 + i,
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.name, required this.price});

  final String name;
  final double price;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: Icon(Icons.image_outlined, size: 36)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Account: a form that stays readable on a very wide screen.
// ---------------------------------------------------------------------------

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CenteredColumn(
      maxWidth: 560,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile'),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(labelText: 'Full name')),
                SizedBox(height: 12),
                TextField(decoration: InputDecoration(labelText: 'Email')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable pieces. Composition: they take a child and know nothing about it.
// ---------------------------------------------------------------------------

class CenteredColumn extends StatelessWidget {
  const CenteredColumn({super.key, required this.child, this.maxWidth = 1200});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
