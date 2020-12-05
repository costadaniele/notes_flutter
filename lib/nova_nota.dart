import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

import 'nota_model.dart';
class NovaNota extends StatefulWidget {
  final Nota nota;
  NovaNota(this.nota);
  @override
  _NovaNotaState createState() => _NovaNotaState();
}
class _NovaNotaState extends State<NovaNota> {
  final db = FirebaseFirestore.instance;
  TextEditingController titulocontroller;
  TextEditingController notacontroller;
  @override
  void initState() {
    super.initState();
    titulocontroller = new TextEditingController(text: widget.nota.titulo);
    notacontroller = new TextEditingController(text: widget.nota.nota);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Nota'),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(18.0),
          alignment: Alignment.center,
          child: Column(children: [
            TextField(
              controller: titulocontroller,
              decoration: InputDecoration(labelText: "Titulo"),
            ),
            TextField(
              controller: notacontroller,
              decoration: InputDecoration(labelText: "Nota"),
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              maxLength: 1000,
            ),
            RaisedButton(
                color: Colors.blueGrey,
                child: (widget.nota.id != null)
                    ? Text("Alterar",
                        style: TextStyle(
                            color: Colors.white))
                    : Text(
                        "Novo",
                        style: TextStyle(
                            color: Colors.white),
                      ),
                onPressed: () {
                  if (widget.nota.id != null) {
                    db.collection("notes").doc(widget.nota.id).set({
                      "titulo": titulocontroller.text,
                      "nota": notacontroller.text
                    });
                    
                  } else {
                    db.collection("notes").doc(widget.nota.id).set({
                      "titulo": titulocontroller.text,
                      "nota": notacontroller.text
                    });
                  }
                  Navigator.pop(context);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                }
                )
          ])),
      floatingActionButton: (widget.nota.id != null)
                    ? FloatingActionButton(
        child: Icon(Icons.delete_forever),
        backgroundColor: Colors.greenAccent[600],
        onPressed: () => excluiNota(
                          context,
                          widget.nota),
      ) : null,
    );
  }

  
  void excluiNota(BuildContext context, Nota doc) async {
    await db.collection("notes").doc(doc.id).delete().then((value) => 
      Navigator.pop(context)
    );
  }
}