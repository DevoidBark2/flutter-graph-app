import 'dart:collection';
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

class _GraphViewState extends State<GraphView> {
  late final matrixF = widget.controllers;
  late final isCheckedWeight = widget.isCheckedWeight;
  late final isCheckedOriented = widget.isCheckedOriented;
  var N = 0;
  bool isHasEulerCycle = false;
  String circle = '';
  var colorVertices = 0;
  var colorEdges = 0;
  var typeEdges = "";
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
  // void countOfRibs(){
  //   // var matrix = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
  //   var count = matrix.length;
  //   N = (count* (count - 1)) ~/ 2;
  // }

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

  void kruskalAlgorithm(){
    print(matrix);
    if(isCheckedWeight == false){
        error = 'Граф должен быть взвешенный';
    }else if(isCheckedOriented == true){
      error="Граф не должен быть орентированный";
    }
    else{
      //var mat = List.generate(matrixF.length, (row) => List.generate(matrixF.length ,(column) => int.tryParse(matrixF[row][column].text)));
      List<Edge> edges = getEdgesFromMatrix(matrix);
      List<Edge> result = [];
      List<int> treeIds = List<int>.generate(matrix.length+1, (int index) => index);
      edges.sort((a, b) => a.w - b.w); // сортируем ребра по весу

      for (Edge edge in edges) {
        if (treeIds[edge.a] != treeIds[edge.b]) {
          result.add(edge);
          int oldId = treeIds[edge.b], newId = treeIds[edge.a];
          for (int i = 1; i <= matrix.length; i++) {
            if (treeIds[i] == oldId) treeIds[i] = newId;
          }
        }
      }
      List<List<int>> newMatrix = List.generate(matrix.length, (i) => List.filled(matrix.length, 0));
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

  // void hromatDigit(List<List<int?>> graph) {
  //   int n = graph.length;
  //   List<int?> colors = List.filled(n, null);
  //   List<bool> usedColors = List.filled(n, false);
  //
  //   for (int i = 0; i < n; i++) {
  //     List<int> neighbors = [];
  //     for (List<int?> edge in graph) {
  //       if (edge[0] == i) {
  //         neighbors.add(edge[1]!);
  //       } else if (edge[1] == i) {
  //         neighbors.add(edge[0]!);
  //       }
  //     }
  //
  //     for (int neighbor in neighbors) {
  //       if (colors[neighbor] != null) {
  //         usedColors[colors[neighbor]!] = true;
  //       }
  //     }
  //
  //     int color;
  //     for (color = 0; color < n; color++) {
  //       if (!usedColors[color]) {
  //         break;
  //       }
  //     }
  //
  //     colors[i] = color;
  //
  //     for (int neighbor in neighbors) {
  //       if (colors[neighbor] != null) {
  //         usedColors[colors[neighbor]!] = false;
  //       }
  //     }
  //   }
  //   print(colors);
  // }

  // void chromaticNumber(List<List<int?>> G, int N){
  //   const int MAXN = 1005;
  //   List<int?> color =  List<int?>.filled(MAXN, 0);
  //   int? ans = 1;
  //
  //   bool checkColor(int u, int c) {
  //     for(int v = 1; v <= N; v++){
  //       if(G[u][v] == 1 && color[v] == c){
  //         return false;
  //       }
  //     }
  //     return true;
  //   }
  //
  //   void dfs(int u) {
  //     if(u == N + 1){
  //       int? cnt = 0;
  //       for(int i = 1; i <= N; i++){
  //         cnt = cnt! > color[i]! ? cnt : color[i];
  //       }
  //       ans = ans! < cnt! ? ans : cnt;
  //       return;
  //     }
  //     for(int c = 1; c <= N; c++){
  //       if(checkColor(u, c)){
  //         color[u] = c;
  //         dfs(u + 1);
  //         color[u] = 0;
  //       }
  //     }
  //   }
  //
  //   dfs(1);
  //   setState(() {
  //     N = ans!;
  //   });
  // }

  void chromaticNumber(List<List<int?>> adjMatrix) {
    int n = adjMatrix.length;
    List<int> colors = List.filled(n, -1);
    List<bool> availableColors;

    for (int i = 0; i < n; i++) {
      availableColors = List.filled(n, true);

      for (int j = 0; j < n; j++) {
        if (adjMatrix[i][j] == 1 && colors[j] != -1) {
          availableColors[colors[j]] = false;
        }
      }

      int cr = 0;
      while (!availableColors[cr]) {
        cr++;
      }

      colors[i] = cr;
    }
    Set<int> uniqueColors = Set<int>.from(colors);
    setState(() {
      N = uniqueColors.length;
    });
  }

  void hasEulerCycle(List<List<int?>> adjacencyMatrix) {
    // Проверяем связность графа
    Set<int> visited = {};
    List<int> stack = [0];
    while (stack.isNotEmpty) {
      int v = stack.removeLast();
      if (!visited.contains(v)) {
        visited.add(v);
        stack.addAll([for (int i = 0; i < adjacencyMatrix[v].length; i++) if (adjacencyMatrix[v][i] == 1 && !visited.contains(i)) i]);
      }
    }
    if (visited.length != adjacencyMatrix.length) {
      setState(() {
        isHasEulerCycle = false;
      });
    }

    // Подсчитываем степени вершин
    List<int?> degrees = [for (List<int?> row in adjacencyMatrix) row.reduce((a, b) => a! + b!)];

    // Проверяем наличие эйлерова цикла
    int oddDegrees = degrees.where((degree) => degree! % 2 == 1).length;
    setState(() {
      isHasEulerCycle = oddDegrees == 0;
    });
  }

  List<int>? findEulerCycle(List<List<int?>> graph) {
    List<List<int>> copy = copyGraph(graph);
    int oddDegreeVertices = 0;
    int startVertex = 0;
    for (int i = 0; i < graph.length; i++) {
      int degree = 0;
      for (int j = 0; j < graph[i].length; j++) {
        degree += graph[i][j]!;
      }
      if (degree % 2 != 0) {
        oddDegreeVertices++;
        if (oddDegreeVertices > 2) {
          return [];
        }
        startVertex = i;
      }
    }
    // продолжаем только если есть не более двух вершин с нечетной степенью
    List<int> cycle = [];
    List<int> stack = [startVertex];
    while (stack.isNotEmpty) {
      int vertex = stack.last;
      bool hasUnvisitedEdges = false;
      for (int i = 0; i < copy[vertex].length; i++) {
        int neighbor = copy[vertex][i];
        if (neighbor != -1) {
          stack.add(neighbor);
          copy[vertex][i] = -1;
          for (int j = 0; j < copy[neighbor].length; j++) {
            if (copy[neighbor][j] == vertex) {
              copy[neighbor][j] = -1;
              break;
            }
          }
          hasUnvisitedEdges = true;
          break;
        }
      }
      if (!hasUnvisitedEdges) {
        cycle.add(vertex);
        stack.removeLast();
      }
    }
    return cycle.reversed.toList();
  }


  void eurlerCircle(){
    var points = findEulerCycle(copyGraph(matrix));
    if (points != null) {
      String path = points.map((u) => String.fromCharCode(65 + u).toString()).join('⇒');
      setState(() {
        circle = path;
      });
    } else {
      setState(() {
        circle = "No Euler cycle";
      });
    }
  }

  List<List<int>> copyGraph(List<List<int?>> graph) {
    int n = graph.length;
    List<List<int>> copy = List.generate(n, (_) => List.filled(n, 0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        copy[i][j] = graph[i][j]!;
      }
    }
    return copy;
  }

  void getRadius(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    List<List<int>> distances = floydWarshall(adjacencyMatrix);
    int radius = n + 1;
    for (int i = 0; i < n; i++) {
      int maxDistance = distances[i].reduce(max);
      if (maxDistance < radius && maxDistance > 0) {
        radius = maxDistance;
      }
    }
    if (radius == n + 1) {
      print("Несвязный граф");
    } else {
      setState(() {
        N = radius;
      });
    }
  }

  List<List<int>> floydWarshall(List<List<int?>> graph) {
    int n = graph.length;
    List<List<int>> distances = List.generate(n, (_) => List.generate(n, (_) => 0), growable: false);
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        if (graph[i][j] != null) {
          distances[i][j] = graph[i][j]!;
        } else {
          distances[i][j] = n + 1;
        }
      }
    }
    for (int k = 0; k < n; k++) {
      for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
          if (distances[i][k] + distances[k][j] < distances[i][j]) {
            distances[i][j] = distances[i][k] + distances[k][j];
          }
        }
      }
    }
    return distances;
  }

  List<List<int>> subMatrix(List<List<int?>> matrix, List<int> rows) {
    int n = rows.length;
    List<List<int>> sub = List.generate(n, (_) => List.generate(n, (_) => 0), growable: false);
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        sub[i][j] = matrix[rows[i]][rows[j]]!;
      }
    }
    return sub;
  }

  List<List<int>> getConnectedComponents(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    List<List<int>> components = [];
    Set<int> visited = {};
    for (int i = 0; i < n; i++) {
      if (!visited.contains(i)) {
        List<int> component = [];
        dfs(adjacencyMatrix, i, visited, component);
        components.add(component);
      }
    }
    return components;
  }

  void dfs(List<List<int?>> adjacencyMatrix, int vertex, Set<int> visited, List<int> component) {
    visited.add(vertex);
    component.add(vertex);
    for (int neighbor = 0; neighbor < adjacencyMatrix.length; neighbor++) {
      if (adjacencyMatrix[vertex][neighbor] == 1 && !visited.contains(neighbor)) {
        dfs(adjacencyMatrix, neighbor, visited, component);
      }
    }
  }

  // List<List<int>> floydWarshall(List<List<int?>> graph) {
  //   int n = graph.length;
  //   List<List<int>> distances = List.generate(n, (_) => List.generate(n, (_) => 0), growable: false);
  //   for (int i = 0; i < n; i++) {
  //     for (int j = 0; j < n; j++) {
  //       if (graph[i][j] != null) {
  //         distances[i][j] = graph[i][j]!;
  //       } else {
  //         distances[i][j] = n + 1;
  //       }
  //     }
  //   }
  //   for (int k = 0; k < n; k++) {
  //     for (int i = 0; i < n; i++) {
  //       for (int j = 0; j < n; j++) {
  //         if (distances[i][k] + distances[k][j] < distances[i][j]) {
  //           distances[i][j] = distances[i][k] + distances[k][j];
  //         }
  //       }
  //     }
  //   }
  //   return distances;
  // }

  void getDiameter(List<List<int?>> adjacencyMatrix) {
    int n = adjacencyMatrix.length;
    int diameter = 0;
    for (int i = 0; i < n; i++) {
      List<int> distances = bfs(adjacencyMatrix, i);
      int maxDistance = distances.reduce(max);
      if (maxDistance > diameter) {
        diameter = maxDistance;
      }
    }
   setState(() {
     N = diameter;
   });
  }

  List<int> bfs(List<List<int?>> adjacencyMatrix, int start) {
    int n = adjacencyMatrix.length;
    List<bool> visited = List.generate(n, (_) => false);
    List<int> distances = List.generate(n, (_) => -1);
    Queue<int> queue = Queue();
    visited[start] = true;
    distances[start] = 0;
    queue.add(start);
    while (queue.isNotEmpty) {
      int u = queue.removeFirst();
      for (int v = 0; v < n; v++) {
        if (adjacencyMatrix[u][v] == 1 && !visited[v]) {
          visited[v] = true;
          distances[v] = distances[u] + 1;
          queue.add(v);
        }
      }
    }
    return distances;
  }

  @override
  void initState() {
    super.initState();
    getColorVertices();
    getColorEdges();
    eurlerCircle();
    getTypeEdges();
  }

  @override
  Widget build(BuildContext context) {
    List<Object> num = ["Свойства","Хроматическое число: $N",circle == "No Euler cycle" ? "Эйлерового цикла нет" : "Эйлеровый цикл равен:$circle" ];
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Text("$N"),
          InteractiveViewer(
            minScale: 0.3,
            maxScale: 10.5,
            // transformationController: viewTransformationController,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: 400,
              height: 400,
              child: CustomPaint(
                painter: OpenPainter(
                    matrix: matrix,
                    algoritmMatrix:algoritmMatrix,
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
              initialChildSize: 0.07,
              minChildSize: 0.07,
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
              const ListTile(
                title: Text('Алгоритмы',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ),
              ListTile(
                title: const Text('Алгоритм Крускала'),
                onTap: (){
                  kruskalAlgorithm();
                  Navigator.pop(context);
                }
              ),
              ListTile(
                  title: const Text('Алгоритм Дейкстры'),
                  onTap: (){
                    kruskalAlgorithm();
                    Navigator.pop(context);
                  }
              ),
              const ListTile(
                title: Text('Свойства',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ),
              ListTile(
                  title: const Text('Хроматическое число'),
                  onTap: (){
                    chromaticNumber(matrix);
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Радиус'),
                  onTap: (){
                    getRadius(matrix);
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Диаметр'),
                  onTap: (){
                    getDiameter(matrix);
                    Navigator.pop(context);
                  }
              ),
            ],
          )
      ),
    );
  }
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

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final List<List<int?>> algoritmMatrix;
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  final int colorVertices;
  final int colorEdges;
  final String typeEdges;
  OpenPainter({Key? key,
    required this.matrix,
    required this.algoritmMatrix,
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

    var drawPoints = Paint()..color = Color(colorVertices)..strokeCap = StrokeCap.round..strokeWidth = 30;
    var drawLines = Paint()..color = Color(colorEdges)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;
    var radius = 140;
    if(matrix.length > 10) {
      radius = 250;
    }else if(matrix.length > 20){
      radius = 500;
    }
    //добавление вершин
    for(var i = 0; i < matrix.length;i++){
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * radius + (size.width / 2)), (sin(angle) * radius + (size.width / 2))));
    }

    //основной цикл полного рисования(петли, веса и т.д.)
    for(var i = 0; i < matrix.length;i++){
      for(var j = 0; j < matrix.length;j++){
        if(matrix[i][j] != 0){
          if(i == j){ // рисует петлю
            Offset ofs = Offset(points[i].dx, points[i].dy - 15);
            canvas.drawCircle(ofs,20.0, paint3);
          }
          else{
                // рисует ребро
                canvas.drawLine(points[i], points[j], drawLines);

                //рисует вес графа
                if(isCheckedWeight){
                  if(matrix[i][j] != -1){
                    TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17), text: "${matrix[i][j]}");
                    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
                    tp.layout();
                    if(matrix.length % 2 == 0){
                      // делим отрезок в отношении 1/3
                      var del = 1/3;
                      tp.paint(canvas, Offset(((points[i].dx + del * points[j].dx) / (1 + del)), ((points[i].dy + del * points[j].dy) / (1 + del))));
                    }else{
                      // иначе делим в нормальном отношении 1/2
                      tp.paint(canvas, Offset(((points[i].dx + points[j].dx) / 2), ((points[i].dy + points[j].dy) / 2)));
                    }
                  }
                }

                if(isCheckedOriented){
                  if(points[i] != points[j] && matrix[i][j] != matrix[j][i]){
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
                }
                // if(isCheckedOriented){
                //   if(points[i] != points[j]){
                //     var del = 19/2;
                //     final targetPoint = Offset(((points[i].dx + del * points[j].dx) / (1 + del)), ((points[i].dy + del * points[j].dy) / (1 + del)));
                //     final dX = targetPoint.dx - points[i].dx;
                //     final dY = targetPoint.dy - points[i].dy;
                //     final angle = atan2(dX, dY);
                //     const arrowSize = 5;
                //     const arrowAngle=  30 * pi/360;
                //
                //     // проверяем наличие обратного ребра
                //     bool isBidirectional = false;
                //     for(int k = 0; k < matrix[j].length; k++){
                //       if(matrix[j][k] == i){
                //         isBidirectional = true;
                //         break;
                //       }
                //       if(matrix[i][k] == j){
                //         isBidirectional = true;
                //         break;
                //       }
                //     }
                //     if(!isBidirectional){
                //       path.moveTo(targetPoint.dx - arrowSize * sin(angle - arrowAngle), targetPoint.dy - arrowSize * cos(angle - arrowAngle));
                //       path.lineTo(targetPoint.dx, targetPoint.dy);
                //       path.lineTo(targetPoint.dx - arrowSize * sin(angle + arrowAngle),targetPoint.dy - arrowSize * cos(angle + arrowAngle));
                //       path.close();
                //       canvas.drawPath(path, paint4);
                //     }
                //   }
                // }
                // matrix[j][i] = 0;
          }
        }
      }
    }

    // рисование вершин и индекса вершины
    for(var i = 0;i < matrix.length;i++) {
      //в дальнейшем тут надо будет при условии рисовать вершины разных цветов
      canvas.drawCircle(points[i], 15, drawPoints);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          text: typeEdges == "SingingCharacter.Letter" ? String.fromCharCode(65 + i) : (i +1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
