import 'package:latlong2/latlong.dart';

class Stop {
  final String name;
  final LatLng location;

  Stop({required this.name, required this.location});
}

// Definindo algumas paradas de exemplo em Brasília
List<Stop> stops = [
  Stop(name: 'Parada 1', location: LatLng(-15.7801, -47.9292)),
  Stop(name: 'Parada 2', location: LatLng(-15.7942, -47.8822)),
  Stop(name: 'Parada 3', location: LatLng(-15.8087, -47.8756)),
  // Adicione mais paradas conforme necessário
];
