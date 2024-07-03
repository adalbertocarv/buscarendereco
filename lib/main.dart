// lib/main.dart
import 'package:flutter/material.dart';
import 'open_street_map_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca Endereços',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _addressController = TextEditingController();
  String? _coordinates;
  String viewbox = "-48.72296,-15.42718,-46.82232,-16.20805"; // DF
  OpenStreetMapService osmService = OpenStreetMapService();

  List<String> _suggestions = [];

  void _searchAddress(String query) async {
    try {
      final result = await osmService.getAddressesFromQuery(query, viewbox: viewbox);
      setState(() {
        _suggestions = result.map((e) => e["display_name"] as String).toList();
      });
    } catch (e) {
      setState(() {
        _suggestions = [];
      });
    }
  }

  void _selectAddress(String address) async {
    try {
      final result = await osmService.getAddressesFromQuery(address, viewbox: viewbox);
      if (result.isNotEmpty) {
        setState(() {
          _coordinates = "Latitude: ${result[0]['lat']}, Longitude: ${result[0]['lon']}";
        });
      }
    } catch (e) {
      setState(() {
        _coordinates = e.toString();
      });
    }
  }

  void _performSearch() {
    _searchAddress(_addressController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste pesquisa endereço/coordenadas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                _searchAddress(textEditingValue.text);
                return _suggestions;
              },
              onSelected: (String selection) {
                _selectAddress(selection);
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                _addressController.text = textEditingController.text;
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Escreva um endereço",
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performSearch,
              child: Text("Pesquisar"),
            ),
            SizedBox(height: 20),
            _coordinates != null ? Text(_coordinates!) : Container(),
          ],
        ),
      ),
    );
  }
}
