// lib/open_street_map_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenStreetMapService {
  final String baseUrl = "https://nominatim.openstreetmap.org";

  Future<List<Map<String, dynamic>>> getAddressesFromQuery(String query, {String? viewbox}) async {
    final String url = "$baseUrl/search?q=$query&format=json&addressdetails=1"
        "&viewbox=${viewbox ?? ''}&bounded=1";
    final Uri uri = Uri.parse(url);
    print("Request URL: $url"); // Print the URL for debugging
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return data.map((item) => {
          "display_name": item["display_name"],
          "lat": item["lat"],
          "lon": item["lon"],
        }).toList();
      } else {
        throw Exception("Nenhum resultado encontrado");
      }
    } else {
      throw Exception("Falha para buscar o endereço");
    }
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    final String url = "$baseUrl/reverse?format=json&lat=$lat&lon=$lon&addressdetails=1";
    final Uri uri = Uri.parse(url);
    print("Request URL: $url"); // Print the URL for debugging
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['display_name'] ?? 'Nenhum endereço encontrado';
    } else {
      throw Exception("Falha para buscar o endereço");
    }
  }
}
