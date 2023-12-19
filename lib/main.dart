// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'home_page.dart';
import 'db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final databaseManager = DatabaseManager();
  //
  // await databaseManager.connect();

  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph App',
      home: const Scaffold(
        body: HomePage(),
      ),
      theme: ThemeData(
        fontFamily: 'JetBrainsMono',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 52.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}








