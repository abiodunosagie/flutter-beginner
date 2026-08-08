import 'package:flutter_test/flutter_test.dart';
import 'package:ride_hail_starter/domain/trip_lifecycle.dart';

void main() {
  test('searching cannot complete directly', () {
    expect(
      TripLifecycle.canTransition(TripStatus.searching, TripStatus.completed),
      false,
    );
  });

  test('happy path transitions', () {
    expect(TripLifecycle.canTransition(TripStatus.searching, TripStatus.accepted), true);
    expect(TripLifecycle.canTransition(TripStatus.accepted, TripStatus.driverArriving), true);
    expect(TripLifecycle.canTransition(TripStatus.driverArriving, TripStatus.inProgress), true);
    expect(TripLifecycle.canTransition(TripStatus.inProgress, TripStatus.completed), true);
  });
}
