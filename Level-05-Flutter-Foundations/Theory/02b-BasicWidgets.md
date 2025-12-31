# Basic Display Widgets: Showing Content

## Think of a Toybox

Imagine your toybox has different types of toys:
- 📝 **Letters** = Text widget (shows words)
- 🖼️ **Pictures** = Image widget (shows photos)
- ⭐ **Stickers** = Icon widget (shows symbols)
- 📦 **Boxes** = Container widget (holds and styles things)
- 📏 **Spacers** = SizedBox widget (creates exact spacing)

Let's learn how to use each one!

---

## Text: Displaying Words

The `Text` widget shows words on the screen.

### Basic Text

```dart
Text('Hello, Flutter!')
```

That's it! Just put your text in quotes.

### Styled Text

Make your text look fancy:

```dart
Text(
  'Styled Text',
  style: TextStyle(
    fontSize: 24,                    // How big
    fontWeight: FontWeight.bold,     // How thick
    color: Colors.blue,              // Color
    fontStyle: FontStyle.italic,     // Slanted
    decoration: TextDecoration.underline,  // Line under
    letterSpacing: 2.0,              // Space between letters
  ),
)
```

### Text Alignment

Control how text lines up:

```dart
Text(
  'Centered Text',
  textAlign: TextAlign.center,  // center, left, right, justify
)
```

### Long Text Handling

What happens when text is too long?

```dart
Text(
  'This is a very very very long text that might not fit on one line',
  maxLines: 2,                        // Maximum 2 lines
  overflow: TextOverflow.ellipsis,    // Show ... at end
)
```

**Overflow options:**
- `TextOverflow.ellipsis` → Shows "..."
- `TextOverflow.clip` → Cuts off text
- `TextOverflow.fade` → Fades out

### Multi-Style Text (RichText)

Different styles in one text:

```dart
RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black, fontSize: 20),
    children: [
      TextSpan(
        text: 'Beautiful ',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: 'World!',
        style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  ),
)
```

Result: "Hello **Beautiful** *World!*" (different colors and styles)

---

## Icon: Showing Symbols

The `Icon` widget displays built-in symbols.

### Basic Icon

```dart
Icon(Icons.favorite)  // Shows a heart ❤️
```

### Styled Icon

```dart
Icon(
  Icons.star,
  size: 48,           // How big (in pixels)
  color: Colors.amber,  // Color
)
```

### Common Icons

Flutter has thousands of built-in icons:

```dart
// Popular icons
Icons.home           // 🏠 House
Icons.favorite       // ❤️ Heart
Icons.star           // ⭐ Star
Icons.settings       // ⚙️ Gear
Icons.person         // 👤 Person
Icons.email          // 📧 Mail
Icons.phone          // 📱 Phone
Icons.camera         // 📷 Camera
Icons.search         // 🔍 Magnifying glass
Icons.menu           // ≡ Three lines
Icons.close          // ✕ X
Icons.add            // + Plus
Icons.delete         // 🗑️ Trash
Icons.edit           // ✏️ Pencil
Icons.check          // ✓ Checkmark
Icons.arrow_back     // ← Left arrow
Icons.arrow_forward  // → Right arrow
Icons.thumb_up       // 👍 Thumbs up
Icons.location_on    // 📍 Pin

// Two versions of same icon
Icons.favorite        // ❤️ Filled heart
Icons.favorite_border // ♡ Outlined heart
```

### Icons in Context

```dart
// Icon with text
Row(
  children: [
    Icon(Icons.star, color: Colors.amber),
    SizedBox(width: 5),
    Text('4.5'),
  ],
)

// Icon button (we'll learn more about this later)
IconButton(
  icon: Icon(Icons.favorite),
  color: Colors.red,
  onPressed: () {
    print('Liked!');
  },
)
```

---

## Image: Showing Pictures

The `Image` widget displays pictures from different sources.

### From Assets (Local Files)

First, add image to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/logo.png
    - assets/images/
```

Then use it:

```dart
Image.asset('assets/images/logo.png')
```

### From Network (Internet)

```dart
Image.network('https://example.com/photo.jpg')
```

### With Size and Fit

```dart
Image.asset(
  'assets/images/photo.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,  // How to fit in the box
)
```

### BoxFit Options

How should the image fit in its box?

```
BoxFit.contain     BoxFit.cover       BoxFit.fill
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│ ┌─────────┐ │    │█████████████│    │█████████████│
│ │         │ │    │█████████████│    │█████████████│
│ │  Image  │ │    │████Image████│    │████Image████│
│ │         │ │    │█████████████│    │█████████████│
│ └─────────┘ │    │█████████████│    │█████████████│
│  (margins)  │    │(may crop)   │    │(may stretch)│
└─────────────┘    └─────────────┘    └─────────────┘
```

```dart
// BoxFit.contain - Fits inside, may have empty space
Image.asset('photo.jpg', fit: BoxFit.contain)

// BoxFit.cover - Fills box, may crop edges
Image.asset('photo.jpg', fit: BoxFit.cover)

// BoxFit.fill - Stretches to fill
Image.asset('photo.jpg', fit: BoxFit.fill)

// BoxFit.none - No resizing
Image.asset('photo.jpg', fit: BoxFit.none)

// BoxFit.scaleDown - Only shrinks if too big
Image.asset('photo.jpg', fit: BoxFit.scaleDown)
```

### Loading and Error Handling

```dart
Image.network(
  'https://example.com/image.jpg',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;  // Loaded!
    return Center(
      child: CircularProgressIndicator(),  // Spinning loader
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(
      Icons.broken_image,  // Show if image fails
      size: 100,
      color: Colors.grey,
    );
  },
)
```

### CircleAvatar: Round Images

For profile pictures:

```dart
// With image
CircleAvatar(
  radius: 40,  // Size
  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
)

// With initials
CircleAvatar(
  radius: 40,
  backgroundColor: Colors.blue,
  child: Text(
    'AB',
    style: TextStyle(color: Colors.white, fontSize: 24),
  ),
)

// With both (initials show while loading)
CircleAvatar(
  radius: 40,
  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  child: Text('AB'),  // Shown while loading
)
```

---

## Container: The Swiss Army Knife

`Container` is the most versatile widget. It can:
- Set size
- Add color/background
- Add padding (space inside)
- Add margin (space outside)
- Add borders and shadows
- Align its child

### Basic Container

```dart
Container(
  color: Colors.blue,
  child: Text('In a blue box'),
)
```

### Sized Container

```dart
Container(
  width: 200,
  height: 100,
  color: Colors.red,
  child: Center(child: Text('Fixed size')),
)
```

### Container with Padding and Margin

```dart
Container(
  margin: EdgeInsets.all(20),      // Space outside
  padding: EdgeInsets.all(16),     // Space inside
  color: Colors.blue,
  child: Text('Padded text'),
)
```

```
        margin (outside)
    ┌─────────────────────┐
    │   Container         │
    │ ┌─────────────────┐ │
    │ │ padding (inside)│ │
    │ │  ┌──────────┐   │ │
    │ │  │  Child   │   │ │
    │ │  └──────────┘   │ │
    │ └─────────────────┘ │
    └─────────────────────┘
```

### Decorated Container

```dart
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    color: Colors.blue,                    // Background color
    borderRadius: BorderRadius.circular(10),  // Rounded corners
    border: Border.all(                    // Border
      color: Colors.black,
      width: 2,
    ),
    boxShadow: [                           // Shadow
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 5,
        offset: Offset(2, 2),  // Shadow position
      ),
    ],
  ),
  child: Center(child: Text('Fancy box')),
)
```

### Container with Gradient

```dart
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Center(
    child: Text(
      'Gradient!',
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
  ),
)
```

### Container Alignment

```dart
Container(
  width: 200,
  height: 200,
  color: Colors.grey[300],
  alignment: Alignment.bottomRight,  // Position child
  child: Text('Bottom Right'),
)
```

**Alignment options:**
```dart
Alignment.topLeft        Alignment.topCenter        Alignment.topRight
Alignment.centerLeft     Alignment.center           Alignment.centerRight
Alignment.bottomLeft     Alignment.bottomCenter     Alignment.bottomRight
```

---

## SizedBox: Exact Size and Spacing

`SizedBox` creates exact sizes or spacing.

### Fixed Size

```dart
SizedBox(
  width: 100,
  height: 50,
  child: ElevatedButton(
    onPressed: () {},
    child: Text('Fixed size button'),
  ),
)
```

### Spacing Between Widgets

This is super common!

```dart
Column(
  children: [
    Text('First item'),
    SizedBox(height: 20),  // 20 pixels of space
    Text('Second item'),
    SizedBox(height: 20),  // 20 pixels of space
    Text('Third item'),
  ],
)
```

### Full Size

```dart
SizedBox.expand(
  child: Container(
    color: Colors.blue,
    child: Center(child: Text('Fills available space')),
  ),
)
```

### Square Size

```dart
SizedBox.square(
  dimension: 100,  // 100x100 box
  child: Container(color: Colors.red),
)
```

---

## Complete Example: Profile Card

Let's combine everything we learned:

```dart
Container(
  width: 300,
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  child: Row(
    children: [
      // Profile picture
      CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
      ),

      SizedBox(width: 16),  // Spacing

      // Name and bio
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alice Johnson',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Flutter Developer',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  'San Francisco, CA',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)
```

---

## Summary: Key Takeaways

| Widget | Purpose | Key Property |
|--------|---------|--------------|
| `Text` | Show words | `style: TextStyle(...)` |
| `Icon` | Show symbols | `Icons.name` |
| `Image` | Show pictures | `fit: BoxFit.cover` |
| `Container` | Versatile box | `decoration: BoxDecoration(...)` |
| `SizedBox` | Exact size/spacing | `width/height` |
| `CircleAvatar` | Round images | `radius` |

---

## Quick Quiz

**Q1:** How do you make text bold and blue?

<details>
<summary>Answer</summary>

```dart
Text(
  'Bold and Blue',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
)
```

</details>

**Q2:** What's the difference between `Container` color and decoration?

<details>
<summary>Answer</summary>

You can't use both at the same time!

```dart
// ✅ Simple: Use color
Container(
  color: Colors.blue,
  child: Text('Hello'),
)

// ✅ Advanced: Use decoration (for borders, shadows, gradients)
Container(
  decoration: BoxDecoration(
    color: Colors.blue,  // Color goes here when using decoration
    borderRadius: BorderRadius.circular(10),
  ),
  child: Text('Hello'),
)
```

</details>

**Q3:** How do you add spacing between items in a Column?

<details>
<summary>Answer</summary>

Use `SizedBox` with height:

```dart
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20px gap
    Text('Second'),
  ],
)
```

</details>

---

**Next:** Learn about layout widgets that organize your screen!

---

## Navigation

⬅️ **Previous:** [Widget Introduction](02a-WidgetIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Layout Basics](02c-LayoutBasics.md)
