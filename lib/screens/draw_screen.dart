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
    if(a == null || a <= 0) {
      return 0;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                const Text('Введите матрицу',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: _row,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()
                          ),
                        )
                    ),
                    const SizedBox(width: 25.0),
                    const Padding(padding:EdgeInsets.only(top: 20.0),child: Text('*',style: TextStyle(fontSize: 40.0),)),
                    const SizedBox(width: 25.0),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: _row,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: (){
                      handleInput(_row) == 1
                          ? Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          body: MatrixPage(matrix: Matrix(int.parse(_row.text),int.parse(_row.text))),
                        );
                      }))
                          : showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                            return Container(
                                height: 200,
                                color: const Color(0xffa4a6db),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text('Не верный ввод!'),
                                        ElevatedButton(
                                          child: const Text('Закрыть'),
                                          onPressed: () => {
                                            Navigator.pop(context)
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                          ),
                        ),
                      );}
                      );
                    },
                    child: const Text('Продолжить')
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}