# Getting Started with Flutter Mastery

**Welcome, future Flutter master! Let's get you set up for success.**

## Before You Begin

### Prerequisites

#### Required Knowledge
- None! This course starts from absolute zero
- No prior programming experience needed

#### If You Know Another Language
If you already know JavaScript, Python, Java, or another language, you'll find Dart familiar. Feel free to skim the basics, but don't skip them entirely.

#### Required Tools
- **Computer** (Windows, Mac, or Linux)
- **Internet connection**
- **2-4 GB of free disk space**

---

## Setup Instructions

### Phase 1: Learn Dart First (Levels 1-4)

For the first four levels, you only need DartPad - no installation required!

#### Option A: DartPad (Recommended for Beginners)

1. Open your browser
2. Go to [dartpad.dev](https://dartpad.dev)
3. You're ready to code!

**DartPad Benefits:**
- Zero setup required
- Works in any browser
- Instant feedback
- Perfect for learning Dart basics

#### Option B: VS Code + Dart (For Local Development)

If you prefer working locally:

**Step 1: Install VS Code**
- Download from [code.visualstudio.com](https://code.visualstudio.com)
- Install for your operating system

**Step 2: Install Dart SDK**

**Windows:**
```bash
# Using Chocolatey
choco install dart-sdk

# Or download from dart.dev/get-dart
```

**Mac:**
```bash
# Using Homebrew
brew tap dart-lang/dart
brew install dart
```

**Linux:**
```bash
# Using apt
sudo apt-get update
sudo apt-get install dart
```

**Step 3: Install VS Code Extensions**
- Open VS Code
- Go to Extensions (Cmd/Ctrl + Shift + X)
- Search and install: "Dart"

**Step 4: Verify Installation**
```bash
dart --version
```

You should see something like: `Dart SDK version: 3.x.x`

---

### Phase 2: Flutter Setup (Level 5 and Beyond)

When you reach Level 5, you'll need Flutter installed.

#### Install Flutter

**Step 1: Download Flutter SDK**

**Windows:**
1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to `C:\src\flutter` (or your preferred location)
3. Add Flutter to PATH:
   - Search "Environment Variables" in Windows
   - Edit PATH, add `C:\src\flutter\bin`

**Mac:**
```bash
# Using Homebrew (recommended)
brew install --cask flutter

# Or download from flutter.dev
```

**Linux:**
```bash
# Download from flutter.dev
# Extract and add to PATH
export PATH="$PATH:`pwd`/flutter/bin"
```

**Step 2: Run Flutter Doctor**
```bash
flutter doctor
```

This checks your setup and tells you what's missing.

**Step 3: Install VS Code Flutter Extension**
- Open VS Code
- Go to Extensions
- Search and install: "Flutter" (this also installs Dart)

**Step 4: Set Up an Emulator/Simulator**

**For Android:**
1. Install Android Studio from [developer.android.com](https://developer.android.com/studio)
2. Open Android Studio → Tools → AVD Manager
3. Create a virtual device

**For iOS (Mac only):**
1. Install Xcode from App Store
2. Open Xcode once to accept license
3. Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
4. Run: `sudo xcodebuild -runFirstLaunch`

**Step 5: Verify Everything**
```bash
flutter doctor -v
```

All checkmarks should be green for your target platform.

---

## Your Learning Path

### Visual Overview

```
Level 1-4 (Dart Only)     Level 5-16 (Flutter)
─────────────────────     ──────────────────────

    DartPad                    VS Code
       │                       + Flutter
       ▼                          │
  ┌─────────┐                     ▼
  │ Level 1 │              ┌──────────┐
  │  Dart   │              │ Level 5  │
  │ Basics  │              │ Flutter  │
  └────┬────┘              │ Basics   │
       │                   └────┬─────┘
       ▼                        │
  ┌─────────┐                   ▼
  │ Level 2 │              ┌──────────┐
  │ Control │              │ Level 6+ │
  │  Flow   │              │ Advanced │
  └────┬────┘              │ Flutter  │
       │                   └──────────┘
       ▼
  ┌─────────┐
  │ Level 3 │
  │Functions│
  └────┬────┘
       │
       ▼
  ┌─────────┐
  │ Level 4 │
  │   OOP   │
  └─────────┘
```

### Recommended Pace

**Week 1-2:** Levels 1-2 (Dart basics, control flow)
**Week 3-4:** Levels 3-4 (Functions, OOP)
**Week 5-6:** Levels 5-6 (Flutter basics, state)
**Week 7-8:** Levels 7-8 (Navigation, networking)
**Week 9-10:** Levels 9-10 (Storage, animations)
**Week 11-12:** Levels 11-12 (Firebase, platform)
**Week 13-14:** Levels 13-14 (Testing, deployment)
**Week 15-16:** Levels 15-16 (Professional patterns, advanced)

---

## How to Use This Curriculum

### Daily Routine

**Ideal Learning Session (1-2 hours):**

```
[20 min] Read theory for current topic
[10 min] Take notes, understand concepts
[45 min] Code along with examples
[15 min] Do exercises
[10 min] Review and experiment
```

### The Learning Process

For every concept:
1. **Read** the theory
2. **Type** the example code yourself (don't copy-paste!)
3. **Run** it and see the result
4. **Modify** it and experiment
5. **Break** it intentionally and fix it
6. **Build** something small using the concept

### The Feynman Technique

After learning a concept:
1. Explain it in simple terms (to yourself or others)
2. Identify gaps in your understanding
3. Go back and fill those gaps
4. Simplify your explanation

If you can explain it simply, you understand it.

---

## Study Schedule Options

### Option 1: Steady Pace (8-10h/week)
**Timeline:** 14-16 weeks

- **Weekdays:** 1-1.5 hours (theory + examples)
- **Weekend:** 3-4 hours (exercises + projects)

**Best for:** Working professionals

### Option 2: Intensive (15-20h/week)
**Timeline:** 6-8 weeks

- **Daily:** 2-3 hours of focused study
- Faster progression, requires dedication

**Best for:** Career changers, students

### Option 3: Relaxed (4-6h/week)
**Timeline:** 20-24 weeks

- **3 sessions per week:** 1.5-2 hours each
- More time for concepts to sink in

**Best for:** Busy schedules

---

## Setting Up Your Workspace

### VS Code Configuration

**Useful Shortcuts:**
- `Cmd/Ctrl + S` - Save (and hot reload in Flutter)
- `Cmd/Ctrl + Shift + P` - Command palette
- `Cmd/Ctrl + /` - Comment/uncomment code
- `F5` - Start debugging
- `Cmd/Ctrl + .` - Quick fix suggestions

**Recommended Settings:**
1. Enable auto-save: Settings → Auto Save → afterDelay
2. Format on save: Settings → Format On Save → checked
3. Enable bracket colorization: Built into VS Code

### File Organization

Keep your practice organized:

```
my-flutter-learning/
├── level-01-practice/
│   ├── hello_world.dart
│   ├── variables_practice.dart
│   └── exercises/
├── level-02-practice/
│   ├── conditionals.dart
│   ├── loops.dart
│   └── exercises/
└── ... (for each level)
```

---

## Note-Taking Strategy

### What to Note

For each level:

```markdown
# Level X: [Topic]

## Key Concepts
- Concept 1: brief explanation
- Concept 2: brief explanation

## Code Snippets I Want to Remember
```dart
// Useful pattern
```

## Mistakes I Made
- Mistake 1 and how I fixed it

## Questions I Have
- [ ] Question 1
- [x] Question 2 (answered)
```

### Tools
- Notion
- Apple Notes
- Markdown files
- Physical notebook (sometimes best!)

---

## When You Get Stuck

### Troubleshooting Steps

1. **Read the error message carefully** - it often tells you exactly what's wrong
2. **Check for typos** - especially semicolons, brackets, quotes
3. **Compare with examples** - did you miss something?
4. **Google the error** - someone else had this problem
5. **Take a break** - fresh eyes see solutions
6. **Ask for help** - after trying the above

### Common Beginner Errors

**Dart:**
- Missing semicolon at end of line
- Mismatched quotes (started with ' ended with ")
- Forgetting `void main()` wrapper
- Typos in variable names

**Flutter:**
- Missing `const` keyword
- Forgetting to call `setState()`
- Wrong widget nesting
- Missing `return` in build method

### Where to Ask Questions

1. **Stack Overflow** - Tag: `dart` or `flutter`
2. **Reddit** - r/FlutterDev, r/dartlang
3. **Discord** - Flutter Community
4. **GitHub Discussions** - flutter/flutter

**How to ask good questions:**
- What you're trying to do
- What you expected
- What actually happened
- Your code (minimal example)
- Error message (full text)

---

## Success Metrics

### Signs You're Ready to Move On

You can:
- Explain the concept to someone else
- Build something using the concept without looking at notes
- Recognize the concept in other code
- Debug issues related to it
- Know when to use it vs alternatives

### Weekly Check-in

Ask yourself:
- [ ] Did I complete the planned content?
- [ ] Did I do all exercises?
- [ ] Can I explain what I learned?
- [ ] Did I build something on my own?

---

## Common Pitfalls to Avoid

### 1. Tutorial Hell
**Problem:** Watching/reading without coding
**Solution:** Type every single line yourself

### 2. Moving Too Fast
**Problem:** Rushing to "finish"
**Solution:** Master each concept before moving on

### 3. Not Building Projects
**Problem:** Only following examples
**Solution:** Build your own small projects

### 4. Giving Up When Stuck
**Problem:** Quitting when confused
**Solution:** Confusion is normal. Take breaks, ask questions.

### 5. Perfectionism
**Problem:** Trying to understand 100% before moving on
**Solution:** 80% understanding is fine. You'll revisit concepts.

---

## Your First Day

### Today's Tasks (30-60 minutes)

1. **Choose your setup:**
   - For now: Use [dartpad.dev](https://dartpad.dev)
   - Later: Install VS Code + Dart

2. **Write your first program:**
   - Go to DartPad
   - Delete existing code
   - Type:
   ```dart
   void main() {
     print('Hello, Flutter Mastery!');
   }
   ```
   - Click Run
   - Celebrate! You just wrote code!

3. **Start Level 1:**
   - Open `Level-01-Dart-Fundamentals/README.md`
   - Read the level overview
   - Begin with the first theory file

---

## Quick Links

### Official Resources
- **Flutter Docs**: [flutter.dev/docs](https://flutter.dev/docs)
- **Dart Docs**: [dart.dev/guides](https://dart.dev/guides)
- **DartPad**: [dartpad.dev](https://dartpad.dev)
- **Pub.dev** (packages): [pub.dev](https://pub.dev)

### This Curriculum
- Main overview: `README.md`
- Level 1: `Level-01-Dart-Fundamentals/`
- Quick reference: `Resources/QuickReference.md`

---

## Ready? Let's Go!

### Your Mission

1. Set up DartPad (or local environment)
2. Write "Hello World"
3. Open Level 1
4. Code every day
5. Don't give up

### Remember

> "The expert in anything was once a beginner."

> "The only way to learn programming is to program."

**You've got this! Now open Level-01-Dart-Fundamentals and let's begin!**

---

**Continue to:** `Level-01-Dart-Fundamentals/README.md`
