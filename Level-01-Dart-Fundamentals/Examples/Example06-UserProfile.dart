// ===========================================
// Example 06: User Profile
// Combining everything you learned
// ===========================================

void main() {
  // -----------------------------------------
  // User Information (using all data types)
  // -----------------------------------------

  // String - text data
  String firstName = 'Alex';
  String lastName = 'Johnson';
  String email = 'alex.johnson@email.com';
  String bio = 'Flutter developer who loves clean code.';

  // int - whole numbers
  int age = 28;
  int followers = 1250;
  int following = 340;
  int posts = 47;

  // double - decimal numbers
  double rating = 4.8;
  double accountBalance = 2549.99;

  // bool - true/false
  bool isVerified = true;
  bool isPremium = false;
  bool isOnline = true;

  // -----------------------------------------
  // Display Profile
  // -----------------------------------------

  print('╔════════════════════════════════════════╗');
  print('║           USER PROFILE                 ║');
  print('╚════════════════════════════════════════╝');

  // Full name (combining strings)
  String fullName = '$firstName $lastName';
  print('\nName: $fullName ${isVerified ? '✓' : ''}');

  print('Email: $email');
  print('Age: $age years old');
  print('Bio: $bio');

  // -----------------------------------------
  // Stats Section
  // -----------------------------------------

  print('\n--- Stats ---');
  print('Posts: $posts');
  print('Followers: $followers');
  print('Following: $following');
  print('Rating: $rating/5.0');

  // -----------------------------------------
  // Account Info
  // -----------------------------------------

  print('\n--- Account ---');
  print('Balance: \$${accountBalance.toStringAsFixed(2)}');
  print('Premium Member: ${isPremium ? 'Yes' : 'No'}');
  print('Status: ${isOnline ? 'Online 🟢' : 'Offline ⚫'}');

  // -----------------------------------------
  // Calculations
  // -----------------------------------------

  print('\n--- Calculations ---');

  // Engagement rate
  double engagementRate = (followers / (followers + following)) * 100;
  print('Engagement: ${engagementRate.toStringAsFixed(1)}%');

  // Days until birthday (pretend calculation)
  int daysUntilBirthday = 45;
  print('Days until birthday: $daysUntilBirthday');

  // Account age in days
  int accountAgeDays = 365 * 2 + 47;  // 2 years and 47 days
  print('Account age: $accountAgeDays days');

  // -----------------------------------------
  // Conditional Messages
  // -----------------------------------------

  print('\n--- Status Messages ---');

  // Using ternary operator
  String memberStatus = isPremium ? 'Premium Member' : 'Free Account';
  print(memberStatus);

  String verificationStatus = isVerified
      ? 'Account Verified ✓'
      : 'Account Not Verified';
  print(verificationStatus);

  // Age-based message
  String ageGroup = age >= 18 ? 'Adult' : 'Minor';
  print('Age Group: $ageGroup');

  // Balance warning
  if (accountBalance < 100) {
    print('⚠️ Low balance warning!');
  } else {
    print('✓ Balance is healthy');
  }

  // -----------------------------------------
  // String Manipulation
  // -----------------------------------------

  print('\n--- String Operations ---');

  // Initials
  String initials = '${firstName[0]}${lastName[0]}';
  print('Initials: $initials');

  // Username suggestion
  String username = '${firstName.toLowerCase()}_${lastName.toLowerCase()}';
  print('Suggested username: $username');

  // Email domain
  int atIndex = email.indexOf('@');
  String domain = email.substring(atIndex + 1);
  print('Email domain: $domain');

  // -----------------------------------------
  // Final Summary
  // -----------------------------------------

  print('\n╔════════════════════════════════════════╗');
  print('║              SUMMARY                   ║');
  print('╚════════════════════════════════════════╝');

  print('''
$fullName (@$username)
$posts posts • $followers followers • $following following
Rating: ${'★' * rating.round()}${'☆' * (5 - rating.round())} ($rating)
Status: $memberStatus | ${isOnline ? 'Online' : 'Offline'}
''');
}

// ===========================================
// Try it yourself:
// 1. Change the user data to your own info
// 2. Add more calculations (like posts per month)
// 3. Add a password field (but don't print it!)
// 4. Create a formatted "about" section
// ===========================================
