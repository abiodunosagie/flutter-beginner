// Week 12, Exercise 5: State Management Comparison App
// Difficulty: Advanced
// Solution

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Riverpod counter
final riverpodCounterProvider = StateProvider<int>((ref) => 0);

// Bloc counter events
abstract class BlocCounterEvent {}
class BlocIncrement extends BlocCounterEvent {}
class BlocDecrement extends BlocCounterEvent {}
class BlocReset extends BlocCounterEvent {}

// Bloc counter state
class BlocCounterState extends Equatable {
  final int count;
  const BlocCounterState(this.count);
  @override
  List<Object> get props => [count];
}

// Bloc counter
class BlocCounter extends Bloc<BlocCounterEvent, BlocCounterState> {
  BlocCounter() : super(const BlocCounterState(0)) {
    on<BlocIncrement>((event, emit) => emit(BlocCounterState(state.count + 1)));
    on<BlocDecrement>((event, emit) => emit(BlocCounterState(state.count - 1)));
    on<BlocReset>((event, emit) => emit(const BlocCounterState(0)));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management Comparison',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => BlocCounter(),
        child: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadLastTab();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentTab = _tabController.index;
        });
        _saveCurrentTab();
      }
    });
  }

  Future<void> _loadLastTab() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTab = prefs.getInt('lastTab') ?? 0;
    setState(() {
      _currentTab = lastTab;
      _tabController.index = lastTab;
    });
  }

  Future<void> _saveCurrentTab() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTab', _currentTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('State Management Comparison'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'setState'),
            Tab(text: 'Riverpod'),
            Tab(text: 'Bloc'),
            Tab(text: 'Comparison'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SetStateCounterTab(),
          RiverpodCounterTab(),
          BlocCounterTab(),
          ComparisonTab(),
        ],
      ),
    );
  }
}

// setState Counter
class SetStateCounterTab extends StatefulWidget {
  @override
  _SetStateCounterTabState createState() => _SetStateCounterTabState();
}

class _SetStateCounterTabState extends State<SetStateCounterTab> {
  int _count = 0;
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;

    return _CounterLayout(
      title: 'setState()',
      count: _count,
      buildCount: _buildCount,
      onIncrement: () => setState(() => _count++),
      onDecrement: () => setState(() => _count--),
      onReset: () => setState(() => _count = 0),
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• Built into Flutter', style: TextStyle(fontSize: 16)),
          Text('• Rebuilds entire widget', style: TextStyle(fontSize: 16)),
          Text('• State tied to widget', style: TextStyle(fontSize: 16)),
          Text('• Simple for local state', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Riverpod Counter
class RiverpodCounterTab extends ConsumerWidget {
  static int _buildCount = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _buildCount++;
    final count = ref.watch(riverpodCounterProvider);

    return _CounterLayout(
      title: 'Riverpod',
      count: count,
      buildCount: _buildCount,
      onIncrement: () => ref.read(riverpodCounterProvider.notifier).state++,
      onDecrement: () => ref.read(riverpodCounterProvider.notifier).state--,
      onReset: () => ref.read(riverpodCounterProvider.notifier).state = 0,
      info: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• Modern approach', style: TextStyle(fontSize: 16)),
          Text('• Compile-time safety', style: TextStyle(fontSize: 16)),
          Text('• No BuildContext needed', style: TextStyle(fontSize: 16)),
          Text('• Easy to test', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Bloc Counter
class BlocCounterTab extends StatelessWidget {
  static int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocCounter, BlocCounterState>(
      builder: (context, state) {
        _buildCount++;

        return _CounterLayout(
          title: 'Bloc',
          count: state.count,
          buildCount: _buildCount,
          onIncrement: () => context.read<BlocCounter>().add(BlocIncrement()),
          onDecrement: () => context.read<BlocCounter>().add(BlocDecrement()),
          onReset: () => context.read<BlocCounter>().add(BlocReset()),
          info: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• Event-driven', style: TextStyle(fontSize: 16)),
              Text('• Predictable state changes', style: TextStyle(fontSize: 16)),
              Text('• Great for complex logic', style: TextStyle(fontSize: 16)),
              Text('• Excellent testing', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }
}

// Reusable counter layout
class _CounterLayout extends StatelessWidget {
  final String title;
  final int count;
  final int buildCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;
  final Widget info;

  const _CounterLayout({
    required this.title,
    required this.count,
    required this.buildCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '$count',
                    style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: onDecrement,
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: onReset,
                        child: Text('Reset'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: onIncrement,
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.blue[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, size: 16),
                        SizedBox(width: 8),
                        Text('Build count: $buildCount'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Characteristics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  info,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Comparison Tab
class ComparisonTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When to Use Each',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _ComparisonCard(
            title: 'setState()',
            color: Colors.green,
            bestFor: 'Simple local state in single widgets',
            pros: [
              'No dependencies',
              'Easy to understand',
              'Fast to implement',
              'Perfect for learning',
            ],
            cons: [
              'Hard to share state',
              'Rebuilds entire widget',
              'Hard to test',
              'Doesn\'t scale well',
            ],
          ),
          _ComparisonCard(
            title: 'Riverpod',
            color: Colors.blue,
            bestFor: 'Most production apps',
            pros: [
              'Compile-time safety',
              'Easy to share state',
              'No BuildContext needed',
              'Good testing support',
              'Less boilerplate than Bloc',
            ],
            cons: [
              'Extra dependency',
              'Learning curve',
              'No event tracking',
            ],
          ),
          _ComparisonCard(
            title: 'Bloc',
            color: Colors.purple,
            bestFor: 'Large enterprise apps',
            pros: [
              'Event tracking',
              'Time-travel debugging',
              'Excellent testing',
              'Clear patterns',
              'Great for complex logic',
            ],
            cons: [
              'More boilerplate',
              'Steeper learning curve',
              'Slower development',
              'Overkill for simple apps',
            ],
          ),
          SizedBox(height: 20),
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Recommendation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Use setState() for local UI state (animations, toggles)',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '• Use Riverpod for most business logic',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '• Use Bloc for complex event-driven features',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '• Mix approaches in one app!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String title;
  final Color color;
  final String bestFor;
  final List<String> pros;
  final List<String> cons;

  const _ComparisonCard({
    required this.title,
    required this.color,
    required this.bestFor,
    required this.pros,
    required this.cons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Best for: $bestFor',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 12),
            Text(
              'Pros:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...pros.map((pro) => Padding(
                  padding: EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Expanded(child: Text(pro, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                )),
            SizedBox(height: 12),
            Text(
              'Cons:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...cons.map((con) => Padding(
                  padding: EdgeInsets.only(left: 8, top: 4),
                  child: Row(
                    children: [
                      Icon(Icons.close, size: 16, color: Colors.red),
                      SizedBox(width: 4),
                      Expanded(child: Text(con, style: TextStyle(fontSize: 14))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
