import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:test_project/models/Task.dart';

class LevelGameScreen extends StatefulWidget {
  final Task task;
  const LevelGameScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<LevelGameScreen> createState() => _LevelGameScreenState();
}

class _LevelGameScreenState extends State<LevelGameScreen> {
  List<Offset> points = [];
  int? selectedVertexIndex;
  int? selectedVertexOffset;
  int time = 0;
  bool isTimeEnd = false;

  int? draggingVertexIndex; // Изменение: индекс перетаскиваемой вершины
  Offset? lastDragOffset;

  @override
  void initState() {
    super.initState();
    initializePoints();
    _startTimer();
    time = widget.task.time_level;// Изменение: инициализация списка вершин
  }

  void initializePoints() {
    final matrix = widget.task.graph;
    final double sizeWidth = 400;
    final double sizeHeight = 400;
    final double radius = getRadius(matrix.length, sizeWidth);

    // Добавление вершин
    for (var i = 0; i < matrix.length; i++) {
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * radius + sizeWidth / 2), sin(angle) * radius + sizeHeight / 2));
    }
  }

  double getRadius(int length, double sizeWidth) {
    double radius = 140;
    if (length > 10) {
      radius = 500;
    } else if (length > 20) {
      radius = 1000;
    }
    return radius;
  }

  void _startTimer(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(time > 0 && isTimeEnd == false){
        setState(() {
          time--;
        });
      }else{
        isTimeEnd = true;
        setState(() {});
        time++;
      }
    });
  }

  int? getTappedVertexIndex(Offset tapPosition) {
    for (int i = 0; i < points.length; i++) {
      final vertexPosition = points[i];
      final distance = (tapPosition - vertexPosition).distance;
      if (distance <= 15) { // Радиус вершины
        return i;
      }
    }
    return null;
  }

  void updateEdgePositions() {
    for (int i = 0; i < widget.task.graph.length; i++) {
      for (int j = 0; j < widget.task.graph.length; j++) {
        if (widget.task.graph[i][j] != 0 && i != j) {
          final startPoint = points[i];
          final endPoint = points[j];
          // points[i][j] = Offset(startPoint, endPoint);
          // Обновление позиции ребра, связанного с вершинами i и j
          // Например, можно обновить список точек ребра, если он хранится отдельно
          // или обновить матрицу ребер с новыми координатами вершин
          widget.task.graph[i][j] = (endPoint - startPoint).distance.toInt();
          // Если ребро неориентированное, то также обновите обратное ребро
          widget.task.graph[j][i] = (endPoint - startPoint).distance.toInt();
          setState(() {

          });
        }
      }
    }
  }

  void _checkPlangraph(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child:  Stack(
          fit: StackFit.expand,
          children: [
            Container(
              child: Container(
                child: isTimeEnd != false
                    ? Text(
                    "${time}",
                  style: TextStyle(
                      color: Colors.red
                  )
                )
                    : Text("${time}"
                )
              ),
            ),
            GestureDetector(
              onLongPressStart: (details) {
                final tapPosition = details.localPosition;
                final vertexIndex = getTappedVertexIndex(tapPosition);
                for (int i = 0; i < points.length; i++) {
                  if ((tapPosition.dx - points[i].dx).abs() < 30.0) {
                    selectedVertexOffset = i;
                    setState(() {});
                    print('Good - Tapped Vertex: $i'); // Выводим сообщение с индексом вершины
                    break;
                  } else {
                    print('Bad');
                  }
                }
                setState(() {
                  draggingVertexIndex = vertexIndex;
                  lastDragOffset = tapPosition;
                });
              },
              onLongPressMoveUpdate: (details) {
                if (draggingVertexIndex != null && lastDragOffset != null) {
                  final newOffset = details.localPosition;
                  final delta = newOffset - lastDragOffset!;
                  setState(() {
                    points[draggingVertexIndex!] += delta;
                    lastDragOffset = newOffset;
                  });
                }
              },
              child: CustomPaint(
                painter: OpenPainter(
                    matrix: widget.task.graph,
                    selectedIndex: selectedVertexOffset,
                    points:points
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right:0,
              child: Container(
                  child: ElevatedButton(
                    onPressed: _checkPlangraph,
                    child: Text('Закончить'),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final int? selectedIndex;
  final List<Offset> points;
  OpenPainter({
    Key? key,
    required this.matrix,
    required this.selectedIndex,
    required this.points
  });
  @override
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var drawPoints = Paint()..color = Color(0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;
    var drawLines = Paint()..color = Color(0xffb69d9d)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;

    var selectedIndexPaint =  Paint()..color = const Color(0xffcd4527)..strokeWidth = 10..style = PaintingStyle.stroke;

    var radius = 140;
    if (matrix.length > 10) {
      radius = 500;
    } else if (matrix.length > 20) {
      radius = 1000;
    }

    // основной цикл полного рисования (петли, веса и направления т.д.)
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix.length; j++) {
        if (matrix[i][j] != 0) {
          final startPoint = this.points[i];
          final endPoint = this.points[j];

          if (i == selectedIndex || j == selectedIndex) {
            drawLines.color = Colors.red; // Изменяем цвет связи выбранной вершины и ребра
          } else {
            drawLines.color = Colors.black; // Используем исходный цвет связи и ребра для остальных вершин
          }

          canvas.drawLine(startPoint, endPoint, drawLines);
        }
      }
    }

    // рисование вершин и индекса вершины
    for (var i = 0; i < matrix.length; i++) {
      canvas.drawCircle(this.points[i], 15, selectedIndex == i ? selectedIndexPaint : drawPoints);
      int letterIndex = i % 26;
      String letter = String.fromCharCode(65 + letterIndex);
      TextSpan span = TextSpan(style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text:  (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if (matrix.length > 9) {
        if (i < 9) {
          tp.paint(canvas, Offset(this.points[i].dx -5.0, this.points[i].dy - 8.0));
        } else {
          tp.paint(canvas, Offset(this.points[i].dx -9.0, this.points[i].dy - 8.0));
        }
      } else {
        tp.paint(canvas, Offset(this.points[i].dx -5.0, this.points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
