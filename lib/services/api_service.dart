import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _nominatimUrl = "https://nominatim.openstreetmap.org/search";

  static Future<List<dynamic>> searchAddress(String query) async {
    final response = await http.get(Uri.parse('$_nominatimUrl?q=$query&format=json&addressdetails=1&bounded=1&viewbox=-47.9510,-15.5051,-47.3389,-15.8234'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load address');
    }
  }
}
