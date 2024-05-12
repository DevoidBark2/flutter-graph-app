import 'dart:math';

import 'package:flutter/material.dart';

class ViewGraph extends StatefulWidget {
  final List<List<int?>> matrix;
  const ViewGraph({Key? key,required this.matrix}) : super(key: key);

  @override
  State<ViewGraph> createState() => _ViewGraphState();
}

class _ViewGraphState extends State<ViewGraph> {
  @override
  Widget build(BuildContext context) {
    List<List<int?>> matrix = widget.matrix;

    // Функция для вращения графа
    List<List<int?>> rotateGraph(List<List<int?>> graph, int current) {
      List<List<int?>> rotatedGraph = List.generate(graph.length, (index) => List.filled(graph.length, 0));

      for (int i = 0; i < graph.length; i++) {
        if (i != current) {
          for (int j = 0; j < graph.length; j++) {
            if (j != current && graph[i][j] != 0) {
              rotatedGraph[i][j] = graph[current][i];
            }
          }
        }
      }

      return rotatedGraph;
    }

    // Функция для поиска непосещенного соседа
    int findUnvisitedAdjacent(List<List<int?>> graph, List<int> visited, int current) {
      for (int i = 0; i < graph.length; i++) {
        if (i != current && graph[current][i] != 0 && visited[i] == 0) {
          return i;
        }
      }
      return -1;
    }

    void updateGraph() {
      print(widget.matrix);
      setState(() {
        // Инициализация
        List<List<int?>> graph = widget.matrix;

        // Гамма-алгоритм
        List<int> visited = List.filled(graph.length, 0);
        List<int> stack = [];
        int current = 0;

        while (true) {
          if (visited[current] == 1) {
            current = stack.removeLast();
          } else {
            visited[current] = 1;
            stack.add(current);
            current = findUnvisitedAdjacent(graph, visited, current);
          }

          if (stack.isEmpty) {
            break;
          }

          // Обновление графа
          List<List<int?>> rotatedGraph = List.generate(graph.length, (index) => List.filled(graph.length, 0));
          for (int i = 0; i < graph.length; i++) {
            for (int j = 0; j < graph.length; j++) {
              if (graph[i][j] != 0) {
                rotatedGraph[i][j] = graph[current][i];
              }
            }
          }
          graph = rotatedGraph;
        }
      });
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CustomPaint(painter: OpenPainter(matrix: widget.matrix,)),
          ),
          ElevatedButton(
            onPressed: updateGraph,
            child: const Text("Start"),
          )
        ],
      )
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  OpenPainter({Key? key,
    required this.matrix,
  });
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final List<Offset> points = [];

    var drawPoints = Paint()..color = Color(0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;
    var drawLines = Paint()..color = Color(0xffb69d9d)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;
    var radius = 140;
    if(matrix.length > 10) {
      radius = 500;
    }else if(matrix.length > 20){
      radius = 1000;
    }
    // добавление вершин
    for(var i = 0; i < matrix.length; i++){

      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      final offsetX = Random().nextDouble() * ((size.width - 20) - (size.width / 2)) + (size.width / 2); // Ограничение для offsetX с учетом отступа
      final offsetY = Random().nextDouble() * ((size.height - 20) - (size.width / 2)) + (size.width / 2); // Ограничение для offsetY с учетом отступа
      points.add(Offset((cos(angle) * radius + offsetX + (size.width / 2)), (sin(angle) * radius + offsetY + (size.width / 2))));
    }

    //основной цикл полного рисования(петли, веса и направления т.д.)
    for(var i = 0; i < matrix.length;i++){
      for(var j = 0; j < matrix.length;j++){
        if(matrix[i][j] != 0) {
          // рисует петлю
          if(i == j) {
            Offset ofs = Offset(points[i].dx, points[i].dy - 15);
            canvas.drawCircle(ofs,20.0, paint3);
          }
          else{
            // рисует ребро
            canvas.drawLine(points[i], points[j], drawLines);
          }
        }
      }
    }

    // рисование вершин и индекса вершины
    for(var i = 0;i < matrix.length;i++) {
      canvas.drawCircle(points[i], 15, drawPoints);
      int letterIndex = i % 26;
      String letter = String.fromCharCode(65 + letterIndex);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          text: (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if(matrix.length > 9){
        if(i < 9){
          tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
        }else{
          tp.paint(canvas, Offset(points[i].dx -9.0, points[i].dy - 8.0));
        }
      }
      else{
        tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}