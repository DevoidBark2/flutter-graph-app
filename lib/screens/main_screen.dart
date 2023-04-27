import 'package:flutter/material.dart';
import 'package:test_project/screens/instruction_screen.dart';
import 'package:test_project/screens/theory_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
          length: 2,
          child: Scaffold(
            body: TabBarView(
              children: [
               TheoryScreen(),
               InstructionScreen()
              ],
            ),
    ),
    );
  }
}
