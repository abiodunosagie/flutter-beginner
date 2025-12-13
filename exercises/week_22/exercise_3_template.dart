/// Exercise 3: Test a Password Validator
///
/// Level: Intermediate
///
/// Task:
/// Create a PasswordValidator class that validates password strength
/// according to security rules, then write comprehensive tests.
///
/// Requirements:
/// 1. Create PasswordValidator class with method:
///    - bool isStrong(String password)
///    - String? validate(String password) // Returns error message or null
///
/// 2. Password rules:
///    - At least 8 characters long
///    - Contains at least one uppercase letter
///    - Contains at least one lowercase letter
///    - Contains at least one number
///    - Contains at least one special character (!@#$%^&*(),.?":{}|<>)
///
/// 3. Write tests covering:
///    - Valid strong passwords
///    - Passwords missing each requirement
///    - Empty password
///    - Very long passwords (100+ chars)
///    - Passwords with only spaces
///    - Common weak passwords
///    - Edge cases with special characters

class PasswordValidator {
  // TODO: Implement isStrong method
  bool isStrong(String password) {
    throw UnimplementedError();
  }

  // TODO: Implement validate method that returns detailed error message
  String? validate(String password) {
    throw UnimplementedError();
  }

  // TODO: Helper methods (optional)
  // bool _hasMinLength(String password) { }
  // bool _hasUppercase(String password) { }
  // bool _hasLowercase(String password) { }
  // bool _hasNumber(String password) { }
  // bool _hasSpecialChar(String password) { }
}

// Example usage:
void main() {
  final validator = PasswordValidator();

  final passwords = [
    'weak',
    'NoNumbers!',
    'no-uppercase-1',
    'NO-LOWERCASE-1!',
    'NoSpecialChar123',
    'Strong1Pass!',
  ];

  for (final password in passwords) {
    final isStrong = validator.isStrong(password);
    final error = validator.validate(password);
    print('Password: $password');
    print('  Strong: $isStrong');
    print('  Error: ${error ?? "None"}');
    print('');
  }
}
