import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart' as path;

void main() =>
    runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  TextEditingController _todoController = TextEditingController();
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedIndex;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = convert.jsonDecode(data);
      });
    });
  }

  void _addTodo() {
    Map<String, dynamic> newTodo = new Map();
    newTodo["title"] = _todoController.text;
    newTodo["ok"] = false;
    _todoController.text = "";

    setState(() {
      _todoList.add(newTodo);
      _saveData();
    });
  }

  Widget _buildItem(context, index) {
    return Dismissible(
      onDismissed: (DismissDirection d) {
        _lastRemoved = Map.from(_todoList[index]);
        _lastRemovedIndex = index;

        setState(() {
          _todoList.removeAt(index);
          final snack = SnackBar(
              content: Text("Tarefa ${_lastRemoved["title"]} removida"),
              duration: Duration(seconds: 3),
              action: SnackBarAction(
                  label: "desfazer",
                  onPressed: () {
                    setState(() {
                      _todoList.insert(_lastRemovedIndex, _lastRemoved);
                      _saveData();
                    });
                  }));

          //Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });

        _saveData();
      },
      key: Key(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()),
      background: Container(
          color: Colors.red,
          child: Align(
            child: Icon(Icons.delete, color: Colors.white),
            alignment: Alignment(-0.8, 0),
          )),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
          onChanged: (bool value) {
            setState(() {
              _todoList[index]["ok"] = value;
              _saveData();
            });
          },
          value: _todoList[index]["ok"],
          secondary: CircleAvatar(
              child: Icon(_todoList[index]["ok"] ? Icons.check : Icons.error)),
          title: Text(_todoList[index]["title"])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("okivia todo list"), centerTitle: true),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                          labelText: "Nova Tarefa",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    child: Text("add"),
                    textColor: Colors.white,
                    onPressed: _addTodo,
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: _todoList.length,
                    itemBuilder: _buildItem),
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 3));

                  setState(() {
                    _todoList.sort((a,b) {
                      if (a["ok"] && !b["ok"]) return 1;
                      if (!a["ok"] && b["ok"]) return -1;
                      return Comparable.compare(a["title"], b["title"]);
                    });
                    _saveData();
                  });
                },
              ),

            )
          ],
        ));
  }

  Future<File> _getFile() async {
    final directory = await path.getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = convert.jsonEncode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
