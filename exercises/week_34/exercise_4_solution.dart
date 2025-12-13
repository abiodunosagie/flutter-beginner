/// Exercise 4 Solution: Media Messages
///
/// This solution demonstrates:
/// - Image picker integration (camera and gallery)
/// - Video picker integration
/// - Firebase Storage upload with progress tracking
/// - Image compression to optimize storage
/// - Cached network image loading
/// - Video playback with controls
/// - Full-screen media viewers
/// - Proper error handling and permissions

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: ChatScreen(chatPartnerId: 'demo', chatPartnerName: 'Demo User'),
    );
  }
}

// Enhanced ChatMessage model with media support
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final List<String> readBy;
  final List<String> deliveredTo;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.readBy = const [],
    this.deliveredTo = const [],
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      mediaType: data['mediaType'],
      mediaUrl: data['mediaUrl'],
      thumbnailUrl: data['thumbnailUrl'],
      readBy: List<String>.from(data['readBy'] ?? []),
      deliveredTo: List<String>.from(data['deliveredTo'] ?? []),
    );
  }

  bool get hasMedia => mediaType != null && mediaUrl != null;
  bool get isImage => mediaType == 'image';
  bool get isVideo => mediaType == 'video';
}

// MediaService for uploading files
class MediaService {
  static Future<String> uploadImage(
    File imageFile,
    String userId,
    Function(double) onProgress,
  ) async {
    // Compress image first
    final compressedFile = await compressImage(imageFile);

    // Generate unique filename
    final filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = FirebaseStorage.instance
        .ref()
        .child('users/$userId/images/$filename');

    // Upload with progress tracking
    final uploadTask = ref.putFile(compressedFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress(progress);
    });

    await uploadTask;

    // Get download URL
    final downloadUrl = await ref.getDownloadURL();

    // Clean up compressed file
    try {
      await compressedFile.delete();
    } catch (_) {}

    return downloadUrl;
  }

  static Future<String> uploadVideo(
    File videoFile,
    String userId,
    Function(double) onProgress,
  ) async {
    // Check file size (limit to 50MB)
    final fileSize = await videoFile.length();
    if (fileSize > 50 * 1024 * 1024) {
      throw Exception('Video size must be less than 50MB');
    }

    // Generate unique filename
    final filename = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    final ref = FirebaseStorage.instance
        .ref()
        .child('users/$userId/videos/$filename');

    // Upload with progress tracking
    final uploadTask = ref.putFile(videoFile);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      final progress = snapshot.bytesTransferred / snapshot.totalBytes;
      onProgress(progress);
    });

    await uploadTask;

    // Get download URL
    return await ref.getDownloadURL();
  }

  static Future<File> compressImage(File file) async {
    // Read image
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw Exception('Failed to decode image');

    // Resize if too large (max 1024px on longest side)
    img.Image resized = image;
    if (image.width > 1024 || image.height > 1024) {
      if (image.width > image.height) {
        resized = img.copyResize(image, width: 1024);
      } else {
        resized = img.copyResize(image, height: 1024);
      }
    }

    // Compress as JPEG with 85% quality
    final compressed = img.encodeJpg(resized, quality: 85);

    // Save to temporary file
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(compressed);

    return tempFile;
  }
}

// Enhanced MessageBubble with media display
class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String currentUserId;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSentByMe = message.senderId == currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSentByMe) ...[
            CircleAvatar(
              backgroundColor: Colors.blue[300],
              child: Text(
                message.senderName[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 280),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue[600] : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: isSentByMe ? Radius.circular(18) : Radius.circular(4),
                  bottomRight: isSentByMe ? Radius.circular(4) : Radius.circular(18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media content
                  if (message.hasMedia) _buildMediaWidget(context),

                  // Text content
                  if (message.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSentByMe ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _formatTime(message.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: isSentByMe ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Timestamp only (if no text)
                  if (message.text.isEmpty && message.hasMedia)
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSentByMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaWidget(BuildContext context) {
    if (message.isImage && message.mediaUrl != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewer(imageUrl: message.mediaUrl!),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          child: CachedNetworkImage(
            imageUrl: message.mediaUrl!,
            placeholder: (context, url) => Container(
              width: 200,
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Icon(Icons.error),
            ),
            fit: BoxFit.cover,
            width: 250,
          ),
        ),
      );
    } else if (message.isVideo && message.mediaUrl != null) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: message.mediaUrl!),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          child: Container(
            width: 250,
            height: 140,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Video thumbnail (you could generate actual thumbnails)
                Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Video',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ImageViewer for fullscreen image viewing
class ImageViewer extends StatelessWidget {
  final String imageUrl;

  const ImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // TODO: Implement download
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download functionality not implemented')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// VideoPlayerScreen for fullscreen video playback
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.replay_10, color: Colors.white, size: 32),
                        onPressed: () {
                          final newPosition = _controller.value.position - Duration(seconds: 10);
                          _controller.seekTo(newPosition);
                        },
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.forward_10, color: Colors.white, size: 32),
                        onPressed: () {
                          final newPosition = _controller.value.position + Duration(seconds: 10);
                          _controller.seekTo(newPosition);
                        },
                      ),
                    ],
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

// ChatScreen with media sending capability
class ChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;

  const ChatScreen({
    Key? key,
    required this.chatPartnerId,
    required this.chatPartnerName,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  bool _isUploading = false;
  double _uploadProgress = 0.0;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendTextMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': text,
        'senderId': currentUser!.uid,
        'senderName': currentUser!.displayName ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
        'readBy': [],
        'deliveredTo': [widget.chatPartnerId],
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      _showError('Failed to send message: $e');
    }
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      final file = File(pickedFile.path);

      // Upload image
      final imageUrl = await MediaService.uploadImage(
        file,
        currentUser!.uid,
        (progress) {
          setState(() => _uploadProgress = progress);
        },
      );

      // Send message with image
      await _sendMediaMessage(
        mediaType: 'image',
        mediaUrl: imageUrl,
      );

      setState(() => _isUploading = false);
      _scrollToBottom();
    } catch (e) {
      setState(() => _isUploading = false);
      _showError('Failed to send image: $e');
    }
  }

  Future<void> _pickAndSendVideo() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      // Check file size
      final fileSize = await file.length();
      if (fileSize > 50 * 1024 * 1024) {
        _showError('Video size must be less than 50MB');
        return;
      }

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Upload video
      final videoUrl = await MediaService.uploadVideo(
        file,
        currentUser!.uid,
        (progress) {
          setState(() => _uploadProgress = progress);
        },
      );

      // Send message with video
      await _sendMediaMessage(
        mediaType: 'video',
        mediaUrl: videoUrl,
      );

      setState(() => _isUploading = false);
      _scrollToBottom();
    } catch (e) {
      setState(() => _isUploading = false);
      _showError('Failed to send video: $e');
    }
  }

  Future<void> _sendMediaMessage({
    String? text,
    required String mediaType,
    required String mediaUrl,
    String? thumbnailUrl,
  }) async {
    await FirebaseFirestore.instance.collection('messages').add({
      'text': text ?? '',
      'senderId': currentUser!.uid,
      'senderName': currentUser!.displayName ?? 'User',
      'timestamp': FieldValue.serverTimestamp(),
      'mediaType': mediaType,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'readBy': [],
      'deliveredTo': [widget.chatPartnerId],
    });
  }

  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndSendImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: Colors.green),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndSendImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.video_library, color: Colors.orange),
                title: Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                  _pickAndSendVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatPartnerName),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromFirestore(doc))
                    .toList();

                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages yet.\nStart the conversation!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  );
                }

                _scrollToBottom();

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      message: messages[index],
                      currentUserId: currentUser!.uid,
                    );
                  },
                );
              },
            ),
          ),

          // Upload progress indicator
          if (_isUploading)
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),

          if (_isUploading)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),

          Divider(height: 1),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, -1),
            blurRadius: 4,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.attach_file, color: Colors.grey[600]),
              onPressed: _isUploading ? null : _showMediaOptions,
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  maxLines: null,
                  enabled: !_isUploading,
                  onSubmitted: (_) => _sendTextMessage(),
                ),
              ),
            ),

            SizedBox(width: 8),

            Container(
              decoration: BoxDecoration(
                color: _isUploading ? Colors.grey : Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: _isUploading ? null : _sendTextMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
