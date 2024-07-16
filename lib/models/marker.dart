import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:buscaendereco/models/stop.dart';
import 'package:buscaendereco/models/address.dart';

class MarkerService {
  Marker createMarkerFromStop(Stop stop) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: stop.location,
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40.0,
        ),
      ),
    );
  }

  Marker createMarkerFromAddress(Address address) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: LatLng(address.lat, address.lon),
      builder: (ctx) => Container(
        child: Icon(
          Icons.location_on,
          color: Colors.blue,
          size: 40.0,
        ),
      ),
    );
  }
}
