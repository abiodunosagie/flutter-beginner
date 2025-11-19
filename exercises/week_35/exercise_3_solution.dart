// Exercise 3: Multi-modal AI with Gemini (Intermediate) - SOLUTION
//
// Complete implementation of image analysis using Google's Gemini Vision model.
//
// SETUP:
// 1. Get Gemini API key from: https://makersuite.google.com/app/apikey
// 2. Add to .env: GEMINI_API_KEY=your_key_here
// 3. Add to pubspec.yaml:
//    dependencies:
//      image_picker: ^1.0.4
//      http: ^1.1.0
//      flutter_dotenv: ^5.1.0

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Analysis',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const ImageAnalysisScreen(),
    );
  }
}

class ImageAnalysisScreen extends StatefulWidget {
  const ImageAnalysisScreen({super.key});

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  final TextEditingController _promptController = TextEditingController(
    text: 'Describe this image in detail',
  );
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  String _analysis = '';
  bool _isLoading = false;

  /// Picks an image from the device gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
          _analysis = ''; // Clear previous analysis
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  /// Takes a photo using the device camera
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _selectedImage = photo;
          _analysis = ''; // Clear previous analysis
        });
      }
    } catch (e) {
      _showError('Failed to take photo: $e');
    }
  }

  /// Converts an image file to base64 string for API transmission
  Future<String> _imageToBase64(XFile image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  /// Gets the MIME type of an image based on its extension
  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }

  /// Analyzes the selected image using Gemini Vision API
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _analysis = '';
    });

    try {
      // Get API key from environment
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(
          'Gemini API key not found.\n\n'
          'Please:\n'
          '1. Create a .env file in your project root\n'
          '2. Add: GEMINI_API_KEY=your_key_here\n'
          '3. Get your key from: https://makersuite.google.com/app/apikey',
        );
      }

      // Convert image to base64
      final base64Image = await _imageToBase64(_selectedImage!);

      // Get image MIME type
      final mimeType = _getMimeType(_selectedImage!.path);

      // Construct Gemini API URL
      // Using gemini-1.5-flash for vision capabilities
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey',
      );

      // Prepare request body
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image,
                }
              },
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'topK': 32,
          'topP': 1,
          'maxOutputTokens': 2048,
        },
      });

      // Make API request
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Request timed out. Please try again.');
            },
          );

      // Process response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract analysis text from response
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final candidate = data['candidates'][0];
          if (candidate['content'] != null &&
              candidate['content']['parts'] != null &&
              candidate['content']['parts'].isNotEmpty) {
            final analysisText =
                candidate['content']['parts'][0]['text'] as String;

            setState(() {
              _analysis = analysisText.trim();
            });
          } else {
            throw Exception('No analysis text in response');
          }
        } else {
          throw Exception('No candidates in response');
        }
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'Bad request: ${errorData['error']['message'] ?? 'Unknown error'}',
        );
      } else if (response.statusCode == 403) {
        throw Exception(
          'API key invalid or quota exceeded.\n'
          'Status: ${response.statusCode}',
        );
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          'API request failed.\n'
          'Status: ${response.statusCode}\n'
          'Error: ${errorData['error']['message'] ?? 'Unknown error'}',
        );
      }
    } on SocketException catch (e) {
      setState(() {
        _analysis = 'Network error: ${e.message}\n\n'
            'Please check your internet connection.';
      });
    } on FormatException catch (e) {
      setState(() {
        _analysis = 'Error parsing response: $e';
      });
    } catch (e) {
      setState(() {
        _analysis = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Shows an error message in a snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Analysis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _analysis = '';
                });
              },
              tooltip: 'Clear image',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image selection buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickImageFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Selected image display
            if (_selectedImage != null) ...[
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: kIsWeb
                      ? Image.network(
                          _selectedImage!.path,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          File(_selectedImage!.path),
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Prompt input
              TextField(
                controller: _promptController,
                decoration: const InputDecoration(
                  labelText: 'What do you want to know about this image?',
                  hintText: 'e.g., Describe this image in detail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.question_answer),
                ),
                maxLines: 2,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Quick prompt suggestions
              Wrap(
                spacing: 8,
                children: [
                  'Describe in detail',
                  'What objects are visible?',
                  'Identify text in image',
                  'What is the mood?',
                ]
                    .map((prompt) => ActionChip(
                          label: Text(prompt, style: const TextStyle(fontSize: 12)),
                          onPressed: _isLoading
                              ? null
                              : () {
                                  _promptController.text = prompt;
                                },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Analyze button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeImage,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.psychology),
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze with Gemini'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Analysis result
            if (_analysis.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.teal),
                  const SizedBox(width: 8),
                  const Text(
                    'Gemini Analysis:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal[200]!, width: 2),
                ),
                child: Text(
                  _analysis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],

            // Instructions (shown when no image selected)
            if (_selectedImage == null)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select an image to analyze',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose from gallery or take a photo,\nthen ask Gemini Vision about it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.teal[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '💡 Try asking about objects, colors, text,\nemotions, or get detailed descriptions!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}
