/// Example 03: POST Request - Creating Data
///
/// This example demonstrates how to send data to an API using POST requests.
/// We'll create a form that submits new post data to JSONPlaceholder.
///
/// To run: flutter run -t lib/main.dart (after copying to a Flutter project)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ═══════════════════════════════════════════════════════════════════════════
// WHAT THIS EXAMPLE COVERS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. Sending POST requests with JSON body
// 2. Form handling in Flutter
// 3. Button loading states
// 4. Showing success/error feedback
// 5. Form validation
//
// ═══════════════════════════════════════════════════════════════════════════

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POST Request Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const CreatePostScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CREATE POST SCREEN
// ═══════════════════════════════════════════════════════════════════════════
//
// POST Request Flow:
// ┌─────────────────────────────────────────────────────────────────────────┐
// │                                                                         │
// │  1. USER FILLS FORM        2. SUBMIT           3. RESPONSE              │
// │  ┌─────────────────┐       ┌─────────────┐     ┌─────────────────┐     │
// │  │ Title: _____    │  →    │ POST /posts │  →  │ ✓ Created!      │     │
// │  │ Body: _____     │       │ {title,body}│     │ ID: 101         │     │
// │  │ [Submit]        │       │             │     │                 │     │
// │  └─────────────────┘       └─────────────┘     └─────────────────┘     │
// │                                                                         │
// └─────────────────────────────────────────────────────────────────────────┘

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  // State
  bool _isSubmitting = false;
  Map<String, dynamic>? _createdPost;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// Submits the form data to the API
  Future<void> _submitPost() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare the data
      final postData = {
        'title': _titleController.text,
        'body': _bodyController.text,
        'userId': 1, // Hardcoded for demo
      };

      // Make POST request
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(postData),
      );

      // Check response
      if (response.statusCode == 201) {
        // Parse created post
        final createdPost = json.decode(response.body);

        setState(() {
          _createdPost = createdPost;
          _isSubmitting = false;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Post created with ID: ${createdPost['id']}'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Clear form
        _titleController.clear();
        _bodyController.clear();
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'POST Request Demo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fill out the form below to send a POST request. '
                      'The data will be sent to JSONPlaceholder API.',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Title field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter post title',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Body field
                  TextFormField(
                    controller: _bodyController,
                    decoration: const InputDecoration(
                      labelText: 'Body',
                      hintText: 'Enter post content',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.article),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      if (value.length < 10) {
                        return 'Content must be at least 10 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Submit button with loading state
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitPost,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Post'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Show created post if available
            if (_createdPost != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Last Created Post:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'ID: ${_createdPost!['id']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Title: ${_createdPost!['title']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Body: ${_createdPost!['body']}'),
                      const SizedBox(height: 4),
                      Text(
                        'User ID: ${_createdPost!['userId']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Code snippet
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Code Used:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '''final response = await http.post(
  Uri.parse('https://api.example.com/posts'),
  headers: {
    'Content-Type': 'application/json',
  },
  body: json.encode({
    'title': 'My Title',
    'body': 'My content',
    'userId': 1,
  }),
);

if (response.statusCode == 201) {
  final created = json.decode(response.body);
  print('Created post ID: \${created['id']}');
}''',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// KEY TAKEAWAYS:
// ═══════════════════════════════════════════════════════════════════════════
//
// 1. POST requests need:
//    - Headers: 'Content-Type': 'application/json'
//    - Body: json.encode(yourData)
//
// 2. Status code 201 = Created (success for POST)
//
// 3. Always validate form data before submitting
//
// 4. Show loading state on submit button:
//    - Disable button
//    - Show spinner
//    - Re-enable after completion
//
// 5. Give user feedback:
//    - SnackBar for quick messages
//    - Show created data for confirmation
//
// 6. Handle errors gracefully:
//    - Try/catch around API call
//    - Show error message to user
//    - Don't leave user stuck
//
// ═══════════════════════════════════════════════════════════════════════════
