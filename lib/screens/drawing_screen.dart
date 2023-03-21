import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  Offset? _typePosition;
  List<Offset> points = [];
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onDoubleTapDown: (details){
          if (kDebugMode) {
            print(_typePosition);
          }
        },
        onTapUp: (position){
          _typePosition = position.localPosition;
          points.add(_typePosition!);
          if (kDebugMode) {
            print(points);
          }
          setState(() {});
        },
          child: Scaffold(
            body: CustomPaint(
              painter: OpenPainter(points:points),
            )
          )
      );
  }
}

class OpenPainter extends CustomPainter{
  final List<Offset> points;
  OpenPainter({Key? key, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = const Color(0xff63aa65)..strokeCap = StrokeCap.round..strokeWidth = 30;
    canvas.drawPoints(PointMode.points, points, paint1);
    for(var i =0;i < points.length;i++){
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold), text: "${i + 1}");
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx - 5.0, points[i].dy - 5.0));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  
}

