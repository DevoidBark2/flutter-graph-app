import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/instruction_screen.dart';
import 'package:test_project/screens/rules_game.dart';
import 'package:test_project/screens/settings_screen.dart';

class TheoryScreen2 extends StatefulWidget {
  const TheoryScreen2({Key? key}) : super(key: key);

  @override
  State<TheoryScreen2> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen2> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Немного теории',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(text: 'Графом', style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ' называется система объектов произвольной природы (вершин) и связок (ребер), соединяющих некоторые пары этих объектов.'),
                ],
              ),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text: 'Пусть ',
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(text: 'V ', style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: '— (непустое) множество вершин, элементы '),
                  TextSpan(text: 'v ∈ V', style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: '— вершины. Граф ',),
                  TextSpan(text: 'G = G(V) ',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: 'с множеством вершин '),
                  TextSpan(text: 'V',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: 'есть некоторое семейство пар вида: '),
                  TextSpan(text: 'e = (a, b)',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ', где '),
                  TextSpan(text: 'a, b ∈ V',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ' указывающих, какие вершины остаются соединёнными. Каждая пара '),
                  TextSpan(text: 'e = (a, b)',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ' — ребро графа.'),
                  TextSpan(text: ' Множество'),
                  TextSpan(text: ' U',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ' — множество ребер '),
                  TextSpan(text: 'e ',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: 'графа. Вершины'),
                  TextSpan(text: ' a и b',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                  TextSpan(text: ' — концевые точки ребра '),
                  TextSpan(text: 'e.',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 17)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(text: 'Широкое применение теории графов в компьютерных науках и информационных технологиях можно объяснить понятием графа как структуры данных. В компьютерных науках и информационных технологиях граф можно описать, как нелинейную структуру данных.'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Некоторые понятия теории графов',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'Два ребра называются ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'смежными', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ' , если у них есть общая вершина.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Два ребра называются ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'кратными', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ', если они соединяют одну и ту же пару вершин.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'Степенью ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: 'вершины называют количество ребер, для которых она является концевой (при этом петли считают дважды).'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Вершина называется ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'изолированной', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ', если она не является концом ни для одного ребра.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Вершина называется ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'висячей', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ', если из неё выходит ровно одно ребро.'),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Граф без кратных ребер и петель называется ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'обыкновенным', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            const SizedBox(height: 15),
            const Text('Виды графов',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'Графы, в которых все ребра являются звеньями, то есть порядок двух концов ребра графа не существенен, называются ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'неориентированными', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_1.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'Графы, в которых все ребра являются дугами, то есть порядок двух концов ребра графа существенен, называются ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'ориентированными графами ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: 'или'),
                      TextSpan(text: ' орграфами.',style: TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_2.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'Смешанным ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: 'называют граф, в котором есть ребра хотя бы двух из упомянутых трех разновидностей (звенья, дуги, петли).'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_3.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'Пустой ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: 'граф — это тот, что состоит только из голых вершин.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_4.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'Мультиграф ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: '— такой граф, в котором пары вершин соединены более, чем одним ребром. То есть есть кратные рёбра, но нет петель.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_5.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'Граф называют ',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'полным', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ', если он содержит все возможные для этого типа рёбра при неизменном множестве вершин. Так, в полном обыкновенном графе каждая пара различных вершин соединена ровно одним звеном.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_6.png')
            ),
            const SizedBox(height: 10),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: 'Взвешенным графом ', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: 'называется граф, вершинам и/или ребрам которого присвоены «весы» — обычно некоторые числа. Пример взвешенного графа — транспортная сеть, в которой ребрам присвоены весы: они показывают стоимость перевозки груза по ребру и пропускные способности дуг.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Image.asset('assets/images/graph_7.png')
            ),
          ],
        ),
      ),
    );
  }
}
