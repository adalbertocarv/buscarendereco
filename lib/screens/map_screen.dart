import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:buscareferencia/services/geolocator_service.dart';
import 'package:buscareferencia/models/marker.dart';
import 'package:buscareferencia/utils/helpers.dart';
import 'package:buscareferencia/models/stop.dart';
import 'package:buscareferencia/models/address.dart';
import 'package:buscareferencia/screens/bus_line_screen.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapScreen extends StatefulWidget {
  final Address destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

// localização do usuário
class _MapScreenState extends State<MapScreen> {
  LatLng _userLocation = LatLng(0, 0);
  List<Marker> _markers = [];
  List<Stop> _stops = [];
  Stop? _nearestStartStop;
  Stop? _nearestEndStop;
  final MarkerService _markerService = MarkerService();

  @override
  void initState() {
    super.initState();
    _setUserLocation();
    _fetchStops();
  }

  void _setUserLocation() async {
    _userLocation = await GeolocatorService.getCurrentLocation();
    _setNearestStops();
  }

  void _setNearestStops() async {
    try {
      final stops = await StopService.fetchStops();
      final userLocation = await GeolocatorService.getCurrentLocation();
      final destination = widget.destination;

      // Calcula a parada mais próxima do usuário
      final nearestStartStop = Helpers.findNearestStop(userLocation, stops);

      // Calcula a parada mais próxima do endereço selecionado
      final nearestEndStop = Helpers.findNearestStop(LatLng(destination.lat, destination.lon), stops);

      // Printa no console as paradas mais próximas
      print('Parada mais próxima do usuário: ${nearestStartStop.point}');
      print('Parada mais próxima do endereço selecionado: ${nearestEndStop.point}');

      // Cria um marcador verde para a localização do usuário
      Marker userLocationMarker = _markerService.createMarkerFromLatLng(userLocation, Colors.green);

      // Cria um marcador azul para o endereço de destino
      Marker destinationMarker = _markerService.createMarkerFromLatLng(LatLng(widget.destination.lat, widget.destination.lon), Colors.blue);

      setState(() {
        _stops = stops;
        _markers = [
          userLocationMarker, // Adiciona o marcador da localização do usuário
          destinationMarker, // Adiciona o marcador do destino
          ...stops.map((stop) => _markerService.createMarkerFromStop(stop)), // Adiciona os marcadores das paradas
        ];
        _nearestStartStop = nearestStartStop;
        _nearestEndStop = nearestEndStop;
      });
    } catch (e) {
      print('Erro ao definir as paradas mais próximas: $e');
    }
  }

  void _fetchStops() async {
    try {
      final stops = await StopService.fetchStops();
      setState(() {
        _stops = stops;
        _markers.addAll(stops.map((stop) => _markerService.createMarkerFromStop(stop)));
      });
    } catch (e) {
      print('falha para buscar paradas: $e');
    }
  }

  void _navigateToBusLines() {
    if (_nearestStartStop != null && _nearestEndStop != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BusLinesScreen(
            startStopCode: _nearestStartStop!.codDftrans,
            endStopCode: _nearestEndStop!.codDftrans,
          ),
        ),
      );
    } else {
      // Handle the case where nearest stops are not available
      print('Paradas mais próximas não disponíveis');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-15.78869450034934, -47.88936481492598),
          //center: _userLocation,
          zoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          // Substituir MarkerLayer por MarkerClusterLayerWidget para clustering
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 70,
              size: Size(50, 50),
              markers: _markers,
              builder: (context, markers) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    markers.length.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _navigateToBusLines,
            child: Text('Ver Linhas de Ônibus'),
          ),
        ],
      ),
    );
  }
}
