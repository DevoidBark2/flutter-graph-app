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


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Демонстрация'),
                              ),
                              body: InputGraph(),
                            ),
                          ),
                        );
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF678094)),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white)
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text("Демострационный вариант"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
