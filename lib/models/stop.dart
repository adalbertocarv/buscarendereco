import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StopService {
  static const String _url = 'https://www.sistemas.dftrans.df.gov.br/parada/geo/paradas/wgs';

  static Future<List<Marker>> fetchMarkers() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List).map((feature) {
        final coordinates = feature['geometry']['coordinates'];
        return Marker(
          point: LatLng(coordinates[1], coordinates[0]),
          width: 50,
          height: 50,
          builder: (ctx) => Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40.0,
          ),
        );
      }).toList();
    } else {
      throw Exception('Failed to load markers');
    }
  }
}
