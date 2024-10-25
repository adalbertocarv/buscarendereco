import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:buscareferencia/services/geolocator_service.dart';
import 'package:buscareferencia/models/marker.dart';
import 'package:buscareferencia/utils/helpers.dart';
import 'package:buscareferencia/models/stop.dart';
import 'package:buscareferencia/models/address.dart';

import '../services/api_service.dart';

class MapScreen extends StatefulWidget {
  final Address destination;

  MapScreen({required this.destination});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _userLocation = LatLng(0, 0);
  List<Marker> _markers = [];
  List<Polyline> _polylines = []; // Para as LineStrings (rotas)
  Stop? _nearestStartStop;
  Stop? _nearestEndStop;
  List<dynamic> _routes = []; // Armazena as rotas buscadas
  final MarkerService _markerService = MarkerService();

  @override
  void initState() {
    super.initState();
    _setUserLocation();
  }

  Color _getLineColor(int index) {
    // Define cores diferentes com base no índice da linha ou outra lógica
    if (index == 0) {
      return Colors.red; // Cor da primeira linha
    } else if (index == 1) {
      return Colors.green; // Cor da segunda linha
    }
    return Colors.blue; // Cor padrão para outras linhas
  }


  /// Busca a localização atual do usuário
  void _setUserLocation() async {
    print('Obtendo localização do usuário...');
    _userLocation = await GeolocatorService.getCurrentLocation();
    print('Localização do usuário obtida: $_userLocation');
    _setNearestStops(); // Chama a função para buscar as paradas mais próximas
  }

  /// Busca as paradas mais próximas da localização do usuário e do destino
  void _setNearestStops() async {
    try {
      final stops = await StopService.fetchStops();
      print('Paradas carregadas: ${stops.length}');

      final destination = widget.destination;

      // Calcular as paradas mais próximas (origem e destino)
      final nearestStartStop = Helpers.findNearestStop(_userLocation, stops);
      final nearestEndStop = Helpers.findNearestStop(LatLng(destination.lat, destination.lon), stops);
      print('Parada mais próxima do usuário: ${nearestStartStop.codDftrans}');
      print('Parada mais próxima do destino: ${nearestEndStop.codDftrans}');

      setState(() {
        _nearestStartStop = nearestStartStop;
        _nearestEndStop = nearestEndStop;
      });

      // Buscar as rotas entre as paradas mais próximas
      if (_nearestStartStop != null && _nearestEndStop != null) {
        print('Buscando rotas entre ${_nearestStartStop!.codDftrans} e ${_nearestEndStop!.codDftrans}');
        await _fetchRoutes(_nearestStartStop!.codDftrans, _nearestEndStop!.codDftrans);
      }
    } catch (e) {
      print('Erro ao definir as paradas mais próximas: $e');
    }
  }

  /// Busca as rotas entre a parada de origem e a parada de destino
  Future<void> _fetchRoutes(int paradaOrigem, int paradaDestino) async {
    try {
      // Buscar as rotas da API
      final routes = await ApiService.fetchRoutes(paradaOrigem, paradaDestino);
      print('Rotas encontradas: ${routes.length}');
      setState(() {
        _routes = routes;
      });

      // Extrair as linhas das rotas e buscar as LineStrings para cada uma
      for (var i = 0; i < routes.length; i++) {
        String linha = routes[i]['linha'];
        await _fetchLineGeoJson(linha, i);  // Passa o índice da linha
      }


      // Extrair os códigos codDftrans das paradas da rota
      List<int> codDftransList = [paradaOrigem, paradaDestino];
      if (routes.length > 1) {
        // Adiciona parada de integração, se existir
        codDftransList.insert(1, routes[0]['parada_destino']); // Parada de integração
        print('Parada de integração encontrada: ${routes[0]['parada_destino']}');
      }

      // Buscar detalhes das paradas usando os codDftrans da rota
      await _fetchStops(codDftransList);
    } catch (e) {
      print('Erro ao buscar rotas: $e');
    }
  }

  /// Busca a LineString GEOJSON para cada linha de ônibus
  Future<void> _fetchLineGeoJson(String linha, int index) async {
    try {
      final lineDetails = await ApiService.fetchLineGeoJson(linha);
      print('LineString carregada para a linha $linha');

      // Criar polylines para as LineStrings retornadas
      for (var feature in lineDetails) {
        if (feature['geometry']['type'] == 'LineString') {
          final coords = feature['geometry']['coordinates'];

          // Converta as coordenadas para LatLng
          final polylinePoints = coords.map<LatLng>((point) {
            return LatLng(point[1], point[0]);
          }).toList();

          // Adiciona a polyline ao mapa com uma cor específica
          setState(() {
            _polylines.add(Polyline(
              points: polylinePoints,
              strokeWidth: 4.0,
              color: _getLineColor(index),  // Define a cor da linha com base no índice
            ));
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar LineString para a linha $linha: $e');
    }
  }


  /// Busca os detalhes das paradas usando os codDftrans retornados pelas rotas
  Future<void> _fetchStops(List<int> codDftransList) async {
    try {
      // Limpa os marcadores existentes antes de adicionar os novos
      setState(() {
        _markers.clear();  // Limpa todos os marcadores anteriores
      });

      // Buscar os detalhes das paradas da API
      final stopDetails = await ApiService.fetchStops(codDftransList);
      print('Paradas detalhadas carregadas: ${stopDetails.length}');

      // Criar novos marcadores para as paradas retornadas pela API
      final newMarkers = stopDetails.map((feature) {
        final coords = feature['geometry']['coordinates'];
        final stopLatLng = LatLng(coords[1], coords[0]);

        // Cria marcador com ícone de ônibus para as paradas
        return Marker(
          width: 80.0,
          height: 80.0,
          point: stopLatLng,
          builder: (ctx) => Icon(
            Icons.directions_bus,  // Ícone de ônibus
            color: Colors.orange,
            size: 40.0,
          ),
        );
      }).toList();

      // Atualiza o estado com os novos marcadores
      setState(() {
        _markers = newMarkers;  // Adiciona os novos marcadores
      });
    } catch (e) {
      print('Erro ao buscar detalhes das paradas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-15.78869450034934, -47.88936481492598),
          zoom: 14.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,  // Exibe os marcadores das paradas
          ),
          PolylineLayer(
            polylines: _polylines,  // Exibe as polylines para as LineStrings
          ),
        ],
      ),
    );
  }
}
