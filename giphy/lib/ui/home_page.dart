import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:giphy/ui/giphy_page.dart';
import 'package:share/share.dart';

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
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=888bLuWQO8pkGdSi3ApvcbGXc1VySFea&limit=15&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=888bLuWQO8pkGdSi3ApvcbGXc1VySFea&q=$_q&limit=19&offset=$_offset&rating=G&lang=en");
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

  int _getCount(List data) {
    if (_q == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot asyncData) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 1),
        itemCount: _getCount(asyncData.data["data"]),
        itemBuilder: (context, index) {
          if (_q == null || index < asyncData.data["data"].length) {
            var image = asyncData.data["data"][index]["images"]["fixed_height"];
            String title = asyncData.data["data"][index]["title"];
            String url = image["url"];

            return GestureDetector(
                onLongPress: () {
                  Share.share(url);
                },
                onTap: () {

                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GiphyPage(title, url)));
                },
                child: Image.network(
                  image["url"],
                  fit: BoxFit.cover,
                ));
          } else {
            return
              Container(
                  color: Colors.green,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _offset += 19;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add, color: Colors.white, size: 80),
                          Text("carregar mais",
                            style: TextStyle(
                                color: Colors.white, fontSize: 22),)
                        ],
                      ))
              );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    print("Size W is ${MediaQuery
        .of(context)
        .size
        .width}");
    print("Size H is ${MediaQuery
        .of(context)
        .size
        .height}");

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif")),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _q = text;
                  _offset = 0;
                });
              },
              style: TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                  labelText: "Search",
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5)))),
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _search(),
                builder: (context, asyncState) {
                  switch (asyncState.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      if (asyncState.hasError)
                        return Container(color: Colors.pink);
                      else
                        return _createGifTable(context, asyncState);
                  }
                }),
          )
        ],
      ),
    );
  }
}
