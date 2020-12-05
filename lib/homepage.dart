import 'package:flutter/material.dart';
import 'package:notes/nota_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'nova_nota.dart';
import 'previsao.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Nota> notas;
  var db = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot> notasinscritos;

  @override
  void initState() {
    //iniciaservico();
    super.initState();
    notas = List();
    notasinscritos?.cancel();
    notasinscritos = db.collection("notes").snapshots().listen((snapshot) {
      final List<Nota> nota = snapshot.docs
          .map((documentSnapshot) =>
              Nota.fromMap(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.notas = nota;
      });
    });
  }

  @override
  void dispose() {
    notasinscritos?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Bloco de Notas'),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: getListaNotas(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      default:
                        List<DocumentSnapshot> documentos = snapshot.data.docs;
                        return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.10, crossAxisCount: 2),
                            itemCount: documentos.length,
                            itemBuilder: (_, index) {
                              return Card(
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                  notas[index].titulo.length >=
                                                          11
                                                      ? notas[index]
                                                              .titulo
                                                              .substring(
                                                                  0, 10) +
                                                          "..."
                                                      : notas[index].titulo,
                                                  style:
                                                      TextStyle(fontSize: 24)),
                                              subtitle: Text(
                                                  notas[index].nota.length >= 21
                                                      ? notas[index]
                                                              .nota
                                                              .substring(
                                                                  0, 20) +
                                                          "..."
                                                      : notas[index].nota,
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              onTap: () => navegarNotas(
                                                  context, notas[index]),
                                            )
                                          ])));
                            });
                    }
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent[600],
        onPressed: () => cadastrarNota(context, Nota(null, "", "")),
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
            leading: new Icon(Icons.home),
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

  Stream<QuerySnapshot> getListaNotas() {
    return FirebaseFirestore.instance.collection("notes").snapshots();
  }

  void navegarNotas(BuildContext context, Nota nota) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovaNota(nota)),
    );
  }

  void cadastrarNota(BuildContext context, Nota nota) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovaNota(Nota(null, "", ""))),
    );
  }
}
