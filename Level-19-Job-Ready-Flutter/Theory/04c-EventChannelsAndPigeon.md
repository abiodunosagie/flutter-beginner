# Event Channels and Pigeon: Streams and Type Safety

## The Big Idea In One Sentence

> Use an **EventChannel** when native pushes a continuous stream of values to Dart, and use **Pigeon** when you want the compiler, not your memory, to keep both sides of the bridge in agreement.

---

## Part 1: EventChannel

A `MethodChannel` is a phone call: you ask, you get one answer. An `EventChannel` is a radio station: you tune in and values keep arriving until you tune out.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   MethodChannel     "What is the battery level?"     │
│                     -> 87. Done.                     │
│                                                      │
│   EventChannel      "Tell me whenever it changes."   │
│                     -> 87 ... 86 ... 86 ... 85 ...   │
│                                                      │
│   Use EventChannel for: sensors, location updates,   │
│   Bluetooth scans, download progress, connectivity   │
│   changes, audio position, barcode scan results.     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### The Dart side

```dart
class BatteryService {
  static const EventChannel _events =
      EventChannel('com.example.myapp/battery_stream');

  Stream<int> get batteryLevelStream => _events
      .receiveBroadcastStream()
      .map((event) => event as int)
      .handleError((Object error) {
        if (error is PlatformException) {
          debugPrint('Battery stream error: ${error.code}');
        }
      });
}
```

Using it in a widget:

```dart
StreamBuilder<int>(
  stream: batteryService.batteryLevelStream,
  builder: (context, snapshot) {
    if (snapshot.hasError) return const Text('Battery unavailable');
    if (!snapshot.hasData) return const CircularProgressIndicator();
    return Text('${snapshot.data}%');
  },
)
```

Or, feeding a bloc (the pattern from Part 2):

```dart
Future<void> _onSubscribed(BatterySubscribed event, Emitter<BatteryState> emit) {
  return emit.forEach<int>(
    _service.batteryLevelStream,
    onData: (level) => state.copyWith(level: level),
  );
}
```

The critical detail: `receiveBroadcastStream()` starts the native stream on the **first** listener and stops it when the **last** listener cancels. So a stream nobody listens to costs nothing, and forgetting to cancel keeps the sensor running and drains the battery. Cancel in `dispose` or `close`.

### The Android side (Kotlin)

```kotlin
EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.myapp/battery_stream")
    .setStreamHandler(object : EventChannel.StreamHandler {
        private var running = false

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            running = true
            Thread {
                while (running) {
                    val level = getBatteryLevel()
                    runOnUiThread { events?.success(level) }   // main thread!
                    Thread.sleep(1000)
                }
            }.start()
        }

        override fun onCancel(arguments: Any?) {
            running = false      // stop the work, release the sensor
        }
    })
```

`onListen` starts producing, `onCancel` must stop and release everything. A stream handler that ignores `onCancel` is the classic native memory and battery leak.

### The iOS side (Swift)

```swift
class BatteryStreamHandler: NSObject, FlutterStreamHandler {
  private var timer: Timer?

  func onListen(
    withArguments arguments: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    UIDevice.current.isBatteryMonitoringEnabled = true
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      events(Int(UIDevice.current.batteryLevel * 100))
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    timer?.invalidate()
    timer = nil
    return nil
  }
}

// In AppDelegate:
let stream = FlutterEventChannel(
  name: "com.example.myapp/battery_stream",
  binaryMessenger: controller.binaryMessenger
)
stream.setStreamHandler(BatteryStreamHandler())
```

The three sink calls are `events(value)` for data, `events(FlutterError(...))` for an error, and `events(FlutterEndOfEventStream)` to close the stream.

---

## Part 2: Pigeon

Hand written channels have one weakness: the two sides agree only by convention. Rename a method on the native side and nothing complains until a user taps the button.

Pigeon fixes that. You describe the interface **once in Dart**, and it generates the Dart, Kotlin, and Swift code for both ends.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   HAND WRITTEN CHANNEL                               │
│   'getBatteryLevel'  typed as a string on both       │
│   sides. Arguments are a Map you unpack by hand.     │
│   Mistakes appear at runtime, on one platform.       │
│                                                      │
│   PIGEON                                             │
│   You write an abstract Dart class.                  │
│   Pigeon generates:                                  │
│     • a Dart class with real method signatures       │
│     • a Kotlin interface you must implement          │
│     • a Swift protocol you must implement            │
│   Mistakes appear at COMPILE time, on both.          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### Step 1: Add pigeon (dev dependency only, it ships no runtime code)

```yaml
dev_dependencies:
  pigeon: ^26.2.0
```

### Step 2: Describe the interface

`pigeons/battery_api.dart`:

```dart
import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/generated/battery_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/myapp/BatteryApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.myapp'),
    swiftOut: 'ios/Runner/BatteryApi.g.swift',
    dartPackageName: 'myapp',
  ),
)
// A data class that crosses the boundary, fields and all.
class BatteryInfo {
  BatteryInfo({required this.level, required this.isCharging, this.health});

  int level;
  bool isCharging;
  String? health;
}

// Dart CALLS these; the native side IMPLEMENTS them.
@HostApi()
abstract class BatteryHostApi {
  BatteryInfo getBatteryInfo();

  @async
  bool requestOptimisationExemption();
}

// The native side CALLS these; Dart IMPLEMENTS them.
@FlutterApi()
abstract class BatteryFlutterApi {
  void onBatteryLow(int level);
}
```

### Step 3: Generate

```bash
dart run pigeon --input pigeons/battery_api.dart
```

Pigeon writes all three files. You never edit them; you re-run the command after changing the definition.

### Step 4: Use it

```dart
// Dart: a real, typed API. No channel names, no string method names.
final api = BatteryHostApi();
final info = await api.getBatteryInfo();
print('${info.level}% charging=${info.isCharging}');
```

```kotlin
// Kotlin: implement the generated interface. If you get the signature
// wrong, the project does not compile.
class BatteryImpl(private val context: Context) : BatteryHostApi {
    override fun getBatteryInfo(): BatteryInfo {
        val bm = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return BatteryInfo(
            level = bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY).toLong(),
            isCharging = bm.isCharging,
            health = null,
        )
    }

    override fun requestOptimisationExemption(callback: (Result<Boolean>) -> Unit) {
        callback(Result.success(true))
    }
}

// Register it once:
BatteryHostApi.setUp(flutterEngine.dartExecutor.binaryMessenger, BatteryImpl(context))
```

```swift
// Swift: implement the generated protocol.
class BatteryImpl: BatteryHostApi {
  func getBatteryInfo() throws -> BatteryInfo {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    return BatteryInfo(
      level: Int64(device.batteryLevel * 100),
      isCharging: device.batteryState == .charging,
      health: nil
    )
  }

  func requestOptimisationExemption(completion: @escaping (Result<Bool, Error>) -> Void) {
    completion(.success(true))
  }
}

// Register it once:
BatteryHostApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: BatteryImpl())
```

Note that Pigeon maps Dart `int` to Kotlin `Long` and Swift `Int64`, because the boundary uses 64 bit integers. The generated file is the source of truth for exact signatures; read it once and the mapping is obvious.

---

## Choosing Between Them

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   MethodChannel                                      │
│   • one or two simple calls                          │
│   • a quick spike                                    │
│   • you want zero build steps                        │
│                                                      │
│   EventChannel                                       │
│   • native pushes values continuously                │
│                                                      │
│   Pigeon                                             │
│   • more than a couple of methods                    │
│   • structured data (classes, enums, lists)          │
│   • a team, where a rename must not break silently   │
│   • you are writing a plugin package                 │
│                                                      │
│   Pigeon does not replace EventChannel for streams;  │
│   for continuous data use an EventChannel, or a      │
│   @FlutterApi callback that native invokes.          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Interview answer: "Method channels for one or two calls, Pigeon once the surface grows or the data has structure, because Pigeon turns a runtime typo into a compile error on both platforms."

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • EventChannel = a stream from native to Dart      │
│   • receiveBroadcastStream starts on first listener  │
│   • onCancel MUST stop the work, or it leaks         │
│   • Sink calls: value, FlutterError, EndOfEventStream│
│   • Pigeon generates Dart + Kotlin + Swift from one  │
│     Dart definition                                  │
│   • @HostApi = Dart calls native                     │
│   • @FlutterApi = native calls Dart                  │
│   • Never edit generated files; re-run pigeon        │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** When do you choose `EventChannel` over `MethodChannel`?

<details>
<summary>Answer</summary>
When the native side produces a continuous stream of values (sensors, location, progress, connectivity) rather than answering a single question.
</details>

**Q2.** What must `onCancel` do, and what happens if it does nothing?

<details>
<summary>Answer</summary>
It must stop the producer and release the resource (timer, sensor, listener). If it does nothing, the native work keeps running after Dart stopped listening, which drains the battery and leaks memory.
</details>

**Q3.** What is the concrete advantage of Pigeon over a hand written channel?

<details>
<summary>Answer</summary>
Both sides are generated from one definition, so method names, argument types, and data classes are checked by the Dart, Kotlin, and Swift compilers. A mismatch fails the build instead of failing on a user's phone.
</details>

---

## Assignment

### Problem 1: Pick the channel

Choose Method or Event for each: read the device model once, receive step counts all day, upload a file and report progress, check whether NFC is available.

### Problem 2: Fix the leak

A location `EventChannel` keeps the GPS on after the user leaves the map screen. Name the two places that could be at fault.

### Problem 3: Write the Pigeon definition

Write a Pigeon `@HostApi` for a scanner SDK with `startScan()`, `stopScan()`, and an async `Future<String> readTag()`.

### Problem 4: Explain the direction

What is the difference between `@HostApi` and `@FlutterApi`?

---

## Assignment Answers

### Problem 1: Pick the channel

- Device model once: `MethodChannel`
- Step counts all day: `EventChannel`
- Upload progress: `EventChannel` (a stream of percentages)
- NFC availability: `MethodChannel`

### Problem 2: Fix the leak

1. The Dart side never cancelled its `StreamSubscription`, so the last listener never went away and `onCancel` was never called.
2. The native `onCancel` ran but did not actually stop the location updates (it did not remove the listener or invalidate the timer).

### Problem 3: Write the Pigeon definition

```dart
@HostApi()
abstract class ScannerHostApi {
  void startScan();
  void stopScan();

  @async
  String readTag();
}
```

`@async` is needed on `readTag` because the native side must wait for hardware before answering.

### Problem 4: Explain the direction

`@HostApi` describes methods Dart calls and native implements (Dart to native). `@FlutterApi` describes methods native calls and Dart implements (native to Dart), which is how you deliver callbacks and push events without an `EventChannel`.

---

## Navigation

⬅️ **Previous:** [Method Channels](04b-MethodChannels.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Flutter On The Web](04d-FlutterOnWeb.md)
