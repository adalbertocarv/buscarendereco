import 'package:latlong2/latlong.dart';
import 'package:buscaendereco/models/stop.dart';

class Helpers {
  static Stop findNearestStop(LatLng location, List<Stop> stops) {
    Stop nearestStop = stops.first;
    double minDistance = _calculateDistance(location, nearestStop.location);

    for (Stop stop in stops) {
      double distance = _calculateDistance(location, stop.location);
      if (distance < minDistance) {
        nearestStop = stop;
        minDistance = distance;
      }
    }

    return nearestStop;
  }

  static double _calculateDistance(LatLng start, LatLng end) {
    final Distance distance = Distance();
    return distance.as(LengthUnit.Meter, start, end);
  }
}
