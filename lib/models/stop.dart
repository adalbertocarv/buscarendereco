// ignore_for_file: unused_import

import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StopService {
  static const String _url = 'https://www.sistemas.dftrans.df.gov.br/parada/geo/paradas/wgs';

  static Future<List<Stop>> fetchStops() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['features'] as List).map((feature) {
        return Stop.fromJson(feature);
      }).toList();
    } else {
      throw Exception('Falha para carregar as paradas');
    }
  }
}


class Stop {
  final LatLng point;
  final int codDftrans;  // Definido como int

  Stop({required this.point, required this.codDftrans});

  // Construtor de fábrica para criar um objeto Stop a partir de JSON
  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      point: LatLng(json['geometry']['coordinates'][1], json['geometry']['coordinates'][0]),
      codDftrans: int.parse(json['properties']['codDftrans']),  // Converte de String para int
    );
  }
}
