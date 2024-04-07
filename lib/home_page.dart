import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/models/User.dart';
import 'package:test_project/screens/auth/login_screen.dart';
import 'package:test_project/screens/draw_screen.dart';
import 'package:test_project/screens/drawing_screen.dart';
import 'package:test_project/screens/interactive_game.dart';
import 'package:test_project/screens/settings_screen.dart';
import 'package:test_project/screens/theory_screen.dart';

class HomePage extends StatefulWidget {
  int selectedIndex;
  HomePage({Key? key, required this.selectedIndex});

  @override
  State<HomePage> createState() => _HomePageState(selectedIndex: selectedIndex);
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  _HomePageState({required int selectedIndex}) {
    _selectedIndex = selectedIndex;
  }

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
  final user = FirebaseAuth.instance.currentUser;
  var data;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users-list')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          final userData = snapshot.docs.map((doc) => doc.data()).toList();

          final userDetails = userData.map((doc) => UserData.fromMap(doc)).toList();

          data = userDetails;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            color: Colors.white,
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
              colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height:120.0,
              decoration: const BoxDecoration(
                color: Color(0xFF678094)
              ),
              child: data != null && data.length > 0 ? Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data[0].profile_image),
                      radius: 30,
                    ),
                   const SizedBox(width: 10),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(data[0].first_name + " " + (data[0].second_name)),
                     ],
                   )
                  ],
                ),
              ) : const SizedBox()
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