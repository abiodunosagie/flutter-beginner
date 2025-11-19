/// Exercise 4: Media Messages (Intermediate-Advanced)
///
/// Level: Intermediate-Advanced
/// Estimated Time: 3-4 hours
///
/// Task:
/// Enable users to send images and videos in the chat:
/// - Pick images from camera or gallery
/// - Pick videos from gallery
/// - Upload to Firebase Storage
/// - Show upload progress
/// - Compress images before uploading
/// - Generate and display video thumbnails
/// - Full-screen image/video viewer
///
/// Requirements:
/// 1. Integrate image_picker for camera/gallery access
/// 2. Upload images/videos to Firebase Storage
/// 3. Show upload progress indicator
/// 4. Compress images to reduce file size
/// 5. Display images in message bubbles
/// 6. Play videos inline or in fullscreen
/// 7. Handle permissions for camera/gallery
///
/// Dependencies (add to pubspec.yaml):
/// image_picker: ^1.0.4
/// firebase_storage: ^11.5.0
/// video_player: ^2.8.1
/// cached_network_image: ^3.3.0
/// image: ^4.1.3  (for compression)
///
/// Firestore Structure Update:
/// messages/
///   {messageId}/
///     text: string (optional if media message)
///     senderId: string
///     senderName: string
///     timestamp: timestamp
///     readBy: array<string>
///     deliveredTo: array<string>
///     mediaType: string? ('image' | 'video' | null)
///     mediaUrl: string? (Firebase Storage URL)
///     thumbnailUrl: string? (for videos)
///
/// Learning Goals:
/// - File handling in Flutter
/// - Firebase Storage operations
/// - Image compression
/// - Video playback
/// - Progress tracking
/// - Permission handling

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// TODO: Import these packages
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:image/image.dart' as img;
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

// TODO: Enhanced ChatMessage model with media support
class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? mediaType; // 'image', 'video', or null
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

  // TODO: Create fromFirestore factory with media fields
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

// TODO: Create MediaService for uploading files
class MediaService {
  // TODO: Upload image to Firebase Storage
  static Future<String> uploadImage(File imageFile, String userId) async {
    // 1. Compress image
    // 2. Generate unique filename
    // 3. Upload to Firebase Storage: users/{userId}/images/{filename}
    // 4. Return download URL

    throw UnimplementedError();
  }

  // TODO: Upload video to Firebase Storage
  static Future<String> uploadVideo(File videoFile, String userId) async {
    // 1. Generate unique filename
    // 2. Upload to Firebase Storage: users/{userId}/videos/{filename}
    // 3. Return download URL

    throw UnimplementedError();
  }

  // TODO: Compress image
  static Future<File> compressImage(File file) async {
    // Read image
    // Resize if too large (max 1024x1024)
    // Compress JPEG quality to 85%
    // Save to temporary file
    // Return compressed file

    throw UnimplementedError();
  }
}

// TODO: Enhanced MessageBubble with media display
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
        children: [
          if (!isSentByMe) ...[
            CircleAvatar(child: Text(message.senderName[0])),
            SizedBox(width: 8),
          ],

          // TODO: Create message container with media support
          Flexible(
            child: Column(
              crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSentByMe ? Colors.blue[600] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: Display media if present
                      if (message.hasMedia) ...[
                        _buildMediaWidget(context),
                        if (message.text.isNotEmpty) SizedBox(height: 8),
                      ],

                      // TODO: Display text if present
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isSentByMe ? Colors.white : Colors.black87,
                          ),
                        ),

                      // TODO: Add timestamp
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Build media widget based on type
  Widget _buildMediaWidget(BuildContext context) {
    if (message.isImage) {
      // TODO: Display image with CachedNetworkImage
      // Make it tappable to open fullscreen
      return Container(); // Replace
    } else if (message.isVideo) {
      // TODO: Display video thumbnail with play button
      // Open video player on tap
      return Container(); // Replace
    }
    return SizedBox.shrink();
  }
}

// TODO: Create ImageViewer for fullscreen image viewing
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
      ),
      body: Center(
        // TODO: Display image with InteractiveViewer for zoom
        child: Container(),
      ),
    );
  }
}

// TODO: Create VideoPlayerWidget
class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // TODO: Create VideoPlayerController

  @override
  void initState() {
    super.initState();
    // TODO: Initialize video player
  }

  @override
  void dispose() {
    // TODO: Dispose video player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Build video player UI with play/pause controls
    return Container();
  }
}

// TODO: ChatScreen with media sending capability
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
  // final _imagePicker = ImagePicker();

  bool _isUploading = false;
  double _uploadProgress = 0.0;

  User? get currentUser => FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // TODO: Implement _sendTextMessage
  Future<void> _sendTextMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add message to Firestore without media fields
  }

  // TODO: Implement _pickAndSendImage
  Future<void> _pickAndSendImage(ImageSource source) async {
    // 1. Pick image using ImagePicker
    // 2. If image selected, show uploading state
    // 3. Compress image
    // 4. Upload to Firebase Storage with progress tracking
    // 5. Send message with mediaType: 'image' and mediaUrl
    // 6. Hide uploading state
  }

  // TODO: Implement _pickAndSendVideo
  Future<void> _pickAndSendVideo() async {
    // 1. Pick video using ImagePicker
    // 2. Check video size (limit to 50MB)
    // 3. Show uploading state
    // 4. Upload to Firebase Storage with progress tracking
    // 5. Send message with mediaType: 'video' and mediaUrl
    // 6. Hide uploading state
  }

  // TODO: Send media message to Firestore
  Future<void> _sendMediaMessage({
    String? text,
    required String mediaType,
    required String mediaUrl,
    String? thumbnailUrl,
  }) async {
    // Add message document with media fields
  }

  // TODO: Show media options (Camera, Gallery, Video)
  void _showMediaOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Camera option
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickAndSendImage(ImageSource.camera);
                },
              ),
              // TODO: Gallery option
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickAndSendImage(ImageSource.gallery);
                },
              ),
              // TODO: Video option
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Video'),
                onTap: () {
                  Navigator.pop(context);
                  // _pickAndSendVideo();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatPartnerName)),
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

                return ListView.builder(
                  controller: _scrollController,
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

          // TODO: Show upload progress indicator
          if (_isUploading)
            LinearProgressIndicator(value: _uploadProgress),

          Divider(height: 1),

          // Message input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(8),
      child: SafeArea(
        child: Row(
          children: [
            // TODO: Attachment button - opens media options
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: _showMediaOptions,
            ),

            // Text field
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onSubmitted: (_) => _sendTextMessage(),
              ),
            ),

            // Send button
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: _sendTextMessage,
            ),
          ],
        ),
      ),
    );
  }
}

/*
HINTS:

1. Pick image:
   final XFile? image = await ImagePicker().pickImage(
     source: ImageSource.gallery,
     imageQuality: 80,
   );

2. Compress image:
   final bytes = await file.readAsBytes();
   final image = img.decodeImage(bytes);
   final resized = img.copyResize(image!, width: 1024);
   final compressed = img.encodeJpg(resized, quality: 85);
   final compressedFile = File('${file.path}_compressed.jpg');
   await compressedFile.writeAsBytes(compressed);

3. Upload to Firebase Storage with progress:
   final ref = FirebaseStorage.instance
       .ref()
       .child('users/${userId}/images/${DateTime.now().millisecondsSinceEpoch}.jpg');

   final uploadTask = ref.putFile(file);

   uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
     setState(() {
       _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
     });
   });

   await uploadTask;
   final downloadUrl = await ref.getDownloadURL();

4. Display image with CachedNetworkImage:
   CachedNetworkImage(
     imageUrl: message.mediaUrl!,
     placeholder: (context, url) => CircularProgressIndicator(),
     errorWidget: (context, url, error) => Icon(Icons.error),
     fit: BoxFit.cover,
     width: 200,
     height: 200,
   )

5. Video player:
   late VideoPlayerController _controller;

   @override
   void initState() {
     super.initState();
     _controller = VideoPlayerController.network(widget.videoUrl)
       ..initialize().then((_) {
         setState(() {});
       });
   }

   @override
   Widget build(BuildContext context) {
     return _controller.value.isInitialized
         ? AspectRatio(
             aspectRatio: _controller.value.aspectRatio,
             child: VideoPlayer(_controller),
           )
         : CircularProgressIndicator();
   }

6. Permissions (add to AndroidManifest.xml):
   <uses-permission android:name="android.permission.CAMERA"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

7. Permissions (add to iOS Info.plist):
   <key>NSCameraUsageDescription</key>
   <string>Need camera access to take photos</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Need gallery access to select photos</string>

8. Check file size:
   final fileSize = await file.length();
   if (fileSize > 50 * 1024 * 1024) { // 50MB
     // Show error
   }
*/
