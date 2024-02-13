import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/screens/splash_screen.dart';
import 'package:test_project/theme/theme_costans.dart';
import 'package:test_project/theme/theme_manager.dart';
import 'firebase_options.dart';

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

  // final user = FirebaseAuth.instance.currentUser;
  // var data;
  @override
  void dispose() {
    _themeManger.removeListener(themeListener);
    super.dispose();
  }

  // void getData() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //
  //   if (user != null) {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('users-list')
  //         .where('uid', isEqualTo: user.uid)
  //         .get();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       setState(() {
  //         data = querySnapshot.docs.first.data();
  //         print('Данные пользователя: $data');
  //       });
  //     } else {
  //       print('Пользователь с UID ${user.uid} не найден в Firestore.');
  //     }
  //   }
  // }

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
      title: 'Graph World',
      home: const Scaffold(
        body: SplashScreen(),
      ),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManger.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}







