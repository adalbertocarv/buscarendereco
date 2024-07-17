import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/bus_line.dart';

class BusLinesScreen extends StatefulWidget {
  final String startStopCode;
  final String endStopCode;

  BusLinesScreen({required this.startStopCode, required this.endStopCode});

  @override
  _BusLinesScreenState createState() => _BusLinesScreenState();
}

class _BusLinesScreenState extends State<BusLinesScreen> {
  List<BusLine> _busLines = [];

  Future<void> _fetchBusLines() async {
    final response = await http.get(Uri.parse('https://www.sistemas.dftrans.df.gov.br/linha/paradacod/${widget.startStopCode}/paradacod/${widget.endStopCode}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final busLines = (jsonData as List).map((json) => BusLine.fromJson(json)).toList();
      setState(() {
        _busLines = busLines;
      });
    } else {
      throw Exception('Falha para carregar linhas de ônibus');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBusLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Linhas de Ônibus'),
      ),
      body: ListView.builder(
        itemCount: _busLines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_busLines[index].descricao),
            subtitle: Text(_busLines[index].numero),
          );
        },
      ),
    );
  }
}
