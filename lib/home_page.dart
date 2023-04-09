import 'package:flutter/material.dart';
import 'package:test_project/screens/draw_screen.dart';
import 'package:test_project/screens/drawing_screen.dart';
import 'package:test_project/screens/profile_screen.dart';
import 'package:test_project/screens/settings_screen.dart';
import 'package:test_project/screens/theory_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TheoryScreen(),
    DrawScreen(),
    ProfileScreen(),
    DrawingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph View'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Настройки',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Настройки'),
                    ),
                    body: const SettingsScreen()
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_added_sharp), label: 'Главная',backgroundColor: Colors.pink),
          BottomNavigationBarItem(icon: Icon(Icons.draw_sharp), label: 'Рисование',backgroundColor: Colors.pink),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль',backgroundColor: Colors.pink),
          BottomNavigationBarItem(icon: Icon(Icons.draw_sharp), label: 'Рисование(другое)',backgroundColor: Colors.pink)
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}



// class HomePage extends StatelessWidget{
//   const HomePage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         MatrixOption(matrix: Matrix(2, 2)),
//         MatrixOption(matrix: Matrix(3, 3)),
//         MatrixOption(matrix: Matrix(4, 4)),
//         MatrixOption(matrix: Matrix(5, 5)),
//         MatrixOption(matrix: Matrix(6, 6)),
//         MatrixOption(matrix: Matrix(7, 7)),
//       ],
//     );
//   }
// }
