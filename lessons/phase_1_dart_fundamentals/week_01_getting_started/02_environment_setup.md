# Environment Setup - Your Developer Workspace

## Why Environment Setup Matters

A carpenter needs a workshop. A painter needs a studio. A programmer needs a **development environment**.

Your development environment includes:
1. **Code Editor** - Where you write code (like Microsoft Word, but for code)
2. **Dart SDK** - The tools that run your Dart code
3. **Flutter SDK** - The tools that build apps (we'll add this in Week 7)

Let's set up your workspace properly.

---

## Option 1: DartPad (Start Here - Zero Setup)

**Best for:** Beginners, quick experiments, learning basics

### What is DartPad?

DartPad is an online code editor. It runs in your browser - no installation needed!

### How to Use DartPad

1. Go to [https://dartpad.dev](https://dartpad.dev)
2. You'll see a code editor on the left
3. Click "Run" to execute code
4. See output on the right in the console

**Try this now:**

```dart
void main() {
  print('Hello from DartPad!');
}
```

Click **Run** and watch it appear on the right.

### DartPad Features

- **Autocomplete**: Start typing and DartPad suggests what you might want
- **Error Detection**: Red underlines show mistakes
- **Formatting**: Click "Format" to clean up your code
- **Samples**: Try the sample programs to learn

**Use DartPad for Weeks 1-4** of this course. It's perfect for learning Dart basics.

---

## Option 2: VS Code (Professional Setup)

**Best for:** Serious development, larger projects, Flutter apps

### What is VS Code?

Visual Studio Code (VS Code) is a free, powerful code editor used by millions of developers.

Think of it as Microsoft Word, but specifically designed for writing code with features like:
- Autocomplete (like predictive text on your phone)
- Error detection (like spell-check for code)
- Debugging tools
- Extensions for any language

### Step 1: Install VS Code

1. Go to [https://code.visualstudio.com](https://code.visualstudio.com)
2. Download for your operating system:
   - **Windows**: Download the Windows installer
   - **Mac**: Download the macOS version
   - **Linux**: Follow the Linux instructions
3. Run the installer
4. Follow the setup wizard (default options are fine)

### Step 2: Install Dart SDK

The Dart SDK contains the tools to run Dart code.

#### On Windows:

1. Download Dart SDK from [https://dart.dev/get-dart](https://dart.dev/get-dart)
2. Click "Windows"
3. Use Chocolatey (package manager):
   - Open PowerShell as Administrator
   - Run: `choco install dart-sdk`

Or use the installer:
   - Download the Dart SDK zip
   - Extract to `C:\tools\dart-sdk`
   - Add to PATH:
     - Search "Environment Variables"
     - Edit "Path"
     - Add `C:\tools\dart-sdk\bin`

#### On Mac:

1. Open Terminal
2. Install Homebrew (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
3. Install Dart:
   ```bash
   brew tap dart-lang/dart
   brew install dart
   ```

#### On Linux:

1. Open Terminal
2. Run:
   ```bash
   sudo apt-get update
   sudo apt-get install apt-transport-https
   wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
   echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
   sudo apt-get update
   sudo apt-get install dart
   ```

### Step 3: Verify Dart Installation

Open terminal/command prompt and type:

```bash
dart --version
```

You should see something like:
```
Dart SDK version: 3.2.0 (stable)
```

If you see this, congratulations! Dart is installed.

### Step 4: Install Dart Extension in VS Code

1. Open VS Code
2. Click the Extensions icon (left sidebar - looks like 4 squares)
3. Search for "Dart"
4. Click "Install" on the official Dart extension by Dart Code
5. Wait for installation to complete

### Step 5: Create Your First Project

1. Create a folder for your Dart projects:
   - Windows: `C:\Users\YourName\DartProjects`
   - Mac/Linux: `~/DartProjects`

2. In VS Code, click "File" → "Open Folder"
3. Select your DartProjects folder
4. Create a new file: `hello.dart`
5. Write:
   ```dart
   void main() {
     print('Hello from VS Code!');
   }
   ```
6. Save the file (Ctrl+S or Cmd+S)
7. Right-click in the editor and select "Run Without Debugging"

You should see output in the terminal at the bottom!

### VS Code Pro Tips

**Useful Shortcuts:**

- `Ctrl+S` / `Cmd+S` - Save file
- `Ctrl+Shift+P` / `Cmd+Shift+P` - Command Palette (search for any command)
- `Ctrl+/` / `Cmd+/` - Comment/uncomment line
- `Alt+Shift+F` / `Option+Shift+F` - Format code
- `F5` - Run with debugging

**Customize Your Editor:**

1. Click the gear icon (bottom left) → Settings
2. Search for settings:
   - Font size
   - Theme (dark mode, light mode)
   - Auto-save

**Recommended Settings:**

```json
{
  "editor.fontSize": 14,
  "editor.formatOnSave": true,
  "editor.minimap.enabled": true,
  "dart.previewFlutterUiGuides": true
}
```

To apply these:
1. Press `Ctrl+Shift+P` / `Cmd+Shift+P`
2. Type "Preferences: Open Settings (JSON)"
3. Add the settings above

---

## Understanding Your Workspace

### File Structure

For now, keep it simple:

```
DartProjects/
├── week1/
│   ├── hello.dart
│   ├── variables.dart
│   └── exercise1.dart
├── week2/
│   └── ...
```

Create folders for each week to stay organized.

### Running Dart Files

**In VS Code:**
1. Open the .dart file
2. Right-click → "Run Without Debugging"

**In Terminal:**
```bash
cd /path/to/your/file
dart run hello.dart
```

**In DartPad:**
Just click "Run"

---

## Troubleshooting

### Problem: "dart: command not found"

**Solution:** Dart isn't in your PATH. Re-install and add to PATH (see installation steps above).

### Problem: VS Code doesn't recognize Dart

**Solution:**
1. Make sure Dart extension is installed
2. Reload VS Code (close and reopen)
3. Check Dart SDK path in settings

### Problem: Code doesn't run in VS Code

**Solution:**
1. Make sure file ends with `.dart`
2. Make sure there's a `main()` function
3. Check for syntax errors (red underlines)

---

## Which Should You Use?

**Use DartPad if:**
- You're just starting (Weeks 1-4)
- You want to quickly test something
- You're on a computer where you can't install software

**Use VS Code if:**
- You're serious about learning
- You want a professional setup
- You're ready for Flutter (Week 7+)

**My Recommendation:** Start with DartPad for this week. Set up VS Code this weekend. Use both!

---

## Exercises

### Exercise 1: DartPad Warmup
1. Go to DartPad
2. Write a program that prints your name and favorite color
3. Click "Run"
4. Take a screenshot - this is your first program!

### Exercise 2: VS Code Setup (Optional for Week 1)
1. Install VS Code
2. Install Dart SDK
3. Create a file `first_program.dart`
4. Write and run a program that prints "I set up my environment!"

### Exercise 3: Organize Your Workspace
1. Create a folder structure for this course
2. Create subfolders: week1, week2, week3, week4
3. In week1, create `hello.dart`

---

## What's Next?

Now that your environment is ready, let's start learning Dart properly!

In the next lesson:
- **Variables** - Storing information
- **Data types** - Different kinds of data
- Your first real programs with actual logic

**You're ready. Let's code.**
