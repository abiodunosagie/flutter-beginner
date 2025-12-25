// Example 04: URL Launcher
// Open websites, make calls, send emails and SMS

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Launcher Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const URLLauncherScreen(),
    );
  }
}

class URLLauncherScreen extends StatelessWidget {
  const URLLauncherScreen({super.key});

  // ══════════════════════════════════════════════════════════
  // LAUNCH METHODS
  // ══════════════════════════════════════════════════════════

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError(context, 'Cannot open $url');
    }
  }

  Future<void> _launchWebsite(BuildContext context, String url, {bool inApp = false}) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: inApp ? LaunchMode.inAppWebView : LaunchMode.externalApplication,
      );
    } else {
      _showError(context, 'Cannot open $url');
    }
  }

  Future<void> _makePhoneCall(BuildContext context, String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError(context, 'Cannot make call');
    }
  }

  Future<void> _sendEmail(BuildContext context, {
    required String to,
    String subject = '',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError(context, 'Cannot send email');
    }
  }

  Future<void> _sendSMS(BuildContext context, String number, {String message = ''}) async {
    final uri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: message.isNotEmpty ? {'body': message} : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showError(context, 'Cannot send SMS');
    }
  }

  Future<void> _openMaps(BuildContext context, String query) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}';
    await _launchUrl(context, url);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Launcher'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ════════════════════════════════════════════════
          // WEBSITES
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.language,
            title: 'Open Website',
            children: [
              _buildActionTile(
                icon: Icons.open_in_browser,
                title: 'Open in Browser',
                subtitle: 'flutter.dev',
                onTap: () => _launchWebsite(context, 'https://flutter.dev'),
              ),
              _buildActionTile(
                icon: Icons.web,
                title: 'Open In-App',
                subtitle: 'Opens in WebView',
                onTap: () => _launchWebsite(
                  context,
                  'https://flutter.dev',
                  inApp: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // PHONE
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.phone,
            title: 'Phone Call',
            children: [
              _buildActionTile(
                icon: Icons.call,
                title: 'Call Number',
                subtitle: '+1 (555) 123-4567',
                onTap: () => _makePhoneCall(context, '+15551234567'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // EMAIL
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.email,
            title: 'Email',
            children: [
              _buildActionTile(
                icon: Icons.mail,
                title: 'Send Email',
                subtitle: 'hello@example.com',
                onTap: () => _sendEmail(
                  context,
                  to: 'hello@example.com',
                  subject: 'Hello from Flutter!',
                  body: 'This email was sent from a Flutter app.',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // SMS
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.message,
            title: 'SMS',
            children: [
              _buildActionTile(
                icon: Icons.sms,
                title: 'Send SMS',
                subtitle: '+1 (555) 123-4567',
                onTap: () => _sendSMS(
                  context,
                  '+15551234567',
                  message: 'Hello from Flutter!',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // MAPS
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.map,
            title: 'Maps',
            children: [
              _buildActionTile(
                icon: Icons.location_on,
                title: 'Open Location',
                subtitle: 'Times Square, New York',
                onTap: () => _openMaps(context, 'Times Square, New York'),
              ),
              _buildActionTile(
                icon: Icons.restaurant,
                title: 'Find Nearby',
                subtitle: 'Restaurants near me',
                onTap: () => _openMaps(context, 'restaurants near me'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // SOCIAL MEDIA
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.share,
            title: 'Social Media',
            children: [
              _buildActionTile(
                icon: Icons.flutter_dash,
                title: 'Flutter Twitter',
                subtitle: '@FlutterDev',
                onTap: () => _launchUrl(context, 'https://twitter.com/FlutterDev'),
              ),
              _buildActionTile(
                icon: Icons.code,
                title: 'Flutter GitHub',
                subtitle: 'github.com/flutter',
                onTap: () => _launchUrl(context, 'https://github.com/flutter'),
              ),
              _buildActionTile(
                icon: Icons.play_circle,
                title: 'YouTube',
                subtitle: 'Flutter Channel',
                onTap: () => _launchUrl(
                  context,
                  'https://www.youtube.com/@flutterdev',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ════════════════════════════════════════════════
          // APP STORES
          // ════════════════════════════════════════════════

          _buildSection(
            context,
            icon: Icons.store,
            title: 'App Stores',
            children: [
              _buildActionTile(
                icon: Icons.android,
                title: 'Play Store',
                subtitle: 'Open app page',
                onTap: () => _launchUrl(
                  context,
                  'https://play.google.com/store/apps/details?id=com.google.android.apps.maps',
                ),
              ),
              _buildActionTile(
                icon: Icons.apple,
                title: 'App Store',
                subtitle: 'Open app page',
                onTap: () => _launchUrl(
                  context,
                  'https://apps.apple.com/app/id585027354',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Icon(icon, size: 20)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/*
 * ═══════════════════════════════════════════════════════════════
 * SETUP REQUIRED
 * ═══════════════════════════════════════════════════════════════
 *
 * 1. Add to pubspec.yaml:
 *    dependencies:
 *      url_launcher: ^6.2.1
 *
 * 2. iOS - Add to ios/Runner/Info.plist:
 *    <key>LSApplicationQueriesSchemes</key>
 *    <array>
 *      <string>https</string>
 *      <string>http</string>
 *      <string>tel</string>
 *      <string>mailto</string>
 *      <string>sms</string>
 *    </array>
 *
 * 3. Android - Add to android/app/src/main/AndroidManifest.xml:
 *    <queries>
 *      <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
 *      <intent><action android:name="android.intent.action.DIAL"/><data android:scheme="tel"/></intent>
 *      <intent><action android:name="android.intent.action.SENDTO"/><data android:scheme="mailto"/></intent>
 *      <intent><action android:name="android.intent.action.SENDTO"/><data android:scheme="sms"/></intent>
 *    </queries>
 *
 * ═══════════════════════════════════════════════════════════════
 */
