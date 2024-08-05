import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:buscareferencia/models/stop.dart';

class Helpers {
  static Stop findNearestStop(LatLng location, List<Stop> stops) {
    Stop? nearestStop;
    double minDistance = double.infinity;

    for (var stop in stops) {
      final distance = distanceBetween(location, stop.point);
      if (distance < minDistance) {
        minDistance = distance;
        nearestStop = stop;
      }
    }

    return nearestStop!;
  }

  static double distanceBetween(LatLng latLng1, LatLng latLng2) {
    final double radius = 6371; // Radius of the earth in km
    final double dLat = latLng2.latitudeInRad - latLng1.latitudeInRad;
    final double dLon = latLng2.longitudeInRad - latLng1.longitudeInRad;
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(latLng1.latitudeInRad) *
            cos(latLng2.latitudeInRad) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = radius * c;

    return distance;
  }
}

extension on LatLng {
  double get latitudeInRad => latitude * pi / 180;
  double get longitudeInRad => longitude * pi / 180;
}
