import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../matrix/matrix.dart';
import '../matrix/matrix_page.dart';

// class DrawScreen extends StatelessWidget {
//   const DrawScreen({Key? key}) : super(key: key);
//
//   final TextEditingController row;
//   final TextEditingController column;
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         // MatrixOption(matrix: Matrix(2, 2)),
//         // MatrixOption(matrix: Matrix(3, 3)),
//         // MatrixOption(matrix: Matrix(4, 4)),
//         // MatrixOption(matrix: Matrix(5, 5)),
//         // MatrixOption(matrix: Matrix(6, 6)),
//         // MatrixOption(matrix: Matrix(7, 7)),
//         // MatrixOption(matrix: Matrix(8, 8)),
//         const MatrixOption(matrix: Matrix(9, 9)),
//         const Text('Введите матрицу'),
//         Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 textAlign: TextAlign.center,
//                 controller: row,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder()
//                 ),
//               ),
//             ),
//             Text('*'),
//             Expanded(
//               child: TextField(
//                 textAlign: TextAlign.center,
//                 controller: column,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder()
//                 ),
//               ),
//             ),
//           ],
//         ),
//         ElevatedButton(
//             onPressed: (){
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return Scaffold(
//                         appBar: AppBar(
//                           title: const Text('Ввод матрицы'),
//                         ),
//                         body: MatrixPage(matrix: Matrix(int.tryParse(row),int.tryParse(column))),
//                       );
//                     },
//                   )
//               );
//             },
//             child: const Text('Далее')
//         )
//       ],
//     );
//   }
// }

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _row = TextEditingController();
  final _column = TextEditingController();

  int handleInput(TextEditingController row,TextEditingController column){
    var a = int.tryParse(row.text);
    var b = int.tryParse(column.text);
    if(a == null || b == null){
      return 0;
    }
    if(a == 0 || b == 0){
      return 0;
    }
    if(a != b){
      return 0;
    }
    if(a > 9 || b > 9){
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Введите матрицу'),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _row,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              const Text('*',style: TextStyle(fontSize: 30.0),),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _column,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: (){
                    handleInput(_row, _column) == 1
                    ? Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: const Text('Ввод матрицы'),
                          ),
                          body: MatrixPage(matrix: Matrix(int.parse(_row.text),int.parse(_column.text))),
                        );
                      }))
                    : handleInput(_row, _column) == 2
                    ? showModalBottomSheet<void>(context: context, builder: (BuildContext context) {return Container(
                      height: 200,
                      color: Colors.amber,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('К сожалению, для матрицы 10 на 10 и больше,вы не сможете построить.Приносим свои извинения'),
                            ElevatedButton(
                              child: const Text('Закрыть'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );})
                    : showModalBottomSheet<void>(context: context, builder: (BuildContext context) {return Container(
                    height: 200,
                    color: Colors.amber,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text('Не верный ввод!'),
                          ElevatedButton(
                            child: const Text('Закрыть'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                  );});
              },
              child: const Text('Далее')
          )
        ],
      ),
    );
  }
}

