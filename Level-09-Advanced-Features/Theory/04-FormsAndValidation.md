# Forms and Validation: Making Smart Input Fields

## The Big Idea In One Sentence

> Wrap your inputs in a `Form` with a `GlobalKey`, give each `TextFormField` a `validator`, and `formKey.currentState!.validate()` checks them all at once and shows error messages.

## The Simple Explanation

Imagine you're filling out a form to join a club. The form asks:
- Your name
- Your email
- Your age

But what if someone writes "pizza" in the age field? That's not a number!

```
WITHOUT VALIDATION:
┌─────────────────────────────────────┐
│  Join Our Club                      │
│                                     │
│  Name:  [ Alex       ]  ✓ OK        │
│  Email: [ blahblah   ]  ✓ Accepted! │
│  Age:   [ pizza      ]  ✓ Accepted! │
│                                     │
│         [Join Now!]                 │
└─────────────────────────────────────┘
         ↓
    App crashes or breaks!
    "pizza" is not a number!


WITH VALIDATION:
┌─────────────────────────────────────┐
│  Join Our Club                      │
│                                     │
│  Name:  [ Alex       ]  ✓ Looks good│
│  Email: [ blahblah   ]  ❌ Not valid │
│         └─ "Please enter a valid    │
│             email address"          │
│  Age:   [ pizza      ]  ❌ Not valid │
│         └─ "Please enter a number"  │
│                                     │
│         [Join Now!] (disabled)      │
└─────────────────────────────────────┘
         ↓
    App shows helpful errors!
    User fixes the mistakes!
```

**Validation** = Checking if the input makes sense before accepting it!

---

## Real-Life Examples of Validation

Think about these everyday situations:

### At the Bank ATM
```
Withdraw amount: $-50

ATM says: "Amount must be positive!"
(You can't withdraw negative money!)
```

### Signing Up for a Website
```
Password: 123

Website says: "Password must be at least 8 characters!"
(Too short = not safe!)
```

### Booking a Flight
```
Departure: December 25
Return: December 20

Website says: "Return date must be after departure!"
(Can't go back before you leave!)
```

---

## Forms in Flutter: The Basics

### What is a Form?

A Form is a container that groups multiple input fields together:

```dart
Form(
  child: Column(
    children: [
      TextFormField(/* Name field */),
      TextFormField(/* Email field */),
      TextFormField(/* Password field */),
      ElevatedButton(/* Submit button */),
    ],
  ),
)
```

### The Magic Key: GlobalKey<FormState>

Every form needs a special key to control it:

```dart
// Create the key
final _formKey = GlobalKey<FormState>();

// Give it to the form
Form(
  key: _formKey,  // ← Attach the key
  child: Column(/*...*/),
)

// Use the key to validate
if (_formKey.currentState!.validate()) {
  // All fields are valid!
}
```

Think of the key like a **remote control** for your form:
- Check if everything is valid
- Save all the values
- Reset all fields

---

## TextFormField: The Input Box

TextFormField is an input box with superpowers:

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',           // Label above the field
    hintText: 'Enter your email', // Placeholder text
    prefixIcon: Icon(Icons.email), // Icon on the left
  ),
  validator: (value) {
    // Check if valid
    if (value == null || value.isEmpty) {
      return 'Please enter your email';  // Error message
    }
    return null;  // null = valid!
  },
)
```

### The Validator Function

The validator is like a bouncer at a club:

```
User types: ""   (empty)
          │
          ▼
    Validator checks
          │
          ├── Empty? → Return error message
          │              "Please enter your email"
          │
          └── Not empty? → Return null (let them in!)


User types: "alex@email.com"
          │
          ▼
    Validator checks
          │
          └── Has @ and .? → Return null (valid!)
```

---

## Common Validation Rules

### 1. Required Field (Can't be empty)

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
```

### 2. Minimum Length

```dart
validator: (value) {
  if (value == null || value.length < 8) {
    return 'Must be at least 8 characters';
  }
  return null;
}
```

### 3. Email Format

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter an email';
  }
  // Simple check: contains @ and .
  if (!value.contains('@') || !value.contains('.')) {
    return 'Please enter a valid email';
  }
  return null;
}
```

### 4. Numbers Only

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a number';
  }
  if (int.tryParse(value) == null) {
    return 'Please enter a valid number';
  }
  return null;
}
```

### 5. Password Matching

```dart
// First password field
final _passwordController = TextEditingController();

TextFormField(
  controller: _passwordController,
  decoration: InputDecoration(labelText: 'Password'),
  obscureText: true,
)

// Confirm password field
TextFormField(
  decoration: InputDecoration(labelText: 'Confirm Password'),
  obscureText: true,
  validator: (value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  },
)
```

---

## Complete Form Example

Let's build a registration form step by step:

```dart
import 'package:flutter/material.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // The form key (remote control)
  final _formKey = GlobalKey<FormState>();

  // Controllers to get values
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  // Clean up controllers
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Handle form submission
  void _submitForm() {
    // Check if all fields are valid
    if (_formKey.currentState!.validate()) {
      // All valid! Get the values
      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final age = int.parse(_ageController.text);

      // Do something with the data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, $name!')),
      );

      print('Name: $name');
      print('Email: $email');
      print('Age: $age');
    }
    // If not valid, errors will show automatically!
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // NAME FIELD
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // EMAIL FIELD
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // PASSWORD FIELD
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter a strong password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,  // Hide password
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // AGE FIELD
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  prefixIcon: Icon(Icons.cake),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null) {
                    return 'Please enter a valid number';
                  }
                  if (age < 0 || age > 120) {
                    return 'Please enter a realistic age';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // SUBMIT BUTTON
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Register'),
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

## How Validation Works: Visual Flow

```
User fills form and taps "Register"
              │
              ▼
    _formKey.currentState!.validate()
              │
              ▼
    Calls validator() on EACH field
              │
    ┌─────────┼─────────┐
    │         │         │
    ▼         ▼         ▼
  Name      Email    Password
validator  validator  validator
    │         │         │
    ├─ null   ├─ null   ├─ "Too short!"
    │  (OK)   │  (OK)   │  (ERROR)
    │         │         │
    └─────────┴────┬────┘
                   │
                   ▼
         At least one error?
              │
    ┌─────────┼─────────┐
    │                   │
   YES                  NO
    │                   │
    ▼                   ▼
Show error           validate()
messages             returns true
under fields              │
    │                     ▼
    └───────────→   Run _submitForm()
      User fixes        code!
       errors
```

---

## Real-Time Validation

Want to validate as the user types? Use `autovalidateMode`:

```dart
Form(
  key: _formKey,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  child: Column(/*...*/),
)
```

Options:
- `disabled` - Only validate when you call validate()
- `always` - Always validate (even before user types)
- `onUserInteraction` - Validate after user starts typing

---

## Input Decorations: Making Forms Pretty

```dart
TextFormField(
  decoration: InputDecoration(
    // Text labels
    labelText: 'Email',           // Floats above when typing
    hintText: 'example@mail.com', // Disappears when typing
    helperText: 'We will never share your email',

    // Icons
    prefixIcon: Icon(Icons.email),    // Left icon
    suffixIcon: Icon(Icons.check),    // Right icon

    // Borders
    border: OutlineInputBorder(),     // Rectangle border
    // OR
    border: UnderlineInputBorder(),   // Just a line

    // Colors
    filled: true,
    fillColor: Colors.grey[100],

    // Error styling
    errorStyle: TextStyle(color: Colors.red),
  ),
)
```

### Visual Comparison

```
OUTLINE BORDER:
┌────────────────────────────┐
│ 📧  Enter your email       │
└────────────────────────────┘

UNDERLINE BORDER:
📧  Enter your email
────────────────────────────

FILLED:
┌────────────────────────────┐
│███████████████████████████│
│ 📧  Enter your email       │
│███████████████████████████│
└────────────────────────────┘
```

---

## Special Input Types

### Password with Show/Hide Toggle

```dart
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
```

### Dropdown Selection

```dart
DropdownButtonFormField<String>(
  decoration: const InputDecoration(
    labelText: 'Country',
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(value: 'us', child: Text('United States')),
    DropdownMenuItem(value: 'uk', child: Text('United Kingdom')),
    DropdownMenuItem(value: 'ca', child: Text('Canada')),
  ],
  validator: (value) {
    if (value == null) {
      return 'Please select a country';
    }
    return null;
  },
  onChanged: (value) {
    // Handle selection
  },
)
```

---

## Helper: Reusable Validators

Create validators once, use everywhere:

```dart
class Validators {
  // Required field
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Minimum length
  static String? Function(String?) minLength(int length) {
    return (value) {
      if (value == null || value.length < length) {
        return 'Must be at least $length characters';
      }
      return null;
    };
  }

  // Number in range
  static String? Function(String?) numberInRange(int min, int max) {
    return (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a number';
      }
      final number = int.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }
      if (number < min || number > max) {
        return 'Must be between $min and $max';
      }
      return null;
    };
  }
}

// Usage:
TextFormField(
  validator: Validators.email,
)

TextFormField(
  validator: Validators.minLength(8),
)

TextFormField(
  validator: Validators.numberInRange(1, 100),
)
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              FORMS & VALIDATION SUMMARY                  │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: Checking user input before accepting it           │
│                                                          │
│  KEY COMPONENTS:                                         │
│  • Form - Container for fields                           │
│  • GlobalKey<FormState> - Remote control for form        │
│  • TextFormField - Input box with validation             │
│  • validator - Function that checks the input            │
│                                                          │
│  VALIDATOR RETURNS:                                      │
│  • null = Input is valid                                 │
│  • String = Error message to show                        │
│                                                          │
│  COMMON VALIDATIONS:                                     │
│  • Required (not empty)                                  │
│  • Minimum length                                        │
│  • Email format                                          │
│  • Numbers only                                          │
│  • Matching fields (password confirm)                    │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What does a validator return when the input is valid?

<details>
<summary>Answer</summary>

`null` - Returning null means "no error" which means the input is valid!

</details>

**Q2:** What does this validator do?

```dart
validator: (value) {
  if (value == null || value.length < 6) {
    return 'Too short!';
  }
  return null;
}
```

<details>
<summary>Answer</summary>

It checks if the input is at least 6 characters long. If it's shorter than 6 characters (or empty), it shows "Too short!" as an error.

</details>

**Q3:** Why do we need `GlobalKey<FormState>`?

<details>
<summary>Answer</summary>

It's like a remote control for the form. We use it to:
- Check if all fields are valid (`_formKey.currentState!.validate()`)
- Save all field values
- Reset all fields

Without it, we couldn't control the form!

</details>

---

## Assignment

### Problem 1: Write a validator

Write a `validator` for a name field that returns an error message when the text is empty, and `null` otherwise.

### Problem 2: Check the whole form

You tapped Submit. Write the line that runs all validators and tells you if the form is valid.

### Problem 3: What does null mean?

In a `validator`, what does returning `null` tell Flutter?

---

## Assignment Answers

### Problem 1: Write a validator

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }
  return null;
},
```

### Problem 2: Check the whole form

```dart
if (_formKey.currentState!.validate()) {
  // all fields passed, do the submit
}
```

### Problem 3: What does null mean?

Returning `null` means "this field is valid, no error." Returning a String means "show this error message."

---

**Next:** Let's learn about Theming and Styling to make our apps beautiful!

---

**Continue to:** `05-ThemingAndStyling.md`
