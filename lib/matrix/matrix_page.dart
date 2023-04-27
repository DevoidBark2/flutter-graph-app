import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/graph/graph_view.dart';
import 'matrix.dart';
import 'matrix_field.dart';
import "package:collection/collection.dart";

class MatrixPage extends StatefulWidget {
  final Matrix matrix;
  const MatrixPage({
    Key? key,
    required this.matrix,
  }) : super(key: key);

  @override
  State<MatrixPage> createState() => _MatrixPageState();
}

class _MatrixPageState extends State<MatrixPage> {
  final controllers = <List<TextEditingController>>[];
  late final rows = widget.matrix.rows;
  late final columns = widget.matrix.columns;
  late bool colorGraph = false;

  Map<String,dynamic>? currentUserData;
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? userId = currentUser?.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      return userData.data() as Map<String, dynamic>;
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
  @override
  void initState() {
    super.initState();
    createControllers();
    getUser();
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
  bool isCheckedWeight = false;
  bool isCheckedOriented = false;

  Future<void> setDataUserGraph(String data) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;
    // Получаем ссылку на коллекцию "userData" для текущего пользователя
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('userData');

    // Создаем новый документ с данными и добавляем его в коллекцию "userData"
    await userRef.add({
      'data': data,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {

    bool checkMatrix(controllers){
      bool isCheckedValidMatrix = true;
      var mat = List.generate(controllers.length, (row) => List.generate(controllers.length ,(column) => int.tryParse(controllers[row][column].text)));
      List<List<int?>> result = List.generate(mat[0].length, (i) => List.filled(mat.length, 0));
      if(currentUserData != null){
        setDataUserGraph(mat.toString());
      }
      //транспонированная матрица
      for (int i = 0; i < mat.length; i++) {
        for (int j = 0; j < mat[0].length; j++) {
          result[j][i] = mat[i][j];
        }
      }
      for(var i = 0; i < mat.length; i++){
          for(var j = 0; j < mat.length; j++){
            if(mat[i][j] == null){
              isCheckedValidMatrix = false;
              break;
            }
          }
      }
      if(isCheckedValidMatrix){
        if(const DeepCollectionEquality().equals(mat, result)){
          if(isCheckedOriented){
            return false;
          }else{
            return true;
          }
        }else{
          if(isCheckedOriented){
            //здесь нужно еще раз проходится по матрице,случай на фото!!!!
            //идти по матрице под главное диогонали и смотреть чтобы были нули!!!!

            for(int i = 0;i < mat.length;i++){
              for(int j = 0; j < i; j++){
                if (mat[i][j] != 0) {
                  return false;
                }
              }
            }
            return true;
          }else{
            return false;
          }
        }
      }
      else{
        return false;
      }
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
      return Colors.red;
    }

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          height: 500,
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
                        child: SizedBox(
                          height: controllers.length > 7 ? 30 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                          width: controllers.length > 7 ? 30 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
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
              Row(
                children: [
                  const Text('Взвешенный да/нет'),
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
              Row(
                children: [
                  const Text('Орграф да/нет'),
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor:MaterialStateProperty.resolveWith(getColor),
                    value: isCheckedOriented,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedOriented = value!;
                      });
                    },
                  ),
                ],
              ),
              InkWell(
                onTap: () => checkMatrix(controllers) == true
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
                child: Container(
                    height: 50,
                    width: 100,
                    margin: const EdgeInsets.all(5),
                    color: Colors.blue,
                    child: const Center(child: Text('Отобразить', style: TextStyle(color: Colors.white),)),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
