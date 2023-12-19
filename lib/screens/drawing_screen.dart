import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset> points = [];
  List<List<int>> edges = [];
  int activePointIndex = -1;

  final adjacencyMatrix = [
    [0, 1, 1, 1, 1],
    [1, 0, 1, 1, 1],
    [1, 1, 0, 1, 1],
    [1, 1, 1, 0, 1],
    [0, 1, 1, 1, 0]];

  @override
  void initState() {
    super.initState();
    createVertices();
    createEdges();
  }

  void createVertices() {
    final numVertices = adjacencyMatrix.length;
    const double radius = 150;
    const double centerX = 300;
    const double centerY = 300;
    final double angleBetweenVertices = 2 * pi / numVertices;

    for (var i = 0; i < numVertices; i++) {
      final x = centerX + radius * cos(i * angleBetweenVertices);
      final y = centerY + radius * sin(i * angleBetweenVertices);
      points.add(Offset(x, y));
    }
  }

  void createEdges() {
    final numVertices = adjacencyMatrix.length;

    for (var i = 0; i < numVertices; i++) {
      for (var j = i + 1; j < numVertices; j++) {
        if (adjacencyMatrix[i][j] == 1) {
          edges.add([i, j]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (position) {
        final typePosition = position.localPosition;
        final tappedPointIndex = getTappedPointIndex(typePosition);
        if (activePointIndex == -1) {
          if (tappedPointIndex == null) {
            points.add(typePosition);
          } else {
            activePointIndex = tappedPointIndex;
          }
        } else
        if (tappedPointIndex != null && tappedPointIndex != activePointIndex) {
          createEdge(activePointIndex, tappedPointIndex);
          activePointIndex = -1;
        }
        setState(() {});
      },
      onLongPressDown: (details) {
        final off = details.localPosition;
        activePointIndex = getTappedPointIndex(off) ?? -1;
        setState(() {});
      },
      onPanUpdate: (details) {
        if (activePointIndex != -1) {
          final newPosition = details.localPosition;
          points[activePointIndex] = newPosition;
          setState(() {});
        }
      },
      onPanEnd: (_) {
        activePointIndex = -1;
      },
      child: Scaffold(
        body: CustomPaint(
          painter: OpenPainter(
              points: points, edges: edges, activePointIndex: activePointIndex),
        ),
      ),
    );
    }



  int? getTappedPointIndex(Offset position) {
    for (var i = 0; i < points.length; i++) {
      if (pow(position.dx - points[i].dx, 2) + pow(position.dy - points[i].dy, 2) <= pow(30, 2)) {
        return i;
      }
    }
    return null;
  }

  void createEdge(int start, int end) {
    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }
    edges.add([start, end]);
  }

}



class OpenPainter extends CustomPainter {
  final List<Offset> points;
  final List<List<int>> edges;
  final int activePointIndex;

  OpenPainter({required this.points, required this.edges, required this.activePointIndex});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color(0xff63aa65)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    var paint2 = Paint()
      ..color = const Color(0xffee0606)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 50;

    for (var i = 0; i < points.length; i++) {
      if (activePointIndex == i) {
        canvas.drawCircle(points[i], 15, paint1);
      } else {
        canvas.drawCircle(points[i], 15, paint2);
      }
    }

    for (var i = 0; i < points.length - 1; i++) {
      drawLine(canvas, points[i], points[i + 1], paint1);
    }

    for (var i = 0; i < points.length; i++) {
      TextSpan span =
      TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text: "${i + 1}");
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx - 5.0, points[i].dy - 5.0));
    }

    for (var i = 0; i < edges.length; i++) {
      final start = points[edges[i][0]];
      final end = points[edges[i][1]];
      drawLine(canvas, start, end, paint1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
  }
}