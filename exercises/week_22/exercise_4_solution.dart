/// Exercise 4 Solution: Test String Utilities
///
/// This solution demonstrates:
/// - String manipulation techniques in Dart
/// - Regular expressions for pattern matching
/// - Handling edge cases (empty, null-like, special chars)
/// - Efficient algorithms for string operations

class StringUtils {
  bool isPalindrome(String text) {
    if (text.isEmpty) return true;

    // Remove non-alphanumeric characters and convert to lowercase
    final cleaned = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();

    if (cleaned.isEmpty) return true;

    // Compare with reversed version
    final reversed = cleaned.split('').reversed.join('');
    return cleaned == reversed;
  }

  String reverse(String text) {
    return text.split('').reversed.join('');
  }

  int countVowels(String text) {
    if (text.isEmpty) return 0;

    final vowels = RegExp(r'[aeiouAEIOU]');
    return vowels.allMatches(text).length;
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;

    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String truncate(String text, int maxLength) {
    if (maxLength < 0) {
      throw ArgumentError('maxLength cannot be negative');
    }

    if (text.length <= maxLength) {
      return text;
    }

    if (maxLength < 3) {
      return text.substring(0, maxLength);
    }

    return '${text.substring(0, maxLength - 3)}...';
  }

  // Bonus methods for testing

  /// Counts words in text (splits by whitespace)
  int countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  /// Removes all whitespace from text
  String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Checks if string contains only alphabetic characters
  bool isAlpha(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }

  /// Checks if string contains only numeric characters
  bool isNumeric(String text) {
    if (text.isEmpty) return false;
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  /// Converts string to title case
  String toTitleCase(String text) {
    if (text.isEmpty) return text;

    final words = text.toLowerCase().split(' ');
    return words.map((word) {
      if (word.isEmpty) return word;

      // Don't capitalize small words unless first word
      final smallWords = ['a', 'an', 'the', 'and', 'but', 'or', 'for', 'nor', 'on', 'at', 'to', 'from', 'by'];
      final index = words.indexOf(word);

      if (index > 0 && smallWords.contains(word)) {
        return word;
      }

      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}

// Example usage:
void main() {
  final utils = StringUtils();

  print('=== Palindrome Tests ===');
  print('Is "racecar" a palindrome? ${utils.isPalindrome('racecar')}'); // true
  print('Is "hello" a palindrome? ${utils.isPalindrome('hello')}'); // false
  print('Is "A man a plan a canal Panama" a palindrome? ${utils.isPalindrome('A man a plan a canal Panama')}'); // true

  print('\n=== Reverse Tests ===');
  print('Reverse of "Flutter": ${utils.reverse('Flutter')}'); // rettulF
  print('Reverse of "Dart": ${utils.reverse('Dart')}'); // traD

  print('\n=== Count Vowels Tests ===');
  print('Vowels in "Hello World": ${utils.countVowels('Hello World')}'); // 3
  print('Vowels in "AEIOU": ${utils.countVowels('AEIOU')}'); // 5
  print('Vowels in "Rhythm": ${utils.countVowels('Rhythm')}'); // 0

  print('\n=== Capitalize Tests ===');
  print('Capitalize "hello world": ${utils.capitalize('hello world')}'); // Hello World
  print('Capitalize "the QUICK brown FOX": ${utils.capitalize('the QUICK brown FOX')}'); // The Quick Brown Fox

  print('\n=== Truncate Tests ===');
  print('Truncate "Hello World" to 8: ${utils.truncate('Hello World', 8)}'); // Hello...
  print('Truncate "Hi" to 10: ${utils.truncate('Hi', 10)}'); // Hi
  print('Truncate "Test" to 2: ${utils.truncate('Test', 2)}'); // Te

  print('\n=== Bonus Methods ===');
  print('Word count in "Hello World": ${utils.countWords('Hello World')}'); // 2
  print('Is "Hello" alpha? ${utils.isAlpha('Hello')}'); // true
  print('Is "Hello123" alpha? ${utils.isAlpha('Hello123')}'); // false
  print('Is "12345" numeric? ${utils.isNumeric('12345')}'); // true
  print('Title case "the lord of the rings": ${utils.toTitleCase('the lord of the rings')}'); // The Lord of the Rings
}
