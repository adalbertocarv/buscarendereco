import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeolocatorService {
  static Future<LatLng> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }
}
