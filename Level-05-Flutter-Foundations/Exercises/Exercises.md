# Level 5 Exercises: Flutter Foundations

Practice building Flutter apps with these exercises. Start simple and work your way up!

---

## Exercise 1: Hello World Variations ⭐

**Goal:** Get comfortable with basic Flutter structure and widgets.

Create a Flutter app that displays:
1. Your name in large, bold text
2. A subtitle with your favorite quote
3. An icon that represents you
4. All centered on the screen with a nice background color

**Requirements:**
- Use `Scaffold` with an `AppBar`
- Use `Column` for layout
- Style the text with `TextStyle`
- Add appropriate spacing with `SizedBox`
- Use `const` where appropriate

**Hints:**
```dart
Text(
  'Your Name',
  style: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## Exercise 2: Profile Card ⭐

**Goal:** Practice using Container, decoration, and layout widgets.

Create a profile card that shows:
- A circular avatar (use `CircleAvatar`)
- Name and title
- Location with an icon
- A brief bio
- Social media stats (Followers, Following, Posts)

**Requirements:**
- Use `Card` widget
- Use `Padding` for spacing
- Use `Row` and `Column` for layout
- Add colors and styling
- Make it look professional

**Example Layout:**
```
┌─────────────────────────┐
│      [Avatar]           │
│                         │
│      John Doe           │
│   Flutter Developer     │
│                         │
│   📍 San Francisco      │
│                         │
│ This is my bio text...  │
│                         │
│  100    1.2K    250     │
│  Posts  Followers  Following │
└─────────────────────────┘
```

---

## Exercise 3: Interactive Counter ⭐⭐

**Goal:** Practice StatefulWidget and setState.

Create a counter app with:
- Display of current count
- Increment button (+)
- Decrement button (-)
- Reset button
- Count should never go below 0

**Bonus Challenges:**
- Change color based on count (e.g., red when 0, green when positive)
- Add a "+5" and "-5" button
- Add a history of all counts

**Requirements:**
- Use `StatefulWidget`
- Use `setState()` for updates
- Handle edge cases (negative numbers)
- Make buttons visually distinct

---

## Exercise 4: Todo List ⭐⭐

**Goal:** Practice lists and state management.

Create a simple todo list app:
- Text field to add new tasks
- List of tasks
- Tap task to mark as complete (strikethrough)
- Delete button for each task
- Show count of completed vs total tasks

**Requirements:**
- Use `TextField` with `TextEditingController`
- Use `ListView.builder`
- Manage list state with `setState()`
- Style completed tasks differently
- Don't forget to `dispose()` the controller

**Example:**
```
┌─────────────────────────┐
│  Add new task...    [+] │
├─────────────────────────┤
│  ☐ Buy groceries    [X] │
│  ☑ Learn Flutter    [X] │
│  ☐ Build an app     [X] │
└─────────────────────────┘
  2 of 3 completed
```

---

## Exercise 5: Layout Practice ⭐⭐

**Goal:** Master Row, Column, and alignment.

Create a page that demonstrates different layouts:

**Section 1: Row Alignment**
- Show boxes aligned: start, center, end, spaceBetween, spaceEvenly

**Section 2: Column Alignment**
- Show items with different crossAxisAlignment options

**Section 3: Expanded/Flexible**
- Show 3 boxes with different flex values (2:1:1)

**Requirements:**
- Use labeled sections
- Different colors for each box
- Clear visual demonstration of each concept
- Use `Container` with different sizes

---

## Exercise 6: Color Picker ⭐⭐

**Goal:** Practice with multiple state variables and user interaction.

Create a color picker app:
- Three sliders for RGB values (0-255)
- Display the resulting color in a large box
- Show the RGB values as text
- Show the hex color code

**Bonus:**
- Add preset color buttons
- Add a "Random Color" button
- Show a list of recently picked colors

**Requirements:**
- Use `StatefulWidget`
- Use `Slider` widgets
- Convert RGB to hex
- Update UI on slider change

---

## Exercise 7: Toggle Features ⭐⭐

**Goal:** Practice with switches, checkboxes, and conditional rendering.

Create a settings page with:
- Dark Mode toggle (change background)
- Notifications toggle
- Font size slider
- Show/hide avatar checkbox
- Different sections (Account, Preferences, About)

**Requirements:**
- Use `Switch` and `Checkbox` widgets
- Use `Slider` for font size
- Conditionally show/hide widgets based on settings
- Use `ListTile` for settings items

---

## Exercise 8: Navigation App ⭐⭐⭐

**Goal:** Practice bottom navigation and page management.

Create an app with 3 tabs:
1. **Home**: Show a welcome message and user stats
2. **Search**: Show a search bar and dummy results
3. **Profile**: Show user profile with edit button

**Requirements:**
- Use `BottomNavigationBar`
- Maintain separate state for each page
- Use appropriate icons
- Highlight active tab
- Each page should have real content

---

## Exercise 9: Form Validation ⭐⭐⭐

**Goal:** Practice forms and validation.

Create a registration form with:
- Name field (required, min 3 characters)
- Email field (required, valid email format)
- Password field (required, min 8 characters, hidden text)
- Confirm password field (must match password)
- Submit button (disabled until valid)
- Show error messages

**Requirements:**
- Use `TextField` widgets
- Validate on text change
- Show/hide password toggle
- Disable submit if invalid
- Clear form after submit

**Validation Rules:**
```dart
// Name: not empty, at least 3 characters
// Email: contains @
// Password: at least 8 characters
// Confirm: matches password
```

---

## Exercise 10: Weather Card ⭐⭐⭐

**Goal:** Build a complex, styled widget.

Create a weather card that shows:
- City name
- Large temperature
- Weather icon
- Weather description
- High/Low temperatures
- Humidity and Wind speed
- 5-day forecast (horizontal scroll)

**Requirements:**
- Use `Card` with nice styling
- Use `Stack` for layering
- Use `Row` and `Column` for layout
- Add gradient background
- Make it visually appealing
- Use dummy data (no API yet)

**Example:**
```
┌─────────────────────────┐
│  ☀️                     │
│  San Francisco          │
│                         │
│      72°F               │
│   Sunny Skies           │
│                         │
│  High: 78°  Low: 65°    │
│  💧 45%     💨 12 mph   │
│                         │
│  Mon  Tue  Wed  Thu  Fri│
│  70°  72°  75°  73°  71°│
└─────────────────────────┘
```

---

## Exercise 11: Image Gallery ⭐⭐⭐

**Goal:** Practice GridView and navigation.

Create a photo gallery app:
- Grid of images (use colored containers as placeholders)
- Tap image to view full screen
- Add like button on each image
- Show liked images count
- Filter to show only liked images

**Requirements:**
- Use `GridView.builder`
- Navigate to detail page with `Navigator.push`
- Manage liked state
- Use `Hero` animation for smooth transition
- Add filter toggle

---

## Exercise 12: Calculator ⭐⭐⭐⭐

**Goal:** Build a functional calculator.

Create a calculator with:
- Number buttons (0-9)
- Operation buttons (+, -, ×, ÷)
- Equals button
- Clear button
- Display showing current input and result
- Basic calculation logic

**Requirements:**
- Grid layout for buttons
- Proper calculation logic
- Handle decimal numbers
- Handle divide by zero
- Clear button resets everything
- Professional styling

---

## Exercise 13: Expense Tracker ⭐⭐⭐⭐

**Goal:** Build a complete mini-app.

Create an expense tracker:
- Add expense (name, amount, category)
- List of expenses
- Delete expense
- Show total expenses
- Filter by category
- Show expenses by category chart (simple bars)

**Requirements:**
- Multiple StatefulWidgets
- Form validation
- List management
- Filtering logic
- Summary calculations
- Nice UI with colors

---

## Exercise 14: Quiz App ⭐⭐⭐⭐

**Goal:** Complex state management and navigation.

Create a quiz app:
- Welcome screen
- Multiple choice questions (one at a time)
- Progress indicator
- Track score
- Results screen with score
- Restart button

**Requirements:**
- Multiple pages/screens
- Progress tracking
- Score calculation
- Navigation between screens
- Timer for each question (bonus)
- Review incorrect answers (bonus)

**Questions Data Structure:**
```dart
class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
}
```

---

## Exercise 15: Final Project - Personal Dashboard ⭐⭐⭐⭐⭐

**Goal:** Combine everything you've learned!

Create a personal dashboard app with:

**Features:**
1. Multiple tabs (Dashboard, Tasks, Notes, Settings)
2. Dashboard: Show widgets for weather, tasks, quick stats
3. Tasks: Full todo list with categories
4. Notes: Add/edit/delete notes
5. Settings: User preferences

**Requirements:**
- Clean, professional UI
- Multiple pages with navigation
- State management across app
- Forms and validation
- Lists (add/edit/delete)
- Local state for preferences
- Reusable components
- Proper code organization

**Bonus Features:**
- Search functionality
- Sort/filter options
- Dark mode toggle
- Animations
- Custom theme

---

## Tips for Success

1. **Start Simple**
   - Get basic structure working first
   - Add features incrementally
   - Test frequently

2. **Read Error Messages**
   - Flutter errors are usually helpful
   - Check the line number
   - Look for "expected" vs "actual"

3. **Use Hot Reload**
   - Press `r` in terminal
   - See changes instantly
   - Saves tons of time

4. **Code Organization**
   - Break into smaller widgets
   - Use meaningful names
   - Add comments for complex logic

5. **Styling**
   - Use consistent spacing
   - Pick a color scheme
   - Make it visually pleasing

6. **Testing**
   - Test edge cases
   - Try different screen sizes
   - Check all user interactions

---

## Common Mistakes to Avoid

❌ **Forgetting setState()**
```dart
// Won't update UI
count++;

// Will update UI
setState(() => count++);
```

❌ **Not disposing controllers**
```dart
@override
void dispose() {
  controller.dispose();  // Don't forget!
  super.dispose();
}
```

❌ **Unbounded constraints**
```dart
// Error: ListView in Column
Column(
  children: [
    ListView(),  // Needs bounded height
  ],
)

// Fix: Wrap in Expanded
Column(
  children: [
    Expanded(child: ListView()),
  ],
)
```

❌ **Missing const**
```dart
// Less efficient
Text('Hello')

// More efficient
const Text('Hello')
```

---

## Solutions

Solutions for these exercises are not provided intentionally. The best way to learn is by:
1. Trying yourself first
2. Reading error messages
3. Consulting the Theory files
4. Looking at Examples
5. Asking for help when truly stuck

Remember: Struggling is part of learning! Don't give up.

---

## What's Next?

After completing these exercises, you're ready for:
- **Level 6:** State Management (Riverpod & BLoC)
- Building more complex apps
- Learning about navigation
- Working with APIs
- Adding animations

Keep practicing and building! 🚀

---

**Continue to:** Level-06-State-Management
