import 'dart:collection';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/algorithms/bfs.dart';
import 'package:test_project/algorithms/chromatic_number.dart';
import 'package:test_project/algorithms/dijkstra_algorithm.dart';
import 'package:test_project/algorithms/get_degress.dart';
import 'package:test_project/algorithms/kruskal_algorithm.dart';

class GraphView extends StatefulWidget {
  final List<List<TextEditingController>> controllers;
  final bool isCheckedWeight;
  final bool isCheckedOriented;

  const GraphView({Key? key, required this.controllers,required this.isCheckedWeight,required this.isCheckedOriented}): super(key: key);
  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  late final matrixFrom = widget.controllers;
  late final isCheckedWeight = widget.isCheckedWeight;
  late final isCheckedOriented = widget.isCheckedOriented;
  var res;
  bool showRes = false;
  int colorVertices = 0;
  int colorEdges = 0;
  String typeEdges = "";
  String error = "";
  late var matrix = List.generate(matrixFrom.length, (row) => List.generate(matrixFrom.length ,(column) => int.tryParse(matrixFrom[row][column].text)));

  void getColorVertices() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      colorVertices = storage.getInt("indexColorVertices") ?? Colors.red.value;
    });
  }
  void getColorEdges() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      colorEdges = storage.getInt("indexColorEdges") ?? Colors.red.value;
    });
  }
  void getTypeEdges() async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      typeEdges = storage.getString("typeEdges") ?? "Digit";
    });
  }
  void kruskal(){
    var result = KruskalAlgorithm.kruskalAlgorithm(isCheckedWeight, isCheckedOriented, error, matrix);
    setState(() {
        //algorithmMatrix = matrix;
        if(result.error == ''){
          matrix = result.newMatrix;
          res = 'Сумма весов минимального остовного дерева: ${result.totalWeight.toInt()}';
          showRes = true;
        }
       else{
         error = result.error;
       }
    });
  }
  void dijkstra(int index){
    var result = DijkstraAlgorithm.dijkstraAlgorithm(matrix, index);
    setState(() {
      res = result.result;
      showRes = true;
    });
  }
  void getDegrees(){
    var result = GetDegreesAlgorithm.getDegrees(matrix);
    setState(() {
      res = result.result;
      showRes = true;
    });
  }
  void bfs(int start){
    var result = BFSAlgorithm.bfs(matrix, start);
    setState(() {
      res = result.toString();
      showRes = true;
    });
  }
  void chromaticNumber(){
    var result = ChromaticNumber.chromaticNumber(matrix);
    setState(() {
      res = "Хроматическое число графа: $result";
      showRes = true;
    });
  }

  void countOfRibs(){
    var edgesCount = 0;
    for(var i=0; i<matrix.length; i++){
      for(var j=i+1; j<matrix[i].length; j++){
        if(matrix[i][j] != null && matrix[i][j] != 0){
          edgesCount++;
        }
      }
    }
    setState(() {
      res = "Кол-во ребер: $edgesCount";
      showRes = true;
    });
  }
  void getRadius(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    List<List<double>> distances = List.generate(n, (_) => List.generate(n, (_) => 0));

    // initialize distances matrix with adjacency matrix values
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (adjacencyMatrix[i][j] != null) {
          distances[i][j] = adjacencyMatrix[i][j]!.toDouble();
        } else {
          distances[i][j] = double.infinity;
        }
      }
    }

    // Floyd-Warshall algorithm
    for (int k = 0; k < n; k++) {
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if (distances[i][k] + distances[k][j] < distances[i][j]) {
            distances[i][j] = distances[i][k] + distances[k][j];
          }
        }
      }
    }

    // find the maximum value in the distances matrix
    double maxDistance = double.negativeInfinity;
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (distances[i][j] > maxDistance && distances[i][j] != double.infinity) {
          maxDistance = distances[i][j];
        }
      }
    }

    setState(() {
      res = maxDistance.toString();
      showRes = true;
    });
  }
  void getDiameter(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    int diameter = 0;

    for (int i = 0; i < n; i++) {
      // Применяем модифицированный алгоритм BFS для получения пути до самой дальней вершины и ее расстояния
      List<int> distances = List.filled(n, -1);
      List<int?> previous = List.filled(n, null);
      Queue<int> queue = Queue<int>();

      queue.add(i);
      distances[i] = 0;

      while (queue.isNotEmpty) {
        int? vertex = queue.removeLast();

        for (int j = 0; j < n; j++) {
          if (adjacencyMatrix[vertex][j] == 1 && distances[j] == -1) {
            queue.add(j);
            distances[j] = distances[vertex] + 1;
            previous[j] = vertex;
          }
        }
      }

      // находим самую дальнюю вершину и путь до нее
      int farthestVertex = distances.indexOf(distances.reduce(max));
      List<int> path = [farthestVertex];

      while (previous[farthestVertex] != null) {
        farthestVertex = previous[farthestVertex]!;
        path.add(farthestVertex);
      }

      // применяем алгоритм BFS для поиска диаметра графа
      distances = List.filled(n, -1);
      previous = List.filled(n, null);
      queue = Queue<int>();

      queue.addAll(path);
      distances[path.last] = 0;

      while (queue.isNotEmpty) {
        int? vertex = queue.removeLast();
        for (int j = 0; j < n; j++) {
          if (adjacencyMatrix[vertex][j] == 1 && distances[j] == -1) {
            queue.add(j);
            distances[j] = distances[vertex] + 1;
            previous[j] = vertex;
          }
        }
      }

      // находим максимальную дистанцию и обновляем значение диаметра
      int maxDistance = distances.reduce(max);

      if (maxDistance > diameter) {
        diameter = maxDistance;
      }
    }

    setState(() {
      res = diameter;
      showRes = true;
    });
  }

  @override
  void initState() {
    super.initState();
    getColorVertices();
    getColorEdges();
    getTypeEdges();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            minScale: matrix.length > 9 ? 0.1 : 0.3,
            maxScale: 10.5,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: 400,
              height: 400,
              child: CustomPaint(
                painter: OpenPainter(
                    matrix: matrix,
                    isCheckedWeight: isCheckedWeight,
                    isCheckedOriented: isCheckedOriented,
                    colorVertices:colorVertices,
                    colorEdges:colorEdges,
                    typeEdges: typeEdges
                ),
              ),
            ),
          ),
          Positioned(
            child: DraggableScrollableSheet(
              initialChildSize: showRes ? 0.07 : 0.0,
              minChildSize: showRes ? 0.07 : 0.0,
              builder: (context,controller) => Container(
                  decoration: BoxDecoration(
                    color:Colors.amberAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: controller,
                      itemCount: 1,
                      itemBuilder: (context,index){
                        return Text(res.toString());
                      },
                    ),
                  )
              ),
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        width: 210,
          child:ListView(
            children: [
              const ListTile(
                title: Text('Свойства',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ),
              ListTile(
                  title: const Text('Степень вершин',textAlign: TextAlign.center),
                  onTap: (){
                    getDegrees();
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Хроматическое число',textAlign: TextAlign.center),
                  onTap: (){
                    chromaticNumber();
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Радиус',textAlign: TextAlign.center),
                  onTap: (){
                    getRadius(matrix);
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Диаметр',textAlign: TextAlign.center),
                  onTap: (){
                    getDiameter(matrix);
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Количество ребер',textAlign: TextAlign.center),
                  onTap: (){
                    countOfRibs();
                    Navigator.pop(context);
                  }
              ),
              const ListTile(
                title: Text('Алгоритмы',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
              ),
              ListTile(
                title: const Text('Алгоритм Крускала',textAlign: TextAlign.center),
                onTap: (){
                  kruskal();
                  if(error != ''){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.amber,
                          child: Center(
                            child: Text(error),
                          ),
                        );
                      },
                    );
                  }
                  else{
                    Navigator.pop(context);
                  }
                }
              ),
              ListTile(
                  title: const Text('Алгоритм Дейкстры',textAlign: TextAlign.center),
                  onTap: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: const Color(0xffE8E8E8FF),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                                child: isCheckedWeight ? ListView.builder(
                                  itemCount: matrix.length,
                                  itemBuilder: (context, index) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        dijkstra(index);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                      ),
                                      child:Text("${index + 1}"),
                                    );
                                  },
                                ) : const Text('Граф должен быть взвешенный')
                            ),
                          )
                        );
                      },
                    );
                  }
              ),
              ListTile(
                  title: const Text('Обход в ширину',textAlign: TextAlign.center),
                  onTap: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: const Color(0xffE8E8E8FF),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                                child:ListView.builder(
                                  itemCount: matrix.length,
                                  itemBuilder: (context, index) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        bfs(index);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child:Text("${index + 1}"),
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                      ),
                                    );
                                  },
                                )
                            ),
                          )
                        );
                      },
                    );
                  }
              ),
            ],
          )
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  final int colorVertices;
  final int colorEdges;
  final String typeEdges;
  OpenPainter({Key? key,
    required this.matrix,
    required this.isCheckedWeight,
    required this.isCheckedOriented,
    required this.colorVertices,
    required this.colorEdges,
    required this.typeEdges
  });
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final List<Offset> points = [];

    var drawPoints = Paint()..color = Color(colorVertices)..strokeCap = StrokeCap.round..strokeWidth = 20;
    var drawLines = Paint()..color = Color(colorEdges)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;
    var radius = 140;
    if(matrix.length > 10) {
      radius = 500;
    }else if(matrix.length > 20){
      radius = 1000;
    }
    //добавление вершин
    for(var i = 0; i < matrix.length;i++){
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * radius + (size.width / 2)), (sin(angle) * radius + (size.width / 2))));
    }

    //основной цикл полного рисования(петли, веса и направления т.д.)
    for(var i = 0; i < matrix.length;i++){
      for(var j = 0; j < matrix.length;j++){
        if(matrix[i][j] != 0) {
          // рисует петлю
          if(i == j) {
            Offset ofs = Offset(points[i].dx, points[i].dy - 15);
            canvas.drawCircle(ofs,20.0, paint3);
          }
          else{
                // рисует ребро
                canvas.drawLine(points[i], points[j], drawLines);

                //рисует вес графа
                if (isCheckedWeight && matrix[i][j] != -1) {
                  TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17), text: "${matrix[i][j]}");
                  TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
                  tp.layout();
                  if (matrix.length % 2 == 0 && matrix[i][j] != matrix[j][i]) {
                    // делим отрезок в отношении 1/3
                    var del = 1/3;
                    tp.paint(canvas, Offset(((points[i].dx + del * points[j].dx) / (1 + del)), ((points[i].dy + del * points[j].dy) / (1 + del))));
                  } else {
                    // иначе делим в нормальном отношении 1/2
                    tp.paint(canvas, Offset(((points[i].dx + points[j].dx) / 2), ((points[i].dy + points[j].dy) / 2)));
                  }
                }

                //рисует направление ребра
                if(isCheckedOriented){
                  if(points[i] != points[j] && matrix[i][j] != matrix[j][i]){
                    var del = 17/2;
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
                }
          }
        }
      }
    }

    // рисование вершин и индекса вершины
    for(var i = 0;i < matrix.length;i++) {
      canvas.drawCircle(points[i], 15, drawPoints);
      int letterIndex = i % 26;
      String letter = String.fromCharCode(65 + letterIndex);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          text: typeEdges == "TypeEdges.Letter" ? "$letter${i + 1}" : (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if(matrix.length > 9){
        if(i < 9){
          tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
        }else{
          tp.paint(canvas, Offset(points[i].dx -9.0, points[i].dy - 8.0));
        }
      }
      else{
        tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
