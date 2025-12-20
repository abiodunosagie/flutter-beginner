// Example 03: Form Validation
// Complete registration form with validation

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Validation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// REGISTRATION PAGE
// ═══════════════════════════════════════════════════════════════

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Form key - like a remote control for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to get text values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  // State for password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // State for terms acceptance
  bool _acceptTerms = false;

  // Loading state
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // FORM SUBMISSION
  // ─────────────────────────────────────────────────────────────

  Future<void> _submitForm() async {
    // Validate all fields
    if (!_formKey.currentState!.validate()) {
      return; // Stop if validation fails
    }

    // Check terms acceptance
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Hide loading
    setState(() => _isLoading = false);

    // Show success
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Registration Successful!'),
          content: Text('Welcome, ${_nameController.text}!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _formKey.currentState!.reset();
                setState(() => _acceptTerms = false);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Icon(Icons.person_add, size: 64, color: Colors.indigo),
              const SizedBox(height: 8),
              const Text(
                'Join Us Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // ─────────────────────────────────────────────────
              // NAME FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                    return 'Name can only contain letters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // EMAIL FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Email regex pattern
                  final emailRegex = RegExp(
                    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // PHONE FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Simple phone validation
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  if (!RegExp(r'^[0-9+\-\s]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // AGE FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Please enter a valid number';
                  }
                  if (age < 13) {
                    return 'You must be at least 13 years old';
                  }
                  if (age > 120) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // PASSWORD FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Create a strong password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  if (!value.contains(RegExp(r'[A-Z]'))) {
                    return 'Password must contain an uppercase letter';
                  }
                  if (!value.contains(RegExp(r'[a-z]'))) {
                    return 'Password must contain a lowercase letter';
                  }
                  if (!value.contains(RegExp(r'[0-9]'))) {
                    return 'Password must contain a number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),

              // Password strength indicator
              Builder(
                builder: (context) {
                  final password = _passwordController.text;
                  int strength = 0;
                  if (password.length >= 8) strength++;
                  if (password.contains(RegExp(r'[A-Z]'))) strength++;
                  if (password.contains(RegExp(r'[a-z]'))) strength++;
                  if (password.contains(RegExp(r'[0-9]'))) strength++;
                  if (password.contains(RegExp(r'[!@#$%^&*]'))) strength++;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: strength / 5,
                        backgroundColor: Colors.grey[300],
                        color: strength <= 2
                            ? Colors.red
                            : strength <= 3
                                ? Colors.orange
                                : Colors.green,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strength <= 2
                            ? 'Weak'
                            : strength <= 3
                                ? 'Medium'
                                : 'Strong',
                        style: TextStyle(
                          fontSize: 12,
                          color: strength <= 2
                              ? Colors.red
                              : strength <= 3
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // CONFIRM PASSWORD FIELD
              // ─────────────────────────────────────────────────
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────
              // TERMS CHECKBOX
              // ─────────────────────────────────────────────────
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _acceptTerms = !_acceptTerms;
                        });
                      },
                      child: const Text(
                        'I agree to the Terms of Service and Privacy Policy',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ─────────────────────────────────────────────────
              // SUBMIT BUTTON
              // ─────────────────────────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
              ),

              const SizedBox(height: 16),

              // Already have account link
              TextButton(
                onPressed: () {
                  // Navigate to login
                },
                child: const Text('Already have an account? Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * KEY CONCEPTS DEMONSTRATED:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Form & GlobalKey<FormState>
 *    - Form wraps all fields
 *    - GlobalKey allows validate() and reset()
 *
 * 2. TextFormField
 *    - controller: Get/set text values
 *    - decoration: Style the field
 *    - validator: Check if valid
 *    - keyboardType: Appropriate keyboard
 *
 * 3. Validators
 *    - Return null if valid
 *    - Return error message if invalid
 *    - Can use RegExp for patterns
 *
 * 4. Password Visibility Toggle
 *    - obscureText: true/false
 *    - suffixIcon with IconButton
 *    - setState to toggle
 *
 * 5. Password Confirmation
 *    - Compare with original password
 *    - Must match exactly
 *
 * 6. Form Submission
 *    - _formKey.currentState!.validate()
 *    - Returns true if all valid
 *    - Shows errors if invalid
 *
 * ═══════════════════════════════════════════════════════════════
 * COMMON VALIDATORS:
 * ═══════════════════════════════════════════════════════════════
 *
 * Required:
 *   if (value == null || value.isEmpty) return 'Required';
 *
 * Min Length:
 *   if (value.length < 8) return 'Too short';
 *
 * Email:
 *   RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
 *
 * Phone:
 *   RegExp(r'^[0-9+\-\s]+$')
 *
 * Number Range:
 *   final n = int.tryParse(value);
 *   if (n == null || n < 0 || n > 100) return 'Invalid';
 *
 * ═══════════════════════════════════════════════════════════════
 * EXERCISES:
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add a username field with unique validation
 * 2. Add a date of birth picker instead of age
 * 3. Add profile picture upload
 * 4. Save form data to SharedPreferences
 * 5. Add real-time validation (validate on change)
 *
 */
