import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'crypto_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _apiKey = "b9765fd2-770c-41fe-bf81-36160fa2e5c0";
  final String _cryptoUrl = "pro-api.coinmarketcap.com";
  final List<MaterialColor> colors = [Colors.blue, Colors.indigo, Colors.red];

  List currencies;

  @override
  initState() {
    super.initState();
    updateData();
  }

  getUrl() {
    var queryParameters = {
      'start': '1',
      'limit': '500',
      'convert': 'USD',
    };

    return Uri.https(
      _cryptoUrl,
      "/v1/cryptocurrency/listings/latest",
      queryParameters,
    );
  }

  void updateData() async {
    var data = await getCurrencies();
    setState(() {
      currencies = data;
    });
  }

  Future<List> getCurrencies() async {
    http.Response response = await http.get(
      getUrl(),
      headers: {"X-CMC_PRO_API_KEY": _apiKey},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var data = jsonResponse['data'];
      print(data[3]);
      return data;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Crypto'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () => updateData())
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: CryptoWidget(
              currencies: currencies,
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }
}
