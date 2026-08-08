enum TripStatus {
  searching,
  accepted,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

class TripLifecycle {
  static const Map<TripStatus, Set<TripStatus>> _allowed = {
    TripStatus.searching: {TripStatus.accepted, TripStatus.cancelled},
    TripStatus.accepted: {TripStatus.driverArriving, TripStatus.cancelled},
    TripStatus.driverArriving: {TripStatus.inProgress, TripStatus.cancelled},
    TripStatus.inProgress: {TripStatus.completed, TripStatus.cancelled},
  };

  static bool canTransition(TripStatus from, TripStatus to) =>
      _allowed[from]?.contains(to) ?? false;

  static void assertTransition(TripStatus from, TripStatus to) {
    if (!canTransition(from, to)) {
      throw StateError('Illegal trip transition: $from → $to');
    }
  }
}
