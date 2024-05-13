import 'package:flutter/material.dart';

import '../models/Vertex.dart';

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final int? selectedIndex;
  final List<Offset> points;
  final int? color;
  final List<Vertex> colorsVertex;
  OpenPainter({
    Key? key,
    required this.matrix,
    required this.selectedIndex,
    required this.points,
    required this.color,
    required this.colorsVertex
  });
  @override
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var drawPoints = Paint()..color = const Color(0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;
    var drawLines = Paint()..color = const Color(0xffb69d9d)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;

    int getVertexColor(List<Vertex> colorsGraph, int selectedIndex) {
      return colorsGraph.firstWhere((Vertex vertex) => vertex.index == selectedIndex, ).color;
    }

    var selectedIndexPaint =  Paint()..color = Color(color != null ? getVertexColor(colorsVertex, selectedIndex!) : 0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;

    var radius = 140;
    if (matrix.length > 10) {
      radius = 500;
    } else if (matrix.length > 20) {
      radius = 1000;
    }

    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix.length; j++) {
        if (matrix[i][j] != 0) {
          final startPoint = points[i];
          final endPoint = points[j];

          final offset = endPoint - startPoint;
          final normalizedOffset = offset / offset.distance * 15; // Длина отступа

          final adjustedStartPoint = startPoint + normalizedOffset;
          final adjustedEndPoint = endPoint - normalizedOffset;

          if (i == selectedIndex || j == selectedIndex) {
            drawLines.color = Colors.black;
          } else {
            drawLines.color = Colors.black;
          }

          canvas.drawLine(adjustedStartPoint, adjustedEndPoint, drawLines);
        }
      }
    }

    for (var i = 0; i < matrix.length; i++) {
      selectedIndexPaint.color = Color(0xffb69d9d); // Set default color
      if (selectedIndex != null && selectedIndex == i) {
        selectedIndexPaint.color = Color(color != null ? getVertexColor(colorsVertex, selectedIndex!) : 0xffb69d9d);
      }

      canvas.drawCircle(points[i], 15, selectedIndexPaint);
      int letterIndex = i % 26;
      String letter = String.fromCharCode(65 + letterIndex);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text:  (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if (matrix.length > 9) {
        if (i < 9) {
          tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
        } else {
          tp.paint(canvas, Offset(points[i].dx -9.0, points[i].dy - 8.0));
        }
      } else {
        tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}