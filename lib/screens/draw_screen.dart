import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference _collectionRef = FirebaseFirestore.instance.collection('tasks');
  var rulesMatrix = [
    'Размер матрицы должен быть задан.',
    'Размер матрицы должен быть больше 0.',
    'Размер матрицы должен представлять число.',
  ];

  Future<void> getTasks() async{
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allTasks = querySnapshot.docs.map((doc) => doc.data()).toList();
    print(allTasks);
  }

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
  void initState() {
    super.initState();
    // getTasks();
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
                          cursorColor: const Color(0xFF678094),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xFF678094),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF678094),
                                  width: 2.0
                                ),
                              ),
                            label: const Text('Длина'),
                              labelStyle: const TextStyle(
                              color: Color(0xFF678094)
                            )
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
                        cursorColor: const Color(0xFF678094),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF678094),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF678094),
                                  width: 2.0
                              ),
                            ),
                            label: const Text('Ширина'),
                            labelStyle: const TextStyle(
                                color: Color(0xFF678094)
                            )
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            height: 250,
                            width: double.infinity,
                            color: const Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0,bottom: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                      'assets/images/error.svg',
                                      width: 70,
                                      height: 70
                                  ),
                                  const SizedBox(height: 15.0),
                                  Text(inputError),
                                  const SizedBox(height: 35.0),
                                  ElevatedButton(
                                    onPressed: () => {
                                      Navigator.pop(context)
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                    ),
                                    child: const Text('Закрыть'),
                                  ),
                                ],
                              ),
                            ),
                          );}
                        );
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                      ),
                      child: const Text('Продолжить'),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                          return Container(
                            height: 280,
                            width: double.infinity,
                            color: const Color(0xffffffff),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: rulesMatrix.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          leading: SvgPicture.asset(
                                            'assets/images/success_icon.svg',
                                            width:20,
                                            height:20
                                          ),
                                          title: Text(rulesMatrix[index]),
                                        );
                                      },
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    child: const Text('Закрыть'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                      child: Container(
                        width: 30.0,
                        height: 30.0,
                        margin: EdgeInsets.only(left: 10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: SvgPicture.asset(
                            'assets/images/question_icon.svg',
                          ),
                        ),
                      ),
                    )
                  ],
                )
                // Container(
                //   child: Padding(
                //     padding: EdgeInsets.all(10.0),
                //     child: Text(
                //         'Силовые алгоритмы',
                //         style: TextStyle(
                //             fontSize: 25.0
                //         )
                //     ),
                //   ),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //       border: Border(
                //           bottom: BorderSide(
                //               color:Colors.black,
                //               width: 1.0
                //           )
                //       )
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: (){
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute<void>(
                //         builder: (BuildContext context) => Scaffold(
                //           appBar: AppBar(
                //             title: const Text('Настройки'),
                //           ),
                //           body: Text('dfdf'),
                //         ),
                //       ),
                //     );
                //   },
                //   child: Text('Попробовать'),
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}