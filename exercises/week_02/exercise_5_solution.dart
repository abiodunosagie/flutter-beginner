// Exercise 5: Password Validator (SOLUTION)

class PasswordValidationResult {
  final bool isValid;
  final List<String> errors;

  PasswordValidationResult(this.isValid, this.errors);
}

PasswordValidationResult validatePassword(String password) {
  List<String> errors = [];

  // Check minimum 8 characters
  if (password.length < 8) {
    errors.add('Password must be at least 8 characters long');
  }

  // Check for at least one uppercase letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    errors.add('Password must contain at least one uppercase letter');
  }

  // Check for at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    errors.add('Password must contain at least one lowercase letter');
  }

  // Check for at least one number
  if (!password.contains(RegExp(r'[0-9]'))) {
    errors.add('Password must contain at least one number');
  }

  // Check for at least one special character
  if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    errors.add('Password must contain at least one special character (!@#$%^&*...)');
  }

  bool isValid = errors.isEmpty;
  return PasswordValidationResult(isValid, errors);
}

void main() {
  print('=== Password Validator ===\n');

  // Test passwords
  List<String> testPasswords = [
    'weak',
    'StrongPass1!',
    'NoNumber!',
    'nonumberorspecial',
    'ALLUPPERCASE123!',
    'alllowercase123!',
    'NoSpecial123',
    'Perfect1!',
  ];

  for (String password in testPasswords) {
    var result = validatePassword(password);
    print('Password: "$password"');
    print('Valid: ${result.isValid ? "✓" : "✗"}');

    if (!result.isValid) {
      print('Errors:');
      for (String error in result.errors) {
        print('  - $error');
      }
    } else {
      print('  ✓ Password meets all requirements!');
    }
    print('');
  }
}
