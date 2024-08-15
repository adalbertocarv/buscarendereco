import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bus_line.dart';

class BusLineService {
  Future<List<BusLine>> getBusLines(String startStopCode, String endStopCode) async {
    final response = await http.get(Uri.parse('https://www.sistemas.dftrans.df.gov.br/linha/paradacod/$startStopCode/paradacod/$endStopCode'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final busLines = (jsonData as List).map((json) => BusLine.fromJson(json)).toList();
      return busLines;
    } else {
      throw Exception('Falha para carregar linhas de ônibus');
    }
  }
}