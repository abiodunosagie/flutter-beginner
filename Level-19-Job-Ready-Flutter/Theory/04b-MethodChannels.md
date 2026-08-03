# Method Channels: Calling Native Code From Dart

## The Big Idea In One Sentence

> A **MethodChannel** is a named pipe between Dart and native code: Dart calls a method name with arguments, the native side answers, and both sides must agree on the name and the types.

---

## The Simple Explanation

Flutter draws its own pixels, so it can do nearly everything by itself. But it cannot read the battery level, talk to a payment SDK, or use a Bluetooth device without asking the operating system. A method channel is the phone line for that request.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   DART SIDE                    NATIVE SIDE           │
│   ─────────                    ───────────           │
│                                                      │
│   MethodChannel('battery')     MethodChannel(same    │
│         │                       name, same string)   │
│         │                              │             │
│   invokeMethod('getLevel') ──────────► onMethodCall  │
│                                        │             │
│                                    read battery      │
│                                        │             │
│   returns 87   ◄─────────────────  result.success(87)│
│                                                      │
│   The channel name must match EXACTLY on both sides. │
│   A typo produces MissingPluginException.            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Use a reverse domain name so two packages cannot collide: `com.yourcompany.yourapp/battery`.

---

## The Dart Side

```dart
import 'package:flutter/services.dart';

class BatteryService {
  static const MethodChannel _channel =
      MethodChannel('com.example.myapp/battery');

  Future<int> getBatteryLevel() async {
    try {
      final level = await _channel.invokeMethod<int>('getBatteryLevel');
      return level ?? -1;
    } on PlatformException catch (e) {
      // The native side called result.error(...)
      debugPrint('Battery error: ${e.code} ${e.message}');
      return -1;
    } on MissingPluginException {
      // No native implementation on this platform (web, desktop, or a typo)
      return -1;
    }
  }

  Future<void> setBrightness(double value) async {
    await _channel.invokeMethod<void>('setBrightness', {'value': value});
  }
}
```

Three things to notice, all of which come up in interviews:

1. Every call is **asynchronous**, always. There is no synchronous path across the boundary.
2. There are two different failures: `PlatformException` (the native code ran and reported an error) and `MissingPluginException` (there is no native code listening at all).
3. Arguments are passed as a `Map`, and only certain types survive the trip.

### Types that cross the boundary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Dart              Android (Kotlin)   iOS (Swift)   │
│   ────              ────────────────   ───────────   │
│   null              null               nil           │
│   bool              Boolean            NSNumber      │
│   int               Int / Long         NSNumber      │
│   double            Double             NSNumber      │
│   String            String             String        │
│   Uint8List         ByteArray          FlutterStandardTypedData
│   List              ArrayList          NSArray       │
│   Map               HashMap            NSDictionary  │
│                                                      │
│   Your own classes do NOT cross. Convert them to a   │
│   Map first, or use Pigeon (next lesson).            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## The Android Side (Kotlin)

`android/app/src/main/kotlin/com/example/myapp/MainActivity.kt`:

```kotlin
package com.example.myapp

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.example.myapp/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getBatteryLevel" -> {
                        val level = getBatteryLevel()
                        if (level >= 0) {
                            result.success(level)
                        } else {
                            result.error("UNAVAILABLE", "Battery level not available", null)
                        }
                    }
                    "setBrightness" -> {
                        val value = call.argument<Double>("value")
                        if (value == null) {
                            result.error("BAD_ARGS", "value is required", null)
                        } else {
                            window.attributes = window.attributes.apply {
                                screenBrightness = value.toFloat()
                            }
                            result.success(null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
```

Key points:

- `configureFlutterEngine` is the hook. Always call `super` first.
- `flutterEngine.dartExecutor.binaryMessenger` is the messenger the channel needs.
- `result.success(value)`, `result.error(code, message, details)`, `result.notImplemented()` are the only three answers.
- `call.argument<T>("name")` reads one named argument, and it can be null.
- **Answer on the main thread.** If you do work on a background thread, hop back before calling `result`, otherwise you get random crashes.

```kotlin
// Background work, answered safely
Thread {
    val data = doSomethingSlow()
    runOnUiThread { result.success(data) }
}.start()
```

---

## The iOS Side (Swift)

`ios/Runner/AppDelegate.swift`:

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController

    let batteryChannel = FlutterMethodChannel(
      name: "com.example.myapp/battery",
      binaryMessenger: controller.binaryMessenger
    )

    batteryChannel.setMethodCallHandler { [weak self] (call, result) in
      switch call.method {
      case "getBatteryLevel":
        self?.receiveBatteryLevel(result: result)
      case "setBrightness":
        guard let args = call.arguments as? [String: Any],
              let value = args["value"] as? Double else {
          result(FlutterError(code: "BAD_ARGS", message: "value is required", details: nil))
          return
        }
        UIScreen.main.brightness = CGFloat(value)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == .unknown {
      result(FlutterError(code: "UNAVAILABLE", message: "Battery level not available", details: nil))
    } else {
      result(Int(device.batteryLevel * 100))
    }
  }
}
```

Key points:

- The Swift equivalents are `result(value)`, `result(FlutterError(...))`, and `result(FlutterMethodNotImplemented)`.
- `controller.binaryMessenger` comes from the root `FlutterViewController`.
- Register the channel **before** `GeneratedPluginRegistrant.register`, and keep `super.application(...)` last.
- Arguments arrive as `[String: Any]`, so cast defensively with `guard let`.

---

## Calling Dart From Native

The pipe runs both ways. The native side can invoke a method on the Dart side:

```kotlin
// Kotlin
channel.invokeMethod("onDeepLinkReceived", mapOf("url" to url))
```

```dart
// Dart: listen for calls coming IN
_channel.setMethodCallHandler((call) async {
  switch (call.method) {
    case 'onDeepLinkReceived':
      final url = call.arguments['url'] as String;
      router.go(Uri.parse(url).path);
      return null;
    default:
      throw MissingPluginException('${call.method} not implemented');
  }
});
```

For a **stream** of values (sensor readings, location updates, download progress), do not spam `invokeMethod`. Use an `EventChannel`, which is the next lesson.

---

## Testing A Method Channel Without A Device

This is the part that impresses in an interview, because it proves you can test native integrations in CI.

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.example.myapp/battery');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      if (call.method == 'getBatteryLevel') return 42;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('returns the level the platform reports', () async {
    expect(await BatteryService().getBatteryLevel(), 42);
  });

  test('returns -1 when the platform reports an error', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      throw PlatformException(code: 'UNAVAILABLE');
    });

    expect(await BatteryService().getBatteryLevel(), -1);
  });
}
```

Both tests run on a laptop with no emulator, because the mock messenger replaces the native side.

---

## Debugging Checklist

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   MissingPluginException                             │
│   • channel names differ (check both strings)        │
│   • the handler was never registered                 │
│   • hot restart is not enough: FULL restart the app  │
│     after editing native code                        │
│   • you are on a platform with no implementation     │
│                                                      │
│   PlatformException                                  │
│   • the native side called result.error on purpose   │
│   • read e.code and e.message, they are yours        │
│                                                      │
│   Returns null unexpectedly                          │
│   • a type mismatch: Kotlin Long into Dart int,      │
│     or a Map with the wrong key                      │
│                                                      │
│   Random crashes                                     │
│   • result called off the main thread on Android     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## When To Write A Channel At All

Check pub.dev first. Camera, location, notifications, biometrics, in app purchase, and sharing all have mature plugins. Write your own channel when:

- You must integrate a company specific native SDK (a payment terminal, a scanner)
- The plugin exists but does not expose the one call you need
- You need performance that only native can give (heavy image or audio work)

Saying "I would check pub.dev first, and write a channel when the SDK is proprietary" is exactly the answer a hiring manager wants for "comfort working with platform specific code".

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • MethodChannel name must match exactly, both      │
│     sides, reverse domain style                      │
│   • Dart: invokeMethod, catch PlatformException      │
│     AND MissingPluginException                       │
│   • Kotlin: configureFlutterEngine + success/error/  │
│     notImplemented, answer on the main thread        │
│   • Swift: AppDelegate + result()/FlutterError/      │
│     FlutterMethodNotImplemented                      │
│   • Only primitives, List, Map, Uint8List cross      │
│   • Native can call Dart too, via setMethodCall-     │
│     Handler on the Dart side                         │
│   • Mock the channel in tests, no device required    │
│   • Full restart after editing native code           │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What is the difference between `PlatformException` and `MissingPluginException`?

<details>
<summary>Answer</summary>
`PlatformException` means the native handler ran and deliberately returned an error. `MissingPluginException` means nothing was listening on that channel at all: a name typo, an unregistered handler, or a platform with no implementation.
</details>

**Q2.** Can you pass a Dart `User` object through a method channel?

<details>
<summary>Answer</summary>
No. Only null, bool, int, double, String, Uint8List, List, and Map cross the boundary. Convert the object to a `Map` first, or use Pigeon to generate type safe bindings.
</details>

**Q3.** Your channel worked yesterday and now throws `MissingPluginException` after you edited `MainActivity.kt`. What is the likely cause?

<details>
<summary>Answer</summary>
A hot reload or hot restart does not rebuild native code. Stop the app and run it again so the new native side is compiled and registered.
</details>

---

## Assignment

### Problem 1: Design the channel

You must call a native "device serial number" API. Write the Dart method, including both error types.

### Problem 2: Answer correctly

In Kotlin, what three responses can a method call handler give, and when do you use each?

### Problem 3: Fix the crash

```kotlin
Thread {
    val data = readSensor()
    result.success(data)
}.start()
```

What is wrong and how do you fix it?

### Problem 4: Test it

Write the setUp block that makes `getSerialNumber` return "ABC123" in a unit test.

---

## Assignment Answers

### Problem 1: Design the channel

```dart
static const _channel = MethodChannel('com.example.myapp/device');

Future<String?> getSerialNumber() async {
  try {
    return await _channel.invokeMethod<String>('getSerialNumber');
  } on PlatformException catch (e) {
    debugPrint('Serial unavailable: ${e.code}');
    return null;
  } on MissingPluginException {
    return null;   // web or desktop, where there is no implementation
  }
}
```

### Problem 2: Answer correctly

- `result.success(value)`: the call worked, here is the answer (value may be null).
- `result.error(code, message, details)`: the call failed in a way the Dart side should handle; it becomes a `PlatformException`.
- `result.notImplemented()`: this handler does not know that method name; it becomes a `MissingPluginException` on the Dart side.

### Problem 3: Fix the crash

`result` is being called from a background thread, which is not allowed. Hop back to the main thread first:

```kotlin
Thread {
    val data = readSensor()
    runOnUiThread { result.success(data) }
}.start()
```

### Problem 4: Test it

```dart
setUp(() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    if (call.method == 'getSerialNumber') return 'ABC123';
    return null;
  });
});
```

---

## Navigation

⬅️ **Previous:** [Platform Aware Code](04a-PlatformAwareCode.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Event Channels and Pigeon](04c-EventChannelsAndPigeon.md)
