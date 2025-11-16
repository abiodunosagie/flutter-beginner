# Week 18: Complete Landing Page - Part 4 (Contact Form & Footer)

## What We're Building

Final sections to complete the landing page:
- 📧 Contact form with validation
- ✅ Form submission handling
- 📰 Newsletter signup
- 🔗 Footer with links
- 📱 Social media icons
- ⬆️ Scroll to top button

---

## Step 1: Contact Form Widget

**lib/widgets/contact_form.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/responsive/responsive_values.dart';
import 'hover_animated_button.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isLoading = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name field
          _buildTextField(
            controller: _nameController,
            label: 'Your Name',
            hint: 'John Doe',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Email field
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'john@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          SizedBox(height: 20),

          // Message field
          _buildTextField(
            controller: _messageController,
            label: 'Message',
            hint: 'Tell us about your project...',
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              if (value.length < 10) {
                return 'Message must be at least 10 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : HoverAnimatedButton(
                    text: 'Send Message',
                    icon: Icons.send,
                    onTap: _submitForm,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium(context).copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textLight),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
```

---

## Step 2: Newsletter Widget

**lib/widgets/newsletter_signup.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class NewsletterSignup extends StatefulWidget {
  @override
  _NewsletterSignupState createState() => _NewsletterSignupState();
}

class _NewsletterSignupState extends State<NewsletterSignup> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _subscribe() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully subscribed!'),
        backgroundColor: AppColors.success,
      ),
    );

    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 500),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          _isLoading
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              : MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _subscribe,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Subscribe',
                        style: AppTypography.button(context).copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
```

---

## Step 3: Contact Section

**lib/sections/contact_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/section_header.dart';
import '../widgets/contact_form.dart';

class ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        vertical: responsive(context, xs: 60, sm: 80, lg: 100),
      ),
      child: ResponsiveContainer(
        child: ResponsiveBuilder(
          builder: (context, deviceSize) {
            final isMobile = deviceSize == DeviceSize.xs;

            return Column(
              children: [
                SectionHeader(
                  badge: 'Contact',
                  title: 'Get in touch',
                  description:
                      'Have a question or want to work together? We\'d love to hear from you.',
                ),

                SizedBox(height: responsive(context, xs: 40, sm: 60, lg: 80)),

                isMobile
                    ? _buildMobileLayout()
                    : _buildDesktopLayout(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildContactInfo(),
        SizedBox(height: 40),
        ContactForm(),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: ContactForm(),
        ),
        SizedBox(width: 80),
        Expanded(
          flex: 3,
          child: _buildContactInfo(),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContactItem(
          Icons.email_outlined,
          'Email',
          'hello@flutterflowpro.com',
        ),
        SizedBox(height: 24),
        _buildContactItem(
          Icons.phone_outlined,
          'Phone',
          '+1 (555) 123-4567',
        ),
        SizedBox(height: 24),
        _buildContactItem(
          Icons.location_on_outlined,
          'Office',
          '123 Tech Street\nSan Francisco, CA 94102',
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.textWhite, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

---

## Step 4: Footer Section

**lib/sections/footer_section.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/responsive/responsive_builder.dart';
import '../core/responsive/responsive_values.dart';
import '../widgets/responsive_container.dart';
import '../widgets/newsletter_signup.dart';

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      padding: EdgeInsets.symmetric(
        vertical: responsive(context, xs: 40, sm: 60, lg: 80),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            // Newsletter section
            _buildNewsletterSection(context),

            SizedBox(height: 60),

            Divider(color: Colors.white.withOpacity(0.1)),

            SizedBox(height: 40),

            // Footer links
            ResponsiveBuilder(
              builder: (context, deviceSize) {
                return deviceSize == DeviceSize.xs
                    ? _buildMobileFooter()
                    : _buildDesktopFooter();
              },
            ),

            SizedBox(height: 40),

            Divider(color: Colors.white.withOpacity(0.1)),

            SizedBox(height: 24),

            // Copyright
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsletterSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Stay updated',
          style: AppTypography.h3(context).copyWith(
            color: AppColors.textWhite,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Subscribe to our newsletter for updates and exclusive offers',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(context).copyWith(
            color: AppColors.textWhite.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 32),
        NewsletterSignup(),
      ],
    );
  }

  Widget _buildMobileFooter() {
    return Column(
      children: [
        _buildFooterColumn('Product', [
          'Features',
          'Pricing',
          'Testimonials',
          'FAQ',
        ]),
        SizedBox(height: 32),
        _buildFooterColumn('Company', [
          'About Us',
          'Careers',
          'Blog',
          'Press Kit',
        ]),
        SizedBox(height: 32),
        _buildFooterColumn('Support', [
          'Help Center',
          'Documentation',
          'API Reference',
          'Contact',
        ]),
        SizedBox(height: 32),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildDesktopFooter() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Row(
                children: [
                  Icon(Icons.flutter_dash, color: AppColors.primary, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'FlutterFlow Pro',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Build better products faster.',
                style: TextStyle(
                  color: AppColors.textWhite.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              _buildSocialLinks(),
            ],
          ),
        ),
        Expanded(
          child: _buildFooterColumn('Product', [
            'Features',
            'Pricing',
            'Testimonials',
            'FAQ',
          ]),
        ),
        Expanded(
          child: _buildFooterColumn('Company', [
            'About Us',
            'Careers',
            'Blog',
            'Press Kit',
          ]),
        ),
        Expanded(
          child: _buildFooterColumn('Support', [
            'Help Center',
            'Documentation',
            'API Reference',
            'Contact',
          ]),
        ),
      ],
    );
  }

  Widget _buildFooterColumn(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16),
        ...links.map((link) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  print('Clicked: $link');
                },
                child: Text(
                  link,
                  style: TextStyle(
                    color: AppColors.textWhite.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        _buildSocialIcon(Icons.facebook, 'Facebook'),
        SizedBox(width: 16),
        _buildSocialIcon(Icons.call, 'Twitter'),
        SizedBox(width: 16),
        _buildSocialIcon(Icons.camera_alt, 'Instagram'),
        SizedBox(width: 16),
        _buildSocialIcon(Icons.shopping_bag, 'LinkedIn'),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, String label) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          print('Clicked: $label');
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.textWhite.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.textWhite,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCopyright() {
    return Text(
      '© 2024 FlutterFlow Pro. All rights reserved.',
      style: TextStyle(
        color: AppColors.textWhite.withOpacity(0.5),
        fontSize: 14,
      ),
    );
  }
}
```

---

## Step 5: Scroll to Top Button

**lib/widgets/scroll_to_top_button.dart**
```dart
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ScrollToTopButton extends StatefulWidget {
  final ScrollController scrollController;

  const ScrollToTopButton({Key? key, required this.scrollController})
      : super(key: key);

  @override
  _ScrollToTopButtonState createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.offset > 500 && !_showButton) {
      setState(() => _showButton = true);
    } else if (widget.scrollController.offset <= 500 && _showButton) {
      setState(() => _showButton = false);
    }
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showButton ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300),
      child: _showButton
          ? Positioned(
              right: 24,
              bottom: 24,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _scrollToTop,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
```

---

## Step 6: Final Main App

**lib/main.dart** (complete)
```dart
import 'package:flutter/material.dart';
import 'sections/hero_section.dart';
import 'sections/features_section.dart';
import 'sections/testimonials_section.dart';
import 'sections/pricing_section.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';
import 'widgets/scroll_to_top_button.dart';
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

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(),
                FeaturesSection(),
                TestimonialsSection(),
                PricingSection(),
                ContactSection(),
                FooterSection(),
              ],
            ),
          ),
          ScrollToTopButton(scrollController: _scrollController),
        ],
      ),
    );
  }
}
```

---

## Final Testing Checklist

```bash
flutter run -d chrome
```

### Test All Features:

**Hero Section:**
- [ ] Gradient background displays
- [ ] Buttons have hover effects
- [ ] Responsive on mobile/desktop

**Features:**
- [ ] Cards hover and lift
- [ ] Statistics animate on load
- [ ] Grid adapts to screen size

**Testimonials:**
- [ ] Auto-rotate every 5 seconds
- [ ] Dots indicate active slide
- [ ] Can click dots to change slides

**Pricing:**
- [ ] Toggle switches monthly/yearly
- [ ] Savings percentage shows on yearly
- [ ] Popular plan highlighted
- [ ] Cards hover effect works

**Contact:**
- [ ] Form validation works
- [ ] Shows error messages
- [ ] Success message on submit
- [ ] Form clears after submit

**Footer:**
- [ ] Newsletter signup works
- [ ] Social links clickable
- [ ] Links navigate (check console)
- [ ] Responsive on all sizes

**Scroll to Top:**
- [ ] Appears after scrolling down 500px
- [ ] Smooth scroll to top on click
- [ ] Fades in/out smoothly

---

## Deployment Preparation

### Build for Production

```bash
# Build web app
flutter build web --release --web-renderer canvaskit

# Output goes to build/web/
```

### Optimize Build

```bash
# HTML renderer (smaller, better for SEO)
flutter build web --release --web-renderer html

# Set base href for subdirectory hosting
flutter build web --base-href /myapp/
```

---

## Customization Tasks

### Task 1: Add Your Branding

**Colors:** Edit `lib/core/theme/app_colors.dart`
**Logo:** Add image to `web/icons/`
**Text:** Update all sections with your content

### Task 2: Add Analytics

```dart
// In index.html
<head>
  <!-- Google Analytics -->
  <script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
  <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'GA_ID');
  </script>
</head>
```

### Task 3: Add Real Form Handling

```dart
// Using HTTP package
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _submitForm() async {
  final response = await http.post(
    Uri.parse('https://your-api.com/contact'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': _nameController.text,
      'email': _emailController.text,
      'message': _messageController.text,
    }),
  );

  if (response.statusCode == 200) {
    // Success!
  }
}
```

---

## Complete Landing Page Summary

You've built a **production-ready landing page** with:

✅ **Hero section** - Gradient background, CTA buttons
✅ **Features grid** - 4 animated cards, statistics
✅ **Testimonials** - Auto-rotating carousel
✅ **Pricing** - Monthly/yearly toggle, 3 plans
✅ **Contact form** - Validation, submission
✅ **Footer** - Newsletter, links, social media
✅ **Scroll to top** - Smooth scroll button
✅ **Fully responsive** - Mobile to 4K displays
✅ **No packages** - Everything from scratch!
✅ **Production ready** - Optimized and professional

---

## Key Takeaways

1. **Form validation** - User-friendly error messages
2. **Loading states** - Show progress during async operations
3. **Responsive design** - Stack on mobile, row on desktop
4. **Newsletter** - Collect emails for marketing
5. **Footer organization** - Grouped links for easy navigation
6. **Scroll behavior** - Smooth animations, scroll to top
7. **Professional polish** - Attention to every detail

---

## What's Next?

**Week 19:** Complete Dashboard Tutorial
- Professional admin dashboard
- Data tables with sorting/filtering
- Charts and graphs (no packages!)
- Multi-level sidebar navigation
- User management interface
- Dashboard widgets and cards

You've completed a professional landing page! 🎉🚀✨
