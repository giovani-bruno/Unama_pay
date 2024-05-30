import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CotacaoPage extends StatefulWidget {
  const CotacaoPage({Key? key}) : super(key: key);

  @override
  _CotacaoPageState createState() => _CotacaoPageState();
}

class _CotacaoPageState extends State<CotacaoPage> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  double dolar = 0.0;
  double euro = 0.0;

  VoidCallback? _realChanged(String text) {
    if (text.isEmpty) {
      dolarController.text = "";
      euroController.text = "";
      return null;
    }

    try {
      double real = double.parse(text);
      dolarController.text = (real / dolar).toStringAsFixed(2);
      euroController.text = (real / euro).toStringAsFixed(2);
    } catch (e) {
      dolarController.text = "";
      euroController.text = "";
    }

    return null;
  }

  VoidCallback? _dolarChanged(String text) {
    if (text.isEmpty) {
      realController.text = "";
      euroController.text = "";
      return null;
    }

    try {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    } catch (e) {
      realController.text = "";
      euroController.text = "";
    }

    return null;
  }

  VoidCallback? _euroChanged(String text) {
    if (text.isEmpty) {
      realController.text = "";
      dolarController.text = "";
      return null;
    }

    try {
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    } catch (e) {
      realController.text = "";
      dolarController.text = "";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 88, 41),
        title: const Center(
          child: Text(
            'Cotação de Moedas',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Aguarde...",
                  style: TextStyle(color: Colors.green, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                String? erro = snapshot.error.toString();
                return Center(
                  child: Text(
                    "Ops, houve uma falha ao buscar os dados : $erro",
                    style: const TextStyle(color: Colors.green, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Icon(
                        Icons.attach_money,
                        size: 180.0,
                        color: Color.fromARGB(255, 39, 88, 41),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Acompanhe as últimas taxas de câmbio e veja como as moedas estão se comportando no mercado. Tenha acesso às informações atualizadas e tome decisões financeiras mais informadas.',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      campoTexto("Reais", "R\$ ", realController, _realChanged),
                      const Divider(),
                      campoTexto("Euros", "€ ", euroController, _euroChanged),
                      const Divider(),
                      campoTexto("Dólares", "US\$ ", dolarController, _dolarChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }

  Widget campoTexto(
      String label, String prefix, TextEditingController c, Function? f) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.green),
        border: const OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: const TextStyle(color: Colors.green, fontSize: 25.0),
      onChanged: (value) => {f!(value)},
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

Future<Map> getData() async {
  var url = Uri.parse('https://api.hgbrasil.com/finance?format=json&key=b6a0ec76');
  http.Response response = await http.get(url);
  return json.decode(response.body);
}