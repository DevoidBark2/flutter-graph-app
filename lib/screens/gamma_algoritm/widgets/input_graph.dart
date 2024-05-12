import 'dart:math';

import 'package:flutter/material.dart';
import "package:collection/collection.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/gamma_algoritm/widgets/view_graph.dart';

import '../../../matrix/matrix_field.dart';

class InputGraph extends StatefulWidget {
  final int length;
  const InputGraph({Key? key,required this.length}) : super(key: key);

  @override
  State<InputGraph> createState() => _InputGraphState();
}

class _InputGraphState extends State<InputGraph> {
  final controllers = <List<TextEditingController>>[];
  bool isCheckedOriented = false;
  String errorMessage = "";
  List<List<int?>> matrix = [];

  List<Widget> warningMsg = [];
  bool hasCycle(List<List<int?>> matrix) {
    int rows = matrix.length;
    int columns = matrix[0].length;

    // Флаг для отслеживания достижимости каждого узла
    List<bool> visited = List.generate(rows * columns, (_) => false);

    // Функция для обхода в глубину с обратной связью
    bool dfs(int node) {
      visited[node] = true;

      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) continue; // Skip the current node

          int newNode = node + i * columns + j;
          if (newNode >= 0 && newNode < rows * columns && matrix[newNode ~/ columns][newNode % columns] != null && !visited[newNode]) {
            if (dfs(newNode)) {
              return true; // Цикл найден
            }
          }
        }
      }

      // Если досюда дошли, означает, что не было цикла
      return false;
    }

    // Начать обход с любого узла
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (matrix[i][j] != null && !visited[i * columns + j]) {
          if (dfs(i * columns + j)) {
            return true; // Цикл найден
          }
        }
      }
    }

    return false; // Если досюда дошли, означает, что цикла в графе нет
  }

  bool isConnected(List<List<int?>> matrix) {
    int rows = matrix.length;
    int columns = matrix[0].length;

    // Флаг для отслеживания достижимости каждого узла
    List<bool> visited = List.generate(rows * columns, (_) => false);

    // Функция для обхода в глубину
    void dfs(int node) {
      visited[node] = true;

      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) continue; // Skip the current node

          int newNode = node + i * columns + j;
          if (newNode >= 0 && newNode < rows * columns && matrix[newNode ~/ columns][newNode % columns] != null && !visited[newNode]) {
            dfs(newNode);
          }
        }
      }
    }

    // Начать обход с любого узла
    dfs(0);

    // Если не было недостижимых узлов, то граф связный
    for (bool unvisited in visited) {
      if (!unvisited) {
        return false;
      }
    }
    return true;
  }

  bool hasBridges(List<List<int?>> matrix) {
    int rows = matrix.length;
    int columns = matrix[0].length;

    // Функция для обхода в глубину с обратной связью
    bool? dfs(int node, List<int> low, List<int> disc, List<int> parent, int time, int maxIterations) {
      low[node] = disc[node] = time++;
      var children = 0;

      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) continue; // Skip the current node

          int newNode = node + i * columns + j;
          if (newNode >= 0 && newNode < rows * columns && matrix[newNode ~/ columns][newNode % columns] != null) {
            int neighbor = newNode;

            if (neighbor != parent[node]) {
              if (dfs(neighbor, low, disc, parent, time, maxIterations) != null) {
                return true; // Found a bridge
              }

              low[node] = min(low[node], low[neighbor]);

              if (low[neighbor] > disc[node]) {
                return true; // Found a bridge
              }
            }

            children++;
          }
        }
      }

      if (maxIterations > 0 && --maxIterations == 0) {
        return null; // Limit of iterations reached, return null to indicate early termination
      }
      return children > 0 ? true : false; // children > 0 can be simplified to children

      // Add the following line to limit the number of iteration
    }

    // Начать обход с любого узла
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (matrix[i][j] != null) {
          List<int> low = List.filled(rows * columns, -1);
          List<int> disc = List.filled(rows * columns, -1);
          List<int> parent = List.filled(rows * columns, -1);
          int time = 0;

          if (dfs(i * columns + j, low, disc, parent, time,1) != null) {
            return true; // Graph has bridges
          }
        }
      }
    }

    return false; // Graph doesn't have bridges
  }

  bool checkMatrix(controllers){
    bool isCheckedValidMatrix = true;
    var mat = List.generate(controllers.length, (row) => List.generate(controllers.length ,(column) => int.tryParse(controllers[row][column].text)));
    matrix = mat;
    List<List<int?>> result = List.generate(mat[0].length, (i) => List.filled(mat.length, 0));

    for(var i = 0; i < mat.length; i++){
      for(var j = 0; j < mat.length; j++){
        if(mat[i][j] == null){
          isCheckedValidMatrix = false;
          errorMessage = "Все поля должны быть заполнены!";
          break;
        }
      }
    }
    if(!isCheckedValidMatrix){
      return false;
    }else{
      for (int i = 0; i < mat.length; i++) {
        for (int j = 0; j < mat[0].length; j++) {
          result[j][i] = mat[i][j];
        }
      }
      if(!const DeepCollectionEquality().equals(mat, result)){
        errorMessage = "Граф должен быть симметричным";
        return false;
      }

      var isConnectedRes = isConnected(mat);
      warningMsg.add(Row(children: [
        isConnectedRes ? SvgPicture.asset(
          'assets/images/success_icon.svg',
          width: 50,
          height: 50,
        ) : SvgPicture.asset(
          'assets/images/warning_icon.svg',
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 15),
        Text(
            isConnectedRes ? 'Граф связный' : 'Граф не связный',
          style: const TextStyle(
            fontWeight: FontWeight.w600
          ),
        )
      ],));

      var hasCycleRes = hasCycle(mat);
      warningMsg.add(Row(children: [
        hasCycleRes ? SvgPicture.asset(
          'assets/images/success_icon.svg',
          width: 50,
          height: 50,
        ) : SvgPicture.asset(
          'assets/images/warning_icon.svg',
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 15),
        Text(
            hasCycleRes ? 'Граф имеет хотя один цикл' : 'Граф не имеет ни одного цикла',
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        )
      ],));

     // var hasBridgesRes = hasBridges(mat);
      warningMsg.add(Row(children: [
        true ? SvgPicture.asset(
          'assets/images/success_icon.svg',
          width: 50,
          height: 50,
        ) : SvgPicture.asset(
          'assets/images/warning_icon.svg',
          width: 50,
          height: 50,
        ),
        const SizedBox(width: 15),
        Text(
            true ? 'Граф имеет мост' : 'Граф не имеет моста',
          style: const TextStyle(
              fontWeight: FontWeight.w600
          ),
        )
      ],));

      return true;
    }
  }

  @override
  void initState() {
    for (var i = 0; i < widget.length; i++) {
      controllers.add(List.generate(widget.length, (index) => TextEditingController(text: '')));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: List.generate(
                                      controllers.length,
                                          (index1) => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: List.generate(
                                          controllers[index1].length,
                                              (index2) => Center(
                                            child: Padding(
                                              padding: controllers.length > 8 ? const EdgeInsets.all(1.0) :
                                              controllers.length > 7 ? const EdgeInsets.all(1.0) :
                                              controllers.length > 6 ? const EdgeInsets.all(2.0) :
                                              controllers.length > 5 ? const EdgeInsets.all(3.0) :
                                              const EdgeInsets.all(6.0),
                                              child: SizedBox(
                                                height: controllers.length > 8 ? 32 : controllers.length > 7 ? 35 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                                                width: controllers.length > 8 ? 32 : controllers.length > 7 ? 35 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                                                child: MatrixField(
                                                  action: (index2  == controllers.length -1 && index1 == controllers.length -1) ? TextInputAction.done : TextInputAction.next,
                                                  controller: controllers[index1][index2],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: (){
                                        warningMsg = [];
                                        final res = checkMatrix(controllers);
                                        if(res){
                                          showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return PhysicalModel(
                                                color: Colors.white,
                                                clipBehavior: Clip.hardEdge,
                                                shadowColor: Colors.black12,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child:  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: warningMsg.length + 1, // +1 for the "Next" button
                                                        itemBuilder: (BuildContext context, int index) {
                                                          if (index == warningMsg.length) {
                                                            return ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                                              ),
                                                              onPressed: () => {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute<void>(
                                                                builder: (BuildContext context) => Scaffold(
                                                                  appBar: AppBar(
                                                                  title: const Text('Виртуализация'),
                                                                  ),
                                                                  body: ViewGraph(matrix:matrix)
                                                                  ),
                                                                  ),
                                                                )
                                                              },
                                                              child: const Text('Далее'),
                                                            );
                                                          }
                                                          return Padding(
                                                            padding: const EdgeInsets.only(bottom: 10),
                                                            child: warningMsg[index],
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              );
                                            },
                                          );
                                          return;
                                        }
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 250,
                                              color: const Color(0xffffffff),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 30.0, bottom: 5),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/error.svg',
                                                          width: 70,
                                                          height: 70
                                                      ),
                                                      const SizedBox(height: 15.0),
                                                      Text(errorMessage),
                                                      const SizedBox(height: 35.0),
                                                      ElevatedButton(
                                                        onPressed: () => {
                                                          Navigator.pop(context)
                                                        },
                                                        style: ButtonStyle(
                                                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                                        ),
                                                        child: const Text('Закрыть'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                      ),
                                      child: const Text('Далее'),
                                    ),
                                  ],
                                )
                              ]
                          )
                      )
                  )
              )
            ]
        ),
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
