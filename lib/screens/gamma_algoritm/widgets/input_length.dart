import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/home_page.dart';
import 'package:test_project/screens/gamma_algoritm/widgets/input_graph.dart';
import 'package:test_project/screens/settings_screen.dart';

class InputLength extends StatefulWidget {
  const InputLength({Key? key}) : super(key: key);

  @override
  State<InputLength> createState() => _GammaAlgoritmState();
}

class _GammaAlgoritmState extends State<InputLength> {

  TextEditingController graphLengthController = TextEditingController();
  String errorMsg = '';

  bool checkLengthMatrix(TextEditingController text) {
    String input = text.text.trim();
    if (input.isEmpty) {
      errorMsg = "Длина матрицы должна быть задана";
      return false;
    }
    int digit = int.parse(input);
    if (digit <= 0) {
      errorMsg = "Длина матрицы должна быть больше 0";
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text(
            "Введите размер матрицы",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: graphLengthController,
            decoration: const InputDecoration(
              hintText: 'Размер матрицы',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: (){
              bool res = checkLengthMatrix(graphLengthController);
              if(res){
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Гамма-алгоритм'),
                      ),
                      body: InputGraph(length: int.parse(graphLengthController.text)),
                    ),
                  ),
                );
                return;
              }
              showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: const Color(0xffffffff),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/error.svg',
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(height: 15.0),
                        Text(errorMsg),
                        const SizedBox(height: 35.0),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                            ),

                            child: const Text('Закрыть')
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
            child: const Text("Далее"),
          )
        ],
      ),
    );
  }
}
