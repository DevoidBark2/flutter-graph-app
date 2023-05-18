import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/algorithms/bfs.dart';
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
  var N = 0;
  var res;
  bool showRes = false;
  bool isHasEulerCycle = false;
  String circle = '';
  var colorVertices = 0;
  var colorEdges = 0;
  var typeEdges = "";
  String error = '';
  List<List<int?>> algorithmMatrix = [];
  late var matrix = List.generate(matrixFrom.length, (row) => List.generate(matrixFrom.length ,(column) => int.tryParse(matrixFrom[row][column].text)));

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
          res = 'Сумма весов минимального остовного дерева: ${result.totalWeight}';
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
      res = result.result;
      showRes = true;
    });
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

    List<int> usedColors = []; // список всех использованных цветов

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
      usedColors.add(cr); // добавляем использованный цвет в список
    }

    int uniqueColors = Set<int>.from(usedColors).length; // подсчитываем количество уникальных цветов

    setState(() {
      res = uniqueColors;
      showRes = true;
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


  List<int> findUnvisitedNeighbors(List<List<int>> graph, int vertex) {
    List<int> neighbors = [];
    for (int i = 0; i < graph[vertex].length; i++) {
      if (graph[vertex][i] == 1) {
        neighbors.add(i);
      }
    }
    return neighbors.where((v) => graph[vertex][v] != -1).toList();
  }
  List<List<int>> findOddDegreeClasses(List<List<int?>> graph) {
    List<List<int>> oddDegreeClasses = [];
    List<bool> visited = List.generate(graph.length, (_) => false);
    for (int i = 0; i < graph.length; i++) {
      if (!visited[i]) {
        List<int> currentClass = [];
        traverseGraph(graph, i, visited, (int vertex, int degree) {
          if (degree % 2 != 0) {
            currentClass.add(vertex);
          }
        });
        if (currentClass.isNotEmpty) {
          oddDegreeClasses.add(currentClass);
        }
      }
    }
    return oddDegreeClasses;
  }
  void traverseGraph(List<List<int?>> graph, int vertex, List<bool> visited, Function onVisit) {
    visited[vertex] = true;
    int degree = 0;
    for (int i = 0; i < graph[vertex].length; i++) {
      if (graph[vertex][i] == 1) {
        degree++;
        if (!visited[i]) {
          traverseGraph(graph, i, visited, onVisit);
        }
      }
    }
    onVisit(vertex, degree);
  }
  void findEulerCycle(List<List<int?>> graph) {
    print(graph);
    List<List<int>> copy = copyGraph(graph);
    print(copy);
    List<int> cycle = [];

    // найдем все вершины с нечетной степенью
    List<List<int>> oddDegreeClasses = findOddDegreeClasses(copy);

    // начинаем с первой вершины с нечетной степенью
    cycle.add(oddDegreeClasses[0][0]);
    int currentIndex = 0;
    while (oddDegreeClasses.isNotEmpty) {
      // переходим к первой вершине, которая может быть частью определенного класса эквивалентности
      while (currentIndex < cycle.length - 1) {
        int lastVertex = cycle.last;
        int nextVertex = cycle[currentIndex + 1];
        if (oddDegreeClasses.any((c) =>
        c.contains(lastVertex) && c.contains(nextVertex))) {
          break;
        }
        currentIndex++;
      }
      // выбираем класс эквивалентности, который может быть продолжен из текущей вершины, и продолжаем цикл
      int currentVertex = cycle[currentIndex];
      List<List<int>> currentClass = oddDegreeClasses
          .where((c) => c.contains(currentVertex))
          .toList();
      if (currentClass.isEmpty) {
        break;
      }
      List<int> neighbors = findUnvisitedNeighbors(copy, currentVertex);
      if (neighbors.isEmpty) {
        cycle.removeAt(currentIndex);
        currentIndex--;
        continue;
      }
      int neighbor = neighbors.first;
      cycle.insert(currentIndex + 1, neighbor);
      copy[currentVertex][neighbor] = -1;
      copy[neighbor][currentVertex] = -1;
      // если мы вернулись в вершину со степенью, не равной 0, значит мы закончили цикл
      if (neighbor == cycle[0] && findUnvisitedNeighbors(copy, cycle[0]).isNotEmpty) {
        // объединяем найденный цикл с остальными
        List<int> newCycle = [];
        for (int i = 0; i < cycle.length - 1; i++) {
          newCycle.add(cycle[i]);
          if (oddDegreeClasses.any((c) =>
          c.contains(cycle[i]) && c.contains(cycle[i + 1]))) {
            oddDegreeClasses.removeWhere((c) =>
            c.contains(cycle[i]) && c.contains(cycle[i + 1]));
          }
        }
        newCycle.add(cycle.last);
        oddDegreeClasses.remove(currentClass);
        cycle = newCycle;
        currentIndex = 0;
      } else {
        currentIndex++;
      }
    }

    // если некоторые классы эквивалентности не были найдены, то граф не содержит эйлерова цикла
    if (oddDegreeClasses.isNotEmpty) {
      setState(() {
        res = "Эйлерового цикла нет";
        showRes = true;
      });
      return;
    }

    // формируем строку-результат
    String resString = '';
    for (int vertex in cycle) {
      resString += '$vertex -> ';
    }
    resString += cycle[0].toString();
    setState(() {
      res = resString;
      showRes = true;
    });
  }


  // void eurlerCircle(){
  //   var points = findEulerCycle(copyGraph(matrix));
  //   if (points != null) {
  //     String path = points.map((u) => (u + 1).toString()).join('⇒');
  //     setState(() {
  //       circle = path;
  //     });
  //   } else {
  //     setState(() {
  //       circle = "No Euler cycle";
  //     });
  //   }
  //   print(circle);
  // }


  List<List<int>> copyGraph(List<List<int?>> graph) {
    List<List<int>> copy = List.generate(graph.length, (index) => []);
    for (int i = 0; i < graph.length; i++) {
      for (int j = 0; j < graph[i].length; j++) {
        copy[i].add(graph[i][j] ?? 0);
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
        res = radius;
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

  // void getDiameter(List<List<int?>> adjacencyMatrix) {
  //   int n = adjacencyMatrix.length;
  //   int diameter = 0;
  //   for (int i = 0; i < n; i++) {
  //     List<int> distances = bfs(adjacencyMatrix, i);
  //     int maxDistance = distances.reduce(max);
  //     if (maxDistance > diameter) {
  //       diameter = maxDistance;
  //     }
  //   }
  //  setState(() {
  //    N = diameter;
  //  });
  // }






  // bool isGraphConnected(List<List<int?>> adjacencyMatrix) {
  //   int n = adjacencyMatrix.length;
  //   List<bool> visited = List.generate(n, (_) => false);
  //   List<List<int>> visitedEdges = [];
  //   Queue<int> queue = Queue();
  //   queue.add(0);
  //   visited[0] = true;
  //
  //   while (queue.isNotEmpty) {
  //     int node = queue.removeFirst();
  //     for (int i = 0; i < n; i++) {
  //       if (adjacencyMatrix[node][i] != null && adjacencyMatrix[node][i] != 0 && !visited[i]) {
  //         queue.add(i);
  //         visited[i] = true;
  //         visitedEdges.add([node, i]);
  //       }
  //     }
  //   }
  //
  //   return visited.every((element) => element == true) && visitedEdges.length == n-1;
  // }



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
                    algorithmMatrix:algorithmMatrix,
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
                          color: Colors.amber,
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
                                    child:Text("${index + 1}"),
                                  );
                                },
                              ) : const Text('Граф должен быть взвешенный')
                          ),
                        );
                      },
                    );
                  }
              ),
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
                  title: const Text('Обход в ширину',textAlign: TextAlign.center),
                  onTap: (){
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          color: Colors.amber,
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
                                  );
                                },
                              )
                          ),
                        );
                      },
                    );
                  }
              ),
              ListTile(
                  title: const Text('Хроматическое число',textAlign: TextAlign.center),
                  onTap: (){
                    chromaticNumber(matrix);
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
                    //getDiameter(matrix);
                    Navigator.pop(context);
                  }
              ),
              ListTile(
                  title: const Text('Найти Эйлеровый цикл',textAlign: TextAlign.center),
                  onTap: (){
                    findEulerCycle(copyGraph(matrix));
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
            ],
          )
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final List<List<int?>> algorithmMatrix;
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  final int colorVertices;
  final int colorEdges;
  final String typeEdges;
  OpenPainter({Key? key,
    required this.matrix,
    required this.algorithmMatrix,
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
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
          text: typeEdges == "TypeEdges.Letter" ? String.fromCharCode(65 + i) : (i +1).toString());
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
