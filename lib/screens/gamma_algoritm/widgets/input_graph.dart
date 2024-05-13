import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class InputGraph extends StatefulWidget {

  const InputGraph({super.key});

  @override
  State<InputGraph> createState() => _InputGraphState();
}

class _InputGraphState extends State<InputGraph> {

  TutorialCoachMark? tutorialCoachMark;

  List<TargetFocus> targets = [];

  GlobalKey top = GlobalKey();
  GlobalKey bottom = GlobalKey();
  GlobalKey left = GlobalKey();

  GlobalKey inputKey = GlobalKey();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1),() {
      _showTutorialCoachMark();
    });
    super.initState();
  }

  void _showTutorialCoachMark(){
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
      pulseEnable: false,
      hideSkip: true,
      colorShadow: Colors.black12
    )..show(context: context);
  }

  void _initTarget(){
    setState(() {

    });
    targets = [
      TargetFocus(
        identify: "top-key",
        shape: ShapeLightFocus.RRect,
        targetPosition: TargetPosition(const Size.fromRadius(100),Offset(100,400)),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context,controller){
              return CoachDesc(
                text: "Lorem input asdsadasd",
                onNext: (){
                  controller.next();
                },
                onSkip: (){
                  controller.skip();
                },
              );
            }
          )
        ]
      ),
      TargetFocus(
          identify: "bottom-key",
          targetPosition: TargetPosition(const Size.fromRadius(100),Offset(100,200)),
          contents: [
            TargetContent(
                align: ContentAlign.bottom,
                builder: (context,controller){
                  return CoachDesc(
                    text: "Lorem input asdsadasd",
                    onNext: (){
                      controller.next();
                    },
                    onSkip: (){
                      controller.skip();
                    },
                  );
                }
            )
          ]
      ),
      // TargetFocus(
      //     identify: "left-key",
      //     keyTarget: left,
      //     contents: [
      //       TargetContent(
      //           align: ContentAlign.bottom,
      //           builder: (context,controller){
      //             return CoachDesc(
      //               text: "Lorem input asdsadasd",
      //               onNext: (){
      //                 controller.next();
      //               },
      //               onSkip: (){
      //                 controller.skip();
      //               },
      //             );
      //           }
      //       )
      //     ]
      // )
    ];

  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        key: top,
        painter: OpenPainter(
            targets: targets,
            isCheckedWeight: false,
            isCheckedOriented: false,
            colorVertices:0xffb69d9d,
            colorEdges:0xffb69d9d,
            typeEdges: "Digit"
        ),
      ),
    );
  }
}

class CoachDesc extends StatefulWidget {
  const CoachDesc({
    super.key,
    required this.text,
    this.skip = "Skip",
    this.next = "Next",
    this.onSkip,
    this.onNext
  });

  final String text;
  final String skip;
  final String next;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachDesc> createState() => _CoachDescState();
}

class _CoachDescState extends State<CoachDesc> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.text,
          ),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: widget.onSkip, child: Text(widget.skip)),
              const SizedBox(width: 16,),
              ElevatedButton(onPressed: widget.onNext, child: Text(widget.next)),
            ],
          )
        ],
      ),
    );
  }
}



class OpenPainter extends CustomPainter {
  final bool isCheckedWeight;
  final bool isCheckedOriented;
  final int colorVertices;
  final int colorEdges;
  final String typeEdges;
  final List<TargetFocus> targets;
  OpenPainter({Key? key,
    required this.isCheckedWeight,
    required this.isCheckedOriented,
    required this.colorVertices,
    required this.colorEdges,
    required this.typeEdges,
    required this.targets
  });
  var currentTargetIndex = 0;
  @override
  void paint(Canvas canvas, Size size) {

    final matrix = [
      [0,1,1,1,0,0],
      [1,0,1,1,0,0],
      [1,1,0,0,1,1],
      [1,1,0,0,1,1],
      [0,0,1,1,0,1],
      [0,0,1,1,1,0]];

    final List<Offset> points = [];

    var drawPoints = Paint()..color = Color(colorVertices)..strokeCap = StrokeCap.round..strokeWidth = 20;

    var drawLines = Paint()..color = Color(0xff000000)..strokeWidth = 2;
    var drawLinesTwo = Paint()..color = Color(0xffc22f2f)..strokeWidth = 5;

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

 // Индикатор текущего target

    for(var i = 0; i < matrix.length; i++) {
      for(var j = 0; j < matrix[i].length; j++) {
        if (matrix[i][j] != 0) { // Добавляем проверку значения в матрице

          // Сбрасываем все цвета рёбер к черному цвету
          for (var i = 0; i < matrix.length; i++) {
            for (var j = 0; j < matrix[i].length; j++) {
              if (matrix[i][j] != 0) {
                canvas.drawLine(points[i], points[j], drawLines);
              }
            }
          }

          // Рисуем рёбра в зависимости от текущего target
          for (var k = 0; k < targets.length; k++) {
            if (targets[k].identify == "top-key" && i == 0 && j == 1) {
              canvas.drawLine(points[0], points[1], drawLinesTwo);
            }
            if (targets[k].identify == "top-key" && i == 1 && j == 3) {
              canvas.drawLine(points[1], points[3], drawLinesTwo);
            }
            if (targets[k].identify == "top-key" && i == 0 && j == 3) {
              canvas.drawLine(points[0], points[3], drawLinesTwo);
            }
            if (targets[k].identify == "bottom-key" && i == 3 && j == 5) {
              canvas.drawLine(points[3], points[5], drawLinesTwo);
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
        tp.paint(canvas, Offset(points[i].dx -5.0, points[i].dy - 8.0,));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
