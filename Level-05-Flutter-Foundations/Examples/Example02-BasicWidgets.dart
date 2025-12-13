// Example 2: Basic Widgets
// Exploring common Flutter widgets

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Widgets',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const WidgetShowcase(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WidgetShowcase extends StatelessWidget {
  const WidgetShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Widgets'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION 1: Text Widgets
            const SectionTitle(title: '1. Text Widget'),
            const TextExamples(),
            const SizedBox(height: 24),

            // SECTION 2: Container Widget
            const SectionTitle(title: '2. Container Widget'),
            const ContainerExamples(),
            const SizedBox(height: 24),

            // SECTION 3: Icon Widget
            const SectionTitle(title: '3. Icon Widget'),
            const IconExamples(),
            const SizedBox(height: 24),

            // SECTION 4: Button Widgets
            const SectionTitle(title: '4. Button Widgets'),
            const ButtonExamples(),
            const SizedBox(height: 24),

            // SECTION 5: Image Widget
            const SectionTitle(title: '5. Image Widget'),
            const ImageExamples(),
            const SizedBox(height: 24),

            // SECTION 6: Card Widget
            const SectionTitle(title: '6. Card Widget'),
            const CardExamples(),
          ],
        ),
      ),
    );
  }
}

// Reusable section title widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }
}

// TEXT EXAMPLES
class TextExamples extends StatelessWidget {
  const TextExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic text
        Text('Simple text'),
        SizedBox(height: 8),

        // Styled text
        Text(
          'Bold and Large',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Colored text
        Text(
          'Colored text',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),

        // Text with multiple styles
        Text(
          'Italic and underlined',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 8),

        // Long text with overflow handling
        Text(
          'This is a very long text that might overflow and we handle it with ellipsis',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// CONTAINER EXAMPLES
class ContainerExamples extends StatelessWidget {
  const ContainerExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Basic colored container
        Container(
          width: double.infinity,
          height: 50,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Basic Container',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Container with decoration
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Rounded Container',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),

        // Container with border and shadow
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: const Text(
            'Container with Border & Shadow',
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),

        // Container with gradient
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
            ),
          ),
          child: const Text(
            'Gradient Container',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ICON EXAMPLES
class IconExamples extends StatelessWidget {
  const IconExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Basic icons with different styles
        Icon(Icons.home, size: 30),
        Icon(Icons.favorite, size: 30, color: Colors.red),
        Icon(Icons.star, size: 30, color: Colors.amber),
        Icon(Icons.settings, size: 30, color: Colors.grey),
        Icon(Icons.notifications, size: 30, color: Colors.blue),
      ],
    );
  }
}

// BUTTON EXAMPLES
class ButtonExamples extends StatelessWidget {
  const ButtonExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Elevated Button
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Elevated Button pressed!')),
            );
          },
          child: const Text('Elevated Button'),
        ),
        const SizedBox(height: 12),

        // Text Button
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Text Button pressed!')),
            );
          },
          child: const Text('Text Button'),
        ),
        const SizedBox(height: 12),

        // Outlined Button
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Outlined Button pressed!')),
            );
          },
          child: const Text('Outlined Button'),
        ),
        const SizedBox(height: 12),

        // Button with icon
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Send'),
        ),
        const SizedBox(height: 12),

        // Icon Buttons in a row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.thumb_up),
              color: Colors.blue,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.thumb_down),
              color: Colors.red,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

// IMAGE EXAMPLES
class ImageExamples extends StatelessWidget {
  const ImageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Placeholder for network image
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 50, color: Colors.grey),
                Text('Image.network() example'),
                Text('(requires internet)', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // CircleAvatar
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Text('AB', style: TextStyle(color: Colors.white)),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple,
              child: Text('XY', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }
}

// CARD EXAMPLES
class CardExamples extends StatelessWidget {
  const CardExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Simple Card
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Simple Card'),
          ),
        ),
        const SizedBox(height: 12),

        // Card with content
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Card Title',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is the card content. Cards are great for displaying related information.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('CANCEL'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ListTile in a Card
        const Card(
          child: ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('John Doe'),
            subtitle: Text('Flutter Developer'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }
}

/*
 * KEY CONCEPTS:
 *
 * 1. Text Widget
 *    - Display text with optional styling
 *    - TextStyle for font, color, size, etc.
 *    - Handle overflow with maxLines and overflow
 *
 * 2. Container Widget
 *    - Versatile box with size, padding, margin
 *    - Use decoration for colors, borders, shadows
 *    - Can have gradients
 *
 * 3. Icon Widget
 *    - Display Material Icons
 *    - Customize size and color
 *    - Many built-in icons in Icons class
 *
 * 4. Button Widgets
 *    - ElevatedButton: Raised with shadow
 *    - TextButton: Flat text only
 *    - OutlinedButton: With border
 *    - IconButton: Just an icon
 *
 * 5. Image Widget
 *    - Image.asset() for local images
 *    - Image.network() for web images
 *    - CircleAvatar for profile pictures
 *
 * 6. Card Widget
 *    - Material Design card
 *    - Elevation for shadow
 *    - Great for grouping content
 *
 * EXERCISES:
 * 1. Create a profile card with avatar, name, and bio
 * 2. Make a button that changes color when pressed
 * 3. Create a styled container with your favorite colors
 * 4. Build a list of cards with different content
 */
