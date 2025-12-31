# Level 9: Advanced Features - Learning Path

Welcome to Level 9! This level teaches you essential advanced features like local storage, databases, forms, theming, and async state handling.

---

## How to Use These Theory Files

Read these theory files **in order**, one at a time. Each teaches a distinct advanced feature.

After each theory file, practice with the matching PART exercises!

---

## Your Learning Path

### Step 1: Local Storage
📖 **[01-LocalStorage.md](01-LocalStorage.md)**
- Understanding local storage
- File system basics
- path_provider package
- Reading and writing files
- When to use file storage

**Time:** 25 minutes
**Then Practice:** PART 1 exercises (Local Storage)

---

### Step 2: SharedPreferences
📖 **[02-SharedPreferences.md](02-SharedPreferences.md)**
- What is SharedPreferences?
- Storing simple data (strings, ints, bools)
- Reading and writing values
- When to use SharedPreferences vs files
- Best practices

**Time:** 25 minutes
**Then Practice:** PART 2 exercises (SharedPreferences)

---

### Step 3: SQLite Database
📖 **[03-SQLiteDatabase.md](03-SQLiteDatabase.md)**
- What is SQLite?
- Creating databases and tables
- CRUD operations
- sqflite package
- Database migrations

**Time:** 40 minutes
**Then Practice:** PART 3 exercises (SQLite)

---

### Step 4: Forms and Validation
📖 **[04-FormsAndValidation.md](04-FormsAndValidation.md)**
- Form widget and GlobalKey
- TextFormField validation
- Custom validators
- Form submission
- Error handling

**Time:** 30 minutes
**Then Practice:** PART 4 exercises (Forms & Validation)

---

### Step 5: Theming and Styling
📖 **[05-ThemingAndStyling.md](05-ThemingAndStyling.md)**
- ThemeData
- Light and dark themes
- Custom colors and fonts
- Theme switching
- Material 3

**Time:** 30 minutes
**Then Practice:** PART 5 exercises (Theming)

---

### Step 6: Futures Deep Dive
📖 **[06-FuturesDeepDive.md](06-FuturesDeepDive.md)**
- Understanding Futures
- async and await
- Future methods (then, catchError, whenComplete)
- Chaining Futures
- Error handling

**Time:** 30 minutes
**Then Practice:** PART 6 exercises (Futures)

---

### Step 7: Streams Explained
📖 **[07-StreamsExplained.md](07-StreamsExplained.md)**
- What are Streams?
- Stream vs Future
- StreamBuilder
- Stream controllers
- Listening to streams

**Time:** 35 minutes
**Then Practice:** PART 7 exercises (Streams)

---

### Step 8: Responsive Design
📖 **[08-ResponsiveDesign.md](08-ResponsiveDesign.md)**
- MediaQuery
- LayoutBuilder
- Responsive layouts
- Screen size breakpoints
- Orientation handling

**Time:** 30 minutes
**Then Practice:** PART 8 exercises (Responsive Design)

---

### PART 9: Accessibility (NEW!)

#### Step 9a: Accessibility Basics
📖 **[09a-AccessibilityBasics.md](09a-AccessibilityBasics.md)**
- What is accessibility (a11y)?
- Semantics widget
- Screen reader support
- Accessible buttons, images, text fields
- ExcludeSemantics and MergeSemantics
- Complete login form example

**Time:** 15 minutes
**Then Practice:** PART 9 exercises 1-5

---

#### Step 9b: Accessibility Testing
📖 **[09b-AccessibilityTesting.md](09b-AccessibilityTesting.md)**
- Testing with TalkBack (Android)
- Testing with VoiceOver (iOS)
- WCAG 2.1 guidelines (POUR principles)
- Contrast ratios
- Touch target sizes
- Automated accessibility testing

**Time:** 18 minutes
**Then Practice:** PART 9 exercises 6-10

---

#### Step 9c: Accessibility Patterns
📖 **[09c-AccessibilityPatterns.md](09c-AccessibilityPatterns.md)**
- Common accessibility patterns
- Accessible cards and lists
- Accessible dialogs and bottom sheets
- Accessible forms and navigation
- Complete shopping app example
- Best practices checklist

**Time:** 20 minutes
**Then Practice:** PART 9 exercises 11-16

---

### PART 10: Internationalization (NEW!)

#### Step 10a: i18n Basics
📖 **[10a-i18nBasics.md](10a-i18nBasics.md)**
- What is i18n and l10n?
- flutter_localizations package
- intl package
- ARB files (App Resource Bundle)
- Basic setup and configuration
- Complete example app

**Time:** 15 minutes
**Then Practice:** PART 10 exercises 1-5

---

#### Step 10b: Multi-Language Support
📖 **[10b-MultiLanguage.md](10b-MultiLanguage.md)**
- Creating translations in ARB files
- Language switching
- Accessing translations in code
- Language detection
- Persisting language preference
- Complete shopping app example

**Time:** 20 minutes
**Then Practice:** PART 10 exercises 6-12

---

#### Step 10c: Localization Advanced
📖 **[10c-LocalizationAdvanced.md](10c-LocalizationAdvanced.md)**
- RTL (Right-to-Left) support
- Date and time formatting
- Number formatting
- Currency formatting
- Plurals and gender
- Complete multi-language app

**Time:** 22 minutes
**Then Practice:** PART 10 exercises 13-20

---

## Total Time for Level 9 Theory

**Estimated:** 8 - 9 hours (including practice)

These features make your app production-ready! This level covers storage, async programming, responsive design, **accessibility**, and **internationalization**.

---

## Learning Strategy

1. **Read one theory file**
2. **Implement the feature**
3. **Test thoroughly (including accessibility!)**
4. **Move to next feature**

Each feature is independent but powerful!

---

## After Completing Level 9

Once you've finished all theory and exercises:

1. **Review the concepts:**
   - Can you persist data locally?
   - Do you understand SQLite databases?
   - Can you validate forms properly?
   - Can you implement theming?
   - **Can you make your app accessible to everyone?**
   - **Can you support multiple languages?**

2. **Complete the Final Project:**
   - Build an app using all advanced features
   - **Must be accessible and support 2+ languages**

3. **Self-Assessment Checklist:**
   - ✅ Understand local storage options
   - ✅ Can work with SQLite databases
   - ✅ Can validate forms properly
   - ✅ Can implement light/dark themes
   - ✅ Understand async programming (Futures & Streams)
   - ✅ Can build responsive layouts
   - ✅ **Can make apps accessible with Semantics**
   - ✅ **Can support multiple languages with i18n**

---

## Learning Tips

✅ **DO:**
- Choose the right storage method for your data
- Validate all user input
- Handle database migrations
- Provide light and dark themes
- Show proper loading/error states
- **Use Semantics for screen reader support**
- **Test with TalkBack and VoiceOver**
- **Support at least 2 languages in production apps**
- **Handle RTL languages properly**

❌ **DON'T:**
- Use SharedPreferences for large data
- Forget to close database connections
- Skip form validation
- Hardcode colors (use theme!)
- Ignore async errors
- **Forget accessibility (exclude 15% of users!)**
- **Hardcode text strings (use i18n!)**
- **Ignore RTL layout issues**

---

**Ready to start?**

👉 Begin with [01-SharedPreferences.md](01-SharedPreferences.md)
