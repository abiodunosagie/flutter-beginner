// Example 05: Platform aware code, a method channel, and an event channel.
//
// Runs on Android, iOS, web, and desktop. On platforms with no native side
// the calls degrade gracefully instead of crashing.
//
// The matching native code is in the lesson 04b-MethodChannels.md:
//   Android: android/app/src/main/kotlin/.../MainActivity.kt
//   iOS:     ios/Runner/AppDelegate.swift

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const PlatformApp());

// ---------------------------------------------------------------------------
// One file that answers "where am I?", named by CAPABILITY.
// ---------------------------------------------------------------------------

class AppPlatform {
  const AppPlatform._();

  static bool get isWeb => kIsWeb;

  // kIsWeb FIRST. It is a compile time constant, so on web the compiler
  // removes everything after &&, and dart:io is never touched.
  static bool get isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  static bool get isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static bool get supportsHaptics => isMobile;
  static bool get supportsNativeBattery => isMobile;

  static String get label {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}

// ---------------------------------------------------------------------------
// The channel wrapper. The UI never touches MethodChannel directly.
// ---------------------------------------------------------------------------

class BatteryService {
  static const MethodChannel _method =
      MethodChannel('com.example.myapp/battery');
  static const EventChannel _events =
      EventChannel('com.example.myapp/battery_stream');

  /// Returns the level, or null when this platform has no implementation.
  Future<int?> getBatteryLevel() async {
    if (!AppPlatform.supportsNativeBattery) return null;

    try {
      return await _method.invokeMethod<int>('getBatteryLevel');
    } on PlatformException catch (e) {
      // The native side ran and reported a problem.
      debugPrint('Battery unavailable: ${e.code} ${e.message}');
      return null;
    } on MissingPluginException {
      // Nothing is listening on that channel: a typo, or no native side.
      debugPrint('No native battery implementation on ${AppPlatform.label}');
      return null;
    }
  }

  Stream<int> get batteryStream {
    if (!AppPlatform.supportsNativeBattery) return const Stream<int>.empty();
    return _events.receiveBroadcastStream().map((event) => event as int);
  }
}

// ---------------------------------------------------------------------------
// UI
// ---------------------------------------------------------------------------

class PlatformApp extends StatelessWidget {
  const PlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform aware',
      theme: ThemeData(useMaterial3: true),
      home: const PlatformPage(),
    );
  }
}

class PlatformPage extends StatefulWidget {
  const PlatformPage({super.key});

  @override
  State<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends State<PlatformPage> {
  final _battery = BatteryService();
  String _level = 'not read yet';
  bool _notifications = true;

  Future<void> _readBattery() async {
    if (AppPlatform.supportsHaptics) {
      await HapticFeedback.selectionClick();
    }

    final level = await _battery.getBatteryLevel();
    if (!mounted) return;

    setState(() {
      _level = level == null
          ? 'no native implementation on ${AppPlatform.label}'
          : '$level%';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Running on ${AppPlatform.label}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Row(label: 'kIsWeb', value: '${AppPlatform.isWeb}'),
          _Row(label: 'isMobile', value: '${AppPlatform.isMobile}'),
          _Row(label: 'isDesktop', value: '${AppPlatform.isDesktop}'),
          _Row(label: 'isApple', value: '${AppPlatform.isApple}'),
          _Row(label: 'defaultTargetPlatform', value: '$defaultTargetPlatform'),
          const Divider(height: 32),

          // .adaptive: a CupertinoSwitch on iOS and macOS, Material elsewhere.
          SwitchListTile.adaptive(
            title: const Text('Notifications'),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          const Divider(height: 32),

          Text('Battery: $_level'),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _readBattery,
            child: const Text('Read battery level'),
          ),
          const SizedBox(height: 24),

          // The stream is empty on platforms without a native side, so this
          // widget is safe everywhere.
          StreamBuilder<int>(
            stream: _battery.batteryStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('Stream error');
              if (!snapshot.hasData) return const Text('Live level: waiting');
              return Text('Live level: ${snapshot.data}%');
            },
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
