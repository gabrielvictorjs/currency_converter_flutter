import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "https://api.hgbrasil.com/finance";

// Asynchronous operation for get currency data
Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

// Home Screen class with stateful widget
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _realController = TextEditingController();
  final _dollarController = TextEditingController();
  final _euroController = TextEditingController();

  double _dollar;
  double _euro;

  void _clearAll() {
    _realController.text = "";
    _dollarController.text = "";
    _euroController.text = "";
  }

  /* 
   * In the code below, the currency values is calculated based on the "Real" entry.
   * Example: if we enter with 1 Real, the dollar controller will be set to 1 divided 
   * by the buying value of the dollar. The same is true for the euro.
   */

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double real = double.parse(text);
    _dollarController.text = (real / _dollar).toStringAsFixed(2);
    _euroController.text = (real / _euro).toStringAsFixed(2);
  }


  void _dollarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double dollar = double.parse(text);
    _realController.text = (dollar * _dollar).toStringAsFixed(2);
    _euroController.text = (dollar * _dollar / _euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }

    double euro = double.parse(text);
    _realController.text = (euro * _euro).toStringAsFixed(2);
    _dollarController.text = (euro * _euro / _dollar).toStringAsFixed(2);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Setting App Bar
      appBar: AppBar(
        title: Text(
          "Conversor de Moedas", 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      // Setting application body
      body: FutureBuilder(
        future: getData(),
        builder: (context, snap) {

          // verify if data is loading
          switch (snap.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:

              // build the loading warning
              return Center(
                child: buildCustomTextWarning("Carregando Dados")
              );
              break;
            
            // else
            default:
              if(snap.hasError) {

                // build the error warning
                return Center(
                  child: buildCustomTextWarning("Erro ao carregar os dados")
                );

              } else {
                // setting the currency values
                _dollar = snap.data["results"]["currencies"]["USD"]["sell"];
                _euro = snap.data["results"]["currencies"]["EUR"]["sell"];

                // build the form
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                      // real input
                      buildTextField("Reais", "R\$", _realController, _realChanged),
                      Divider(),
                      // dollar input
                      buildTextField("Dollar", "US\$", _dollarController, _dollarChanged),
                      Divider(),
                      // euro input
                      buildTextField("Euro", "€", _euroController, _euroChanged)
                    ],
                  )
                );
              }
          }
        },  
      )
    );
  }
}



// Builds the text fields after data was loading
Widget buildTextField(String label, String prefix, TextEditingController controller, Function fun) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix
    ),

    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: fun,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}


// Builds the warning text while data is loading
Widget buildCustomTextWarning(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.amber, fontSize: 25.0), 
    textAlign: TextAlign.center
  );
}