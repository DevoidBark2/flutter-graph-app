// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      // User? currentUser = FirebaseAuth.instance.currentUser;
      // String? userId = currentUser?.uid;
      // DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      // return userData.data() as Map<String, dynamic>;
    } catch (e) {
      print('Ошибка при получении данных текущего пользователя: $e');
      return null;
    }
  }
  Future<void> getUser() async {
    Map<String, dynamic>? userData = await getCurrentUserData();
    setState(() {
      currentUserData = userData;
    });
  }
  Future<void> setDataUserGraph(String matrix,bool orinted,bool weight) async {
    // User? currentUser = FirebaseAuth.instance.currentUser;
    // String? userId = currentUser?.uid;
    // final userRef = FirebaseFirestore.instance.collection('users').doc(userId).collection('userData');
    // await userRef.add({'matrix': matrix, 'orinted' : orinted, 'weight': weight, 'timestamp': FieldValue.serverTimestamp()});
  }
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
      return Colors.blue;
    }
    return Colors.blue;
  }

  bool checkMatrix(controllers){
    bool isCheckedValidMatrix = true;
    var mat = List.generate(controllers.length, (row) => List.generate(controllers.length ,(column) => int.tryParse(controllers[row][column].text)));
    List<List<int?>> result = List.generate(mat[0].length, (i) => List.filled(mat.length, 0));

    for(var i = 0; i < mat.length; i++){
      for(var j = 0; j < mat.length; j++){
        if(mat[i][j] == null){
          isCheckedValidMatrix = false;
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
      //сохранение графа в бд
      if(currentUserData != null){
       setDataUserGraph(mat.toString(),isCheckedOriented,isCheckedWeight);
      }
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
    createControllers();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ввод матрицы'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
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
                            );
                          },
                        ),
                        child: const Text('Отобразить')
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}