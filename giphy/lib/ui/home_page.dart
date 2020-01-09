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

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.green);
  }
}
