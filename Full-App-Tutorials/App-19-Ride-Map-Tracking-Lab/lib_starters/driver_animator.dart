// Copy into your map lab project: lib/map/driver_animator.dart
// Pure Dart — no Google Maps dependency. Feed output into Marker position.

import 'dart:async';

class GeoPointLite {
  final double lat;
  final double lng;
  const GeoPointLite(this.lat, this.lng);
}

/// Animates a point from [from] to [to] over [duration].
class DriverAnimator {
  DriverAnimator({
    required this.from,
    required this.to,
    this.duration = const Duration(seconds: 12),
    this.tick = const Duration(milliseconds: 200),
  });

  final GeoPointLite from;
  final GeoPointLite to;
  final Duration duration;
  final Duration tick;

  final _controller = StreamController<GeoPointLite>.broadcast();
  Timer? _timer;
  var _t = 0.0;

  Stream<GeoPointLite> get stream => _controller.stream;

  void start() {
    stop();
    _t = 0;
    final steps = duration.inMilliseconds / tick.inMilliseconds;
    _timer = Timer.periodic(tick, (timer) {
      _t += 1 / steps;
      if (_t >= 1) {
        _controller.add(to);
        stop();
        return;
      }
      _controller.add(_lerp(from, to, _t));
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
    _controller.close();
  }

  static GeoPointLite _lerp(GeoPointLite a, GeoPointLite b, double t) => GeoPointLite(
        a.lat + (b.lat - a.lat) * t,
        a.lng + (b.lng - a.lng) * t,
      );
}
