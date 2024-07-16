import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math';

class Helpers {
  static Marker findNearestMarker(LatLng location, List<Marker> markers) {
    Marker? nearestMarker;
    double minDistance = double.infinity;

    for (var marker in markers) {
      final distance = distanceBetween(location, marker.point);
      if (distance < minDistance) {
        minDistance = distance;
        nearestMarker = marker;
      }
    }

    return nearestMarker!;
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