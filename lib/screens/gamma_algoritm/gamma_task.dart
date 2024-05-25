import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/Task.dart';

class GammaTaskScreen extends StatefulWidget {
  final List<List<int>> graph;
  final List<String> listQuistion;
  final String question;
  final int answer;
  final int total_count;
  const GammaTaskScreen({super.key,
    required this.graph,
    required this.listQuistion,
    required this.question,
    required this.answer,
    required this.total_count
  });


  @override
  State<GammaTaskScreen> createState() => _GammaTaskState();
}

class _GammaTaskState extends State<GammaTaskScreen> {

  final user = FirebaseAuth.instance.currentUser;
  var _userData;

  // void getUserData() {
  //   _userData.get().then((value) {
  //     // skills1 = value.data()!['skills'].where((element) => element['title'] == "Тайм-экстендер x2");
  //     setState(() {});
  //   });
  //
  //   _userData.snapshots().listen((snapshot) {
  //     if (snapshot.data() != null) {
  //       setState(() {});
  //     }
  //   });
  // }


  int userTotalData = 0;
  late List skills = [];
  late List skills1 = [];

  void getUserData() {
    _userData.get().then((value) {
      userTotalData = value.data()!['user_total'];
      skills = value.data()!['tips'];
      print(skills);
      // skills1 = value.data()!['skills'].where((element) => element['title'] == "Тайм-экстендер x2");
      setState(() {});
    });

    _userData.snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        userTotalData = snapshot.data()!['user_total'];
        skills = snapshot.data()!['tips'];
        setState(() {});
      }
    });
  }



  Future<void> _setCountToUser () async {

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users-list').where('uid', isEqualTo: user?.uid ?? '').get();
    final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    int totalCurrentUser = userData[0]['user_total'];

    await FirebaseFirestore.instance.collection('users-list').doc(user?.uid).update({
      'user_total': totalCurrentUser + widget.total_count,
    });

    Navigator.pop(context);

    final snackBar = SnackBar(
        content: Text("Молодец,ты выполнил задание! Получай ${widget.total_count} очков."),
        backgroundColor: Colors.green
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final hiddenElem = [];

  @override
  void initState() {
    super.initState();

    _generateProbabilities();
    if (user != null) {
      _userData = FirebaseFirestore.instance.collection('users-list').doc(
          FirebaseAuth.instance.currentUser?.uid ?? '');
      getUserData();
    }
  }

  List<double> _probabilities = [];

  void _generateProbabilities() {
    setState(() {
      _probabilities = List.generate(widget.listQuistion.length, (index) {
        if (index == widget.answer) {
          // Set a higher probability for the correct answer
          return 0.8 + Random().nextDouble() * 0.2;
        } else {
          return Random().nextDouble();
        }
      });
      // Normalize the probabilities to sum up to 100
      _probabilities = _probabilities.map((probability) => probability * 100).toList();
      _probabilities = _probabilities.map((probability) => probability / _probabilities.reduce((a, b) => a + b)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          minScale: widget.graph.length > 9 ? 0.1 : 0.3,
          maxScale: 10.5,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          child: SizedBox(
            width: 400,
            height: 413,
            child: CustomPaint(
              painter: OpenPainter(
                  matrix: widget.graph,
                  colorVertices:0,
                  colorEdges:0,
                  typeEdges: "TypeEdges.Digit"
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: skills.where((element) => element['title'] == "50 / 50").isNotEmpty
                      ?  GestureDetector(
                    onTap: (){
                      if (hiddenElem.isEmpty) {
                        var random = Random();
                        int index1, index2;
                        do {
                          index1 = random.nextInt(widget.listQuistion.length -
                              1);
                        } while (index1 == widget.answer);
                        do {
                          index2 = random.nextInt(widget.listQuistion.length -
                              1);
                        } while (index2 == widget.answer || index2 == index1);
                        hiddenElem.add(index1);
                        hiddenElem.add(index2);

                        final CollectionReference userListRef = FirebaseFirestore.instance.collection('users-list');
                        final userDocument = userListRef.doc(user?.uid);

                        userDocument.get().then((userListDoc) {
                          if (userListDoc.exists) {
                            final userListData = userListDoc.data() as Map<String, dynamic>;
                            final skillsList = userListData['tips'];
                            final removedSkill = skillsList.removeAt(skills.indexWhere((element) => element['title'] == "50 / 50"));
                            if (removedSkill != null) {
                              userListData['tips'] = skillsList;
                              final updatedUserListData = {...userListData};
                              userDocument.update(updatedUserListData);
                            }
                          }
                        }).catchError((error) {
                          print('Error removing skill from user-list: $error');
                        });

                        setState(() {});
                        return;
                      }

                      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: const Color(0xffffffff),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/error.svg',
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(height: 15.0),
                                const Text(
                                    "Больше нельзя использовать данную подсказку в этом задании!",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 30.0),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                    ),

                                    child: const Text('Закрыть')
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                    child: Wrap(
                      children: [
                        SvgPicture.network(
                          skills.firstWhere((element) => element['title'] == "50 / 50")['image_item'],
                          width: 35,
                          height: 35,
                        ),
                        Text('${skills.where((element) => element['title'] == "50 / 50").length}'),
                      ],
                    ),
                  )
                      : const SizedBox(height: 0),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: skills.where((element) => element['title'] == "Помощь зала").isNotEmpty
                      ? GestureDetector(
                    onTap: (){
                      final CollectionReference userListRef = FirebaseFirestore.instance.collection('users-list');
                      final userDocument = userListRef.doc(user?.uid);

                      _probabilities = [];

                      _generateProbabilities();

                      userDocument.get().then((userListDoc) {
                        if (userListDoc.exists) {
                          final userListData = userListDoc.data() as Map<String, dynamic>;
                          final skillsList = userListData['tips'];
                          final removedSkill = skillsList.removeAt(skills.indexWhere((element) => element['title'] == "Помощь зала"));
                          if (removedSkill != null) {
                            userListData['tips'] = skillsList;
                            final updatedUserListData = {...userListData};
                            userDocument.update(updatedUserListData);
                          }
                        }
                      }).catchError((error) {
                          print('Error removing skill from user-list: $error');
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            contentPadding: const EdgeInsets.all(20),
                            title: const Text('Помощь зала'),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              child: ListView.builder(
                                itemCount: widget.listQuistion.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(widget.listQuistion[index]),
                                    subtitle: Text(
                                      "${(_probabilities[index] * 100).toInt()}%",
                                    ),
                                  );
                                },
                              )
                            )
                          );
                        },
                      );
                    },
                    child: Wrap(
                      children: [
                        SvgPicture.network(
                          skills.firstWhere((element) => element['title'] == "Помощь зала")['image_item'],
                          width: 35,
                          height: 35,
                        ),
                        Text('${skills.where((element) => element['title'] == "Помощь зала").length}'),
                      ],
                    ),
                  )
                      : const SizedBox(height: 0),
                ),
              ],
            )

          ),
        ),
        Positioned(
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.4,
            builder: (context, controller) => Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          widget.question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                          mainAxisExtent: 80
                      ),
                      itemCount: widget.listQuistion.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = widget.listQuistion[index];
                        return GestureDetector(
                          onTap: !hiddenElem.contains(index) ? (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Подтверждение ответа"),
                                  content: const Text("Вы подтверждаете данный вариант ответа?"),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                          ),
                                          child: const Text('Назад'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                          ),
                                          child: const Text('Да'),
                                          onPressed: () {
                                            Navigator.of(context).pop();

                                            if(index == widget.answer){
                                              _setCountToUser();
                                            }
                                            else{
                                              Navigator.of(context).pop();

                                              const snackBar = SnackBar(
                                                  content: Text("Задание выполнено неверно, попробуйте еще раз!"),
                                                  backgroundColor: Colors.red
                                              );

                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                            // if(index == widget.answer){
                            //   _setCountToUser();
                            // }
                          } : null,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: hiddenElem.contains(index) ? <Color>[const Color(0xFF834db5), const Color(0xFF674594)]: <Color>[const Color(0xFF819db5), const Color(0xFF678094)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(5),
                              child: Center(child: Text(
                                  item,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600
                                ),
                              )
                              ),
                            )
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class OpenPainter extends CustomPainter {
  final List<List<int?>> matrix;
  final int colorVertices;
  final int colorEdges;
  final String typeEdges;
  OpenPainter({Key? key,
    required this.matrix,
    required this.colorVertices,
    required this.colorEdges,
    required this.typeEdges
  });
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    final List<Offset> points = [];

    var drawPoints = Paint()..color = Color(0xffb69d9d)..strokeCap = StrokeCap.round..strokeWidth = 20;

    var drawLines = Paint()..color = Color(0xffcb3e3e)..strokeWidth = 2;

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
          canvas.drawLine(points[i], points[j], drawLines);
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
