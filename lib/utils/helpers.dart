import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:buscareferencia/models/stop.dart';

class Helpers {
  // Encontra a parada mais próxima de uma localização específica (LatLng)
  static Stop findNearestStop(LatLng location, List<Stop> stops) {
    Stop? nearestStop;
    double minDistance = double.infinity;

    for (var stop in stops) {
      final distance = distanceBetween(location, stop.point); // Calcula a distância
      if (distance < minDistance) {
        minDistance = distance;
        nearestStop = stop;
      }
    }

    return nearestStop!;
  }

  // Calcula a distância entre dois pontos LatLng usando a fórmula do haversine
  static double distanceBetween(LatLng latLng1, LatLng latLng2) {
    final double radius = 6371; // Raio da Terra em km
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

// Extensão da classe LatLng para converter latitude e longitude em radianos
extension on LatLng {
  double get latitudeInRad => latitude * pi / 180;
  double get longitudeInRad => longitude * pi / 180;
}
