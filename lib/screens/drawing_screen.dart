import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/algorithms/kruskal_algorithm.dart';
import 'package:test_project/home_page.dart';
import 'package:test_project/screens/drop_down_screen.dart';

import '../models/DropDownItem.dart';
import '../models/Task.dart';
import 'auth/login_screen.dart';
import 'level_game_screen.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

enum FilterList {
      All,
      TypeOne,
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<Offset> points = [];
  List<List<int>> edges = [];
  int activePointIndex = -1;
  FilterList valueFilter = FilterList.All;

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
  late List skills = [];



  Future<void> getUserData() async{
    try {
      QuerySnapshot querySnapshot = await _collectionRef.where('uid', isEqualTo: user?.uid ?? '').get();
      QuerySnapshot _user = await _userData.where('uid', isEqualTo: user?.uid ?? '').get();
      final userData = _user.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        userTotalData = userData[0]['user_total'];
        skills = userData[0]['skills'];
        print(skills);
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
  double _currentValue = 20;
  bool showFilterBlock = false;
  Future<void> _refreshData() async {
    getUserData();
  }
  final ValueNotifier<bool> _showFrontSide = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    if(user != null){
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top:5.0,right: 10.0,bottom: 5.0,left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          _showFrontSide.value = !_showFrontSide.value;
                        });
                      },
                      child:  AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: _showFrontSide.value ? Container(
                          key: const ValueKey<int>(0),
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/money.svg',
                                      height: 40.0,
                                      width: 40.0,
                                    ),
                                    Text(
                                      "$userTotalData",
                                      style: const TextStyle(
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute<void>(
                                          builder: (BuildContext context) => Scaffold(
                                            appBar: AppBar(
                                              title: const Text('Навыки'),
                                            ),
                                            body: const DropDownScreen(type:'skills-list'),
                                          ),
                                        ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/skills_icon.svg',
                                        height: 40.0,
                                        width: 40.0,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute<void>(
                                          builder: (BuildContext context) => Scaffold(
                                            appBar: AppBar(
                                              title: const Text('Подсказки'),
                                            ),
                                            body: const DropDownScreen(type: 'tips-list'),
                                          ),
                                        ),
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/thinks_icon.svg',
                                        height: 50.0,
                                        width: 40.0,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ) : Container(
                          key: const ValueKey<int>(1),
                          height: 150.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:   ListView.builder(
                              itemCount: skills.length,
                              itemBuilder: (BuildContext context, int index) {
                                final skill = skills[index];
                                return Column(
                                  children: [
                                    SvgPicture.network(
                                      skill['image_item'],
                                      width: 40,
                                      height: 40,
                                    ),
                                    Text(skill['title'].toString()),
                                  ],
                                );
                              }
                            )
                          ),
                        ),
                      )
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:Colors.black,
                                  width: 1.0
                              )
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                'Задания',
                                style: TextStyle(
                                    fontSize: 25.0
                                )
                            ),
                            GestureDetector(
                              onTap: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       title: Text("Фильтр"),
                                //       content: Column(
                                //         children: [
                                //           Slider(
                                //             value: _currentValue,
                                //             max: 100,
                                //             divisions: 5,
                                //             label: _currentValue.round().toString(),
                                //             onChanged: (double value) {
                                //               setState(() {
                                //                 _currentValue = value;
                                //               });
                                //             },
                                //           ),
                                //           // RadioListTile<FilterList>(
                                //           //   title: const Text('Все'),
                                //           //   value: FilterList.All,
                                //           //   groupValue: valueFilter,
                                //           //   onChanged: (FilterList? value) {
                                //           //     setState(() {
                                //           //       valueFilter = value!;
                                //           //     });
                                //           //   },
                                //           // ),
                                //           // RadioListTile<FilterList>(
                                //           //   title: const Text('Тип 1'),
                                //           //   value: FilterList.TypeOne,
                                //           //   groupValue: valueFilter,
                                //           //   onChanged: (FilterList? value) {
                                //           //     setState(() {
                                //           //       valueFilter = value!;
                                //           //     });
                                //           //   },
                                //           // ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
                                setState(() {
                                  showFilterBlock = !showFilterBlock;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF678094),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Фильтр',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationX(0),
                      child: Container(
                        color: const Color(0xFFE8581C),
                        child: showFilterBlock ? Column(
                          children: [
                            Text('Фильтры'),
                            Slider(
                              value: _currentValue,
                              max: 100,
                              divisions: 5,
                              label: _currentValue.round().toString(),
                              onChanged: (double value) {
                                setState(() {
                                  _currentValue = value;
                                });
                              },
                            ),
                          ],
                        ) : const SizedBox(),
                      )
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _collectionRef.snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Ошибка получения данных: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SpinKitFadingCircle(
                            color: Color(0xFF819db5),
                            size: 100.0,
                            duration: Duration(milliseconds: 3000),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
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
                                                child: const Text('Закрыть'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(context, MaterialPageRoute<void>(
                                                    builder: (BuildContext context) {
                                                      return Scaffold(
                                                          appBar: AppBar(
                                                            title: Text('Уровень ${index + 1}'),
                                                          ),
                                                          body: LevelGameScreen(task:task)
                                                      );
                                                    },
                                                  ));
                                                },
                                                child: const Text('Начать'),
                                              )
                                            ]
                                        );
                                      }
                                  );
                                },
                                child: Container(
                                  height: 80.0,
                                  margin: const EdgeInsets.only(bottom: 20.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF819db5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text("${task.id}"),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: <Widget>[
                                              const Text('Сложность: '),
                                              const SizedBox(width: 5.0),
                                              ...List.generate(
                                                task.level,
                                                    (index) => Padding(
                                                  padding: const EdgeInsets.only(right: 5.0),
                                                  child: SvgPicture.asset(
                                                    'assets/images/complexity.svg',
                                                    height: 20.0,
                                                    width: 20.0,
                                                  ),
                                                ),
                                              ).toList(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/money.svg',
                                                height: 40.0,
                                                width: 40.0,
                                              ),
                                              const SizedBox(width: 5.0),
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
            const Center(
              child: Text('Доступ к игре ограничен!'),
            ),
            Center(
              child: Column(
                children: [
                  const Text('Войдите в свой аккаунт.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return HomePage(selectedIndex: 5);
                        })
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                    ),
                    child: const Text('Войти'),
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