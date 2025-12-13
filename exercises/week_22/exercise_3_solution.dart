/// Exercise 3 Solution: Test a Password Validator
///
/// This solution demonstrates:
/// - Using regular expressions for pattern matching
/// - Providing detailed validation feedback
/// - Handling edge cases (empty, whitespace, very long)
/// - Clear separation of concerns with helper methods

class PasswordValidator {
  static const int minLength = 8;
  static const String specialChars = r'!@#$%^&*(),.?":{}|<>';

  bool isStrong(String password) {
    return validate(password) == null;
  }

  String? validate(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    }

    if (password.trim().isEmpty) {
      return 'Password cannot contain only whitespace';
    }

    if (!_hasMinLength(password)) {
      return 'Password must be at least $minLength characters long';
    }

    if (!_hasUppercase(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!_hasLowercase(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!_hasNumber(password)) {
      return 'Password must contain at least one number';
    }

    if (!_hasSpecialChar(password)) {
      return 'Password must contain at least one special character ($specialChars)';
    }

    return null; // Password is strong
  }

  bool _hasMinLength(String password) {
    return password.length >= minLength;
  }

  bool _hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  bool _hasLowercase(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasNumber(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  bool _hasSpecialChar(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  // Additional method: Get strength score (0-5)
  int getStrengthScore(String password) {
    int score = 0;

    if (_hasMinLength(password)) score++;
    if (_hasUppercase(password)) score++;
    if (_hasLowercase(password)) score++;
    if (_hasNumber(password)) score++;
    if (_hasSpecialChar(password)) score++;

    return score;
  }

  // Additional method: Get strength description
  String getStrengthDescription(String password) {
    final score = getStrengthScore(password);

    switch (score) {
      case 0:
      case 1:
        return 'Very Weak';
      case 2:
        return 'Weak';
      case 3:
        return 'Medium';
      case 4:
        return 'Strong';
      case 5:
        return 'Very Strong';
      default:
        return 'Unknown';
    }
  }
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
    'Short1!',
    'Strong1Pass!',
    'VeryStr0ng&Secure!',
    '   spaces   ',
    '',
  ];

  for (final password in passwords) {
    final isStrong = validator.isStrong(password);
    final error = validator.validate(password);
    final score = validator.getStrengthScore(password);
    final description = validator.getStrengthDescription(password);

    print('Password: "$password"');
    print('  Strong: $isStrong');
    print('  Score: $score/5 ($description)');
    print('  Error: ${error ?? "None"}');
    print('');
  }
}
