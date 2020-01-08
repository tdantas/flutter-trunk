import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const request = "https://api.hgbrasil.com/finance?key=a2e28412";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
          )
      )));
}

Future<Map> getData() async {
  print("getting data");
  http.Response response = await http.get(request);
  return convert.jsonDecode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double dolar;
  double euro;
  String _value = "initial value";
  Future<Map> _currencies;

  TextEditingController realController = TextEditingController();
  TextEditingController euroController = TextEditingController();
  TextEditingController dolarController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _currencies = getData();
  }

  void _realChanged(String text) {
    setState(() {
      _value = "real";
    });

    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsPrecision(2);
    euroController.text = (real/euro).toStringAsPrecision(2);
  }

  void _dolarChanged(String text) {
    setState(() {
      _value = "dolar";
    });

    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsPrecision(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsPrecision(2);
  }

  void _euroChanged(String text) {
    setState(() {
      _value = "euro";
    });
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsPrecision(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsPrecision(2);
  }

  _resetFields () {
    realController.text = "";
    euroController.text= "";
    dolarController.text= "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: Text("\$Coin Converter\$"),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _resetFields)
            ],
            backgroundColor: Colors.amber),
        body: FutureBuilder<Map>(
            future: _currencies,
            builder: (context, asyncState) {
              switch (asyncState.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child:
                        Text("loading", style: TextStyle(color: Colors.amber)),
                  );
                default:
                  if (asyncState.hasError) {
                    return Center(
                      child:
                          Text("error", style: TextStyle(color: Colors.amber)),
                    );
                  } else {
                    dolar = asyncState.data["results"]["currencies"]["USD"]["buy"];
                    euro = asyncState.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(_value, style: TextStyle(color: Colors.white, backgroundColor: Colors.blue), textAlign:  TextAlign.center, ),
                          Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                          buildTextField("Reais", "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextField("Dolares", "\$ ", dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "EU ", euroController, _euroChanged),
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function onChanged) {
  return TextField(
    controller: controller,
    onChanged: onChanged,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    style: TextStyle(color: Colors.green, fontSize: 25),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      labelText: label,
      prefixIcon: Icon(Icons.monetization_on, color: Colors.amber),
      labelStyle: TextStyle(color: Colors.amber),
      prefixStyle: TextStyle(color: Colors.amber, fontSize: 15) ,
      prefixText: prefix,),
  );
}
