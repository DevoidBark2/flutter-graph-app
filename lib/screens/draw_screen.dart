import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../matrix/matrix.dart';
import '../matrix/matrix_page.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final matrixSize = TextEditingController();
  var inputError = '';

  int handleInput(TextEditingController row){
    var a = int.tryParse(row.text);
    if(a == null){
      inputError = "Размер матрицы должен быть задан!";
      return 0;
    }
    if(a <= 0){
      inputError = "Размер матрицы должен быть больше нуля!";
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
                const Text('Введите матрицу',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,fontFamily: 'JetBrainsMono')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: matrixSize,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Длина')
                          ),
                        )
                    ),
                    const SizedBox(width: 25.0),
                    const Padding(padding:EdgeInsets.only(top: 20.0),child: Text('*',style: TextStyle(fontSize: 40.0))),
                    const SizedBox(width: 25.0),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: matrixSize,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          label: Text('Ширина')
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: (){
                      handleInput(matrixSize) == 1
                          ? Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return Scaffold(
                          body: MatrixPage(matrix: Matrix(int.parse(matrixSize.text),int.parse(matrixSize.text))),
                        );
                      }))
                          : showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                            return Container(
                                height: 200,
                                color: const Color(0xffffffff),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/images/error.svg',
                                            width: 50,
                                            height: 50
                                        ),
                                        const SizedBox(height: 15.0),
                                        Text(inputError),
                                        const SizedBox(height: 35.0),
                                        ElevatedButton(
                                          child: const Text('Закрыть'),
                                          onPressed: () => {
                                            Navigator.pop(context)
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                                          ),
                                        ),
                                      ],
                                  ),
                                ),
                      );}
                      );
                    },
                    child: const Text('Продолжить'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                    ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}