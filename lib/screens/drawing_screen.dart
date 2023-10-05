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
  int activePointIndex = -1;
  int startVertexIndex = -1;
  int endVertexIndex = -1;

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
            startVertexIndex = tappedPointIndex;
          }
        } else {
          if (tappedPointIndex != null && tappedPointIndex != activePointIndex) {
            endVertexIndex = tappedPointIndex;
            createEdge(startVertexIndex, endVertexIndex);
          }
          resetLine();
        }
        if (kDebugMode) {
          print(points);
        }
        setState(() {});
      },
      onLongPressDown: (details) {
        resetLine();
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
        resetLine();
      },
      child: Scaffold(body: CustomPaint(painter: OpenPainter(points: points, activePointIndex: activePointIndex))),
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
    for (var i = start + 1; i < end; i++) {
      points.removeAt(start + 1);
      end--;
    }
  }

  void resetLine() {
    startVertexIndex = -1;
    endVertexIndex = -1;
  }
}

class OpenPainter extends CustomPainter {
  final List<Offset> points;
  final int activePointIndex;

  OpenPainter({Key? key, required this.points, required this.activePointIndex});

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
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text: "${i + 1}");
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx - 5.0, points[i].dy - 5.0));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
  }
}