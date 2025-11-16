# Week 1 Project: Personal Portfolio Generator

## Project Overview

You've learned the fundamentals! Now it's time to build something meaningful that combines everything:
- `main()` function
- `print()` statements
- Variables (String, int, double, bool)
- String interpolation
- Comments

**Goal:** Create a program that generates a personal portfolio/bio card with your information.

---

## Project Requirements

### Must Have:
1. Personal information (name, age, location)
2. Professional information (job title, years of experience)
3. Skills or interests (at least 3)
4. Contact information (email, website)
5. A fun fact or quote
6. Proper formatting with visual separators
7. Good comments explaining each section

### Bonus Challenges:
- Calculate something (age in months, years until retirement, etc.)
- Use special characters to make a border
- Include statistics (projects completed, etc.)
- Make it visually appealing

---

## Example Output

```
╔═══════════════════════════════════════════╗
║        DEVELOPER PORTFOLIO                ║
╚═══════════════════════════════════════════╝

👤 PERSONAL INFO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name:          Alex Rivera
Age:           27 years old
Location:      San Francisco, CA
Language:      English, Spanish

💼 PROFESSIONAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Title:         Mobile App Developer
Experience:    3.5 years
Current Focus: Learning Flutter
Projects:      12 completed

🛠️  SKILLS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Dart Programming
• UI/UX Design
• Problem Solving
• Coffee Making ☕

📊 STATISTICS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Age in months:     324
Age in days:       9855
Experience (days): 1277

📫 CONTACT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Email:    alex.rivera@email.com
Website:  www.alexrivera.dev
GitHub:   github.com/arivera

💭 FUN FACT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"I debug with print statements and I'm not ashamed!"

╔═══════════════════════════════════════════╗
║  Thank you for viewing my portfolio! 🚀   ║
╚═══════════════════════════════════════════╝
```

---

## Starter Template

Use this as a starting point:

```dart
void main() {
  // ═══════════════════════════════════════
  // PERSONAL INFORMATION
  // ═══════════════════════════════════════
  String firstName = 'Your';
  String lastName = 'Name';
  int age = 25;
  String city = 'Your City';
  String country = 'Your Country';

  // ═══════════════════════════════════════
  // PROFESSIONAL INFORMATION
  // ═══════════════════════════════════════
  String jobTitle = 'Your Job or "Aspiring Developer"';
  double yearsExperience = 0.0;
  bool isLearningFlutter = true;
  int projectsCompleted = 0;

  // ═══════════════════════════════════════
  // SKILLS & INTERESTS
  // ═══════════════════════════════════════
  String skill1 = 'First skill';
  String skill2 = 'Second skill';
  String skill3 = 'Third skill';
  String skill4 = 'Fourth skill';

  // ═══════════════════════════════════════
  // CONTACT INFORMATION
  // ═══════════════════════════════════════
  String email = 'your.email@example.com';
  String website = 'yourwebsite.com';
  String github = 'github.com/yourusername';

  // ═══════════════════════════════════════
  // FUN FACTS & CALCULATIONS
  // ═══════════════════════════════════════
  String funFact = 'Your fun fact or favorite quote';

  // Calculate age in months and days
  int ageInMonths = age * 12;
  int ageInDays = age * 365;

  // ═══════════════════════════════════════
  // DISPLAY PORTFOLIO
  // ═══════════════════════════════════════

  // TODO: Print your beautiful portfolio here!
  // Use the example above as inspiration
  // Make it your own!

  print('╔═══════════════════════════════════════════╗');
  print('║        DEVELOPER PORTFOLIO                ║');
  print('╚═══════════════════════════════════════════╝');
  print('');

  // Add the rest of your portfolio...
}
```

---

## Step-by-Step Guide

### Step 1: Fill in Your Information

Replace all the placeholder values with your real (or fictional) information:
- Your actual name, age, location
- Your skills (can include "learning," "curious about," etc.)
- Your interests

**Tip:** If you don't have some values (like years of experience), use 0 or make something up for practice!

### Step 2: Add Calculations

Make your portfolio interesting with calculated values:

```dart
// Examples of calculations you can add:
int ageInMonths = age * 12;
int ageInDays = age * 365;  // Approximate
int experienceDays = (yearsExperience * 365).round();
int daysUntilBirthday = 90;  // You can make this up for now
```

### Step 3: Create the Display

Use `print()` statements to display everything beautifully:

```dart
print('👤 PERSONAL INFO');
print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
print('Name:     $firstName $lastName');
print('Age:      $age years old');
print('Location: $city, $country');
print('');
```

### Step 4: Add Visual Flair

Use special characters to make it pretty:
- Boxes: `╔ ╗ ╚ ╝ ═ ║`
- Lines: `─ ━ ═ ┼ ├ ┤`
- Bullets: `• ◦ ▪ ▸`
- Emojis: `👤 💼 🛠️ 📫 💭 🚀`

**How to type these:**
- Copy-paste from examples
- Or use your OS character map
- Or just use regular characters like `===` and `---`

### Step 5: Test and Refine

1. Run your program
2. Check the output
3. Adjust spacing and alignment
4. Make it look professional

---

## Challenges

### Challenge 1: Beginner
Create a basic portfolio with:
- Name, age, location
- At least 2 skills
- Contact email
- One fun fact

### Challenge 2: Intermediate
Add to the basic version:
- Calculate age in months and days
- Add years of experience
- Include 4+ skills
- Add visual borders

### Challenge 3: Advanced
Create a stunning portfolio with:
- All calculations (age in days, months, weeks)
- Beautiful formatting with special characters
- Multiple sections (personal, professional, skills, contact)
- Statistics section
- Perfectly aligned text
- Color-coded emojis for each section

---

## Sample Solution

<details>
<summary>Click to reveal a complete solution</summary>

```dart
void main() {
  // ═══════════════════════════════════════
  // PERSONAL INFORMATION
  // ═══════════════════════════════════════
  String firstName = 'Jordan';
  String lastName = 'Smith';
  int age = 26;
  String city = 'Portland';
  String country = 'USA';
  String nativeLanguage = 'English';

  // ═══════════════════════════════════════
  // PROFESSIONAL INFORMATION
  // ═══════════════════════════════════════
  String jobTitle = 'Aspiring Flutter Developer';
  double yearsExperience = 0.5;
  bool isLearningFlutter = true;
  int projectsCompleted = 3;

  // ═══════════════════════════════════════
  // SKILLS & INTERESTS
  // ═══════════════════════════════════════
  String skill1 = 'Dart Programming';
  String skill2 = 'Problem Solving';
  String skill3 = 'UI/UX Design';
  String skill4 = 'Quick Learner';

  // ═══════════════════════════════════════
  // CONTACT INFORMATION
  // ═══════════════════════════════════════
  String email = 'jordan.smith@email.com';
  String website = 'jordansmith.dev';
  String github = 'github.com/jordansmith';

  // ═══════════════════════════════════════
  // FUN FACT & QUOTE
  // ═══════════════════════════════════════
  String funFact = 'I learned to code by building a calculator app!';
  String favoriteQuote = '"Code is poetry written in logic."';

  // ═══════════════════════════════════════
  // CALCULATIONS
  // ═══════════════════════════════════════
  int ageInMonths = age * 12;
  int ageInDays = age * 365;
  int experienceInDays = (yearsExperience * 365).round();

  // ═══════════════════════════════════════
  // DISPLAY PORTFOLIO
  // ═══════════════════════════════════════

  print('');
  print('╔═══════════════════════════════════════════╗');
  print('║        DEVELOPER PORTFOLIO                ║');
  print('╚═══════════════════════════════════════════╝');
  print('');

  // Personal Information Section
  print('👤 PERSONAL INFO');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Name:          $firstName $lastName');
  print('Age:           $age years old');
  print('Location:      $city, $country');
  print('Language:      $nativeLanguage');
  print('');

  // Professional Section
  print('💼 PROFESSIONAL');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Title:         $jobTitle');
  print('Experience:    $yearsExperience years');
  print('Learning:      Flutter & Dart');
  print('Projects:      $projectsCompleted completed');
  print('Active:        ${isLearningFlutter ? "Yes! 🔥" : "No"}');
  print('');

  // Skills Section
  print('🛠️  SKILLS');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('• $skill1');
  print('• $skill2');
  print('• $skill3');
  print('• $skill4');
  print('');

  // Statistics Section
  print('📊 STATISTICS');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Age in months:     $ageInMonths');
  print('Age in days:       $ageInDays');
  print('Experience (days): $experienceInDays');
  print('');

  // Contact Section
  print('📫 CONTACT');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Email:    $email');
  print('Website:  $website');
  print('GitHub:   $github');
  print('');

  // Fun Facts Section
  print('💭 ABOUT ME');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('Fun Fact: $funFact');
  print('Quote:    $favoriteQuote');
  print('');

  print('╔═══════════════════════════════════════════╗');
  print('║  Thank you for viewing my portfolio! 🚀   ║');
  print('╚═══════════════════════════════════════════╝');
  print('');
}
```

</details>

---

## Reflection Questions

After completing the project, think about these:

1. **What was the hardest part?** (Variables? Formatting? String interpolation?)
2. **What would you add if you could?** (More sections? More calculations?)
3. **How does this relate to real apps?** (Hint: Apps display user profiles similarly!)
4. **What did you learn about organizing code?** (Comments? Variable grouping?)

---

## Next Steps

Congratulations! You've completed Week 1 and built your first real program!

**You now know:**
- How to structure a Dart program
- How to create and use variables
- How to display information with formatting
- How to calculate values
- How to organize code with comments

**Next week** we'll learn:
- String manipulation (splitting, combining, searching)
- Advanced math operations
- Comparison and logical operations

**Save your portfolio program!** You'll improve it as you learn more.

---

## Share Your Work

Take a screenshot of your portfolio output and be proud! This is the first of many projects you'll build on your Flutter journey.

**Remember:** Every expert was once a beginner who refused to give up. You're on your way! 🚀
