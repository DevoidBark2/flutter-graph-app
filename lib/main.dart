import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/screens/splash_screen.dart';
import 'package:test_project/screens/theory_screen.dart';
import 'package:test_project/theme/theme_costans.dart';
import 'package:test_project/theme/theme_manager.dart';
import 'firebase_options.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

ThemeManger _themeManger = ThemeManger();

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    _themeManger.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeManger.addListener(themeListener);
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph App',
      home: const Scaffold(
        body: SplashScreen(),
      ),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManger.themeMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/homepage': (context) => const TheoryScreen()
      },
    );
  }
}







