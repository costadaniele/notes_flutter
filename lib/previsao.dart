import 'package:flutter/material.dart';
import 'dart:developer';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:notes/homepage.dart';

class Previsao extends StatefulWidget {
  Previsao({Key key}) : super(key: key);
  @override
  _PrevisaoState createState() => new _PrevisaoState();
}

class _PrevisaoState extends State<Previsao> {
  double _temp;
  String _name;
  String _description;
  String _icon;

  @override
  void initState() {
    //iniciaservico();
    super.initState();
    _recuperar();
  }

  Future<String> _recuperar() async {
    var url =
        'http://api.openweathermap.org/data/2.5/weather?q=santos,sp,br&units=metric&appid=be1b3eee2052d9adedf9e3d48b4143d0';
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    Map<String, dynamic> retorno = convert.jsonDecode(response.body);
    setState(() {
      _temp = retorno["main"]["temp"];
      _name = retorno["name"];
      _description = retorno["weather"][0]["description"];
      _icon = retorno["weather"][0]["icon"];
    });
    return '';
  }

  Future<String> getFutureDados() async => await _recuperar();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Previsão do Tempo'),
      ),
      body: Center(
        child: Container(
            padding: EdgeInsets.all(40),
            child: FutureBuilder(
                future: getFutureDados(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Temperatura: $_temp",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Nome: $_name",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "Descrição: $_description",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 50),
                              child: Image.network(
                                  "http://openweathermap.org/img/w/" +
                                      _icon +
                                      ".png")),
                        ]);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.replay),
        backgroundColor: Colors.greenAccent[600],
        onPressed: _recuperar,
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          new Container(
              child: new DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'assets/images/header_background1.png'))),
                  child: Stack(children: <Widget>[
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text("Bloco de Notas",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))),
                  ]))),
          ListTile(
            leading: new Icon(Icons.home),
            title: Text("Início"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage()));
            },
          ),
          ListTile(
            leading: new Icon(Icons.wb_cloudy),
            title: Text("Previsão do Tempo"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Previsao()));
            },
          ),
        ],
      )),
    );
  }
}
