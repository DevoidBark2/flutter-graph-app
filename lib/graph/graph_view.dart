import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GraphView extends StatefulWidget {
  final List<List<TextEditingController>> controllers;


  const GraphView({Key? key, required this.controllers}): super(key: key);

  @override
  State<GraphView> createState() => _GraphViewState();
}


class _GraphViewState extends State<GraphView> {
  late final matrixF = widget.controllers;
  @override
  Widget build(BuildContext context) {
    var m = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
          child: CustomPaint(
            painter: OpenPainter(matrix: m),
          ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  OpenPainter({Key? key, required this.matrix});
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 30;

    var paint2 = Paint()
      ..color = const Color(0xffef0037)//rounded points
      ..strokeWidth = 2;

    var paint3 =  Paint()
      ..color = const Color(0xffef0037)//rounded points
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    // var paint4 =  Paint()
    //   ..color = const Color(0xffef0037)//rounded points
    //   ..strokeWidth = 10;

    final List<Offset> points = [];
    for(var i =0; i < matrix.length;i++){
      if(matrix.length == 4){
        if(i == 0){
          points.add(const Offset(75, 75));
        }
        if(i == 1){
          points.add(const Offset(225, 75));
        }
        if(i == 2){
          points.add(const Offset(75, 225));
        }
        if(i == 3){
          points.add(const Offset(225, 225));
        }
      }
      if(matrix.length == 5){
        if(i == 0){
          points.add(const Offset(150, 50));
        }
        if(i == 1){
          points.add(const Offset(50, 150));
        }
        if(i == 2){
          points.add(const Offset(250, 150));
        }
        if(i == 3){
          points.add(const Offset(100, 250));
        }
        if(i == 4){
          points.add(const Offset(200, 250));
        }
      }
      if(matrix.length == 2){
        if(i == 0){
          points.add(const Offset(75, 75));
        }
        if(i == 1){
          points.add(const Offset(225, 75));
        }
      }

    }


    for(var i =0;i < matrix.length  ;i++){
      for(var j = 0;j < matrix.length;j++){
        if(matrix[i][j] != 0){
          if(i == j){ // рисует петлю
            Offset ofs = Offset(points[i].dx, points[i].dy - 15);
            canvas.drawCircle(ofs,20.0, paint3);
          }
          else{  // рисует просто линия
               //рисует вес графа
               //  TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold), text: "${matrix[i][j]}");
               //  TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
               //  tp.layout();
               //  tp.paint(canvas, Offset(points[i].dx + 20.0, points[j].dy + 20.0));

              canvas.drawLine(points[i], points[j], paint2);
              // if(matrix[j][i] > 0){
              //   matrix[j][i] = 0;
              // }
              // else{
              //   //рисуем стрелку
              // }
                matrix[j][i] = 0;
            //
            // path.moveTo(points[i].dx - 20, points[i].dy - 20);
            // path.lineTo(points[i].dx - 20,points[i].dy - 20);
            //
            // // path.moveTo(points[i].dx +50, points[i].dy + 50);
            // path.lineTo(points[i].dx -15, points[i].dy +30);
            //
            // // path.moveTo(points[i].dx -15, points[i].dy +30);
            // // path.lineTo(points[i].dx -100, points[i].dy -100);
            // path.close();
            // canvas.drawPath(path,paint4);

          }
        }
        canvas.drawPoints(PointMode.points, points, paint1);
        for(var i =0;i < points.length;i++){
          TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold), text: "${i + 1}");
          TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
          tp.layout();
          tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
        }
      }
    }


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}