// NOTES — not a full maps app (needs API keys).
// When you add google_maps_flutter:
//
// GoogleMap(
//   initialCameraPosition: CameraPosition(target: LatLng(pickup.lat, pickup.lng), zoom: 13),
//   markers: {
//     Marker(markerId: MarkerId('pickup'), position: LatLng(pickup.lat, pickup.lng)),
//     Marker(markerId: MarkerId('dropoff'), position: LatLng(dropoff.lat, dropoff.lng)),
//     if (driver != null)
//       Marker(markerId: MarkerId('driver'), position: LatLng(driver.lat, driver.lng),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
//   },
//   polylines: {
//     Polyline(
//       polylineId: PolylineId('route'),
//       points: [LatLng(pickup.lat, pickup.lng), LatLng(dropoff.lat, dropoff.lng)],
//       width: 4,
//     ),
//   },
// )
//
// Listen to DriverAnimator.stream and setState driver position.
// On trip status accepted/inProgress → animator.start().
// On completed/cancelled → animator.stop().
