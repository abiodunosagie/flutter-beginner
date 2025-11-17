// Exercise 5: Password Validator (Advanced)
// TODO: Create a password validation function

class PasswordValidationResult {
  final bool isValid;
  final List<String> errors;

  PasswordValidationResult(this.isValid, this.errors);
}

// TODO: Validate password with all requirements
PasswordValidationResult validatePassword(String password) {
  List<String> errors = [];

  // TODO: Check minimum 8 characters

  // TODO: Check for at least one uppercase letter

  // TODO: Check for at least one lowercase letter

  // TODO: Check for at least one number

  // TODO: Check for at least one special character (!@#$%^&*)

  bool isValid = errors.isEmpty;
  return PasswordValidationResult(isValid, errors);
}

void main() {
  // Test passwords
  List<String> testPasswords = [
    'weak',
    'StrongPass1!',
    'NoNumber!',
    'nonumberorspecial',
    'ALLUPPERCASE123!',
  ];

  for (String password in testPasswords) {
    var result = validatePassword(password);
    print('\nPassword: "$password"');
    print('Valid: ${result.isValid}');
    if (!result.isValid) {
      print('Errors:');
      for (String error in result.errors) {
        print('  - $error');
      }
    }
  }
}
