# Week 18: Complete Landing Page - Part 2 (Features Section)

## What We're Building

A **features section** showcasing the product's key capabilities:
- ✨ Animated feature cards with icons
- 📊 Statistics counter
- 🎯 Responsive grid layout
- 🎨 Hover effects

---

## Features Section Structure

```
Features Section
├── Section Header (Title + Description)
├── Features Grid (4 feature cards)
└── Statistics Row (4 stats counters)
```

---

## Step 1: Create Feature Model

**lib/models/feature.dart**
```dart
import 'package:flutter/material.dart';

class Feature {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  Feature({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
```

---

## Step 2: Section Header Widget

**lib/widgets/section_header.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  final String badge;
  final String title;
  final String description;
  final TextAlign textAlign;

  const SectionHeader({
    Key? key,
    required this.badge,
    required this.title,
    required this.description,
    this.textAlign = TextAlign.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            badge.toUpperCase(),
            style: AppTypography.caption(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        SizedBox(height: 16),

        // Title
        Text(
          title,
          textAlign: textAlign,
          style: AppTypography.h2(context).copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        SizedBox(height: 16),

        // Description
        Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Text(
            description,
            textAlign: textAlign,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## Step 3: Feature Card Widget

**lib/widgets/feature_card.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../models/feature.dart';

class FeatureCard extends StatefulWidget {
  final Feature feature;

  const FeatureCard({Key? key, required this.feature}) : super(key: key);

  @override
  _FeatureCardState createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? widget.feature.color.withOpacity(0.5)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? widget.feature.color.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _isHovered ? 30 : 10,
              offset: Offset(0, _isHovered ? 15 : 5),
            ),
          ],
        ),
        transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.feature.color.withOpacity(0.8),
                    widget.feature.color,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: widget.feature.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.feature.icon,
                color: Colors.white,
                size: 32,
              ),
            ),

            SizedBox(height: 24),

            // Title
            Text(
              widget.feature.title,
              style: AppTypography.h4(context).copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 12),

            // Description
            Text(
              widget.feature.description,
              style: AppTypography.bodyMedium(context).copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),

            SizedBox(height: 20),

            // Learn more link
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  print('Learn more: ${widget.feature.title}');
                },
                child: Row(
                  children: [
                    Text(
                      'Learn more',
                      style: AppTypography.bodySmall(context).copyWith(
                        color: widget.feature.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: widget.feature.color,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Step 4: Statistic Widget

**lib/widgets/statistic_card.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class StatisticCard extends StatefulWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatisticCard({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  _StatisticCardState createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start animation when widget appears
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          SizedBox(height: 16),

          // Animated value
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                widget.value,
                style: AppTypography.h2(context).copyWith(
                  color: AppColors.primary,
                ),
              );
            },
          ),

          SizedBox(height: 8),

          // Label
          Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Step 5: Features Section

**lib/sections/features_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';
import '../widgets/feature_card.dart';
import '../widgets/statistic_card.dart';
import '../models/feature.dart';

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        vertical: responsive(context, xs: 60, sm: 80, lg: 100),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            // Section header
            SectionHeader(
              badge: 'Features',
              title: 'Everything you need to succeed',
              description:
                  'Powerful features designed to help you work smarter, collaborate better, and achieve more.',
            ),

            SizedBox(height: responsive(context, xs: 40, sm: 60, lg: 80)),

            // Features grid
            _buildFeaturesGrid(context),

            SizedBox(height: responsive(context, xs: 60, sm: 80, lg: 100)),

            // Statistics
            _buildStatistics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = _getFeatures();

    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        int columns = 1;

        if (deviceSize.index >= DeviceSize.sm.index) {
          columns = 2;
        }
        if (deviceSize.index >= DeviceSize.lg.index) {
          columns = 4;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: columns == 1 ? 1.2 : 0.85,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            return FeatureCard(feature: features[index]);
          },
        );
      },
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        responsive(context, xs: 32, sm: 48, lg: 64),
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ResponsiveBuilder(
        builder: (context, deviceSize) {
          final isMobile = deviceSize == DeviceSize.xs;

          if (isMobile) {
            return Column(
              children: _buildStatisticsList(),
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildStatisticsList(),
          );
        },
      ),
    );
  }

  List<Widget> _buildStatisticsList() {
    return [
      Expanded(
        child: StatisticCard(
          value: '10K+',
          label: 'Active Users',
          icon: Icons.people,
        ),
      ),
      Expanded(
        child: StatisticCard(
          value: '50K+',
          label: 'Projects Created',
          icon: Icons.folder,
        ),
      ),
      Expanded(
        child: StatisticCard(
          value: '99.9%',
          label: 'Uptime',
          icon: Icons.trending_up,
        ),
      ),
      Expanded(
        child: StatisticCard(
          value: '24/7',
          label: 'Support',
          icon: Icons.support_agent,
        ),
      ),
    ];
  }

  List<Feature> _getFeatures() {
    return [
      Feature(
        icon: Icons.bolt,
        title: 'Lightning Fast',
        description:
            'Built for speed with optimized performance that keeps up with your workflow.',
        color: Color(0xFFF59E0B),
      ),
      Feature(
        icon: Icons.security,
        title: 'Enterprise Security',
        description:
            'Bank-level encryption and security measures to keep your data safe and protected.',
        color: Color(0xFF10B981),
      ),
      Feature(
        icon: Icons.sync,
        title: 'Real-time Sync',
        description:
            'Stay in sync across all your devices with instant cloud synchronization.',
        color: Color(0xFF3B82F6),
      ),
      Feature(
        icon: Icons.analytics,
        title: 'Advanced Analytics',
        description:
            'Get insights with powerful analytics and detailed reports on your progress.',
        color: Color(0xFF8B5CF6),
      ),
    ];
  }
}
```

---

## Step 6: Update Main App

**lib/main.dart** (update)
```dart
import 'package:flutter/material.dart';
import 'sections/hero_section.dart';
import 'sections/features_section.dart';  // Add this
import 'core/theme/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFlow Pro Landing Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroSection(),
            FeaturesSection(),  // Add this
            // More sections coming...
          ],
        ),
      ),
    );
  }
}
```

---

## Step 7: Run and Test

```bash
flutter run -d chrome
```

**What you should see:**
1. Hero section (from Part 1)
2. Features section with 4 animated cards
3. Cards lift on hover
4. Statistics section with gradient background
5. Responsive grid (1 col mobile, 2 col tablet, 4 col desktop)

**Test these:**
- Hover over feature cards (should lift with shadow)
- Click "Learn more" (check console)
- Resize browser (grid should adapt)
- Check statistics counter animation on load

---

## Customization Tasks

### Task 1: Add Your Own Features

Edit `_getFeatures()` in `features_section.dart`:

```dart
Feature(
  icon: Icons.your_icon,
  title: 'Your Feature',
  description: 'Your feature description here.',
  color: Color(0xFFYOURCOLOR),
),
```

### Task 2: Change Statistics

Edit `_buildStatisticsList()`:

```dart
StatisticCard(
  value: '500+',
  label: 'Your Metric',
  icon: Icons.your_icon,
),
```

### Task 3: Add Stagger Animation

Make cards appear one by one:

```dart
class _FeaturesGridState extends State<_FeaturesGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                index * 0.2,
                1.0,
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: FeatureCard(feature: features[index]),
        );
      },
    );
  }
}
```

---

## Advanced: Parallax Scroll Effect

Add subtle movement on scroll:

```dart
class ParallaxFeatureCard extends StatefulWidget {
  final Feature feature;
  final ScrollController scrollController;

  const ParallaxFeatureCard({
    Key? key,
    required this.feature,
    required this.scrollController,
  }) : super(key: key);

  @override
  _ParallaxFeatureCardState createState() => _ParallaxFeatureCardState();
}

class _ParallaxFeatureCardState extends State<ParallaxFeatureCard> {
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {
      _offset = widget.scrollController.offset * 0.1;
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: FeatureCard(feature: widget.feature),
    );
  }
}
```

---

## Understanding the Code

### 1. Feature Model
```dart
class Feature {
  final IconData icon;      // Icon to display
  final String title;       // Feature name
  final String description; // What it does
  final Color color;        // Brand color
}
```

**Why?** Separates data from UI. Easy to add/remove features.

### 2. Hover Animation
```dart
bool _isHovered = false;  // Track hover state

MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: AnimatedContainer(
    transform: Matrix4.translationValues(0, _isHovered ? -8 : 0, 0),
    // Moves up 8px on hover
  ),
)
```

**Why?** Creates professional web interactions.

### 3. Responsive Grid
```dart
int columns = 1;  // Default: Mobile (1 column)

if (deviceSize >= sm) columns = 2;  // Tablet: 2 columns
if (deviceSize >= lg) columns = 4;  // Desktop: 4 columns
```

**Why?** Adapts to all screen sizes automatically.

### 4. Statistics Counter
```dart
AnimationController _controller;

_controller.forward();  // Counts from 0 to 1 over 2 seconds
```

**Why?** Engaging visual that draws attention to metrics.

---

## Common Issues

### Issue 1: Cards Not Hovering

**Problem:** Hover effect doesn't work

**Solution:** Make sure you're using `MouseRegion`:
```dart
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  // ...
)
```

### Issue 2: Grid Spacing Wrong

**Problem:** Cards too close or too far

**Solution:** Adjust spacing:
```dart
SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisSpacing: 24,  // Horizontal gap
  mainAxisSpacing: 24,   // Vertical gap
)
```

### Issue 3: Statistics Don't Animate

**Problem:** Numbers appear instantly

**Solution:** Ensure `vsync` is set:
```dart
class _StatisticCardState extends State<StatisticCard>
    with SingleTickerProviderStateMixin {  // Add this
  // ...
}
```

---

## Key Takeaways

1. **Feature cards** = Modular, reusable components
2. **Hover effects** = Professional web feel
3. **Responsive grid** = Adapts columns based on screen
4. **Statistics** = Animated counters for engagement
5. **Gradient backgrounds** = Visual hierarchy
6. **Shadow elevation** = Depth and dimension
7. **Separation of concerns** = Data models vs UI

---

## What's Next?

**Part 3:** Testimonials & Pricing
- Customer testimonial cards
- Automatic carousel/slider
- Pricing comparison table
- Toggle monthly/yearly pricing
- All without packages!

You've built the features section! Looking amazing! ✨🎨
