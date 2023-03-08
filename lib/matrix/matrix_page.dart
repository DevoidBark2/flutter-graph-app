
import 'package:flutter/material.dart';
import 'package:test_project/graph/graph.dart';
import 'package:test_project/graph/graph_view.dart';
import '../graph/node.dart';
import 'matrix.dart';
import 'matrix_field.dart';

class MatrixPage extends StatefulWidget {
  final Matrix matrix;

  const MatrixPage({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  final controllers = <List<TextEditingController>>[];
  late final rows = widget.matrix.rows;
  late final columns = widget.matrix.columns;
  var nodeA = NodeGraph('A', 1);
  var nodeB = NodeGraph('B', 2);
  var nodeC = NodeGraph('C', 3);
  var nodeD = NodeGraph('D', 4);

  @override
  void initState() {
    super.initState();
    createControllers();
  }

  void createControllers() {
    for (var i = 0; i < rows; i++) {
      controllers.add(List.generate(columns, (index) => TextEditingController(text: '')));
    }
  }

  void printMatrix() {
    final strings = <List<String>>[];
    for (var controllerRow in controllers) {
      final row = controllerRow.map((e) => e.text).toList();
      strings.add(row);
    }
  }

  @override
  void dispose() {
    for (var controllerRow in controllers) {
      for (final c in controllerRow) {
        c.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controllers.length,
                  (index1) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controllers[index1].length,
                      (index2) => Center(
                    child: SizedBox(
                      height: controllers.length > 5 ? 40 : controllers.length > 6 ? 20 : 50,
                      width: controllers.length > 5 ? 40 : controllers.length > 6 ? 20 : 50,
                      child: MatrixField(
                        controller: controllers[index1][index2],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // TextButton(
          //   onPressed: printMatrix,
          //   child: const Text('View Graph'),
          // )
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(),
                      body: GraphView(controllers: controllers),
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
              child: const Center(child: Text('View Graph')),
            ),
          ),
        ],
      ),
    );
  }
}
