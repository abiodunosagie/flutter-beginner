# Week 18: Complete Landing Page - Part 1 (Setup & Hero Section)

## What We're Building

A **professional landing page** for a fictional product called "FlutterFlow Pro" - a productivity app.

**What the page will have:**
1. ✨ Animated hero section with call-to-action
2. 🎯 Features section with icons and descriptions
3. 💬 Testimonials carousel
4. 📊 Pricing cards
5. 📧 Contact form
6. 🔗 Footer with links
7. 📱 Fully responsive (mobile to 4K)

**No packages!** Everything built from scratch.

---

## Project Setup

### Step 1: Create New Flutter Project

```bash
flutter create flutter_landing_page
cd flutter_landing_page
flutter run -d chrome
```

### Step 2: Project Structure

Create this folder structure:

```
lib/
├── main.dart
├── core/
│   ├── responsive/
│   │   ├── breakpoints.dart
│   │   ├── responsive_builder.dart
│   │   └── responsive_values.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_typography.dart
│   └── constants/
│       └── app_constants.dart
├── widgets/
│   ├── responsive_container.dart
│   └── hover_animated_button.dart
└── sections/
    ├── hero_section.dart
    ├── features_section.dart
    ├── testimonials_section.dart
    ├── pricing_section.dart
    ├── contact_section.dart
    └── footer_section.dart
```

### Step 3: Copy Responsive System

From previous lesson, create these files:

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

## Design System

### Step 4: Define Colors

**lib/core/theme/app_colors.dart**
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF6366F1);      // Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Accent colors
  static const Color accent = Color(0xFFF59E0B);       // Amber
  static const Color accentLight = Color(0xFFFBBF24);

  // Neutral colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1F2937);

  // Text colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
  );
}
```

### Step 5: Define Typography

**lib/core/theme/app_typography.dart**
```dart
import 'package:flutter/material.dart';
import '../responsive/responsive_values.dart';

class AppTypography {
  // Headings
  static TextStyle h1(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 36, sm: 48, lg: 64),
      fontWeight: FontWeight.bold,
      height: 1.1,
      letterSpacing: -1,
    );
  }

  static TextStyle h2(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 30, sm: 36, lg: 48),
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  static TextStyle h3(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 24, sm: 30, lg: 36),
      fontWeight: FontWeight.w600,
      height: 1.3,
    );
  }

  static TextStyle h4(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 20, sm: 24, lg: 28),
      fontWeight: FontWeight.w600,
      height: 1.4,
    );
  }

  // Body text
  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 18, sm: 20, lg: 22),
      height: 1.6,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 16, sm: 17, lg: 18),
      height: 1.6,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 14, sm: 15, lg: 16),
      height: 1.5,
    );
  }

  // Buttons
  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 16, sm: 17, lg: 18),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );
  }

  // Captions
  static TextStyle caption(BuildContext context) {
    return TextStyle(
      fontSize: responsive(context, xs: 12, sm: 13, lg: 14),
      height: 1.4,
    );
  }
}
```

---

## Reusable Widgets

### Step 6: Responsive Container

**lib/widgets/responsive_container.dart**
```dart
import 'package:flutter/material.dart';
import '../core/responsive/responsive_values.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({
    Key? key,
    required this.child,
    this.maxWidth = 1200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? double.infinity,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: responsive(context, xs: 16, sm: 24, lg: 32),
        ),
        child: child,
      ),
    );
  }
}
```

### Step 7: Hover Animated Button

**lib/widgets/hover_animated_button.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class HoverAnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isPrimary;
  final IconData? icon;

  const HoverAnimatedButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isPrimary = true,
    this.icon,
  }) : super(key: key);

  @override
  _HoverAnimatedButtonState createState() => _HoverAnimatedButtonState();
}

class _HoverAnimatedButtonState extends State<HoverAnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? (_isHovered ? AppColors.accentGradient : AppColors.primaryGradient)
                : null,
            color: widget.isPrimary ? null : Colors.transparent,
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: _isHovered ? AppColors.primary : AppColors.textWhite,
                    width: 2,
                  ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.isPrimary
                          ? AppColors.primary.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.isPrimary
                      ? AppColors.textWhite
                      : (_isHovered ? AppColors.primary : AppColors.textWhite),
                  size: 20,
                ),
                SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: AppTypography.button(context).copyWith(
                  color: widget.isPrimary
                      ? AppColors.textWhite
                      : (_isHovered ? AppColors.primary : AppColors.textWhite),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Hero Section

### Step 8: Build Hero Section

**lib/sections/hero_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/hover_animated_button.dart';

class HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: ResponsiveContainer(
        child: ResponsiveBuilder(
          builder: (context, deviceSize) {
            final isMobile = deviceSize == DeviceSize.xs;

            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: responsive(context, xs: 60, sm: 80, lg: 120),
              ),
              child: isMobile
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            );
          },
        ),
      ),
    );
  }

  // Mobile: Stack vertically
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildContent(context, textAlign: TextAlign.center),
        SizedBox(height: 48),
        _buildIllustration(context),
      ],
    );
  }

  // Desktop: Side by side
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: _buildContent(context, textAlign: TextAlign.left),
        ),
        SizedBox(width: 80),
        Expanded(
          flex: 5,
          child: _buildIllustration(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, {required TextAlign textAlign}) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentLight.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                color: AppColors.accentLight,
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Trusted by 10,000+ users',
                style: AppTypography.bodySmall(context).copyWith(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // Main heading
        Text(
          'Boost Your Productivity',
          textAlign: textAlign,
          style: AppTypography.h1(context).copyWith(
            color: AppColors.textWhite,
          ),
        ),

        SizedBox(height: 16),

        // Subheading
        Text(
          'The ultimate tool for developers, designers, and teams to collaborate and ship faster.',
          textAlign: textAlign,
          style: AppTypography.bodyLarge(context).copyWith(
            color: AppColors.textWhite.withOpacity(0.9),
          ),
        ),

        SizedBox(height: 40),

        // CTA buttons
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : WrapAlignment.start,
          children: [
            HoverAnimatedButton(
              text: 'Get Started Free',
              icon: Icons.rocket_launch,
              onTap: () {
                print('Get Started clicked');
              },
            ),
            HoverAnimatedButton(
              text: 'Watch Demo',
              icon: Icons.play_circle_outline,
              isPrimary: false,
              onTap: () {
                print('Watch Demo clicked');
              },
            ),
          ],
        ),

        SizedBox(height: 32),

        // Social proof
        _buildSocialProof(context, textAlign),
      ],
    );
  }

  Widget _buildSocialProof(BuildContext context, TextAlign textAlign) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Join thousands of happy users',
          style: AppTypography.bodySmall(context).copyWith(
            color: AppColors.textWhite.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Star rating
            ...List.generate(5, (index) {
              return Icon(
                Icons.star,
                color: AppColors.accentLight,
                size: 20,
              );
            }),
            SizedBox(width: 12),
            Text(
              '4.9 out of 5',
              style: AppTypography.bodySmall(context).copyWith(
                color: AppColors.textWhite.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        responsive(context, xs: 24, sm: 32, lg: 48),
      ),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textWhite.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Placeholder for illustration
          Icon(
            Icons.devices,
            size: responsive(context, xs: 120, sm: 150, lg: 200),
            color: AppColors.textWhite,
          ),
          SizedBox(height: 24),
          Text(
            'Available on all platforms',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium(context).copyWith(
              color: AppColors.textWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Main App

### Step 9: Put It Together

**lib/main.dart**
```dart
import 'package:flutter/material.dart';
import 'sections/hero_section.dart';
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
        fontFamily: 'Inter', // Add custom font in pubspec.yaml if desired
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
            // More sections will be added in next parts
          ],
        ),
      ),
    );
  }
}
```

---

## Test and Preview

### Step 10: Run the App

```bash
flutter run -d chrome
```

**What you should see:**
- Beautiful gradient hero section
- Responsive layout (try resizing browser!)
- Animated hover effects on buttons
- Centered content with max width
- Different layouts for mobile vs desktop

**Test these:**
1. Resize browser from 320px to 1920px
2. Hover over buttons (should lift and change color)
3. Click buttons (check console logs)
4. Mobile view (content stacks vertically)
5. Desktop view (content side-by-side)

---

## Customization Tasks

### Task 1: Change Colors

Edit `app_colors.dart`:
```dart
static const Color primary = Color(0xFF10B981);  // Green theme
```

### Task 2: Add Your Brand Text

Edit `hero_section.dart`:
```dart
Text(
  'Your Awesome Product',  // Change this
  style: AppTypography.h1(context).copyWith(
    color: AppColors.textWhite,
  ),
),
```

### Task 3: Add Animation

Make the illustration bounce:

```dart
class _IllustrationState extends State<_Illustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _controller.value * 20 - 10),
          child: child,
        );
      },
      child: Icon(Icons.devices, size: 200),
    );
  }
}
```

---

## Key Takeaways

1. **Project structure** = Organized folders for scalability
2. **Design system** = Defined colors and typography
3. **Responsive** = Works on all screen sizes
4. **Reusable widgets** = Button and container components
5. **Mobile-first** = Stack on mobile, side-by-side on desktop
6. **Hover effects** = Professional web interactions
7. **No packages** = Everything built from scratch!

---

## What's Next?

**Part 2:** Features Section
- Icon grid layout
- Feature cards with hover effects
- Animated statistics
- Fully responsive grid

You've built the hero section! Looking professional! 🚀✨
