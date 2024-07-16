import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:buscaendereco/models/address.dart';

class MarkerService {
  Marker createMarkerFromStop(Marker stop) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: stop.point,
      builder: (ctx) => Icon(
        Icons.location_on,
        color: Colors.green,
        size: 40.0,
      ),
    );
  }

  Marker createMarkerFromAddress(Address address) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(address.lat, address.lon),
      builder: (ctx) => Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 40.0,
      ),
    );
  }
}
