# App 05: Ride Hailing — Complete Start-to-Finish

> Build an **Uber/Bolt-style** system: rider requests, driver accepts, trip lifecycle, map UI, fares. This is what hiring managers mean by “can you build real apps?”

**Time:** 25–40 hours (full MVP)  
**Minimum levels:** 06–08 + 12 (maps/location). Firebase (11) recommended for multi-device.  
**Modes:**  
- **A — Solo MVP (mock backend):** one app, role switch, in-memory / local mock drivers  
- **B — Production shape:** Rider app + Driver app (or role flag) + Firestore backend  

Do **Mode A fully**, then upgrade pieces to **Mode B**.

---

## 1. Product brief

### Personas

| Persona | Goals |
|---------|--------|
| **Rider** | Set pickup/dropoff, see estimate, request ride, track driver, pay (mock), rate |
| **Driver** | Go online, receive requests, accept/reject, navigate trip states, earn |
| **System** | Match, price, enforce trip state machine |

### MVP scope (ship this)

1. Auth (email) or guest demo mode  
2. Rider home with map + pickup/dropoff  
3. Fare estimate  
4. Request ride → waiting  
5. Driver online queue → accept  
6. Trip states: `accepted → arriving → inProgress → completed`  
7. Trip history  
8. Simple rating  

### Explicit non-goals (v1)

- Real card payments (show UI only or mock)  
- Surge ML  
- Multiple stops  
- Admin console  

---

## 2. Why employers care

You demonstrate:

- **Domain state machines** (trip lifecycle)  
- **Maps & location**  
- **Role-based UX**  
- **Realtime** matching (Firestore streams or mock streams)  
- **Separation of domain vs UI**  

---

## 3. Domain model

```dart
enum UserRole { rider, driver }

enum TripStatus {
  idle,
  searching,      // rider waiting for match
  accepted,       // driver accepted
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

class GeoPointLite {
  final double lat;
  final double lng;
  const GeoPointLite(this.lat, this.lng);
}

class Trip {
  final String id;
  final String riderId;
  final String? driverId;
  final GeoPointLite pickup;
  final GeoPointLite dropoff;
  final String pickupAddress;
  final String dropoffAddress;
  final double estimatedFare;
  final double distanceKm;
  final TripStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

### State machine (hard rules)

```
searching → accepted → driverArriving → inProgress → completed
    ↘ cancelled          ↘ cancelled      ↘ cancelled
accepted cannot go back to searching
completed is terminal
only driver moves arriving → inProgress → completed
rider or driver may cancel before inProgress (policy)
```

Encode transitions in one place:

```dart
class TripLifecycle {
  static bool canTransition(TripStatus from, TripStatus to) {
    const allowed = {
      TripStatus.searching: {TripStatus.accepted, TripStatus.cancelled},
      TripStatus.accepted: {TripStatus.driverArriving, TripStatus.cancelled},
      TripStatus.driverArriving: {TripStatus.inProgress, TripStatus.cancelled},
      TripStatus.inProgress: {TripStatus.completed, TripStatus.cancelled},
    };
    return allowed[from]?.contains(to) ?? false;
  }
}
```

---

## 4. Architecture

```
lib/
  main.dart
  app.dart
  core/
    theme.dart
    router.dart
    result.dart
  domain/
    models/
    trip_lifecycle.dart
    fare_calculator.dart
  data/
    repositories/
      trip_repository.dart
      auth_repository.dart
      location_repository.dart
    datasources/
      mock_trip_datasource.dart
      firestore_trip_datasource.dart
  features/
    auth/
    rider/
      home_map_page.dart
      confirm_ride_page.dart
      trip_tracking_page.dart
    driver/
      driver_home_page.dart
      incoming_request_sheet.dart
      active_trip_page.dart
    history/
      trip_history_page.dart
  shared/
    map/
    widgets/
```

**Repository pattern:** UI never talks to Firestore directly.

---

## 5. Fare calculator (deterministic)

```dart
class FareCalculator {
  static const base = 2.50;
  static const perKm = 1.20;
  static const perMinute = 0.25;
  static const minFare = 5.00;

  /// rough haversine distance
  static double distanceKm(GeoPointLite a, GeoPointLite b) {
    const r = 6371.0;
    final dLat = _rad(b.lat - a.lat);
    final dLng = _rad(b.lng - a.lng);
    final x = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(a.lat)) * cos(_rad(b.lat)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(x), sqrt(1 - x));
    return r * c;
  }

  static double estimate({
    required GeoPointLite pickup,
    required GeoPointLite dropoff,
    double avgSpeedKmh = 28,
  }) {
    final km = distanceKm(pickup, dropoff);
    final minutes = (km / avgSpeedKmh) * 60;
    final raw = base + perKm * km + perMinute * minutes;
    return double.parse((raw < minFare ? minFare : raw).toStringAsFixed(2));
  }

  static double _rad(double d) => d * pi / 180;
}
```

---

## 6. Mode A — Mock matching (learn the UX first)

`MockTripDatasource`:

- Rider `requestTrip` → creates trip `searching`  
- Timer 2s later (or driver app button) → assign `driverId`, status `accepted`  
- Stream trips via `StreamController`  

```dart
class MockTripRepository implements TripRepository {
  final _controller = StreamController<List<Trip>>.broadcast();
  final _trips = <Trip>[];

  @override
  Stream<List<Trip>> watchForUser(String userId, UserRole role) {
    return _controller.stream.map((all) {
      if (role == UserRole.rider) {
        return all.where((t) => t.riderId == userId).toList();
      }
      return all.where((t) => t.driverId == userId || t.status == TripStatus.searching).toList();
    });
  }

  @override
  Future<Trip> requestRide({
    required String riderId,
    required GeoPointLite pickup,
    required GeoPointLite dropoff,
    required String pickupAddress,
    required String dropoffAddress,
  }) async {
    final fare = FareCalculator.estimate(pickup: pickup, dropoff: dropoff);
    final trip = Trip(
      id: UniqueKey().toString(),
      riderId: riderId,
      driverId: null,
      pickup: pickup,
      dropoff: dropoff,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      estimatedFare: fare,
      distanceKm: FareCalculator.distanceKm(pickup, dropoff),
      status: TripStatus.searching,
      createdAt: DateTime.now(),
    );
    _trips.add(trip);
    _emit();
    return trip;
  }

  void _emit() => _controller.add(List.unmodifiable(_trips));

  Future<void> acceptTrip(String tripId, String driverId) async {
    final i = _trips.indexWhere((t) => t.id == tripId);
    if (i < 0) return;
    final t = _trips[i];
    if (!TripLifecycle.canTransition(t.status, TripStatus.accepted)) {
      throw StateError('illegal transition');
    }
    _trips[i] = t.copyWith(driverId: driverId, status: TripStatus.accepted, updatedAt: DateTime.now());
    _emit();
  }

  // advanceStatus similarly...
}
```

Build UI completely on mocks. Then swap datasource.

---

## 7. Mode B — Firestore shape

### Collections

```
users/{uid} { role, name, isOnline, heading, location }
trips/{tripId} { ...trip fields, status }
drivers_online/{uid} { location, updatedAt }  // optional geo queries later
```

### Rider request

```dart
await trips.add({
  'riderId': uid,
  'driverId': null,
  'status': 'searching',
  'pickup': GeoPoint(lat, lng),
  'dropoff': GeoPoint(...),
  'estimatedFare': fare,
  'createdAt': FieldValue.serverTimestamp(),
});
```

### Driver listens for open trips

```dart
FirebaseFirestore.instance
  .collection('trips')
  .where('status', isEqualTo: 'searching')
  .snapshots();
```

### Accept (transaction)

```dart
await db.runTransaction((tx) async {
  final snap = await tx.get(tripRef);
  if (snap['status'] != 'searching') throw Exception('taken');
  tx.update(tripRef, {
    'status': 'accepted',
    'driverId': driverId,
  });
});
```

### Rules (sketch)

- Riders create trips with their uid  
- Drivers update only if `driverId == auth.uid` or accepting searching  
- Riders read own trips; drivers read assigned + searching  

Write full rules before demo day.

---

## 8. Feature build order (do not skip)

### Phase 1 — Skeleton (Day 1–2)

- [ ] Role picker (Rider / Driver) after login  
- [ ] Bottom nav or separate home shells  
- [ ] Theme + router  

### Phase 2 — Rider map (Day 3–5)

- [ ] `google_maps_flutter` map  
- [ ] Current location (permission flow + denied UI)  
- [ ] Tap/long-press set dropoff (MVP: fixed dropoff search field)  
- [ ] Polyline optional  
- [ ] Confirm sheet: distance + fare  

**Packages:**

```yaml
google_maps_flutter: ^2.5.0
geolocator: ^12.0.0
permission_handler: ^11.0.0
```

Platform keys: Android manifest + iOS AppDelegate API keys (never commit secrets; use `--dart-define` or local config).

### Phase 3 — Request + tracking (Day 6–8)

- [ ] Request button → `searching` UI (pulse animation)  
- [ ] Listen trip status stream  
- [ ] Status banner: “Finding driver…” / “Driver accepted” / “On trip”  
- [ ] Cancel button while allowed  

### Phase 4 — Driver app (Day 9–12)

- [ ] Online toggle  
- [ ] List/stream of `searching` trips with fare + distance  
- [ ] Accept → navigate active trip  
- [ ] Buttons: Arrived | Start trip | Complete  
- [ ] Illegal transitions show error  

### Phase 5 — History & polish (Day 13–15)

- [ ] Completed trips list  
- [ ] Rating 1–5 dialog  
- [ ] Empty/error states  
- [ ] Basic unit tests on `FareCalculator` + `TripLifecycle`  

### Phase 6 — Backend upgrade (optional)

- [ ] Firebase auth  
- [ ] Firestore trips  
- [ ] Transaction accept  
- [ ] Two physical devices test  

---

## 9. Screen inventory

| Screen | Role | Notes |
|--------|------|-------|
| Login / Register | both | |
| Role home | both | |
| Rider map | rider | core |
| Confirm ride | rider | fare |
| Searching | rider | |
| Trip live | rider | status |
| Driver online | driver | list |
| Active trip | driver | actions |
| History | both | |
| Profile | both | |

---

## 10. UX details that look “senior”

1. **Disable double tap** on Request / Accept (loading flags)  
2. **Optimistic UI** only when safe; accept uses transaction  
3. **Permission preflight** education screen before system dialog  
4. **Status chip colors** for trip states  
5. **Money formatting** with `NumberFormat.simpleCurrency`  
6. **Time estimates** “~12 min” from distance/speed  

---

## 11. Testing plan

### Unit

```dart
test('min fare applies', () {
  final fare = FareCalculator.estimate(
    pickup: GeoPointLite(0, 0),
    dropoff: GeoPointLite(0.001, 0.001),
  );
  expect(fare >= FareCalculator.minFare, true);
});

test('cannot complete from searching', () {
  expect(TripLifecycle.canTransition(TripStatus.searching, TripStatus.completed), false);
});
```

### Manual E2E (two accounts)

1. Driver online  
2. Rider requests A→B  
3. Driver sees request, accepts  
4. Rider sees accepted  
5. Driver: arriving → start → complete  
6. Both see completed history  

---

## 12. Portfolio README section

Include:

- Architecture diagram (roles + trip machine)  
- GIF of request → accept → complete  
- Tech: Flutter, maps, streams, Firestore  
- Tradeoffs: mock vs realtime matching, geoqueries later (GeoFlutterFire / geohash)  

---

## 13. Stretch (after MVP)

| Feature | Notes |
|---------|--------|
| Driver location stream on rider map | update GeoPoint every 3–5s |
| Chat rider↔driver | reuse App 04 patterns |
| Stripe payment hold | server-side only |
| Admin cancel | cloud function |
| Multiple vehicle types | fare multipliers |

---

## 14. Implementation notes file

Create in your project:

`docs/TRIP_STATE_MACHINE.md` — paste the transition table.  
`docs/API_CONTRACT.md` — if you add a custom backend later.

---

## Big idea

Ride-hailing is not “a map widget.” It is a **shared trip state machine** with two clients and strict transitions. Master that, and maps become decoration.
