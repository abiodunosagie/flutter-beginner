# Dashboard Part 2: Dashboard Content & Charts

## What You'll Learn

In this lesson, you'll build the main dashboard content with:
- Animated statistics cards showing key metrics
- Custom line chart (no packages!)
- Custom bar chart for comparisons
- Recent activity feed
- Responsive grid layouts

By the end, you'll have a professional dashboard overview page with beautiful data visualizations.

## Understanding Dashboard Components

A good dashboard shows important information at a glance. Think of it like a car's dashboard - you see speed, fuel, temperature all in one place. Our admin dashboard will show:

1. **Stat Cards**: Quick numbers (revenue, users, orders)
2. **Charts**: Visual trends over time
3. **Activity Feed**: What's happening recently

## Step 1: Create the Stat Card Widget

The stat card will display a metric with an icon, value, and percentage change.

Create `lib/widgets/cards/stat_card.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/models/stat_card_data.dart';

class StatCard extends StatefulWidget {
  final StatCardData data;

  const StatCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create animation controller for counter
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create animation from 0 to the target value
    _animation = Tween<double>(
      begin: 0,
      end: widget.data.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? DashboardColors.primary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Title Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.data.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      widget.data.icon,
                      color: widget.data.color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  // Percentage change indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.data.changePercentage >= 0
                          ? DashboardColors.success.withOpacity(0.1)
                          : DashboardColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.data.changePercentage >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: widget.data.changePercentage >= 0
                              ? DashboardColors.success
                              : DashboardColors.error,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.data.changePercentage.abs()}%',
                          style: TextStyle(
                            color: widget.data.changePercentage >= 0
                                ? DashboardColors.success
                                : DashboardColors.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                widget.data.title,
                style: const TextStyle(
                  color: DashboardColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              // Animated Value
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Text(
                    widget.data.prefix +
                    _formatNumber(_animation.value) +
                    widget.data.suffix,
                    style: const TextStyle(
                      color: DashboardColors.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),

              const SizedBox(height: 4),

              // Subtitle
              Text(
                widget.data.subtitle,
                style: const TextStyle(
                  color: DashboardColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    // Format large numbers with K, M suffixes
    if (value >= 1000000) {
      return (value / 1000000).toStringAsFixed(1) + 'M';
    } else if (value >= 1000) {
      return (value / 1000).toStringAsFixed(1) + 'K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
```

**What's happening here?**

1. **Animation**: We use `AnimationController` to animate the number from 0 to the target value over 1.5 seconds
2. **Hover Effect**: Card lifts up 4 pixels and shows a colored shadow when you hover
3. **Percentage Indicator**: Shows green trending up arrow for positive change, red trending down for negative
4. **Number Formatting**: Automatically converts 1000 to "1K", 1000000 to "1M"
5. **Color Coding**: Each card has its own color for the icon background

## Step 2: Update StatCardData Model

We need to add more properties to our model. Update `lib/core/models/stat_card_data.dart`:

```dart
import 'package:flutter/material.dart';

class StatCardData {
  final String title;
  final double value;
  final String prefix;
  final String suffix;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double changePercentage;

  const StatCardData({
    required this.title,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.subtitle = '',
    required this.icon,
    required this.color,
    this.changePercentage = 0,
  });
}
```

## Step 3: Create Custom Line Chart

Now let's build a line chart from scratch. No packages needed!

Create `lib/widgets/charts/line_chart.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class ChartDataPoint {
  final String label;
  final double value;

  const ChartDataPoint({
    required this.label,
    required this.value,
  });
}

class CustomLineChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final String title;
  final Color color;
  final double height;

  const CustomLineChart({
    Key? key,
    required this.data,
    required this.title,
    this.color = DashboardColors.primary,
    this.height = 300,
  }) : super(key: key);

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          // Title
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DashboardColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          // Chart
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: LineChartPainter(
                    data: widget.data,
                    color: widget.color,
                    progress: _animation.value,
                    hoveredIndex: _hoveredIndex,
                  ),
                  child: MouseRegion(
                    onHover: (event) {
                      _handleHover(event.localPosition);
                    },
                    onExit: (_) {
                      setState(() => _hoveredIndex = null);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.data.map((point) {
              return Text(
                point.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: DashboardColors.textSecondary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _handleHover(Offset position) {
    // Calculate which data point is being hovered
    final chartWidth = context.size?.width ?? 0;
    final spacing = chartWidth / (widget.data.length - 1);
    final index = (position.dx / spacing).round();

    if (index >= 0 && index < widget.data.length) {
      setState(() => _hoveredIndex = index);
    }
  }
}

class LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final Color color;
  final double progress;
  final int? hoveredIndex;

  LineChartPainter({
    required this.data,
    required this.color,
    required this.progress,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Find min and max values for scaling
    final maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    // Calculate spacing between points
    final spacing = size.width / (data.length - 1);

    // Create path for the line
    final path = Path();
    final gradientPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final normalizedValue = (data[i].value - minValue) / range;
      final y = size.height - (normalizedValue * size.height * 0.9) - (size.height * 0.05);

      if (i == 0) {
        path.moveTo(x, y);
        gradientPath.moveTo(x, size.height);
        gradientPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        gradientPath.lineTo(x, y);
      }
    }

    // Complete gradient path
    gradientPath.lineTo(size.width, size.height);
    gradientPath.close();

    // Draw gradient fill
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Clip to show only the animated portion
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    canvas.drawPath(gradientPath, gradientPaint);
    canvas.restore();

    // Draw line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width * progress, size.height));
    canvas.drawPath(path, linePaint);
    canvas.restore();

    // Draw points and labels
    for (int i = 0; i < data.length; i++) {
      final x = i * spacing;
      final normalizedValue = (data[i].value - minValue) / range;
      final y = size.height - (normalizedValue * size.height * 0.9) - (size.height * 0.05);

      // Only draw if within animation progress
      if (x > size.width * progress) break;

      final isHovered = hoveredIndex == i;

      // Draw point
      final pointPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(Offset(x, y), isHovered ? 6 : 4, pointPaint);
      canvas.drawCircle(Offset(x, y), isHovered ? 6 : 4, borderPaint);

      // Draw tooltip on hover
      if (isHovered) {
        _drawTooltip(canvas, Offset(x, y), data[i].value.toStringAsFixed(0));
      }
    }
  }

  void _drawTooltip(Canvas canvas, Offset position, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(position.dx, position.dy - 30),
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(4),
    );

    final tooltipPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(tooltipRect, tooltipPaint);

    textPainter.paint(
      canvas,
      Offset(
        position.dx - textPainter.width / 2,
        position.dy - 30 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.hoveredIndex != hoveredIndex;
  }
}
```

**What's happening in the line chart?**

1. **Animation**: The chart draws from left to right over 1 second
2. **Scaling**: We find the min/max values and scale all points to fit the canvas
3. **Gradient Fill**: Area under the line has a gradient from color to transparent
4. **Hover Tooltips**: Hovering over a point shows its exact value
5. **Smooth Curves**: We use Path to draw smooth lines between points

## Step 4: Create Custom Bar Chart

Create `lib/widgets/charts/bar_chart.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class BarChartData {
  final String label;
  final double value;
  final Color? color;

  const BarChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class CustomBarChart extends StatefulWidget {
  final List<BarChartData> data;
  final String title;
  final double height;

  const CustomBarChart({
    Key? key,
    required this.data,
    required this.title,
    this.height = 300,
  }) : super(key: key);

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DashboardColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(widget.data.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildBar(index),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Labels
          Row(
            children: widget.data.asMap().entries.map((entry) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    entry.value.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: DashboardColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int index) {
    final data = widget.data[index];
    final maxValue = widget.data
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b);

    final heightPercentage = (data.value / maxValue);
    final color = data.color ?? DashboardColors.chartColors[index % DashboardColors.chartColors.length];
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Value label (shown on hover)
          AnimatedOpacity(
            opacity: isHovered ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                data.value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Bar
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: widget.height * heightPercentage * _animation.value,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
}
```

**What's happening in the bar chart?**

1. **Proportional Heights**: Each bar's height is calculated as a percentage of the max value
2. **Gradient Bars**: Each bar has a subtle gradient from top to bottom
3. **Hover Labels**: Values appear above bars when you hover
4. **Color Cycling**: If no color is specified, we cycle through our palette
5. **Smooth Animation**: Bars grow from bottom to top over 1.2 seconds

## Step 5: Create Recent Activity Widget

Create `lib/widgets/activity/recent_activity.dart`:

```dart
import 'package:flutter/material.dart';
import '../../core/theme/dashboard_colors.dart';

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  const ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class RecentActivity extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivity({
    Key? key,
    required this.activities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: DashboardColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              return _buildActivityItem(activities[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    return Row(
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: activity.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            activity.icon,
            color: activity.color,
            size: 20,
          ),
        ),

        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: DashboardColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                activity.description,
                style: const TextStyle(
                  fontSize: 13,
                  color: DashboardColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // Time
        Text(
          activity.time,
          style: const TextStyle(
            fontSize: 12,
            color: DashboardColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
```

## Step 6: Build the Dashboard Overview Page

Now let's put everything together! Update `lib/pages/dashboard_page.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/theme/dashboard_colors.dart';
import '../core/models/stat_card_data.dart';
import '../widgets/cards/stat_card.dart';
import '../widgets/charts/line_chart.dart';
import '../widgets/charts/bar_chart.dart';
import '../widgets/activity/recent_activity.dart';
import '../core/utils/responsive.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          const Text(
            'Dashboard Overview',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: DashboardColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Welcome back! Here\'s what\'s happening today.',
            style: TextStyle(
              fontSize: 14,
              color: DashboardColors.textSecondary,
            ),
          ),

          const SizedBox(height: 32),

          // Stat Cards
          ResponsiveBuilder(
            builder: (context, deviceSize) {
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: _getStatCards().map((data) {
                  return SizedBox(
                    width: _getCardWidth(context, deviceSize),
                    child: StatCard(data: data),
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 32),

          // Charts Row
          ResponsiveBuilder(
            builder: (context, deviceSize) {
              final isDesktop = deviceSize.index >= DeviceSize.lg.index;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomLineChart(
                        data: _getRevenueData(),
                        title: 'Revenue Trend',
                        color: DashboardColors.primary,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: CustomBarChart(
                        data: _getMonthlyData(),
                        title: 'Monthly Comparison',
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    CustomLineChart(
                      data: _getRevenueData(),
                      title: 'Revenue Trend',
                      color: DashboardColors.primary,
                    ),
                    const SizedBox(height: 24),
                    CustomBarChart(
                      data: _getMonthlyData(),
                      title: 'Monthly Comparison',
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 32),

          // Recent Activity
          RecentActivity(
            activities: _getRecentActivities(),
          ),
        ],
      ),
    );
  }

  double _getCardWidth(BuildContext context, DeviceSize deviceSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    switch (deviceSize) {
      case DeviceSize.xs:
        return screenWidth - 48; // Full width on mobile
      case DeviceSize.sm:
        return (screenWidth - 72) / 2; // 2 columns on tablet
      case DeviceSize.md:
      case DeviceSize.lg:
      case DeviceSize.xl:
        return (screenWidth - 120) / 4; // 4 columns on desktop
    }
  }

  List<StatCardData> _getStatCards() {
    return [
      const StatCardData(
        title: 'Total Revenue',
        value: 45231,
        prefix: '\$',
        subtitle: 'From all sources',
        icon: Icons.attach_money,
        color: DashboardColors.success,
        changePercentage: 12.5,
      ),
      const StatCardData(
        title: 'Total Users',
        value: 8492,
        suffix: '',
        subtitle: 'Active users',
        icon: Icons.people,
        color: DashboardColors.primary,
        changePercentage: 8.2,
      ),
      const StatCardData(
        title: 'Total Orders',
        value: 1893,
        suffix: '',
        subtitle: 'This month',
        icon: Icons.shopping_cart,
        color: DashboardColors.warning,
        changePercentage: -3.1,
      ),
      const StatCardData(
        title: 'Growth Rate',
        value: 23.5,
        suffix: '%',
        subtitle: 'Year over year',
        icon: Icons.trending_up,
        color: DashboardColors.info,
        changePercentage: 5.7,
      ),
    ];
  }

  List<ChartDataPoint> _getRevenueData() {
    return const [
      ChartDataPoint(label: 'Jan', value: 30000),
      ChartDataPoint(label: 'Feb', value: 35000),
      ChartDataPoint(label: 'Mar', value: 32000),
      ChartDataPoint(label: 'Apr', value: 38000),
      ChartDataPoint(label: 'May', value: 42000),
      ChartDataPoint(label: 'Jun', value: 45000),
    ];
  }

  List<BarChartData> _getMonthlyData() {
    return const [
      BarChartData(label: 'Mon', value: 420),
      BarChartData(label: 'Tue', value: 380),
      BarChartData(label: 'Wed', value: 450),
      BarChartData(label: 'Thu', value: 390),
      BarChartData(label: 'Fri', value: 480),
      BarChartData(label: 'Sat', value: 350),
      BarChartData(label: 'Sun', value: 310),
    ];
  }

  List<ActivityItem> _getRecentActivities() {
    return const [
      ActivityItem(
        title: 'New order received',
        description: 'Order #12345 from John Doe',
        time: '2 min ago',
        icon: Icons.shopping_bag,
        color: DashboardColors.success,
      ),
      ActivityItem(
        title: 'User registered',
        description: 'sarah@example.com joined',
        time: '15 min ago',
        icon: Icons.person_add,
        color: DashboardColors.primary,
      ),
      ActivityItem(
        title: 'Payment processed',
        description: '\$299.00 received',
        time: '1 hour ago',
        icon: Icons.payment,
        color: DashboardColors.info,
      ),
      ActivityItem(
        title: 'Product updated',
        description: 'Inventory adjusted for SKU-789',
        time: '2 hours ago',
        icon: Icons.inventory,
        color: DashboardColors.warning,
      ),
      ActivityItem(
        title: 'Support ticket resolved',
        description: 'Ticket #543 marked as complete',
        time: '3 hours ago',
        icon: Icons.support_agent,
        color: DashboardColors.success,
      ),
    ];
  }
}
```

## Step 7: Test Your Dashboard

Run the app:

```bash
flutter run -d chrome
```

You should see:

1. **Four stat cards** at the top showing:
   - Total Revenue with counter animation
   - Total Users
   - Total Orders (with negative percentage in red)
   - Growth Rate
   - All cards lift on hover

2. **Revenue trend line chart** showing:
   - Animated line drawing from left to right
   - Gradient fill under the line
   - Hover tooltips showing exact values

3. **Monthly comparison bar chart** showing:
   - Bars growing from bottom to top
   - Different colors for each bar
   - Values appearing on hover

4. **Recent activity feed** showing:
   - 5 recent events
   - Color-coded icons
   - Timestamps

## Understanding the Concepts

### 1. Custom Painting

When you want to draw custom shapes (like charts), you use `CustomPaint` with a `CustomPainter`:

```dart
CustomPaint(
  painter: MyPainter(),
  child: Container(), // optional child
)

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw here using canvas
    canvas.drawLine(start, end, paint);
    canvas.drawCircle(center, radius, paint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return true; // Repaint when something changes
  }
}
```

### 2. Animation Controllers

For smooth animations, use `AnimationController`:

```dart
// In State class
late AnimationController _controller;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this, // Requires SingleTickerProviderStateMixin
  );
  _controller.forward(); // Start animation
}

@override
void dispose() {
  _controller.dispose(); // Clean up
  super.dispose();
}
```

### 3. Responsive Layouts

We use different layouts based on screen size:

```dart
ResponsiveBuilder(
  builder: (context, deviceSize) {
    if (deviceSize.index >= DeviceSize.lg.index) {
      // Desktop: side by side
      return Row(children: [chart1, chart2]);
    } else {
      // Mobile: stacked
      return Column(children: [chart1, chart2]);
    }
  },
)
```

## Exercises

### Exercise 1: Add More Stat Cards
Add two more stat cards:
- "Average Order Value" - $52.30 with +4.2% change
- "Conversion Rate" - 3.2% with -1.1% change

**Solution:**
```dart
const StatCardData(
  title: 'Avg Order Value',
  value: 52.30,
  prefix: '\$',
  subtitle: 'Per transaction',
  icon: Icons.receipt,
  color: Color(0xFF8B5CF6),
  changePercentage: 4.2,
),
const StatCardData(
  title: 'Conversion Rate',
  value: 3.2,
  suffix: '%',
  subtitle: 'Visitor to customer',
  icon: Icons.percent,
  color: Color(0xFFEC4899),
  changePercentage: -1.1,
),
```

### Exercise 2: Change Chart Colors
Modify the line chart to use a purple gradient instead of blue.

**Hint:** Change the `color` property when creating `CustomLineChart`.

**Solution:**
```dart
CustomLineChart(
  data: _getRevenueData(),
  title: 'Revenue Trend',
  color: const Color(0xFF8B5CF6), // Purple
)
```

### Exercise 3: Add More Data Points
Extend the revenue chart to show 12 months instead of 6.

**Solution:**
```dart
List<ChartDataPoint> _getRevenueData() {
  return const [
    ChartDataPoint(label: 'Jan', value: 30000),
    ChartDataPoint(label: 'Feb', value: 35000),
    ChartDataPoint(label: 'Mar', value: 32000),
    ChartDataPoint(label: 'Apr', value: 38000),
    ChartDataPoint(label: 'May', value: 42000),
    ChartDataPoint(label: 'Jun', value: 45000),
    ChartDataPoint(label: 'Jul', value: 48000),
    ChartDataPoint(label: 'Aug', value: 46000),
    ChartDataPoint(label: 'Sep', value: 51000),
    ChartDataPoint(label: 'Oct', value: 53000),
    ChartDataPoint(label: 'Nov', value: 55000),
    ChartDataPoint(label: 'Dec', value: 58000),
  ];
}
```

### Exercise 4: Format Large Numbers Better
Update the `_formatNumber` function in `StatCard` to handle numbers like 1,234,567.

**Solution:**
```dart
String _formatNumber(double value) {
  if (value >= 1000000) {
    return (value / 1000000).toStringAsFixed(1) + 'M';
  } else if (value >= 1000) {
    // Add commas for thousands
    final intValue = value.toInt();
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  } else {
    return value.toStringAsFixed(0);
  }
}
```

### Exercise 5: Add Smooth Curve to Line Chart
Instead of straight lines, make the chart use smooth Bezier curves.

**Hint:** Use `Path.quadraticBezierTo()` or `Path.cubicTo()` instead of `lineTo()`.

**Challenge:** This is advanced! Research Bezier curves and implement smooth interpolation between points.

## What You've Learned

✅ How to build animated stat cards with hover effects
✅ Creating custom charts from scratch using CustomPaint
✅ Drawing paths, gradients, and shapes on canvas
✅ Implementing animation controllers for smooth transitions
✅ Building responsive layouts that adapt to screen size
✅ Formatting numbers with K/M suffixes
✅ Creating interactive tooltips on hover
✅ Organizing dashboard components logically

## Next Steps

In the next lesson, we'll add:
- **Data tables** with sorting and filtering
- **Pagination** for large datasets
- **Search functionality**
- **Export to CSV**

You're building a professional admin dashboard from scratch - no packages needed! 🎉
