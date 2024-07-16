// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:buscaendereco/services/geolocator_service.dart';
import 'package:buscaendereco/models/marker.dart';
import 'package:buscaendereco/utils/helpers.dart';
import 'package:buscaendereco/models/stop.dart';
import 'package:buscaendereco/models/address.dart';

class MapScreen extends StatefulWidget {
  final Address destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _userLocation = LatLng(0, 0);
  List<Marker> _markers = [];
  final MarkerService _markerService = MarkerService();

  @override
  void initState() {
    super.initState();
    _setUserLocation();
  }

  void _setUserLocation() async {
    _userLocation = await GeolocatorService.getCurrentLocation();
    _setNearestStops();
  }

  void _setNearestStops() {
    final startStop = Helpers.findNearestStop(_userLocation, stops);
    final endStop = Helpers.findNearestStop(
        LatLng(widget.destination.lat, widget.destination.lon), stops);

    setState(() {
      _markers = [
        _markerService.createMarkerFromStop(startStop),
        _markerService.createMarkerFromAddress(widget.destination),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mapa'),
        ),
        body: Stack(children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(-15.78869450034934, -47.88936481492598),
              zoom: 16,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              /* maxBounds: LatLngBounds(
                LatLng(-16.17864544023852, -48.4366282004513),
                LatLng(-15.388611133575429, -47.2832140703871),
              ),*/ // limite do mapa
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
        ]
        )
    );
  }
}
