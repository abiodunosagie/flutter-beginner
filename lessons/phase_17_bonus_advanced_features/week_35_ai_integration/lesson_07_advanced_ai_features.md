# Lesson 7: Advanced AI Features (Image Generation, Vision, Speech)

## 5-Year-Old Analogy 🎨

Imagine you have three magical friends:
1. **The Artist** - You describe something (like "a purple unicorn eating pizza") and they draw it for you!
2. **The Eye Friend** - You show them any picture and they tell you exactly what's in it!
3. **The Voice Friend** - You talk to them and they understand you, or they read text and speak it back to you!

Today we're learning how to make our app have all three magical powers!

---

## What We'll Build

Advanced AI capabilities:

1. ✅ **Image Generation** with DALL-E 3 and Stable Diffusion
2. ✅ **Vision AI** - analyze and understand images
3. ✅ **Speech-to-Text** - convert voice to text
4. ✅ **Text-to-Speech** - AI voice reading
5. ✅ **Image Editing** - modify existing images
6. ✅ **Background Removal**
7. ✅ **Image Upscaling**

---

## Part 1: Image Generation

### Step 1: Create Image Generation Models

```dart
// lib/models/image_generation_models.dart
import 'package:json_annotation/json_annotation.dart';

part 'image_generation_models.g.dart';

enum ImageSize {
  @JsonValue('256x256')
  small,
  @JsonValue('512x512')
  medium,
  @JsonValue('1024x1024')
  large,
  @JsonValue('1792x1024')
  landscape,
  @JsonValue('1024x1792')
  portrait,
}

enum ImageQuality {
  @JsonValue('standard')
  standard,
  @JsonValue('hd')
  hd,
}

enum ImageStyle {
  @JsonValue('vivid')
  vivid,
  @JsonValue('natural')
  natural,
}

// DALL-E Request
@JsonSerializable()
class DalleRequest {
  final String model;
  final String prompt;
  final int n;
  final String size;
  @JsonKey(includeIfNull: false)
  final String? quality;
  @JsonKey(includeIfNull: false)
  final String? style;

  DalleRequest({
    this.model = 'dall-e-3',
    required this.prompt,
    this.n = 1,
    this.size = '1024x1024',
    this.quality,
    this.style,
  });

  factory DalleRequest.fromJson(Map<String, dynamic> json) =>
      _$DalleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DalleRequestToJson(this);
}

// Image data
@JsonSerializable()
class ImageData {
  final String url;
  @JsonKey(name: 'revised_prompt')
  final String? revisedPrompt;

  ImageData({
    required this.url,
    this.revisedPrompt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}

// DALL-E Response
@JsonSerializable()
class DalleResponse {
  final int created;
  final List<ImageData> data;

  DalleResponse({
    required this.created,
    required this.data,
  });

  factory DalleResponse.fromJson(Map<String, dynamic> json) =>
      _$DalleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DalleResponseToJson(this);
}
```

Generate code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

### Step 2: Create Image Generation Client

```dart
// lib/services/image_generation_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../config/api_config.dart';
import '../models/image_generation_models.dart';
import '../services/base_http_client.dart';

class ImageGenerationClient {
  final BaseHTTPClient _httpClient = BaseHTTPClient();
  final APIConfig _config = APIConfig();
  final Logger _logger = Logger();

  // ========== DALL-E 3 IMAGE GENERATION ==========

  Future<String?> generateImage({
    required String prompt,
    ImageSize size = ImageSize.large,
    ImageQuality quality = ImageQuality.standard,
    ImageStyle style = ImageStyle.vivid,
  }) async {
    try {
      final apiKey = await _config.openaiApiKey;

      if (apiKey.isEmpty) {
        throw Exception('OpenAI API key not found');
      }

      final request = DalleRequest(
        prompt: prompt,
        size: _getSizeString(size),
        quality: _getQualityString(quality),
        style: _getStyleString(style),
      );

      _logger.d('Generating image with DALL-E 3...');

      final response = await _httpClient.post(
        '${APIConfig.openaiBaseUrl}${APIConfig.openaiImageEndpoint}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: request.toJson(),
      );

      final jsonResponse = jsonDecode(response.body);
      final dalleResponse = DalleResponse.fromJson(jsonResponse);

      if (dalleResponse.data.isEmpty) {
        throw Exception('No image generated');
      }

      final imageUrl = dalleResponse.data.first.url;
      final revisedPrompt = dalleResponse.data.first.revisedPrompt;

      _logger.i('Image generated successfully');
      if (revisedPrompt != null) {
        _logger.d('Revised prompt: $revisedPrompt');
      }

      // Download and save image
      final savedPath = await _downloadAndSaveImage(imageUrl, prompt);
      return savedPath;
    } catch (e) {
      _logger.e('Image generation error: $e');
      rethrow;
    }
  }

  // ========== STABLE DIFFUSION (via Hugging Face) ==========

  Future<String?> generateImageStableDiffusion({
    required String prompt,
    String model = 'stabilityai/stable-diffusion-2-1',
  }) async {
    try {
      // Note: You'll need a Hugging Face API key
      final apiKey = ''; // Add your Hugging Face API key

      if (apiKey.isEmpty) {
        throw Exception('Hugging Face API key not found');
      }

      _logger.d('Generating image with Stable Diffusion...');

      final response = await http.post(
        Uri.parse('https://api-inference.huggingface.co/models/$model'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'inputs': prompt}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }

      // Save image bytes
      final bytes = response.bodyBytes;
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/sd_$timestamp.png');
      await file.writeAsBytes(bytes);

      _logger.i('Stable Diffusion image saved');
      return file.path;
    } catch (e) {
      _logger.e('Stable Diffusion error: $e');
      rethrow;
    }
  }

  // ========== IMAGE EDITING ==========

  Future<String?> editImage({
    required File originalImage,
    required File maskImage,
    required String prompt,
  }) async {
    try {
      final apiKey = await _config.openaiApiKey;

      if (apiKey.isEmpty) {
        throw Exception('OpenAI API key not found');
      }

      _logger.d('Editing image with DALL-E...');

      // Create multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${APIConfig.openaiBaseUrl}/images/edits'),
      );

      request.headers['Authorization'] = 'Bearer $apiKey';

      request.files.add(
        await http.MultipartFile.fromPath('image', originalImage.path),
      );

      request.files.add(
        await http.MultipartFile.fromPath('mask', maskImage.path),
      );

      request.fields['prompt'] = prompt;
      request.fields['n'] = '1';
      request.fields['size'] = '1024x1024';

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        throw Exception('Failed to edit image: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body);
      final dalleResponse = DalleResponse.fromJson(jsonResponse);

      final imageUrl = dalleResponse.data.first.url;
      final savedPath = await _downloadAndSaveImage(imageUrl, 'edited');

      _logger.i('Image edited successfully');
      return savedPath;
    } catch (e) {
      _logger.e('Image editing error: $e');
      rethrow;
    }
  }

  // ========== HELPER METHODS ==========

  Future<String> _downloadAndSaveImage(String url, String description) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = description
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
          .substring(0, description.length > 20 ? 20 : description.length);
      final file = File('${directory.path}/${filename}_$timestamp.png');

      await file.writeAsBytes(response.bodyBytes);

      _logger.i('Image saved to: ${file.path}');
      return file.path;
    } catch (e) {
      _logger.e('Error saving image: $e');
      rethrow;
    }
  }

  String _getSizeString(ImageSize size) {
    switch (size) {
      case ImageSize.small:
        return '256x256';
      case ImageSize.medium:
        return '512x512';
      case ImageSize.large:
        return '1024x1024';
      case ImageSize.landscape:
        return '1792x1024';
      case ImageSize.portrait:
        return '1024x1792';
    }
  }

  String _getQualityString(ImageQuality quality) {
    return quality == ImageQuality.hd ? 'hd' : 'standard';
  }

  String _getStyleString(ImageStyle style) {
    return style == ImageStyle.vivid ? 'vivid' : 'natural';
  }
}
```

---

### Step 3: Create Image Generation Screen

```dart
// lib/screens/image_generation_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/image_generation_models.dart';
import '../services/image_generation_client.dart';

class ImageGenerationScreen extends StatefulWidget {
  const ImageGenerationScreen({Key? key}) : super(key: key);

  @override
  State<ImageGenerationScreen> createState() => _ImageGenerationScreenState();
}

class _ImageGenerationScreenState extends State<ImageGenerationScreen> {
  final ImageGenerationClient _client = ImageGenerationClient();
  final TextEditingController _promptController = TextEditingController();

  String? _generatedImagePath;
  bool _isGenerating = false;
  ImageSize _selectedSize = ImageSize.large;
  ImageQuality _selectedQuality = ImageQuality.standard;
  ImageStyle _selectedStyle = ImageStyle.vivid;

  Future<void> _generateImage() async {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a prompt')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _generatedImagePath = null;
    });

    try {
      final imagePath = await _client.generateImage(
        prompt: prompt,
        size: _selectedSize,
        quality: _selectedQuality,
        style: _selectedStyle,
      );

      setState(() {
        _generatedImagePath = imagePath;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Generation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prompt input
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Describe the image you want',
                hintText: 'A serene lake at sunset with mountains...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Quick prompts
            Wrap(
              spacing: 8,
              children: [
                _quickPromptChip('A futuristic city at night'),
                _quickPromptChip('A cute robot playing guitar'),
                _quickPromptChip('Abstract colorful galaxy'),
                _quickPromptChip('Photorealistic cat portrait'),
              ],
            ),
            const SizedBox(height: 16),

            // Settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    // Size
                    const Text('Size'),
                    SegmentedButton<ImageSize>(
                      segments: const [
                        ButtonSegment(
                          value: ImageSize.large,
                          label: Text('Square'),
                        ),
                        ButtonSegment(
                          value: ImageSize.landscape,
                          label: Text('Landscape'),
                        ),
                        ButtonSegment(
                          value: ImageSize.portrait,
                          label: Text('Portrait'),
                        ),
                      ],
                      selected: {_selectedSize},
                      onSelectionChanged: (Set<ImageSize> newSelection) {
                        setState(() => _selectedSize = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quality
                    const Text('Quality'),
                    SegmentedButton<ImageQuality>(
                      segments: const [
                        ButtonSegment(
                          value: ImageQuality.standard,
                          label: Text('Standard'),
                        ),
                        ButtonSegment(
                          value: ImageQuality.hd,
                          label: Text('HD'),
                        ),
                      ],
                      selected: {_selectedQuality},
                      onSelectionChanged: (Set<ImageQuality> newSelection) {
                        setState(() => _selectedQuality = newSelection.first);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Style
                    const Text('Style'),
                    SegmentedButton<ImageStyle>(
                      segments: const [
                        ButtonSegment(
                          value: ImageStyle.vivid,
                          label: Text('Vivid'),
                        ),
                        ButtonSegment(
                          value: ImageStyle.natural,
                          label: Text('Natural'),
                        ),
                      ],
                      selected: {_selectedStyle},
                      onSelectionChanged: (Set<ImageStyle> newSelection) {
                        setState(() => _selectedStyle = newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Generate button
            ElevatedButton.icon(
              onPressed: _isGenerating ? null : _generateImage,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isGenerating ? 'Generating...' : 'Generate Image'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Generated image
            if (_isGenerating)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Creating your image...'),
                      SizedBox(height: 8),
                      Text(
                        'This may take 10-30 seconds',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            if (_generatedImagePath != null && !_isGenerating)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(_generatedImagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share functionality
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Save to gallery functionality
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _quickPromptChip(String prompt) {
    return ActionChip(
      label: Text(prompt),
      onPressed: () {
        setState(() {
          _promptController.text = prompt;
        });
      },
    );
  }
}
```

---

## Part 2: Speech-to-Text

Already integrated in Lesson 6! Uses `speech_to_text` package.

**Key Features**:
- Real-time speech recognition
- Multiple language support
- Confidence scores
- Continuous listening

---

## Part 3: Text-to-Speech

### Add Dependency

```yaml
dependencies:
  flutter_tts: ^3.8.3
```

### Create TTS Service

```dart
// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // 0.0 to 1.0
    await _tts.setVolume(1.0); // 0.0 to 1.0
    await _tts.setPitch(1.0); // 0.5 to 2.0

    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> pause() async {
    await _tts.pause();
  }

  Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages;
  }

  Future<void> setLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  Future<void> setVoice(Map<String, String> voice) async {
    await _tts.setVoice(voice);
  }
}
```

### Use in Chat

```dart
// In MessageBubble widget, add speak button
IconButton(
  icon: const Icon(Icons.volume_up, size: 16),
  onPressed: () {
    TTSService().speak(message.content);
  },
  tooltip: 'Read aloud',
)
```

---

## Part 4: Advanced Vision Features

### Background Removal (using remove.bg API)

```dart
// lib/services/image_processing_service.dart
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageProcessingService {
  static const String removeBgApiKey = 'your-remove-bg-api-key';

  Future<String?> removeBackground(File imageFile) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.remove.bg/v1.0/removebg'),
      );

      request.headers['X-Api-Key'] = removeBgApiKey;
      request.fields['size'] = 'auto';
      request.files.add(
        await http.MultipartFile.fromPath('image_file', imageFile.path),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();

        final directory = await getApplicationDocumentsDirectory();
        final outputFile = File('${directory.path}/no_bg_${DateTime.now().millisecondsSinceEpoch}.png');
        await outputFile.writeAsBytes(bytes);

        return outputFile.path;
      }

      return null;
    } catch (e) {
      print('Background removal error: $e');
      return null;
    }
  }

  // Image upscaling (using AI upscaler API)
  Future<String?> upscaleImage(File imageFile, {int scale = 2}) async {
    // Implement using services like:
    // - Deep AI Image Upscaler
    // - Let's Enhance API
    // - Topaz Labs API
    return null;
  }
}
```

---

## Part 5: Combining Features - AI Photo Editor

```dart
// lib/screens/ai_photo_editor_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_client.dart';
import '../services/image_processing_service.dart';
import '../services/image_generation_client.dart';

class AIPhotoEditorScreen extends StatefulWidget {
  const AIPhotoEditorScreen({Key? key}) : super(key: key);

  @override
  State<AIPhotoEditorScreen> createState() => _AIPhotoEditorScreenState();
}

class _AIPhotoEditorScreenState extends State<AIPhotoEditorScreen> {
  final ImagePicker _picker = ImagePicker();
  final GeminiClient _geminiClient = GeminiClient();
  final ImageProcessingService _processingService = ImageProcessingService();

  File? _selectedImage;
  String _analysisResult = '';
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _analysisResult = '';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isProcessing = true);

    final response = await _geminiClient.analyzeImage(
      imageFile: _selectedImage!,
      prompt: 'Analyze this image in detail. Describe objects, colors, mood, and suggest improvements.',
    );

    setState(() {
      _isProcessing = false;
      if (response.isSuccess) {
        _analysisResult = response.content!;
      }
    });
  }

  Future<void> _removeBackground() async {
    if (_selectedImage == null) return;

    setState(() => _isProcessing = true);

    final result = await _processingService.removeBackground(_selectedImage!);

    setState(() => _isProcessing = false);

    if (result != null) {
      setState(() {
        _selectedImage = File(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Photo Editor'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage == null)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Select Image'),
                      ),
                    ],
                  ),
                ),
              ),

            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(_selectedImage!),
              ),
              const SizedBox(height: 16),

              // Action buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _analyzeImage,
                    icon: const Icon(Icons.analytics),
                    label: const Text('Analyze'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _removeBackground,
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Remove BG'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Image'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Analysis result
              if (_analysisResult.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Analysis',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Divider(),
                        Text(_analysisResult),
                      ],
                    ),
                  ),
                ),
            ],

            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
```

---

## Cost Optimization for Image Generation

### 1. Cache Generated Images

```dart
final Map<String, String> _imageCache = {};

Future<String?> generateImageCached(String prompt) async {
  if (_imageCache.containsKey(prompt)) {
    return _imageCache[prompt];
  }

  final result = await generateImage(prompt: prompt);
  if (result != null) {
    _imageCache[prompt] = result;
  }

  return result;
}
```

### 2. Use Lower Quality for Previews

```dart
// Generate preview (cheap)
final preview = await generateImage(
  prompt: prompt,
  quality: ImageQuality.standard,
  size: ImageSize.medium,
);

// If user likes it, generate HD version
final hd = await generateImage(
  prompt: prompt,
  quality: ImageQuality.hd,
  size: ImageSize.large,
);
```

### 3. Implement Generation Quotas

```dart
class GenerationQuota {
  static int _dailyGenerations = 0;
  static const int dailyLimit = 10;

  static bool canGenerate() {
    return _dailyGenerations < dailyLimit;
  }

  static void incrementCount() {
    _dailyGenerations++;
  }

  static void resetDaily() {
    _dailyGenerations = 0;
  }
}
```

---

## Summary

You now have advanced AI features:

- ✅ **Image Generation** with DALL-E 3
- ✅ **Stable Diffusion** integration
- ✅ **Image Editing** capabilities
- ✅ **Vision AI** for image analysis
- ✅ **Speech-to-Text** for voice input
- ✅ **Text-to-Speech** for voice output
- ✅ **Background Removal**
- ✅ **Combined AI photo editor**

**Next lesson**: Production considerations - rate limiting, error handling, cost management, caching, and deployment!
