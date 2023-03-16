import 'package:flutter/material.dart';
import 'matrix/matrix.dart';
import 'matrix/matrix_option.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Material(
        child: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MatrixOption(matrix: Matrix(2, 2)),
              MatrixOption(matrix: Matrix(3, 3)),
              MatrixOption(matrix: Matrix(4, 4)),
              MatrixOption(matrix: Matrix(5, 5)),
              MatrixOption(matrix: Matrix(6, 6)),
              MatrixOption(matrix: Matrix(7, 7)),
            ],
          ),
        ),
    );
  }
}
