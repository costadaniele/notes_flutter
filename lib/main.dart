import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*
  await Firebase.initializeApp();
  FirebaseFirestore db1 = FirebaseFirestore.instance;
  db1.collection("biblioteca").add({"titulo": "Novo Titulo 4", "tipo": "PDF"});
  */
  runApp(new MyApp());
}
