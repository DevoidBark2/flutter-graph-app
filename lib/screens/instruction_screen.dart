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
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            BulletedList(
              listItems:[
                Text('Вы можете посмотреть все ранее созданные вами графы в вашем Профиле.'),
                Text('Сверху справа находятся Настройки, в которых вы сможете изменить цвет ребер и вершин'),
              ],
              listOrder: ListOrder.ordered,
              bulletType: BulletType.conventional,
            ),
            SizedBox(height: 10),
            Text('Инструкция',textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25)),
            SizedBox(height: 10),
            BulletedList(
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
          ],
        ),
      ),
    );
  }
}
