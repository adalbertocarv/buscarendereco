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
    _fetchMarkers();
  }

  void _setUserLocation() async {
    _userLocation = await GeolocatorService.getCurrentLocation();
    _setNearestStops();
  }

  void _setNearestStops() async {
    final markers = await StopService.fetchMarkers();
    final nearestStartMarker = Helpers.findNearestMarker(_userLocation, markers);
    final nearestEndMarker = Helpers.findNearestMarker(LatLng(widget.destination.lat, widget.destination.lon), markers);

    // Create a green marker for the user's location
    Marker userLocationMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: _userLocation,
      builder: (ctx) => Icon(
        Icons.location_on,
        color: Colors.green, // Green color for user's location
        size: 40.0,
      ),
    );

    // Create a blue marker for the destination address
    Marker destinationMarker = Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(widget.destination.lat, widget.destination.lon),
      builder: (ctx) => Icon(
        Icons.location_on,
        color: Colors.blue, // Blue color for destination address
        size: 40.0,
      ),
    );

    setState(() {
      _markers = [
        userLocationMarker, // Add the user's location marker
        destinationMarker, // Add the destination marker
        ...markers, // Add the other markers
      ];
    });
  }

  void _fetchMarkers() async {
    try {
      final markers = await StopService.fetchMarkers();
      setState(() {
        _markers.addAll(markers);
      });
    } catch (e) {
      print('Failed to fetch markers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
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
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}