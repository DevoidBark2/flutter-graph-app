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

  int activeTarget = 0;

  List<TargetFocus> targets = [];

  GlobalKey image_1 = GlobalKey();
  GlobalKey image_2 = GlobalKey();
  GlobalKey image_3 = GlobalKey();
  GlobalKey image_4 = GlobalKey();
  GlobalKey image_5 = GlobalKey();
  GlobalKey image_6 = GlobalKey();
  GlobalKey image_7 = GlobalKey();

  GlobalKey inputKey = GlobalKey();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100),() {
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
        identify: "image_1",
        shape: ShapeLightFocus.RRect,
        keyTarget: image_1,
        contents: [
          TargetContent(
            builder: (context,controller){
              return CoachDesc(
                text: "Первый этап — инициализация алгоритма.В графе G выбирается любой простой цикл и производится его укладка на плоскость. Пусть в примере это будет цикл {1,2,3,4,5,6}.",
                onNext: (){
                  controller.next();
                  _scrollController.addListener(() {
                    if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent + 10, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                    }
                  });
                  setState(() {
                    activeTarget++;
                  });
                },
                onSkip: (){
                  _scrollController.addListener(() {
                    if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent + 10, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                    }
                  });
                  controller.skip();
                  setState(() {
                    activeTarget--;
                  });
                },
              );
            }
          )
        ]
      ),
      TargetFocus(
          identify: "image_2",
          keyTarget: image_2,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "После его укладки получаем две грани: Γ1 и Γ2. Уже уложенную во время работы алгоритма часть будем обозначать Gplane. В примере сейчас Gplane— выбранный цикл {1,2,3,4,5,6}.",
                    onNext: (){
                      controller.next();
                      activeTarget++;
                      _scrollController.animateTo(_scrollController.offset + 400, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
                    },
                    onSkip: (){
                      controller.skip();
                      activeTarget--;
                    }
                  );
                }
            )
          ]
      ),
      TargetFocus(
          identify: "image_3_1",
          keyTarget: image_3,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "Пусть в каком-то сегменте нет ни одной контактной вершины. В таком случае граф до выделения Gplane был несвязным, что противоречит условию. Пусть контактная вершина в сегменте только одна. Это значит, что в графе был мост или точка сочленения, чего быть не может так же по условию. Таким образом, в каждом сегменте имеется не менее двух контактных вершин. Соответственно, в каждом сегменте есть цепь между любой парой контактных вершин. Пусть грань Γ вмещает сегмент S, если номера всех контактных вершин Sпринадлежат этой грани, S⊂Γ. Очевидно, таких граней может быть несколько. Множество таких граней обозначим Γ(S), а их число — |Γ(S)|.",
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
          identify: "image_3_2",
          keyTarget: image_3,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "Итак, рассмотрим все сегменты Si и для каждого определим число |Γ(Si)|. Если найдется такой номер i, что |Γ(Si)|=0, то граф не планарен, алгоритм завершает работу. Иначе выбираем такой сегмент Si, для которого число |Γ(Si)| минимально. Если таких сегментов несколько, можно выбрать любой из них. Найдем в этом сегменте цепь между двумя контактными вершинами и уложим ее в любую грань из множества Γ(Si), совместив контактные вершины сегмента с соответствующими вершинами грани.",
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
          identify: "image_3_3",
          keyTarget: image_3,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "Выбранная грань разобьется на две. Выбранный сегмент после того, как из него взяли цепь, либо исчезнет, либо распадется на меньшие части, в которых будут новые контактные вершины, ведущие к вершинам обновленного Gplane",
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
          identify: "image_4",
          keyTarget: image_4,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "В примере для любого i: Si⊂{Γ1,Γ2}, то есть |Γ(Si)|=2. Следовательно, можем выбрать любой Si. Пусть это будет сегмент S1. В нем есть цепь {1,4}. Вставим эту цепь в грань Γ1, например, и этот сегмент исчезнет. После укладки цепи граф G и сегменты будут выглядеть так",
                    onNext: (){
                      _scrollController.animateTo(_scrollController.offset + 300, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
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
          identify: "image_5",
          keyTarget: image_5,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "Третий и последующие этапы аналогичны второму. Повторять вышеуказанные действия нужно либо до тех пор, пока не будет получена плоская укладка, то есть множество сегментов не останется пустым, либо пока не будет получено, что граф не планарен.Разберем пример до конца. Повторим снова общий шаг. Теперь |Γ(S1)|=|Γ(S3)|=1, |Γ(S2)|=|Γ(S4)|=2. Возьмем S1. В ней цепь {2,5}, которую мы уложим в грань Γ2, после чего этот сегмент исчезнет. Теперь картина будет следующая",
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
          identify: "image_6",
          keyTarget: image_6,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                builder: (context,controller){
                  return CoachDesc(
                    text: "На следующем шаге |Γ(S1)|=|Γ(S3)|=2, |Γ(S2)|=1. Выбираем сегмент S2, содержащий цепь {3,5}. Уложим ее в грань Γ2, после чего этот сегмент снова исчезнет",
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
          identify: "image_7",
          keyTarget: image_7,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
                align: ContentAlign.top,
                builder: (context,controller){
                  return CoachDesc(
                    text: "Теперь |Γ(S1)|=1, а |Γ(S3)|=2. Уложим сначала цепь {2,4} из первого сегмента, он пропадет, потом уложим цепь {6,7,5} из третьего. В результате граф будет полностью уложен на плоскость, множество сегментов останется пустым. Таким образом, мы получили плоскую укладку исходного графа G.",
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
    ];

  }
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_1,'assets/images/demo-gamma/gamma_alg_1.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_2,'assets/images/demo-gamma/gamma_alg_2.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_3,'assets/images/demo-gamma/gamma_alg_3.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_4,'assets/images/demo-gamma/gamma_alg_4.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_5,'assets/images/demo-gamma/gamma_alg_5.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_6,'assets/images/demo-gamma/gamma_alg_6.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF678094))
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(key: image_7,'assets/images/demo-gamma/gamma_alg_7.png'),
                )
              ],
            )
        ),
      ),
    );
  }
}

class CoachDesc extends StatefulWidget {
  const CoachDesc({
    super.key,
    required this.text,
    this.skip = "Пропустить",
    this.next = "Далее",
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
      child: SingleChildScrollView(
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
                TextButton(onPressed: widget.onSkip, child: Text(
                    widget.skip,
                  style: const TextStyle(
                    color: Color(0xFF678094)
                  ),
                )),
                const SizedBox(width: 16,),
                ElevatedButton(
                    onPressed: widget.onNext,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                  ),
                    child: Text(widget.next),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
