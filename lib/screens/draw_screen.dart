import 'package:flutter/material.dart';
import '../matrix/matrix.dart';
import '../matrix/matrix_option.dart';

class DrawScreen extends StatelessWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        MatrixOption(matrix: Matrix(2, 2)),
        MatrixOption(matrix: Matrix(3, 3)),
        MatrixOption(matrix: Matrix(4, 4)),
        MatrixOption(matrix: Matrix(5, 5)),
        MatrixOption(matrix: Matrix(6, 6)),
        MatrixOption(matrix: Matrix(7, 7)),
      ],
    );
  }
}
