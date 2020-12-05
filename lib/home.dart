import 'package:flutter/material.dart';
import 'homepage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bloco de Notas',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: new MyHomePage(),
    );
  }
}
