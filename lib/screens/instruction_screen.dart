import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({Key? key}) : super(key: key);

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const BulletedList(
              listItems:[
                Text('Вы можете посмотреть все ранее созданные вами графы в вашем Профиле.'),
                Text('Сверху справа находятся Настройки, в которых вы сможете изменить цвет ребер и вершин'),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            const SizedBox(height: 10),

            const Text('Инструкция',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
            const SizedBox(height: 10),
            const BulletedList(
              listItems:[
                Text('Зайдите в пункт меню "Визуализация".'),
                Text('Введите размер матрицы в любой из двух полей ввода и нажмите кнопку "Далее".'),
                Text('Далее откроется экран с матрицей с размерам которым вы указали в окне ранее.'),
                Text('Введите матрицу смежности и нажмите кнопку "Отобразить".'),
                Text('На экране появится ваш граф, масштаб которого вы можете изменять.'),
                Text('Снизу экрана находится выдвигающеся меню, в котором вы сможете увидеть свойства данного графа.'),
                Text('Сверху справа находится бургер-меню,в котором находятся алгоритмы над графами.')
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.numbered,
            ),
            const Text('Примечания',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'В окне ввода матрицы смежности значения',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: ' на главной диагонали больше 0', style: TextStyle(fontWeight: FontWeight.w800)),
                      TextSpan(text: ' означает присутствие петли у данной вершины.'),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            BulletedList(
              listItems:[
                RichText(
                  text: TextSpan(
                    text: 'Для обхода в ширину',
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(text: ' матрица должна состоять из 0 и 1.', style: TextStyle(fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
          ],
        ),
      ),
    );
  }
}
