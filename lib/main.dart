import 'package:flutter/material.dart';
import 'package:buscareferencia/screens/search_address_screen.dart';
import 'package:buscareferencia/screens/map_screen.dart';
import 'package:buscareferencia/models/address.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Busca Referência',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  void _searchAddress(BuildContext context) async {
    final Address result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchAddressScreen()),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(destination: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Busca por endereço/referência'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _searchAddress(context),
          child: Text('Buscar endereço'),
        ),
      ),
    );
  }
}
