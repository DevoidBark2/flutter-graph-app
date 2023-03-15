import 'dart:math';
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
  var N = 0;
  var count = 0;
  bool completeGraph(){
    var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
    for(var i = 0; i < matrix.length; i++){
      for(var j = 0; j < matrix.length;j++){
        if(i == j){
          continue;
        }
        if(matrix[i][j] == 0){
          return false;
        }
      }
    }
    return true;
  }

  void countOfRibs(){
    var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
    for(var i = 0; i < matrix.length; i++){
      for(var j = 0; j < matrix.length;j++){
        if(matrix[i][j] != 0){
          count++;
        }
      }
    }
    N = count ~/ 2;
  }
  bool emptyGraph(){
    var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
    var count = 0;
    for(var i = 0; i < matrix.length; i++){
      for(var j = 0; j < matrix.length;j++){
        count += matrix[i][j]!;
      }
    }
    if(count == 0){
      return true;
    }
    else{
      return false;
    }
  }
  @override
  void initState() {
    super.initState();
    countOfRibs();
  }

  @override
  Widget build(BuildContext context) {
    var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: OpenPainter(matrix: matrix),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                  child: Text('Количество ребер: $N')
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: completeGraph() == true ? const Text('Полный граф') : const Text('Не полный граф')
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: emptyGraph() == true ? const Text('Пустой граф: Да') : const Text('Пустой граф: Нет')
              ),
            ],
          )
        ],
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

    var paintForPoint = Paint()
      ..color = const Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 25;

    var paint2 = Paint()
      ..color = const Color(0xffef0037)//rounded points
      ..strokeWidth = 2;

    var paint3 =  Paint()
      ..color = const Color(0xffb69d9d)//rounded points
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // var paint4 =  Paint()
    //   ..color = const Color(0xffef0037)//rounded points
    //   ..strokeWidth = 10;

    final List<Offset> points = [];
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 140, paint3);

    final segment = 360 / matrix.length;
    for(var i =0; i < matrix.length;i++){
      final angle = 2 * pi * (i / matrix.length) + segment;
      points.add(Offset((cos(angle) * 140 + (size.width / 2)), (sin(angle) * 140 + (size.width / 2))));
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
              // }
              matrix[j][i] = 0;
          }
        }
      }
    }

    // рисование вершин
    if(points.length > 6){
      canvas.drawPoints(PointMode.points, points, paintForPoint);
    }
    else{
      canvas.drawPoints(PointMode.points, points, paint1);
    }

    // рисование индекса вершины
    for(var i =0;i < points.length;i++){
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold), text: "${i + 1}");
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}