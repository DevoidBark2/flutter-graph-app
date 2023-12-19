import 'package:flutter/material.dart';
import 'package:test_project/models/Task.dart';

class LevelGameScreen extends StatefulWidget {
  final Task task;
  const LevelGameScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<LevelGameScreen> createState() => _LevelGameScreenState();
}

class _LevelGameScreenState extends State<LevelGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.task.level),
    );
  }
}
