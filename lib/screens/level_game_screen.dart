import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/models/Task.dart';

import '../models/DropDownItem.dart';

class LevelGameScreen extends StatefulWidget {
  final Task task;
  const LevelGameScreen({Key? key, required this.task}) : super(key: key);

  @override
  State<LevelGameScreen> createState() => _LevelGameScreenState();
}

class _LevelGameScreenState extends State<LevelGameScreen> {
  List<Offset> points = [];
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

  @override
  void initState() {
    super.initState();
    initializePoints();
    getUserData();
    _startTimer();
    time.value = widget.task.time_level;
  }

  void initializePoints() {
    final matrix = widget.task.graph;
    final double sizeWidth = 400;
    final double sizeHeight = 400;
    final double radius = getRadius(matrix.length, sizeWidth);

    for (var i = 0; i < matrix.length; i++) {
      final angle = 2 * pi * (i / matrix.length) + (360 / matrix.length);
      points.add(Offset((cos(angle) * radius + sizeWidth / 2), sin(angle) * radius + sizeHeight / 2));
    }
  }

  double getRadius(int length, double sizeWidth) {
    double radius = 140;
    if (length > 10) {
      radius = 500;
    } else if (length > 20) {
      radius = 1000;
    }
    return radius;
  }

  void _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
      QuerySnapshot _user = await _userData.where('uid', isEqualTo: currentUserUid ?? '').get();
      final userData = _user.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        skills = userData[0]['skills'];
        print("UPDATE SKILLS STATE ${skills}");
        setState(() {});
      }

    } catch (e) {
      print('Exception occurred: $e');
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

  void _checkPlangraph(){
    Navigator.pop(context);
  }

  final colors = [
    const Color(0xffe8e809),
    const Color(0xff1fde4c),
    const Color(0xff2d3fc0),
    const Color(0xffed1a44),
    const Color(0xffb642f5),
    const Color(0xff4287f5),
    const Color(0xff24d2c3),
    const Color(0xffc58d15),
    const Color(0xffef6317),
    const Color(0xffc71b71),
    
  ];

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
                  "${time.value}",
                  style: const TextStyle(
                      color: Colors.red
                  )
              )
                  : Text( "${time.value}")
          ),
          GestureDetector(
            onLongPressStart: (details) {
              final tapPosition = details.localPosition;
              final vertexIndex = getTappedVertexIndex(tapPosition);
              for (int i = 0; i < points.length; i++) {
                if ((tapPosition.dx - points[i].dx).abs() < 30.0) {
                  selectedVertexOffset = i;
                  setState(() {});
                  print('Good - Tapped Vertex: $i');
                  break;
                } else {
                  print('Bad');
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
             onDoubleTapDown: (details){
               final tapPosition = details.localPosition;
               final vertexIndex = getTappedVertexIndex(tapPosition);
               for (int i = 0; i < points.length; i++) {
                 if ((tapPosition.dx - points[i].dx).abs() < 30.0) {
                   print('Change color vertex: $i');
                   showDialog(
                     context: context,
                     builder: (BuildContext context) {
                       return AlertDialog(
                       title: const Text('Цвета'),
                       content: SingleChildScrollView(
                         child: SizedBox(
                           child: Wrap(
                             spacing: 8.0, // gap between adjacent chips
                             runSpacing: 4.0,
                             children: [
                               GridView.builder(
                                 shrinkWrap: true,
                                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                   crossAxisCount: 2,
                                   crossAxisSpacing: 10.0,
                                   mainAxisSpacing: 10.0,
                                   childAspectRatio: 1.0,
                                 ),
                                 itemCount: colors.length,
                                 itemBuilder: (BuildContext context, int index) {
                                   final color = colors[index];
                                   return Padding(
                                     padding: const EdgeInsets.all(5),
                                     child: ElevatedButton(
                                       onPressed: () {
                                         print('Selected Color: $index');
                                         selectedVertexOffset = i;
                                         selectedColor = color.value;
                                         setState(() {});
                                         Navigator.pop(context);
                                       },
                                       style: ElevatedButton.styleFrom(
                                         backgroundColor: color,
                                         shape: const StadiumBorder(),
                                         padding: const EdgeInsets.all(12),
                                       ),
                                       child: const SizedBox(),
                                     ),
                                   );
                                 },
                               )
                             ],
                           ),
                         ),
                       ),
                       );
                     },
                   );
                 } else {
                   print('No Change vertex');
                 }
               }
             },
            child: CustomPaint(
              painter: OpenPainter(
                  matrix: widget.task.graph,
                  selectedIndex: selectedVertexOffset,
                  color: selectedColor,
                  points:points
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
                        spacing: 8.0, // gap between adjacent chips
                        runSpacing: 4.0,
                        children: skills.isNotEmpty ? List.generate(
                        skills.length,
                            (index) => ElevatedButton(
                          onPressed: () {
                            print(index);
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
                                print('Error removing skill from user-list: $error');
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
                      ) :
                        [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/empty_icon.svg',
                                height: 70.0,
                                width: 70.0,
                              ),
                              Text("Список пуст!")
                            ],
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
            child: const Text('Навыки и подсказки'),
          ),
          ),
          Positioned(
            bottom: 0,
            right:0,
            child: ElevatedButton(
              onPressed: _checkPlangraph,
              child: const Text('Закончить'),
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
  OpenPainter({
    Key? key,
    required this.matrix,
    required this.selectedIndex,
    required this.points,
    required this.color
  });
  @override
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    var drawPoints = Paint()..color = Color(0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;
    var drawLines = Paint()..color = Color(0xffb69d9d)..strokeWidth = 2;

    var paint3 =  Paint()..color = const Color(0xffb69d9d)..strokeWidth = 1..style = PaintingStyle.stroke;
    var paint4 =  Paint()..color = const Color(0xff000000)..strokeWidth = 10..style = PaintingStyle.stroke;

    var selectedIndexPaint =  Paint()..color = Color(color != null ? color as int : 0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;

    var radius = 140;
    if (matrix.length > 10) {
      radius = 500;
    } else if (matrix.length > 20) {
      radius = 1000;
    }

    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix.length; j++) {
        if (matrix[i][j] != 0) {
          final startPoint = this.points[i];
          final endPoint = this.points[j];

          if (i == selectedIndex || j == selectedIndex) {
            drawLines.color = Colors.red;
          } else {
            drawLines.color = Colors.black;
          }

          canvas.drawLine(startPoint, endPoint, drawLines);
        }
      }
    }

    for (var i = 0; i < matrix.length; i++) {
      canvas.drawCircle(points[i], 15, selectedIndex == i ? selectedIndexPaint : drawPoints);
      int letterIndex = i % 26;
      String letter = String.fromCharCode(65 + letterIndex);
      TextSpan span = TextSpan(style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), text:  (i + 1).toString());
      TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      if (matrix.length > 9) {
        if (i < 9) {
          tp.paint(canvas, Offset(this.points[i].dx -5.0, this.points[i].dy - 8.0));
        } else {
          tp.paint(canvas, Offset(this.points[i].dx -9.0, this.points[i].dy - 8.0));
        }
      } else {
        tp.paint(canvas, Offset(this.points[i].dx -5.0, this.points[i].dy - 8.0));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
