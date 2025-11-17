/// Exercise 4: Test String Utilities
///
/// Level: Intermediate-Advanced
///
/// Task:
/// Create a StringUtils class with various string manipulation methods,
/// then write comprehensive tests for each method.
///
/// Requirements:
/// 1. Create StringUtils class with methods:
///    - bool isPalindrome(String text) // Checks if text reads same forwards/backwards
///    - String reverse(String text) // Reverses the string
///    - int countVowels(String text) // Counts a, e, i, o, u (case-insensitive)
///    - String capitalize(String text) // Capitalizes first letter of each word
///    - String truncate(String text, int maxLength) // Truncates with "..."
///
/// 2. Write tests covering:
///    - Normal cases for each method
///    - Empty strings
///    - Single character strings
///    - Strings with special characters
///    - Case sensitivity handling
///    - Unicode characters
///    - Very long strings (10,000+ chars)
///
/// Palindrome examples: "racecar", "A man a plan a canal Panama" (ignore spaces/case)

class StringUtils {
  // TODO: Implement isPalindrome
  // Should ignore spaces, punctuation, and case
  bool isPalindrome(String text) {
    throw UnimplementedError();
  }

  // TODO: Implement reverse
  String reverse(String text) {
    throw UnimplementedError();
  }

  // TODO: Implement countVowels
  // Count a, e, i, o, u (both uppercase and lowercase)
  int countVowels(String text) {
    throw UnimplementedError();
  }

  // TODO: Implement capitalize
  // "hello world" -> "Hello World"
  String capitalize(String text) {
    throw UnimplementedError();
  }

  // TODO: Implement truncate
  // If text is longer than maxLength, truncate and add "..."
  // "Hello World" with maxLength=8 -> "Hello..."
  String truncate(String text, int maxLength) {
    throw UnimplementedError();
  }
}

// Example usage:
void main() {
  final utils = StringUtils();

  print('Is "racecar" a palindrome? ${utils.isPalindrome('racecar')}');
  print('Reverse of "Flutter": ${utils.reverse('Flutter')}');
  print('Vowels in "Hello World": ${utils.countVowels('Hello World')}');
  print('Capitalize "hello world": ${utils.capitalize('hello world')}');
  print('Truncate "Hello World" to 8: ${utils.truncate('Hello World', 8)}');
}
