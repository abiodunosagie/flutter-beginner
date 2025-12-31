# StatelessWidget Properties: Making Widgets Reusable

## For 5-Year-Olds: Name Tags

Imagine you have a **name tag maker**. You give it different names, and it creates tags:

```
Give it "Alice" → Creates: [Hello, Alice!]
Give it "Bob"   → Creates: [Hello, Bob!]
Give it "Carol" → Creates: [Hello, Carol!]
```

The name tag maker is the same, but you can give it different names!

**Properties work the same way:**
```dart
// The name tag maker
class NameTag extends StatelessWidget {
  final String name;  // ← This is a property

  const NameTag({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// Making different tags
NameTag(name: 'Alice')  // Shows: Hello, Alice!
NameTag(name: 'Bob')    // Shows: Hello, Bob!
```

Same widget, different data!

---

## Adding Properties to StatelessWidgets

Properties let you pass data into your widgets to make them reusable.

### Basic Property Example

```dart
class Greeting extends StatelessWidget {
  // 1. Declare the property
  final String name;

  // 2. Add it to the constructor
  const Greeting({
    super.key,
    required this.name,  // 'required' means you must provide it
  });

  // 3. Use it in build()
  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// Usage:
Greeting(name: 'Alice')  // Shows: Hello, Alice!
Greeting(name: 'World')  // Shows: Hello, World!
```

### Breaking Down the Syntax

```dart
final String name;
//    ^^^^^^ ^^^^
//    Type   Name

required this.name
//       ^^^^ ^^^^
//       'this' refers to the property above
```

---

## Required vs Optional Properties

### Required Properties

Use `required` when the widget MUST have this data:

```dart
class UserCard extends StatelessWidget {
  final String name;    // Must have
  final int age;        // Must have

  const UserCard({
    super.key,
    required this.name,
    required this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text('Age: $age'),
      ],
    );
  }
}

// Must provide both:
UserCard(name: 'Alice', age: 25)  // ✅ Works

// Missing property:
UserCard(name: 'Alice')  // ❌ Error: age is required
```

### Optional Properties

Remove `required` for optional data:

```dart
class ProfileCard extends StatelessWidget {
  final String name;
  final String? bio;  // Optional (nullable with ?)

  const ProfileCard({
    super.key,
    required this.name,
    this.bio,  // No 'required' = optional
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        if (bio != null) Text(bio!),  // Only show if provided
      ],
    );
  }
}

// Both work:
ProfileCard(name: 'Alice')                          // ✅ No bio
ProfileCard(name: 'Bob', bio: 'Flutter developer')  // ✅ With bio
```

---

## Default Values

Give properties default values to make them optional:

```dart
class StyledText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const StyledText({
    super.key,
    required this.text,
    this.fontSize = 16,        // Default: 16
    this.color = Colors.black, // Default: black
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: color),
    );
  }
}

// All of these work:
StyledText(text: 'Hello')                                    // Uses defaults
StyledText(text: 'Hello', fontSize: 24)                      // Custom size
StyledText(text: 'Hello', color: Colors.blue)                // Custom color
StyledText(text: 'Hello', fontSize: 20, color: Colors.red)   // Both custom
```

---

## Multiple Properties Example

```dart
class InfoCard extends StatelessWidget {
  final IconData icon;      // Required
  final String title;       // Required
  final String value;       // Required
  final Color color;        // Optional with default

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage:
InfoCard(
  icon: Icons.people,
  title: 'Followers',
  value: '1,234',
  color: Colors.purple,
)

InfoCard(
  icon: Icons.favorite,
  title: 'Likes',
  value: '567',
  // Uses default blue color
)
```

**Result:**
```
┌─────────────┐  ┌─────────────┐
│    👥       │  │     ❤️      │
│ Followers   │  │   Likes     │
│   1,234     │  │    567      │
└─────────────┘  └─────────────┘
  Purple icon      Blue icon (default)
```

---

## Property Types

You can use any type as a property:

### Basic Types

```dart
class DataDisplay extends StatelessWidget {
  final String text;      // Text
  final int number;       // Whole number
  final double price;     // Decimal number
  final bool isActive;    // true/false
  final Color color;      // Color

  const DataDisplay({
    super.key,
    required this.text,
    required this.number,
    required this.price,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Text('Number: $number'),
        Text('Price: \$$price'),
        Text(isActive ? 'Active' : 'Inactive'),
        Container(width: 50, height: 50, color: color),
      ],
    );
  }
}
```

### List Properties

```dart
class TagList extends StatelessWidget {
  final List<String> tags;

  const TagList({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: tags.map((tag) => Chip(label: Text(tag))).toList(),
    );
  }
}

// Usage:
TagList(tags: ['Flutter', 'Dart', 'Mobile'])
```

### Function Properties

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;  // Function type

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// Usage:
CustomButton(
  label: 'Click Me',
  onPressed: () {
    print('Button clicked!');
  },
)
```

---

## The `final` Keyword

All properties in StatelessWidget MUST be `final`:

```dart
// ✅ CORRECT
class GoodWidget extends StatelessWidget {
  final String name;  // final = can't change
  // ...
}

// ❌ WRONG
class BadWidget extends StatelessWidget {
  String name;  // Missing final - won't compile!
  // ...
}
```

### Why final?

StatelessWidgets are **immutable** (unchangeable). Once created, they can't be modified:

```dart
final widget = Greeting(name: 'Alice');
widget.name = 'Bob';  // ❌ ERROR: Can't change final property

// To show a different name, create a NEW widget:
final newWidget = Greeting(name: 'Bob');  // ✅ Creates new instance
```

---

## Widget Composition

Build complex widgets by combining simpler ones:

```dart
class UserProfile extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final bool isVerified;

  const UserProfile({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar section
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(avatarUrl),
            ),
            const SizedBox(width: 16),

            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Action section
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// Usage:
UserProfile(
  name: 'Alice Smith',
  email: 'alice@example.com',
  avatarUrl: 'https://example.com/alice.jpg',
  isVerified: true,
)
```

**Result:**
```
┌──────────────────────────────────────┐
│  [👤]  Alice Smith ✓                >│
│        alice@example.com             │
└──────────────────────────────────────┘
```

---

## Using const for Performance

### When You CAN Use const

All properties must be compile-time constants:

```dart
// ✅ Can use const
const Greeting(name: 'Alice')        // String literal
const InfoCard(color: Colors.blue)   // Predefined color

// ✅ Can use const with const values
const InfoCard(
  icon: Icons.star,     // Predefined icon
  title: 'Rating',      // String literal
  value: '4.5',         // String literal
  color: Colors.amber,  // Predefined color
)
```

### When You CANNOT Use const

Properties use runtime values:

```dart
// ❌ Cannot use const
Greeting(name: userName)              // Variable
InfoCard(value: count.toString())     // Calculated value
UserProfile(avatarUrl: user.photoUrl) // Object property

// ❌ Cannot use const
ProfileCard(
  name: name,           // Runtime variable
  timestamp: DateTime.now(),  // Runtime value
)
```

---

## Real-World Examples

### Example 1: Product Card

```dart
class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final double? originalPrice;  // Optional (for showing discount)
  final double rating;

  const ProductCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.rating = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = originalPrice != null && originalPrice! > price;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Price section
                Row(
                  children: [
                    Text(
                      '\$$price',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '\$${originalPrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Rating
                if (rating > 0)
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Usage:
ProductCard(
  name: 'Wireless Headphones',
  imageUrl: 'https://example.com/headphones.jpg',
  price: 79.99,
  originalPrice: 99.99,
  rating: 4.5,
)
```

### Example 2: Status Badge

```dart
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Usage:
StatusBadge(text: 'Active', color: Colors.green, icon: Icons.check_circle)
StatusBadge(text: 'Pending', color: Colors.orange)
StatusBadge(text: 'Error', color: Colors.red, icon: Icons.error)
```

### Example 3: Custom Header

```dart
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }
}

// Usage:
SectionHeader(
  title: 'Popular Products',
  subtitle: 'Trending this week',
  onSeeAll: () => print('Navigate to all products'),
)
```

---

## Common Patterns

### Pattern 1: Boolean Flags

```dart
class FeatureCard extends StatelessWidget {
  final String title;
  final bool isNew;
  final bool isPremium;

  const FeatureCard({
    super.key,
    required this.title,
    this.isNew = false,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isNew) const Chip(label: Text('NEW')),
            if (isPremium) const Icon(Icons.stars, color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
```

### Pattern 2: Enum for Options

```dart
enum ButtonStyle { filled, outlined, text }

class StyledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonStyle style;

  const StyledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = ButtonStyle.filled,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case ButtonStyle.filled:
        return ElevatedButton(onPressed: onPressed, child: Text(label));
      case ButtonStyle.outlined:
        return OutlinedButton(onPressed: onPressed, child: Text(label));
      case ButtonStyle.text:
        return TextButton(onPressed: onPressed, child: Text(label));
    }
  }
}
```

---

## Key Takeaways

| Concept | Description |
|---------|-------------|
| Properties | Data passed to widgets via constructor |
| final | All properties must be final (immutable) |
| required | Property must be provided when creating widget |
| Optional | No 'required', can be omitted |
| Default values | Make properties optional with defaults |
| Composition | Combine simple widgets to build complex ones |

---

## Quick Quiz

**Q1:** Why must all properties be `final`?

<details>
<summary>Answer</summary>

StatelessWidgets are immutable (can't change). Making properties `final` enforces this rule. Once a widget is created with certain data, that data can't be changed. To show different data, you create a new widget instance.

</details>

**Q2:** What's the difference between required and optional properties?

<details>
<summary>Answer</summary>

- **Required** properties use the `required` keyword and MUST be provided when creating the widget
- **Optional** properties don't use `required` and can be omitted. They should either have a default value or be nullable (Type?)

</details>

**Q3:** When can you use `const` when creating a widget?

<details>
<summary>Answer</summary>

You can use `const` when ALL properties are compile-time constants (string literals, predefined colors, etc.). You CANNOT use `const` when properties come from variables or runtime calculations.

</details>

---

**Next:** Learn how to use BuildContext to access theme data, screen size, and navigation.

---

## Navigation

⬅️ **Previous:** [StatelessWidget Intro](03a-StatelessIntro.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [BuildContext & Context](03c-StatelessContext.md)
