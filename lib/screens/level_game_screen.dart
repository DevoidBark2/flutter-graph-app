import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_project/models/Task.dart';

class LevelGameScreen extends StatefulWidget {
  final Task task;
  const LevelGameScreen({super.key, required this.task});

  @override
  State<LevelGameScreen> createState() => _LevelGameScreenState();
}

class _LevelGameScreenState extends State<LevelGameScreen> {
  List<Offset> points = [];
  List<Vertex> colorsGraph = [];
  int? selectedVertexIndex;
  int? selectedVertexOffset;
  ValueNotifier<int> time = ValueNotifier<int>(0);
  ValueNotifier<bool> isTimeEnd = ValueNotifier<bool>(false);
  Timer? _timer;

  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users-list');
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;


  int? draggingVertexIndex;
  Offset? lastDragOffset;

  int? selectedColor;

  int colorVertices = 0;
  int colorEdges = 0;

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

  @override
  void initState() {
    super.initState();
    getColorEdges();
    getColorVertices();

    initializePoints();
    getUserData();
    _startTimer();
    time.value = widget.task.time_level;
  }

  void initializePoints() {
    final matrix = widget.task.graph;
    const double sizeWidth = 400;
    const double sizeHeight = 400;
    final double radius = getRadius(matrix.length, sizeWidth);

    for (var i = 0; i < matrix.length; i++) {
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * radius + sizeWidth / 2), sin(angle) * radius + sizeHeight / 2));
    }
  }

  double getRadius(int length, double sizeWidth) {
    double radius = 140;
    if (length > 10) {
      radius = 200;
    } else if (length > 20) {
      radius = 1000;
    }
    return radius;
  }

  void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(time.value > 0 && !isTimeEnd.value){
        setState(() {
          time.value--;
        });
      }else{
        isTimeEnd.value = true;
       setState(() {
         time.value--;
       });
      }
    });
  }

  int? getTappedVertexIndex(Offset tapPosition) {
    for (int i = 0; i < points.length; i++) {
      final vertexPosition = points[i];
      final distance = (tapPosition - vertexPosition).distance;
      if (distance <= 15) {
        return i;
      }
    }
    return null;
  }

  late List skills = [];
  final _userData = FirebaseFirestore.instance.collection('users-list');

  Future<void> getUserData() async{
    try {
      QuerySnapshot user = await _userData.where('uid', isEqualTo: currentUserUid).get();
      final userData = user.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        skills = userData[0]['skills'];
        setState(() {});
      }

    } catch (e) {
      if (kDebugMode) {
        print('Exception occurred: $e');
      }
    }
  }

  void updateEdgePositions() {
    for (int i = 0; i < widget.task.graph.length; i++) {
      for (int j = 0; j < widget.task.graph.length; j++) {
        if (widget.task.graph[i][j] != 0 && i != j) {
          final startPoint = points[i];
          final endPoint = points[j];
          widget.task.graph[i][j] = (endPoint - startPoint).distance.toInt();
          widget.task.graph[j][i] = (endPoint - startPoint).distance.toInt();
          setState(() {});
        }
      }
    }
  }

  double getPercentage(int timeLeft, int totalPrice) {
    if (timeLeft == 0) {
      return 0;
    }
    return (totalPrice * (timeLeft.toDouble() / widget.task.time_level.toDouble()));
  }

  int resultPrice(int price) {
    double percentage = 0.0;
    if (time.value > 0) {
      return price;
    } else {
      final total = widget.task.total;
      percentage = getPercentage(time.value.toInt(), total);
      final deductedPoints = total * percentage ~/ 100;
      final price = total - deductedPoints;
      return price.toInt();
    }
  }


  Future<void> setNewPrice(int newPrice) async {
    final user = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users-list').where('uid', isEqualTo: user?.uid ?? '').get();
    final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    int totalCurrentUser = userData[0]['user_total'];

    await FirebaseFirestore.instance.collection('users-list').doc(user?.uid).update({
      'user_total': totalCurrentUser + newPrice,
      'skills':skills
    });
  }

  void _checkPlanGraph(){
    List<Segment> pointsGraph = [];

    for(int i=0; i<widget.task.graph.length; i++){
      for(int j=i+1; j< widget.task.graph.length; j++){
        if(widget.task.graph[i][j] == 1){
          pointsGraph.add(Segment(
              a: Point(x: points[i].dx, y: points[i].dy),
              b: Point(x: points[j].dx, y: points[j].dy)
          ));
        }
      }
    }

    bool flag = false;
    for(int i=0; i<pointsGraph.length; i++){
      for(int j=i+1; j<pointsGraph.length; j++){
        if(pointsGraph[i].intersect(pointsGraph[j])){
          flag = true;
          break;
        }
      }
    }

    if(flag){
      const snackBar = SnackBar(
          content: Text("Задание выполнено неверно,попробуйте ещё раз!"),
          backgroundColor: Colors.red
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setNewPrice(time.value > 0 ? widget.task.total : (widget.task.total - (time.value.abs() / 2)).ceil());

    Navigator.pop(context);

    final snackBar = SnackBar(
        content: Text("Молодец,ты выполнил задание! Получай ${time.value > 0 ? widget.task.total : (widget.task.total - (time.value.abs() / 2)).ceil()} очков"),
        backgroundColor: time.value > 0 ? Colors.green : Colors.amber[800]
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        fit: StackFit.expand,

        children: [
          Container(
              child: isTimeEnd.value
                  ? Text(
                  "Оставшееся время: ${time.value} сек.",
                  style: const TextStyle(
                      color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  )
              )
                  : Text( "Оставшееся время: ${time.value} сек.",
                style: const TextStyle(
                    fontSize: 18
                ),
              )
          ),
          InteractiveViewer(
            minScale: 0.1,
            maxScale: 10.5,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: GestureDetector(
              onLongPressStart: (details) {
                final tapPosition = details.localPosition;
                final vertexIndex = getTappedVertexIndex(tapPosition);
                for (int i = 0; i < points.length; i++) {
                  if ((tapPosition.dx - points[i].dx).abs() < 30.0) {
                    selectedVertexOffset = i;
                    setState(() {});
                    break;
                  }
                }
                setState(() {
                  draggingVertexIndex = vertexIndex;
                  lastDragOffset = tapPosition;
                });
              },
              onLongPressMoveUpdate: (details) {
                if (draggingVertexIndex != null && lastDragOffset != null) {
                  final newOffset = details.localPosition;
                  final delta = newOffset - lastDragOffset!;
                  setState(() {
                    points[draggingVertexIndex!] += delta;
                    lastDragOffset = newOffset;
                  });
                }
              },
              child: CustomPaint(
                painter: OpenPainter(
                    matrix: widget.task.graph,
                    selectedIndex: selectedVertexOffset,
                    color: selectedColor,
                    points:points,
                    colorsVertex: colorsGraph,
                    colorVertices:colorVertices,
                    colorEdges:colorEdges,
                ),
              ),
            ),
          ),
          Positioned( bottom: 0,
            left:0,child:  ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Все навыки'),
                    content: SizedBox(
                      child: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: skills.isNotEmpty ? List.generate(
                        skills.length,
                            (index) => ElevatedButton(
                          onPressed: () {
                            if (skills[index]['total_time'] != null) {
                              time.value = time.value + int.parse(skills[index]['total_time'].toString());
                              if(time.value > 0){
                                isTimeEnd.value = false;
                                setState(() {});
                              }
                              Navigator.pop(context);

                              final CollectionReference userListRef = FirebaseFirestore.instance.collection('users-list');
                              final userDocument = userListRef.doc(currentUserUid);

                              userDocument.get().then((userListDoc) {
                                if (userListDoc.exists) {
                                  final userListData = userListDoc.data() as Map<String, dynamic>;
                                  final skillsList = userListData['skills'];
                                  final removedSkill = skillsList.removeAt(index);
                                  if (removedSkill != null) {
                                    userListData['skills'] = skillsList;
                                    final updatedUserListData = {...userListData};
                                    userDocument.update(updatedUserListData);
                                  }
                                  setState(() {
                                    getUserData();
                                  });
                                }
                              }).catchError((error) {
                                if (kDebugMode) {
                                  print('Error removing skill from user-list: $error');
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                SvgPicture.network(
                                  skills[index]['image_item'],
                                  width: 20,
                                  height: 20,
                                ),
                                Text(skills[index]['title'].toString())
                              ],
                            ),
                          ),
                        ),
                      )
                            :
                        [
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/empty_icon.svg',
                                  height: 70.0,
                                  width: 70.0,
                                ),
                                const Text("Список пуст!")
                              ],
                            ),
                          )
                        ],
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
            child: const Text('Навыки'),
          ),
          ),
          Positioned(
            bottom: 0,
            right:0,
            child: ElevatedButton(
              onPressed: _checkPlanGraph,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
              ),
              child: const Text('Проверить'),
            ),
          )
        ],
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final int? selectedIndex;
  final List<Offset> points;
  final int? color;
  final List<Vertex> colorsVertex;
  final int colorVertices;
  final int colorEdges;
  OpenPainter({
    Key? key,
    required this.matrix,
    required this.selectedIndex,
    required this.points,
    required this.color,
    required this.colorsVertex,
    required this.colorVertices,
    required this.colorEdges
  });
  @override
  @override
  void paint(Canvas canvas, Size size) {

    var drawLines = Paint()..color = Color(colorEdges)..strokeWidth = 2;

    int getVertexColor(List<Vertex> colorsGraph, int selectedIndex) {
      return colorsGraph.firstWhere((Vertex vertex) => vertex.index == selectedIndex, ).color;
    }

    var selectedIndexPaint =  Paint()..color = Color(colorVertices)..strokeCap = StrokeCap.round..strokeWidth = 20;

    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix.length; j++) {
        if (matrix[i][j] != 0) {
          final startPoint = points[i];
          final endPoint = points[j];

          final offset = endPoint - startPoint;
          final normalizedOffset = offset / offset.distance * 15;

          final adjustedStartPoint = startPoint + normalizedOffset;
          final adjustedEndPoint = endPoint - normalizedOffset;

          if (i == selectedIndex || j == selectedIndex) {
            drawLines.color = Colors.black;
          } else {
            drawLines.color = Colors.black;
          }

          canvas.drawLine(adjustedStartPoint, adjustedEndPoint, drawLines);
        }
      }
    }

    for (var i = 0; i < matrix.length; i++) {
      selectedIndexPaint.color = const Color(0xffb69d9d); // Set default color
      if (selectedIndex != null && selectedIndex == i) {
        selectedIndexPaint.color = Color(color != null ? getVertexColor(colorsVertex, selectedIndex!) : 0xffb69d9d);
      }

      canvas.drawCircle(points[i], 15, selectedIndexPaint);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text:  (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if (matrix.length > 9) {
        if (i < 9) {
          tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
        } else {
          tp.paint(canvas, Offset(points[i].dx -9.0, points[i].dy - 8.0));
        }
      } else {
        tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class Point {
  final double eps = 0.1;
  final double x, y;

  const Point({required this.x, required this.y});

  // лежит ли точка между двумя заданными (над отрезком или над продолжением)
  // через скалярное произведение векторов
  bool between(Point a, Point b) {
    double pab = (b.x - a.x) * (x - a.x) + (b.y - a.y) * (y - a.y);
    double pba = (a.x - b.x) * (x - b.x) + (a.y - b.y) * (y - b.y);
    return (pab > eps) && (pba > eps);
  }
}

class Segment {
  final double eps = 0.1;
  final Point a, b;

  const Segment({required this.a,required this.b});

  // параллельны ли отрезки
  bool parallel(Segment s)
  {
    double v1x = b.x - a.x;
    double v1y = b.y - a.y;
    double v2x = s.b.x - s.a.x;
    double v2y = s.b.y - s.a.y;
    double delta = v1x * v2y - v1y * v2x;

    return (delta).abs() < eps;
  }

  // точка пересечения прямых, содержащих отрезки
  Point cross(Segment s)
  {
    if (parallel(s)) throw Exception("parallel not intersect");
    // коэффициенты общего уравнения первой прямой
    double a1 = b.y - a.y;
    double b1 = a.x - b.x;
    double c1 = -(b.y - a.y) * a.x - (a.x - b.x) * a.y;
    // коэффициенты общего уравнения 2ой прямой
    double a2 = s.b.y - s.a.y;
    double b2 = s.a.x - s.b.x;
    double c2 = -(s.b.y - s.a.y) * s.a.x - (s.a.x - s.b.x) * s.a.y;
    // debug Console.WriteLine($"{A1}x + {B1}y + {C1} = 0");
    // решаем систему методом Крамера
    double delta = a1 * b2 - a2 * b1;
    double delta1 = b1 * c2 - b2 * c1;
    double delta2 = a2 * c1 - a1 * c2;
    return Point(x:delta1 / delta, y:delta2 / delta);
  }

  bool intersect(Segment s)
  {
    if (parallel(s)) return false;
    Point p = cross(s);
    if (p.between(s.a, s.b) && p.between(a, b)) {
      return true;
    }
    return false;
  }
}

class Vertex {
  final int index;
  final int color;

  Vertex({required this.index, required this.color});
}