import 'dart:math';
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
  int index = 0;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onLongPressStart: (details){
          var off = details.localPosition;
          for(var i = 0;i < points.length;i++){
            if(pow(off.dx - points[i].dx,2) + pow(off.dy - points[i].dy,2) <= pow(30,2)){
              index = i;
              flag = false;
              break;
            }
          }
          flag = true;
          setState(() {});
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
              painter: OpenPainter(points:points,index:index,flag:flag),
            )
          )
      );
  }
}

class OpenPainter extends CustomPainter{
  final List<Offset> points;
  final int index;
  late final bool flag;
  OpenPainter({Key? key, required this.points,required this.index,required this.flag});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()..color = const Color(0xff63aa65)..strokeCap = StrokeCap.round..strokeWidth = 30;
    var paint2 = Paint()..color = const Color(0xffee0606)..strokeCap = StrokeCap.round..strokeWidth = 50;
    for(var i =0;i < points.length;i++){
      var flag = false;
      if(index == i && flag != true){
        canvas.drawCircle(points[i], 15, paint1);
        flag = true;
      }else{
        canvas.drawCircle(points[i], 50, paint2);
      }
    }
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

