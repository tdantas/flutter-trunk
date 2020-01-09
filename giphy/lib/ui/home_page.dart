import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _q;
  int _offset = 0;

  Future<Map> _search() async {
    http.Response response;
    if (_q == null) {
      response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=888bLuWQO8pkGdSi3ApvcbGXc1VySFea&limit=10&rating=G");
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=888bLuWQO8pkGdSi3ApvcbGXc1VySFea&q=$_q&limit=25&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _search().then((r) {
      print(r);
    });
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot data) {
    return Container(color: Colors.amber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif")
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: Icon(Icons.search, color: Colors.white,),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5))
                  )
              ),
            ) ,
          ),
          Expanded(
            child: FutureBuilder(
              future: _search(),
              builder: (context, asyncState) {
                switch(asyncState.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5,
                      ),
                    );
                  default:
                    if(asyncState.hasError) return Container(color: Colors.pink);
                    else return _createGifTable(context, asyncState);
                }
              }
            ),
          )
        ],

      ),
    );
  }
}
