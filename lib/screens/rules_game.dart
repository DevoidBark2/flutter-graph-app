import 'package:flutter/material.dart';

class RulesGameScreen extends StatefulWidget {
  const RulesGameScreen({Key? key}) : super(key: key);

  @override
  State<RulesGameScreen> createState() => _RulesGameScreenState();
}

class _RulesGameScreenState extends State<RulesGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: Text('Правила игры'),
      ),
    );
  }
}
