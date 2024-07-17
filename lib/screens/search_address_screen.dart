import 'package:flutter/material.dart';
import 'package:buscareferencia/services/api_service.dart';
import 'package:buscareferencia/models/address.dart';

class SearchAddressScreen extends StatefulWidget {
  @override
  _SearchAddressScreenState createState() => _SearchAddressScreenState();
}

class _SearchAddressScreenState extends State<SearchAddressScreen> {
  TextEditingController _controller = TextEditingController();
  List<Address> _addresses = [];

  void _searchAddress(String query) async {
    final results = await ApiService.searchAddress(query);
    setState(() {
      _addresses = results.map((data) => Address.fromJson(data)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar endereço'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Insira um endereço',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchAddress(_controller.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_addresses[index].displayName),
                  onTap: () {
                    Navigator.pop(context, _addresses[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
