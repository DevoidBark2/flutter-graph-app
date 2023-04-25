import 'dart:core';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphView extends StatefulWidget {
  final List<List<TextEditingController>> controllers;
  final bool isCheckedWeight;
  final bool isCheckedOriented;

  const GraphView({Key? key, required this.controllers,required this.isCheckedWeight,required this.isCheckedOriented}): super(key: key);
  @override
  State<GraphView> createState() => _GraphViewState();
}

class Edge {
  int a, b, w;
  Edge(this.a, this.b, this.w);
}

List<Edge> getEdgesFromMatrix(List<List<int?>> matrix) {
  List<Edge> edges = [];
  int n = matrix.length;
  for (int i = 0; i < n; i++) {
    for (int j = i + 1; j < n; j++) {
      if (matrix[i][j] != 0) {
        edges.add(Edge(i+1, j+1, matrix[i][j]!));
      }
    }
  }
  return edges;
}

class _GraphViewState extends State<GraphView> {
  late final matrixF = widget.controllers;
  late final isCheckedWeight = widget.isCheckedWeight;
  late final isCheckedOriented = widget.isCheckedOriented;
  var N = 0;
  var colorVertices = 0;
  var colorEdges = 0;
  String count = '';
  String error = '';
  List<List<int?>> algoritmMatrix = [];
  late var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));

  // bool completeGraph(){
  //   var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
  //   for(var i = 0; i < matrix.length; i++){
  //     for(var j = 0; j < matrix.length;j++){
  //       if(i == j){
  //         continue;
  //       }
  //       if(matrix[i][j] == 0){
  //         return false;
  //       }
  //     }
  //   }
  //   return true;
  // }
  // bool emptyGraph(){
  //   var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
  //   var count = 0;
  //   for(var i = 0; i < matrix.length; i++){
  //     for(var j = 0; j < matrix.length;j++){
  //       count += matrix[i][j]!;
  //     }
  //   }
  //   if(count == 0){
  //     return true;
  //   }
  //   else{
  //     return false;
  //   }
  // }
  void countOfRibs(){
    var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
    var count = matrix.length;
    N = (count* (count - 1)) ~/ 2;
  }

  void getColorVertices() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      colorVertices = storage.getInt("indexColorVertices") ?? 0xfffcba03;
    });
  }
  void getColorEdges() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      colorEdges = storage.getInt("indexColorEdges") ?? 0xfffcba03;
    });
  }

  void printOneText(){
    if(isCheckedWeight == false){
        error = 'Граф должен быть взвешенный';
    }else{
      var mat = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
      List<Edge> edges = getEdgesFromMatrix(mat);
      List<Edge> result = [];
      List<int> treeIds = List<int>.generate(mat.length+1, (int index) => index);
      edges.sort((a, b) => a.w - b.w); // сортируем ребра по весу

      for (Edge edge in edges) {
        if (treeIds[edge.a] != treeIds[edge.b]) {
          result.add(edge);
          int oldId = treeIds[edge.b], newId = treeIds[edge.a];
          for (int i = 1; i <= mat.length; i++) {
            if (treeIds[i] == oldId) treeIds[i] = newId;
          }
        }
      }
      List<List<int>> newMatrix = List.generate(mat.length, (i) => List.filled(mat.length, 0));
      for (Edge edge in result) {
        newMatrix[edge.a - 1][edge.b - 1] = edge.w;
        newMatrix[edge.b - 1][edge.a - 1] = edge.w;
      }
      setState(() {
        algoritmMatrix = matrix;
        matrix = newMatrix;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    countOfRibs();
    getColorVertices();
    getColorEdges();
  }

  @override
  Widget build(BuildContext context) {
    List<Object> num = ["Свойства","Кол-во ребер: $N"];
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Text(count),
          InteractiveViewer(
            minScale: 0.3,
            maxScale: 10.5,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: 400,
              height: 400,
              child: CustomPaint(
                painter: OpenPainter(matrix: matrix, algoritmMatrix:algoritmMatrix, isCheckedWeight: isCheckedWeight,isCheckedOriented: isCheckedOriented,colorVertices:colorVertices,colorEdges:colorEdges),
              ),
            ),
          ),
          Positioned(
            child: DraggableScrollableSheet(
              initialChildSize: 0.08,
              minChildSize: 0.08,
              builder: (context,controller) => Container(
                  decoration: BoxDecoration(
                    color:Colors.amberAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: controller,
                      itemCount: num.length,
                      itemBuilder: (context,index){
                        return index == 0 ? Text('${num[index]}',textAlign: TextAlign.center) : Text("${num[index]}");
                      },
                    ),
                  )
              ),
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        width: 250,
          child:ListView(
            children: [
              ListTile(
                title: const Text('Алгоритм Крускала'),
                onTap: (){
                  printOneText();
                  // error != '' ? final snackBar = SnackBar(
                  //   content: const Text('Yay! A SnackBar!'),
                  //   action: SnackBarAction(
                  //     label: 'Undo',
                  //     onPressed: () {
                  //       // Some code to undo the change.
                  //     },
                  //   ),
                  // );
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.pop(context);

                }
              )
            ],
          )
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final List<List<int?>> algoritmMatrix;
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  final int colorVertices;
  final int colorEdges;
  OpenPainter({Key? key,
    required this.matrix,
    required this.algoritmMatrix,
    required this.isCheckedWeight,
    required this.isCheckedOriented,
    required this.colorVertices,
    required this.colorEdges
  });
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final List<Offset> points = [];

    var drawPoints = Paint()..color = Color(colorVertices)..strokeCap = StrokeCap.round..strokeWidth = 30; //!!!!!!!!!!!!!!!!!
    var drawLines = Paint()..color = Color(colorEdges)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;

    //добавление вершин
    for(var i =0; i < matrix.length;i++){
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * 140 + (size.width / 2)), (sin(angle) * 140 + (size.width / 2))));
    }

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
                canvas.drawLine(points[i], points[j], drawLines);
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
              matrix[j][i] = 0;
          }
        }
      }
    }

    // рисование вершин
    for(var i = 0;i < matrix.length;i++) {
      //в дальнейшем тут надо будет при условии рисовать вершины разных цветов
      canvas.drawCircle(points[i], 15, drawPoints);
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
