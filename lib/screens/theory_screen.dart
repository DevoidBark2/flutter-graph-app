import 'package:flutter/material.dart';

class TheoryScreen extends StatelessWidget {
  const TheoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: RichText(
        text: TextSpan(
          children: const <TextSpan>[
            TextSpan(text: 'Граф', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: " система объектов произвольной природы (вершин) и связок (ребер), соединяющих некоторые пары этих объектов.")
          ],
          style: DefaultTextStyle.of(context).style,
        ),
      ),
    );
  }
}
