import 'package:flutter/material.dart';
import '../matrix/matrix.dart';
import '../matrix/matrix_page.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final _row = TextEditingController();

  int handleInput(TextEditingController row){
    var a = int.tryParse(row.text);
    if(a == null){
      return 0;
    }
    if(a == 0){
      return 0;
    }
    if(a > 9){
      return 2;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Введите матрицу'),
            const SizedBox(
              height: 30,
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
                  )
                ),
                const Text('*',style: TextStyle(fontSize: 30.0),),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _row,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: (){
                      handleInput(_row) == 1
                      ? Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: const Text('Ввод матрицы'),
                            ),
                            body: MatrixPage(matrix: Matrix(int.parse(_row.text),int.parse(_row.text))),
                          );
                        }))
                      : handleInput(_row) == 2
                      ? showModalBottomSheet<void>(context: context, builder: (BuildContext context) {return Container(
                        height: 200,
                        color: Colors.amber,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Text('Матрицы 10x10 и больше еще в разработке!'),
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
      ),
    );
  }
}

