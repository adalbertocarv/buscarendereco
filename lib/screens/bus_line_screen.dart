import 'package:flutter/material.dart';
import '../services/bus_line_service.dart';
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
  final BusLineService _busLineService = BusLineService();

  @override
  void initState() {
    super.initState();
    _fetchBusLines();
  }

  Future<void> _fetchBusLines() async {
    final busLines = await _busLineService.getBusLines(widget.startStopCode, widget.endStopCode);
    setState(() {
      _busLines = busLines;
    });
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