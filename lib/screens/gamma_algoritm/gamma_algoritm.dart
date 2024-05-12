import 'package:flutter/material.dart';
import 'package:test_project/home_page.dart';
import 'package:test_project/screens/gamma_algoritm/widgets/input_length.dart';
import 'package:test_project/screens/settings_screen.dart';

class GammaAlgoritm extends StatefulWidget {
  const GammaAlgoritm({Key? key}) : super(key: key);

  @override
  State<GammaAlgoritm> createState() => _GammaAlgoritmState();
}

class _GammaAlgoritmState extends State<GammaAlgoritm> {

  TextEditingController graphLengthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const InputLength();
  }
}
