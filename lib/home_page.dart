import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/auth/login_screen.dart';
import 'package:test_project/screens/draw_screen.dart';
import 'package:test_project/screens/drawing_screen.dart';
import 'package:test_project/screens/interactive_game.dart';
import 'package:test_project/screens/profile_screen.dart';
import 'package:test_project/screens/settings_screen.dart';
import 'package:test_project/screens/main_screen.dart';
import 'package:test_project/screens/theory_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TheoryScreen(),
    DrawScreen(),
    DrawingScreen(),
    InteractiveGame(),
    SettingsScreen(),
    LoginScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    print(user);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/Logo.svg',
              width: 50,
              height: 50,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Настройки',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Настройки'),
                    ),
                    body: const SettingsScreen(),
                  ),
                ),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Colors.orange, Colors.deepOrange],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height:100.0,
              decoration: const BoxDecoration(
                color: Colors.blueAccent
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Главная'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.draw_rounded),
              title: const Text('Визуализация'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.gamepad),
              title: const Text('Игра'),
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Настройки'),
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            user != null ?  ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Профиль'),
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ) : ListTile(
              leading: const Icon(Icons.login_rounded),
              title: const Text('Войти'),
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}