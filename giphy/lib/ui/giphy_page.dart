import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GiphyPage extends StatelessWidget {
  final String _title;
  final String _url;

  GiphyPage(this._title, this._url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(_url);
              },
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Image.network(_url),
        ));
  }
}
