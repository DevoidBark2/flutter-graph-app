import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/algorithms/kruskal_algorithm.dart';
import 'package:test_project/home_page.dart';

import '../models/Task.dart';
import 'auth/login_screen.dart';
import 'level_game_screen.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset> points = [];
  List<List<int>> edges = [];
  int activePointIndex = -1;

  final adjacencyMatrix = [
    [0, 1, 1, 1, 1],
    [1, 0, 1, 1, 1],
    [1, 1, 0, 1, 1],
    [1, 1, 1, 0, 1],
    [0, 1, 1, 1, 0]];

  final List<Task> tasks = [];

  final _collectionRef = FirebaseFirestore.instance.collection('tasks');
  final _userData = FirebaseFirestore.instance.collection('users-list');

  final user = FirebaseAuth.instance.currentUser;
  int userTotalData = 0;

  Future<void> getUserData() async{
    try {
      QuerySnapshot querySnapshot = await _collectionRef.where('uid', isEqualTo: user?.uid ?? '').get();
      QuerySnapshot _user = await _userData.where('uid', isEqualTo: user?.uid ?? '').get();
      final userData = _user.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        userTotalData = userData[0]['total_user'];
        setState(() {});
      }

    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  // Future<void> getTasks() async{
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //   final allTasks = querySnapshot.docs.map((doc) => tasks.from(doc)).toList();
  //   allTasks.map((Task task){
  //     tasks.add(task);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    createVertices();
    createEdges();
    getUserData();
    // getTasks();
  }

  void createVertices() {
    final numVertices = adjacencyMatrix.length;
    const double radius = 150;
    const double centerX = 300;
    const double centerY = 300;
    final double angleBetweenVertices = 2 * pi / numVertices;

    for (var i = 0; i < numVertices; i++) {
      final x = centerX + radius * cos(i * angleBetweenVertices);
      final y = centerY + radius * sin(i * angleBetweenVertices);
      points.add(Offset(x, y));
    }
  }

  void createEdges() {
    final numVertices = adjacencyMatrix.length;

    for (var i = 0; i < numVertices; i++) {
      for (var j = i + 1; j < numVertices; j++) {
        if (adjacencyMatrix[i][j] == 1) {
          edges.add([i, j]);
        }
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    if(user != null){
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top:5.0,right: 10.0,bottom: 5.0,left: 10.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 150.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[Colors.orange, Colors.deepOrange],
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/money.svg',
                                      height: 40.0,
                                      width: 40.0,
                                    ),
                                    Text(
                                      "${userTotalData}",
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container()
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                              'Задачи',
                              style: TextStyle(
                                  fontSize: 25.0
                              )
                          ),
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:Colors.black,
                                    width: 1.0
                                )
                            )
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _collectionRef.snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Ошибка получения данных: ${snapshot.error}');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SpinKitFadingCircle(
                              color: Colors.orange,
                              size: 100.0,
                              duration: Duration(milliseconds: 3000),
                            );
                          }

                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Center(
                              child:  Text('Нет доступных задач'),
                            );
                          }

                          final tasks = snapshot.data!.docs
                              .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
                              .toList();

                          return Container(
                            width:MediaQuery.of(context).size.height / 2,
                            height: MediaQuery.of(context).size.height / 2,
                            child: ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (BuildContext context, int index) {
                                final task = tasks[index];
                                return GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                              title: Text('Задание ${task.id}'),
                                              content: Container(
                                                height: 100.0,
                                                child: Padding(
                                                  padding: EdgeInsets.all((10.0)),
                                                  child: Column(
                                                    children: [
                                                      Text('${task.description}'),
                                                      Text('Время выполнения:${task.time_level} сек.')
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Закрыть'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute<void>(
                                                      builder: (BuildContext context) {
                                                        return Scaffold(
                                                            appBar: AppBar(
                                                              title: Text('Уровень${index + 1}'),
                                                            ),
                                                            body: LevelGameScreen(task:task)
                                                        );
                                                      },
                                                    ));
                                                  },
                                                  child: Text('Начать'),
                                                )
                                              ]
                                          );
                                        }
                                    );
                                  },
                                  child: Container(
                                    height: 80.0,
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(  // Расположение по правому нижнему углу
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("${task.id}"),
                                          ),
                                        ),
                                        Align(  // Расположение по правому нижнему углу
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("Уровень ${task.level}"),
                                          ),
                                        ),
                                        Align(// Расположение по правому нижнему углу
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.0, bottom: 10.0), // Измените EdgeInsets здесь
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/money.svg',
                                                  height: 40.0,
                                                  width: 40.0,
                                                ),
                                                SizedBox(width: 5.0), // Добавьте небольшой отступ между иконкой и текстом
                                                Text("${task.total}"),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
            )
        ),
      );
    }
    else{
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/lock.svg',
              height: 120,
              width: 120,
            ),
            Center(
              child: Text('Доступ к игре ограничен!'),
            ),
            Center(
              child: Column(
                children: [
                  Text('Войдите в свой аккаунт'),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return HomePage(selectedIndex: 5);
                        })
                      );
                    },
                    child: Text('Войти'),
                  )
                ],
              ),
            )
          ],
        )
      );
    }
  }



  int? getTappedPointIndex(Offset position) {
    for (var i = 0; i < points.length; i++) {
      if (pow(position.dx - points[i].dx, 2) + pow(position.dy - points[i].dy, 2) <= pow(30, 2)) {
        return i;
      }
    }
    return null;
  }

  void createEdge(int start, int end) {
    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }
    edges.add([start, end]);
  }

}



class OpenPainter extends CustomPainter {
  final List<Offset> points;
  final List<List<int>> edges;
  final int activePointIndex;

  OpenPainter({required this.points, required this.edges, required this.activePointIndex});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = const Color(0xff63aa65)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;
    var paint2 = Paint()
      ..color = const Color(0xffee0606)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 50;

    for (var i = 0; i < points.length; i++) {
      if (activePointIndex == i) {
        canvas.drawCircle(points[i], 15, paint1);
      } else {
        canvas.drawCircle(points[i], 15, paint2);
      }
    }

    for (var i = 0; i < points.length - 1; i++) {
      drawLine(canvas, points[i], points[i + 1], paint1);
    }

    for (var i = 0; i < points.length; i++) {
      TextSpan span =
      TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text: "${i + 1}");
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, Offset(points[i].dx - 5.0, points[i].dy - 5.0));
    }

    for (var i = 0; i < edges.length; i++) {
      final start = points[edges[i][0]];
      final end = points[edges[i][1]];
      drawLine(canvas, start, end, paint1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    canvas.drawLine(start, end, paint);
  }
}