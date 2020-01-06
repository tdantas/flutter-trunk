import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
      title: 'contador de pessoa',
      debugShowCheckedModeBanner: false,
      home: Home()));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _people = 0;
  String _infoText = "Pode Entrar";

  void _changePeople(int delta) {
    setState(() {
      _people += delta;
      if(_people < 0) {
        _infoText = "Mundo invertido";
      } else if (_people <= 10) {
        _infoText = "pode entrar !";
      } else {
        _infoText = "lotado";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/restaurant.jpg", fit: BoxFit.fill, height: 1000),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Pessoas: $_people",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        _changePeople(1);
                      },
                      child: Text("+1",
                          style:
                          TextStyle(fontSize: 40, color: Colors.white)),
                    )),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: FlatButton(
                      onPressed: () {
                        _changePeople(-1);
                      },
                      child: Text("-1",
                          style:
                          TextStyle(fontSize: 40, color: Colors.white)),
                    ))
              ],
            ),
            Text(
              _infoText,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30.0, color: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
