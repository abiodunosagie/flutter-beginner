# Level 05 PART 6b: Input Widgets - Forms and User Input

## For a 5-Year-Old

Imagine you're filling out a form to join a fun club:
- You write your name in a box (that's a **text field**)
- You check boxes for things you like (that's **checkboxes**)
- You turn switches ON or OFF (like light switches)
- You pick one option from a list (like choosing your favorite color)
- You slide a button to choose a number (like volume control)

Flutter gives you ALL these input types! They help users tell your app what they want. Let's learn how to use them all!

---

## Input Widget Types Overview

| Widget | What It Does | Best For |
|--------|--------------|----------|
| **TextField** | Type text | Names, messages, any text |
| **TextFormField** | TextField with validation | Login forms, data forms |
| **Checkbox** | Check/uncheck one option | Agree to terms, settings |
| **Switch** | Toggle on/off | Enable/disable features |
| **Radio** | Pick ONE from many | Choose gender, payment method |
| **Slider** | Pick a number by sliding | Volume, brightness, age |
| **DropdownButton** | Pick from dropdown list | Country, category, etc. |

---

## TextField - Basic Text Input

**Best for:** Simple text input without validation

### Basic Usage

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
  ),
)
```

### With Controller (to get the value)

```dart
class TextFieldExample extends StatefulWidget {
  @override
  State<TextFieldExample> createState() => _TextFieldExampleState();
}

class _TextFieldExampleState extends State<TextFieldExample> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Clean up!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Name',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Get the text value
            String name = _controller.text;
            print('Name: $name');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

### All InputDecoration Options

```dart
TextField(
  decoration: InputDecoration(
    // Labels
    labelText: 'Email',
    hintText: 'user@example.com',
    helperText: 'Enter your email address',

    // Icons
    prefixIcon: Icon(Icons.email),
    suffixIcon: Icon(Icons.check_circle, color: Colors.green),

    // Border (outlined style)
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),

    // Focus border (when typing)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.blue, width: 2),
    ),

    // Error border
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red, width: 2),
    ),

    // Background color
    filled: true,
    fillColor: Colors.grey[100],

    // Content padding
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
)
```

### Common TextField Patterns

```dart
// Password field
TextField(
  obscureText: true,  // Hide text
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
)

// Email field
TextField(
  keyboardType: TextInputType.emailAddress,
  decoration: InputDecoration(
    labelText: 'Email',
    prefixIcon: Icon(Icons.email),
  ),
)

// Phone number
TextField(
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: 'Phone',
    prefixIcon: Icon(Icons.phone),
  ),
)

// Number only
TextField(
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: 'Age',
  ),
)

// Multi-line (for longer text)
TextField(
  maxLines: 5,
  decoration: InputDecoration(
    labelText: 'Description',
    alignLabelWithHint: true,
    border: OutlineInputBorder(),
  ),
)

// With character counter
TextField(
  maxLength: 50,
  decoration: InputDecoration(
    labelText: 'Bio',
  ),
)
```

### TextField Events

```dart
TextField(
  onChanged: (value) {
    // Called every time text changes
    print('Current text: $value');
  },
  onSubmitted: (value) {
    // Called when user presses enter/done
    print('Submitted: $value');
  },
  onTap: () {
    // Called when field is tapped
    print('Field tapped');
  },
)
```

---

## TextFormField - TextField with Validation

**Best for:** Forms that need validation (login, signup, etc.)

### Basic Form with Validation

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email field
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null; // Valid
            },
          ),

          SizedBox(height: 16),

          // Password field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),

          SizedBox(height: 24),

          // Submit button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Form is valid
                String email = _emailController.text;
                String password = _passwordController.text;
                print('Login: $email / $password');

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing login...')),
                );
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### Common Validators

```dart
// Email validator
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email';
  }
  return null;
}

// Password validator
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain an uppercase letter';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain a number';
  }
  return null;
}

// Phone number validator
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Enter a valid 10-digit phone number';
  }
  return null;
}

// Required field
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

// Number range
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Age is required';
  }
  int? age = int.tryParse(value);
  if (age == null) {
    return 'Enter a valid number';
  }
  if (age < 18 || age > 100) {
    return 'Age must be between 18 and 100';
  }
  return null;
}

// Confirm password
final _passwordController = TextEditingController();

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

## Checkbox - Check/Uncheck Options

**Best for:** Multiple selections, agreements

### Basic Checkbox

```dart
class CheckboxExample extends StatefulWidget {
  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value ?? false;
        });
      },
    );
  }
}
```

### CheckboxListTile (with label)

```dart
class CheckboxListTileExample extends StatefulWidget {
  @override
  State<CheckboxListTileExample> createState() => _CheckboxListTileExampleState();
}

class _CheckboxListTileExampleState extends State<CheckboxListTileExample> {
  bool acceptTerms = false;
  bool subscribeNewsletter = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('I accept the Terms and Conditions'),
          value: acceptTerms,
          onChanged: (bool? value) {
            setState(() {
              acceptTerms = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading, // Checkbox on left
        ),

        CheckboxListTile(
          title: Text('Subscribe to newsletter'),
          subtitle: Text('Get weekly updates'),
          value: subscribeNewsletter,
          onChanged: (bool? value) {
            setState(() {
              subscribeNewsletter = value ?? false;
            });
          },
        ),
      ],
    );
  }
}
```

### Multiple Checkboxes (List of Options)

```dart
class MultipleCheckboxes extends StatefulWidget {
  @override
  State<MultipleCheckboxes> createState() => _MultipleCheckboxesState();
}

class _MultipleCheckboxesState extends State<MultipleCheckboxes> {
  List<String> selectedHobbies = [];

  final List<String> hobbies = [
    'Reading',
    'Gaming',
    'Sports',
    'Music',
    'Cooking',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select your hobbies:', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        ...hobbies.map((hobby) {
          return CheckboxListTile(
            title: Text(hobby),
            value: selectedHobbies.contains(hobby),
            onChanged: (bool? checked) {
              setState(() {
                if (checked == true) {
                  selectedHobbies.add(hobby);
                } else {
                  selectedHobbies.remove(hobby);
                }
              });
            },
          );
        }).toList(),
        SizedBox(height: 16),
        Text('Selected: ${selectedHobbies.join(", ")}'),
      ],
    );
  }
}
```

---

## Switch - Toggle On/Off

**Best for:** Settings, enable/disable features

### Basic Switch

```dart
class SwitchExample extends StatefulWidget {
  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (bool value) {
        setState(() {
          isSwitched = value;
        });
      },
    );
  }
}
```

### SwitchListTile (with label)

```dart
class SwitchListTileExample extends StatefulWidget {
  @override
  State<SwitchListTileExample> createState() => _SwitchListTileExampleState();
}

class _SwitchListTileExampleState extends State<SwitchListTileExample> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: Text('Enable Notifications'),
          subtitle: Text('Receive push notifications'),
          value: notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        ),

        SwitchListTile(
          title: Text('Dark Mode'),
          value: darkModeEnabled,
          onChanged: (bool value) {
            setState(() {
              darkModeEnabled = value;
            });
          },
          secondary: Icon(Icons.dark_mode), // Icon on left
        ),
      ],
    );
  }
}
```

---

## Radio - Pick ONE Option

**Best for:** Selecting one from multiple options

### Basic Radio Buttons

```dart
class RadioExample extends StatefulWidget {
  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String selectedGender = 'male';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<String>(
          title: Text('Male'),
          value: 'male',
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value!;
            });
          },
        ),

        RadioListTile<String>(
          title: Text('Female'),
          value: 'female',
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value!;
            });
          },
        ),

        RadioListTile<String>(
          title: Text('Other'),
          value: 'other',
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value!;
            });
          },
        ),
      ],
    );
  }
}
```

### Radio with Enum

```dart
enum PaymentMethod { creditCard, paypal, cash }

class RadioEnumExample extends StatefulWidget {
  @override
  State<RadioEnumExample> createState() => _RadioEnumExampleState();
}

class _RadioEnumExampleState extends State<RadioEnumExample> {
  PaymentMethod selectedPayment = PaymentMethod.creditCard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<PaymentMethod>(
          title: Text('Credit Card'),
          subtitle: Text('Pay with credit/debit card'),
          value: PaymentMethod.creditCard,
          groupValue: selectedPayment,
          onChanged: (PaymentMethod? value) {
            setState(() {
              selectedPayment = value!;
            });
          },
        ),

        RadioListTile<PaymentMethod>(
          title: Text('PayPal'),
          subtitle: Text('Pay with PayPal account'),
          value: PaymentMethod.paypal,
          groupValue: selectedPayment,
          onChanged: (PaymentMethod? value) {
            setState(() {
              selectedPayment = value!;
            });
          },
        ),

        RadioListTile<PaymentMethod>(
          title: Text('Cash'),
          subtitle: Text('Pay with cash on delivery'),
          value: PaymentMethod.cash,
          groupValue: selectedPayment,
          onChanged: (PaymentMethod? value) {
            setState(() {
              selectedPayment = value!;
            });
          },
        ),
      ],
    );
  }
}
```

---

## Slider - Pick a Number

**Best for:** Ranges, volume, brightness, ratings

### Basic Slider

```dart
class SliderExample extends StatefulWidget {
  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double sliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Value: ${sliderValue.round()}'),
        Slider(
          value: sliderValue,
          min: 0,
          max: 100,
          divisions: 10, // Snap to 10 divisions
          label: sliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              sliderValue = value;
            });
          },
        ),
      ],
    );
  }
}
```

### RangeSlider (Two Values)

```dart
class RangeSliderExample extends StatefulWidget {
  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues rangeValues = RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Range: ${rangeValues.start.round()} - ${rangeValues.end.round()}'),
        RangeSlider(
          values: rangeValues,
          min: 0,
          max: 100,
          divisions: 10,
          labels: RangeLabels(
            rangeValues.start.round().toString(),
            rangeValues.end.round().toString(),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              rangeValues = values;
            });
          },
        ),
      ],
    );
  }
}
```

---

## DropdownButton - Pick from List

**Best for:** Long lists of options (countries, categories)

### Basic Dropdown

```dart
class DropdownExample extends StatefulWidget {
  @override
  State<DropdownExample> createState() => _DropdownExampleState();
}

class _DropdownExampleState extends State<DropdownExample> {
  String selectedFruit = 'Apple';

  final List<String> fruits = ['Apple', 'Banana', 'Orange', 'Mango', 'Grape'];

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedFruit,
      items: fruits.map((String fruit) {
        return DropdownMenuItem<String>(
          value: fruit,
          child: Text(fruit),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedFruit = newValue!;
        });
      },
    );
  }
}
```

### DropdownButtonFormField (with validation)

```dart
class DropdownFormFieldExample extends StatefulWidget {
  @override
  State<DropdownFormFieldExample> createState() => _DropdownFormFieldExampleState();
}

class _DropdownFormFieldExampleState extends State<DropdownFormFieldExample> {
  String? selectedCountry;

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCountry,
      decoration: InputDecoration(
        labelText: 'Country',
        border: OutlineInputBorder(),
      ),
      items: countries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCountry = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }
}
```

---

## Complete Example: Registration Form

```dart
import 'package:flutter/material.dart';

void main() => runApp(RegistrationFormApp());

class RegistrationFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistrationFormPage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class RegistrationFormPage extends StatefulWidget {
  @override
  State<RegistrationFormPage> createState() => _RegistrationFormPageState();
}

class _RegistrationFormPageState extends State<RegistrationFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();

  // Values
  String? selectedCountry;
  String selectedGender = 'male';
  bool acceptTerms = false;
  bool subscribeNewsletter = false;
  double experienceYears = 0;

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please accept terms and conditions')),
        );
        return;
      }

      // Form is valid
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Country: $selectedCountry');
      print('Gender: $selectedGender');
      print('Experience: ${experienceYears.round()} years');
      print('Subscribe: $subscribeNewsletter');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
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

              SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Country dropdown
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.public),
                  border: OutlineInputBorder(),
                ),
                items: countries.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a country';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Gender radio buttons
              Text('Gender', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Male'),
                      value: 'male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Female'),
                      value: 'female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Experience slider
              Text('Years of Experience: ${experienceYears.round()}'),
              Slider(
                value: experienceYears,
                min: 0,
                max: 20,
                divisions: 20,
                label: experienceYears.round().toString(),
                onChanged: (value) {
                  setState(() {
                    experienceYears = value;
                  });
                },
              ),

              SizedBox(height: 16),

              // Checkboxes
              CheckboxListTile(
                title: Text('I accept the Terms and Conditions'),
                value: acceptTerms,
                onChanged: (value) {
                  setState(() {
                    acceptTerms = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                title: Text('Subscribe to newsletter'),
                value: subscribeNewsletter,
                onChanged: (value) {
                  setState(() {
                    subscribeNewsletter = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Register', style: TextStyle(fontSize: 18)),
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

## Best Practices

### 1. Always Use Controllers with Cleanup

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // IMPORTANT!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

### 2. Use Form for Multiple Fields

```dart
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(...),
      TextFormField(...),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // All fields valid
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

### 3. Provide Clear Error Messages

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Email is required'; // Clear message
  }
  if (!value.contains('@')) {
    return 'Please enter a valid email address'; // Specific
  }
  return null;
}
```

### 4. Use Appropriate Keyboard Types

```dart
// Email
TextField(keyboardType: TextInputType.emailAddress)

// Phone
TextField(keyboardType: TextInputType.phone)

// Number
TextField(keyboardType: TextInputType.number)

// URL
TextField(keyboardType: TextInputType.url)
```

### 5. Show Loading State During Submission

```dart
bool isLoading = false;

ElevatedButton(
  onPressed: isLoading ? null : () async {
    setState(() => isLoading = true);
    // Submit form
    await submitForm();
    setState(() => isLoading = false);
  },
  child: isLoading
    ? CircularProgressIndicator()
    : Text('Submit'),
)
```

---

## Summary

You now know:
- **TextField** for basic text input
- **TextFormField** for validated forms
- **Checkbox** for multiple selections
- **Switch** for on/off toggles
- **Radio** for single selection from options
- **Slider** for numeric ranges
- **DropdownButton** for selecting from lists
- How to validate forms properly
- Best practices for forms

**Key Takeaways:**
- Use **TextFormField** with **Form** for validation
- Always dispose of controllers
- Provide clear error messages
- Use appropriate keyboard types
- Show loading states during submission

---

**Next:** Learn about List Widgets

**Continue to:** `06c-ListWidgets.md`
