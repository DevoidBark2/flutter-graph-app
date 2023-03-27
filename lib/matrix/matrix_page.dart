import 'package:flutter/foundation.dart';
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

  @override
  void initState() {
    super.initState();
    createControllers();
  }

  void createControllers() {
    for (var i = 0; i < rows; i++) {
      controllers.add(List.generate(columns, (index) => TextEditingController(text: '')));
    }
  }

  // @override
  // void dispose() {
  //   for (var controllerRow in controllers) {
  //     for (final c in controllerRow) {
  //       c.dispose();
  //     }
  //   }
  //   super.dispose();
  // }
  bool isCheckedWeight = false;
  bool isCheckedOriented = false;
  @override
  Widget build(BuildContext context) {

    bool checkMatrix(controllers){
      bool isCheckedValidMatrix = true;
      var mat = List.generate(controllers.length, (row) => List.generate(controllers.length ,(column) => int.tryParse(controllers[row][column].text)));
      List<List<int?>> result = List.generate(mat[0].length, (i) => List.filled(mat.length, 0));

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
                          height: controllers.length > 9 ? 30 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
                          width: controllers.length > 9 ? 30 : controllers.length > 6 ? 40 : controllers.length > 5 ? 45 : 50,
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
                    color: Colors.orange,
                    child: const Center(child: Text('View Graph')),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// onTap: checkMatrix(controllers) == true ? () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
// return Scaffold(
// appBar: AppBar(),
// body: GraphView(controllers:controllers),
// );
// })
// ) : () => Navigator.of(context).pop(MaterialPageRoute(builder: (context) {
// return Scaffold(
// appBar: AppBar(),
// body: const HomePage(),
// );
// })),
