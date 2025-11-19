// Exercise 3: Multi-modal AI with Gemini (Intermediate)
//
// Build an app that can analyze images using Google's Gemini Vision model.
// Users can take photos or select from gallery and get AI analysis.
//
// Learning Objectives:
// - Work with Gemini API
// - Handle image input (camera/gallery)
// - Encode images to base64
// - Send multi-modal requests (text + image)
// - Display image analysis results
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
  final TextEditingController _promptController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedImage;
  String _analysis = '';
  bool _isLoading = false;

  // TODO: Implement method to pick image from gallery
  // Use ImagePicker to select an image
  // Store result in _selectedImage
  Future<void> _pickImageFromGallery() async {
    // TODO: Implement this method
    // Use _picker.pickImage(source: ImageSource.gallery)
    // Update _selectedImage and clear previous analysis
  }

  // TODO: Implement method to take photo with camera
  // Use ImagePicker to capture a photo
  // Store result in _selectedImage
  Future<void> _takePhoto() async {
    // TODO: Implement this method
    // Use _picker.pickImage(source: ImageSource.camera)
    // Update _selectedImage and clear previous analysis
  }

  // TODO: Implement method to convert image to base64
  // Read image bytes and convert to base64 string
  // This is needed for Gemini API
  Future<String> _imageToBase64(XFile image) async {
    // TODO: Implement this method
    // Read image bytes: await image.readAsBytes()
    // Convert to base64: base64Encode(bytes)
    return '';
  }

  // TODO: Implement method to analyze image with Gemini
  // Send image (as base64) and text prompt to Gemini API
  // Display the analysis result
  //
  // Gemini API endpoint:
  // https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent
  //
  // Request format:
  // {
  //   "contents": [{
  //     "parts": [
  //       {"text": "What's in this image?"},
  //       {"inline_data": {"mime_type": "image/jpeg", "data": "base64_data_here"}}
  //     ]
  //   }]
  // }
  //
  // Response format:
  // {
  //   "candidates": [{
  //     "content": {
  //       "parts": [{"text": "Analysis text here"}]
  //     }
  //   }]
  // }
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _analysis = '';
    });

    try {
      // TODO: Get API key
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Gemini API key not found in .env');
      }

      // TODO: Convert image to base64
      final base64Image = await _imageToBase64(_selectedImage!);

      // TODO: Get the image mime type (e.g., image/jpeg, image/png)
      final mimeType = ''; // Determine from file extension

      // TODO: Create the API URL with API key
      final url = Uri.parse(''); // Gemini API endpoint

      // TODO: Create request body with text prompt and image
      final body = jsonEncode({
        // Add contents array with parts (text and image)
      });

      // TODO: Make POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // TODO: Check response and extract analysis
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract text from: data['candidates'][0]['content']['parts'][0]['text']
        final analysisText = ''; // TODO: Extract from response

        setState(() {
          _analysis = analysisText;
        });
      } else {
        throw Exception('API request failed: ${response.statusCode}');
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Analysis'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _takePhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
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
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: kIsWeb
                      ? Image.network(_selectedImage!.path, fit: BoxFit.contain)
                      : Image.file(File(_selectedImage!.path), fit: BoxFit.contain),
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
                ),
                maxLines: 2,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Analyze button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyzeImage,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.psychology),
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Analysis result
            if (_analysis.isNotEmpty) ...[
              const Text(
                'Analysis:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal[200]!),
                ),
                child: Text(
                  _analysis,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ],

            // Instructions (shown when no image selected)
            if (_selectedImage == null)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.add_photo_alternate, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Select an image to analyze',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choose from gallery or take a photo,\nthen ask Gemini about it!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
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
