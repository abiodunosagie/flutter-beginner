// Exercise 3: String Utilities (SOLUTION)

String reverseString(String text) {
  return text.split('').reversed.join('');
}

bool isPalindrome(String text) {
  String cleaned = text.toLowerCase().replaceAll(' ', '');
  return cleaned == reverseString(cleaned);
}

int countVowels(String text) {
  int count = 0;
  String vowels = 'aeiouAEIOU';

  for (int i = 0; i < text.length; i++) {
    if (vowels.contains(text[i])) {
      count++;
    }
  }

  return count;
}

String capitalizeWords(String text) {
  List<String> words = text.split(' ');
  List<String> capitalized = [];

  for (String word in words) {
    if (word.isNotEmpty) {
      capitalized.add(word[0].toUpperCase() + word.substring(1).toLowerCase());
    }
  }

  return capitalized.join(' ');
}

void main() {
  // Test all functions
  print('=== Reverse String ===');
  print('Reverse "Hello": ${reverseString('Hello')}');
  print('Reverse "Dart": ${reverseString('Dart')}');

  print('\n=== Palindrome Check ===');
  print('Is "racecar" palindrome? ${isPalindrome('racecar')}');
  print('Is "A man a plan a canal Panama" palindrome? ${isPalindrome('A man a plan a canal Panama')}');
  print('Is "hello" palindrome? ${isPalindrome('hello')}');

  print('\n=== Count Vowels ===');
  print('Vowels in "education": ${countVowels('education')}');
  print('Vowels in "programming": ${countVowels('programming')}');

  print('\n=== Capitalize Words ===');
  print('Capitalize "hello world": ${capitalizeWords('hello world')}');
  print('Capitalize "the quick brown fox": ${capitalizeWords('the quick brown fox')}');
}
