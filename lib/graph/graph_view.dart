import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class GraphView extends StatefulWidget {
  final List<List<TextEditingController>> controllers;
  final bool isCheckedWeight;
  final bool isCheckedOriented;

  const GraphView({Key? key, required this.controllers,required this.isCheckedWeight,required this.isCheckedOriented}): super(key: key);
  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  late final matrixF = widget.controllers;
  late final isCheckedWeight = widget.isCheckedWeight;
  late final isCheckedOriented = widget.isCheckedOriented;
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
              painter: OpenPainter(matrix: matrix,isCheckedWeight: isCheckedWeight,isCheckedOriented: isCheckedOriented),
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
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: isCheckedWeight == true ? Text('$isCheckedWeight') : const Text('')
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
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  OpenPainter({Key? key, required this.matrix,required this.isCheckedWeight,required this.isCheckedOriented});
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    var paint1 = Paint()
      ..color = const Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 30;

    var paint2 = Paint()
      ..color = const Color(0xffef0037)//rounded points
      ..strokeWidth = 2;

    var paint3 =  Paint()
      ..color = const Color(0xffb69d9d)//rounded points
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    var paint4 =  Paint()
      ..color = const Color(0xff000000)//rounded points
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final List<Offset> points = [];
    var paint5 =  Paint()
      ..color = const Color(0xffb69d9d)//rounded points
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    //рисование точек
    for(var i =0; i < matrix.length;i++){
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * 140 + (size.width / 2)), (sin(angle) * 140 + (size.width / 2))));
    }

    canvas.drawCircle(Offset(150,150), 140, paint5);

    //основной цикл полного рисования(петли, веса и т.д.)
    for(var i =0;i < matrix.length  ;i++){
      for(var j = 0;j < matrix.length;j++){
        if(matrix[i][j] != 0){
          if(i == j){ // рисует петлю
            Offset ofs = Offset(points[i].dx, points[i].dy - 15);
            canvas.drawCircle(ofs,20.0, paint3);
          }
          else{
                // рисует просто линия
                canvas.drawLine(points[i], points[j], paint2);
                TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold), text: "${matrix[i][j]}");
                TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
                tp.layout();
                //рисует вес графа
                if(isCheckedWeight){
                  if(matrix.length % 2 == 0){
                    var del = 1/3; // делим отрезок в отношении 1/3
                    tp.paint(canvas, Offset(((points[i].dx + del * points[j].dx) / (1 + del)), ((points[i].dy + del * points[j].dy) / (1 + del))));
                  }else{
                    // иначе делим в нормальном отношении 1/2
                    tp.paint(canvas, Offset(((points[i].dx + points[j].dx) / 2), ((points[i].dy + points[j].dy) / 2)));
                  }
                }

              if(isCheckedOriented){
                var del = 19/2;
                final targetPoint = Offset(((points[i].dx + del * points[j].dx) / (1 + del)), ((points[i].dy + del * points[j].dy) / (1 + del)));
                final dX = targetPoint.dx - points[i].dx;
                final dY = targetPoint.dy - points[i].dy;
                final angle = atan2(dX, dY);
                const arrowSize = 5;
                const arrowAngle=  30 * pi/360;
                path.moveTo(targetPoint.dx - arrowSize * sin(angle - arrowAngle), targetPoint.dy - arrowSize * cos(angle - arrowAngle));
                path.lineTo(targetPoint.dx, targetPoint.dy);
                path.lineTo(targetPoint.dx - arrowSize * sin(angle + arrowAngle),targetPoint.dy - arrowSize * cos(angle + arrowAngle));
                path.close();
                canvas.drawPath(path, paint4);
              }

              // if(matrix[j][i]! > 0){
              //   matrix[j][i] = 0;
              // }
              // else{
              //   //рисуем стрелку
              //
              // }
              matrix[j][i] = 0;
          }
        }
      }
    }

    // рисование вершин
    for(var i = 0;i < matrix.length;i++) {
      //в дальнейшем тут надо будет при условии рисовать вершины разных цветов
      canvas.drawCircle(points[i], 15, paint1);
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