import 'package:flutter/material.dart';

import 'matrix.dart';
import 'matrix_page.dart';

class MatrixOption extends StatelessWidget {
  final Matrix matrix;
  const MatrixOption({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Ввод матрицы'),
                  ),
                  body: MatrixPage(matrix: matrix),
                );
              },
            ),
          );
        },
        child: Container(
          height: 50,
          width: 100,
          margin: const EdgeInsets.all(5),
          color: Colors.orange,
          child: Center(child: Text('${matrix.rows}' 'x' '${matrix.columns} Matrix ')),
        ),
      ),
    );
  }
}