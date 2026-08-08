# App 19: Ride Map Tracking Lab — Complete Tutorial

> Extends App 05 / `ride_hail_starter` with **maps, polylines, and driver location stream**.

**Time:** 12–20 hours · **Min level:** 12 + App 05  
**Packages:** `google_maps_flutter`, `geolocator`, `permission_handler`

## Features

- [ ] Permission preflight screen  
- [ ] Map with pickup + dropoff markers  
- [ ] Polyline between points (or decode directions API stretch)  
- [ ] Driver marker updates every 2–3s (mock path or GPS)  
- [ ] Camera follows driver during `inProgress`  
- [ ] Status banner over map  

## Mock driver movement

```dart
// Interpolate lat/lng from pickup → dropoff over N ticks
GeoPointLite lerp(GeoPointLite a, GeoPointLite b, double t) => GeoPointLite(
  a.lat + (b.lat - a.lat) * t,
  a.lng + (b.lng - a.lng) * t,
);
```

## Build order

1. Static map + two markers  
2. Wire trip status from mock repo  
3. Animate driver marker on accept  
4. Real GPS for rider pickup pin  
5. Background location **only if** you understand platform policies  

## Safety / policy

Background location requires clear disclosure and Play/App Store justification. For the portfolio, foreground mock animation is enough.

## Test script

1. Request ride → map shows route ends  
2. Accept as driver → driver marker moves  
3. Complete → stop updates  

## Portfolio blurb

> Map-centric ride tracking lab with markers, polyline, and simulated driver movement tied to trip states.

## File map

```
lib/
  map/trip_map.dart
  map/driver_animator.dart
  pages/rider_map_page.dart
```

## Google Maps keys

Use `--dart-define=GOOGLE_MAPS_API_KEY=...` and inject into Android manifest / iOS AppDelegate via your preferred secure method. Never commit unrestricted keys.

## Integration with ride_hail_starter

1. Copy trip domain from sample-apps  
2. Replace status list UI with map scaffold  
3. On status `accepted`/`inProgress`, start animator  

## Done when

Driver accept causes visible marker motion from pickup toward dropoff.
