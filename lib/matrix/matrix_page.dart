import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/graph/graph_view.dart';
import 'matrix.dart';
import 'matrix_field.dart';
import "package:collection/collection.dart";

class MatrixPage extends StatefulWidget {
  final Matrix matrix;
  const MatrixPage({ Key? key, required this.matrix}) : super(key: key);

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  final controllers = <List<TextEditingController>>[];
  late final rows = widget.matrix.rows;
  late final columns = widget.matrix.columns;
  late bool colorGraph = false;
  bool isCheckedWeight = false;
  bool isCheckedOriented = false;
  Map<String,dynamic>? currentUserData;
  final textFieldController = TextEditingController();
  final upper = TextEditingController();
  String errorMessage = "";
  var rulesFillMatrix = [
    'Можно вводить веса графа ручным способом',
    'Можно вводить веса графа автозаполнением',
    'Если нажать один раз на кнопку \"Автозаполнение\", матрица заполнятся 0 и 1',
    'Если зажать кнопку \"Автозаполнение\", Вы сможете выбрать маскимальное число для рандомных весов графа',
  ];

  // Future<Map<String, dynamic>?> getCurrentUserData() async {
  //   try {
  //     User? currentUser = FirebaseAuth.instance.currentUser;
  //     String? userId = currentUser?.uid;
  //     DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  //     return userData.data() as Map<String, dynamic>;
  //   } catch (e) {
  //     print('Ошибка при получении данных текущего пользователя: $e');
  //     return null;
  //   }
  // }
  // Future<void> getUser() async {
  //   Map<String, dynamic>? userData = await getCurrentUserData();
  //   setState(() {
  //     currentUserData = userData;
  //   });
  // }
  // Future<void> setDataUserGraph(String matrix,bool orinted,bool weight) async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   String? userId = currentUser?.uid;
  //   final userRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('userData');
  //   await userRef.add({'data': matrix, 'timestamp': FieldValue.serverTimestamp()});
  // }
  void createControllers() {
    for (var i = 0; i < rows; i++) {
      controllers.add(List.generate(columns, (index) => TextEditingController(text: '')));
    }
  }

  @override
  void dispose() {
    for (var controllerRow in controllers) {
      for (final c in controllerRow) {
        c.dispose();
      }
    }
    super.dispose();
  }
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return const Color(0xFF8eb3ed);
    }
    return const Color(0xFF678094);
  }

  bool checkMatrix(controllers){
    bool isCheckedValidMatrix = true;
    var mat = List.generate(controllers.length, (row) => List.generate(controllers.length ,(column) => int.tryParse(controllers[row][column].text)));
    print("mat ${mat.toString()}");
    List<List<int?>> result = List.generate(mat[0].length, (i) => List.filled(mat.length, 0));
    print(result);

    for(var i = 0; i < mat.length; i++){
      for(var j = 0; j < mat.length; j++){
        if(mat[i][j] == null){
          isCheckedValidMatrix = false;
          errorMessage = "Все поля должны быть заполнены!";
          break;
        }
      }
    }
    if(!isCheckedValidMatrix){
      return false;
    }else{
      for (int i = 0; i < mat.length; i++) {
        for (int j = 0; j < mat[0].length; j++) {
          result[j][i] = mat[i][j];
        }
      }
      if(const DeepCollectionEquality().equals(mat, result)){
        isCheckedOriented = false;
      }
      else{
        isCheckedOriented = true;
      }
      // //сохранение графа в бд
      // if(currentUserData != null){
      //  setDataUserGraph(mat.toString(),isCheckedOriented,isCheckedWeight);
      // }
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    createControllers();
    // getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ввод матрицы'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: SizedBox(
                        child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: List.generate(
                                        controllers.length,
                                            (index1) => Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(
                                            controllers[index1].length,
                                                (index2) => Center(
                                              child: Padding(
                                                padding: controllers.length > 8 ? const EdgeInsets.all(1.0) :
                                                controllers.length > 7 ? const EdgeInsets.all(1.0) :
                                                controllers.length > 6 ? const EdgeInsets.all(2.0) :
                                                controllers.length > 5 ? const EdgeInsets.all(3.0) :
                                                const EdgeInsets.all(6.0),
                                                child: SizedBox(
                                                  height: controllers.length > 8 ? 32 : controllers.length > 7 ? 35 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                                                  width: controllers.length > 8 ? 32 : controllers.length > 7 ? 35 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                                                  child: MatrixField(
                                                    action: (index2  == controllers.length -1 && index1 == controllers.length -1) ? TextInputAction.done : TextInputAction.next,
                                                    controller: controllers[index1][index2],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox( width:233,child: Text('Взвешенный граф')),
                                          Checkbox(
                                            checkColor: Colors.white,
                                            fillColor:MaterialStateProperty.resolveWith(getColor),
                                            value: isCheckedWeight,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isCheckedWeight = value!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () => checkMatrix(controllers) == true
                                            ?
                                        Navigator.push(context,MaterialPageRoute(builder: (context) {
                                          return GraphView(controllers:controllers,isCheckedWeight: isCheckedWeight,isCheckedOriented: isCheckedOriented);
                                        }))
                                            :
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.white,
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SvgPicture.asset(
                                                          'assets/images/error.svg',
                                                          width: 50,
                                                          height: 50
                                                      ),
                                                      const SizedBox(height: 15.0),
                                                      Text(errorMessage),
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
                                              ),
                                            );
                                          },
                                        ),
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                        ),
                                        child: const Text('Отобразить'),
                                      ),

                                     Row(
                                       children: [
                                         ElevatedButton(
                                           onPressed: () {
                                             for (int i = 0; i < controllers.length; i++) {
                                               for (int j = 0; j < controllers[i].length; j++) {
                                                 int? upperValue = int.tryParse(upper.text);
                                                 int rnd = Random().nextInt((upperValue?.toInt() ?? 2));
                                                 controllers[i][j].text = rnd.toString();
                                                 controllers[j][i].text = rnd.toString();
                                                 if (i == j) {
                                                   bool rnd = Random().nextBool();
                                                   if (rnd) {
                                                     controllers[i][j].text = 0.toString();
                                                   } else {
                                                     controllers[i][j].text = 1.toString();
                                                   }
                                                 }
                                               }
                                             }
                                           },
                                           onLongPress: () {
                                             showDialog(
                                               context: context,
                                               builder: (BuildContext context) {
                                                 return AlertDialog(
                                                   backgroundColor: Colors.white,
                                                   contentPadding: const EdgeInsets.all(20),
                                                   title: const Text('Максимальное число для рандомных весов графа 🎲'),
                                                   content: Container(
                                                     height: 140,
                                                     child: Center(
                                                       child: Column(
                                                         mainAxisAlignment: MainAxisAlignment.center,
                                                         children: [
                                                           SizedBox(
                                                             width: 50,
                                                             child: TextField(
                                                               textAlign: TextAlign.center,
                                                               controller: upper,
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
                                                                   )
                                                               ),
                                                             ),
                                                           ),
                                                           const SizedBox(height: 10),
                                                           ElevatedButton(
                                                             onPressed: () {
                                                               for (int i = 0; i < controllers.length; i++) {
                                                                 for (int j = 0; j < controllers[i].length; j++) {
                                                                   int? upperValue = int.tryParse(upper.text);
                                                                   int rnd = Random().nextInt((upperValue?.toInt() ?? 2));
                                                                   controllers[i][j].text = rnd.toString();
                                                                   controllers[j][i].text = rnd.toString();
                                                                   if (i == j) {
                                                                     bool rnd = Random().nextBool();
                                                                     if (rnd) {
                                                                       controllers[i][j].text = 0.toString();
                                                                     } else {
                                                                       controllers[i][j].text = 1.toString();
                                                                     }
                                                                   }
                                                                 }
                                                               }
                                                               Navigator.pop(context);
                                                             },
                                                             style: ButtonStyle(
                                                               backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                                               foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                             ),
                                                             child: const Text('Сгенерировать'),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 );
                                               },
                                             );
                                           },
                                           style: ButtonStyle(
                                             backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                           ),
                                           child: const Text('Автозаполнение'),
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
                                                           itemCount: rulesFillMatrix.length,
                                                           itemBuilder: (BuildContext context, int index) {
                                                             return ListTile(
                                                               leading: SvgPicture.asset(
                                                                   'assets/images/success_icon.svg',
                                                                   width:20,
                                                                   height:20
                                                               ),
                                                               title: Text(rulesFillMatrix[index]),
                                                             );
                                                           },
                                                         ),
                                                       ),
                                                       const SizedBox(height: 10),
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
                                    ],
                                  )
                                ]
                            )
                        )
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}