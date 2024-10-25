import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _nominatimUrl = "https://nominatim.openstreetmap.org/search";

  // Busca endereços pelo query fornecido
  static Future<List<dynamic>> searchAddress(String query) async {
    final response = await http.get(Uri.parse('$_nominatimUrl?q=$query&format=json&addressdetails=&format=json&addressdetails=1&viewbox=-47.9510,-15.5051,-47.3389,-15.8234'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha para carregar endereço/referencia');
    }
  }
  // Busca a linha de ônibus em formato LineString GEOJSON
  static Future<List<dynamic>> fetchLineGeoJson(String linha) async {
    final response = await http.get(Uri.parse('https://www.sistemas.dftrans.df.gov.br/percurso/linha/numero/$linha/WGS'));
    print('Requisição fetchLineGeoJson para linha $linha feita com status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Resposta da API fetchLineGeoJson para linha $linha');
      return json.decode(response.body)['features']; // Retorna a feature LineString
    } else {
      throw Exception('Falha ao buscar linha $linha');
    }
  }

  // Busca a rota entre paradas de origem e destino
  static Future<List<dynamic>> fetchRoutes(int paradaOrigem, int paradaDestino) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/rotas/?origem=$paradaOrigem&destino=$paradaDestino'));
      print('Requisição fetchRoutes feita com status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Resposta da API fetchRoutes: ${response.body}');
        return json.decode(response.body)['rota'];
      } else {
        print('Erro na requisição fetchRoutes: ${response.body}');
        throw Exception('Falha ao buscar rota');
      }
    } catch (e) {
      print('Erro ao fazer requisição fetchRoutes: $e');
      throw Exception('Erro ao buscar rota');
    }
  }

  // Busca detalhes de paradas por codDftrans
  static Future<List<dynamic>> fetchStops(List<int> codDftransList) async {
    try {
      final codDftransParams = codDftransList.map((e) => "codDftrans=$e").join('&');
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/paradas/geo/?$codDftransParams'));
      print('Requisição fetchStops feita com status: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Resposta da API fetchStops: ${response.body}');
        return json.decode(response.body)['features'];
      } else {
        print('Erro na requisição fetchStops: ${response.body}');
        throw Exception('Falha ao buscar detalhes de paradas');
      }
    } catch (e) {
      print('Erro ao fazer requisição fetchStops: $e');
      throw Exception('Erro ao buscar paradas');
    }
  }
}
