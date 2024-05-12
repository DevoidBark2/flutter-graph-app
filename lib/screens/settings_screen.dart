import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

enum TypeEdges { Digit, Letter }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedColorVertices = Colors.red.value;
  int selectedColorEdges = Colors.green.value;
  TypeEdges? _typeEdges;

  @override
  void initState() {
    super.initState();
    getColorVertices();
    getColorEdges();
    getTypeEdges();
  }

  void getColorVertices() async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      selectedColorVertices = storage.getInt("indexColorVertices") ?? Colors.red.value;
    });
  }

  void getColorEdges() async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      selectedColorEdges = storage.getInt("indexColorEdges") ?? Colors.green.value;
    });
  }

  void getTypeEdges() async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      _typeEdges = TypeEdges.values.firstWhere((e) => e.toString() == (storage.getString("typeEdges") ?? TypeEdges.Digit.toString()));
    });
  }

  void setColorVertices(Color color) async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setInt("indexColorVertices", color.value);
      selectedColorVertices = color.value;
    });
  }

  void setColorEdges(Color color) async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setInt("indexColorEdges", color.value);
      selectedColorEdges = color.value;
    });
  }

  void changeColorEdges(Color color) {
    setState(() => selectedColorEdges = color.value);
    setColorEdges(color);
  }

  void changeColorVertices(Color color) {
    setState(() => selectedColorVertices = color.value);
    setColorVertices(color);
  }

  void setTypeEdges() async {
    var storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setString("typeEdges", _typeEdges.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Цвет ребер',style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color:Color(selectedColorEdges),
                      border: Border.all(
                        color: Colors.black,
                        width: 1
                      )
                    )
                ),
                const Expanded(child: SizedBox(width: 100,)),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Выберите цвет'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: Color(selectedColorEdges),
                              onColorChanged: changeColorEdges,
                              pickerAreaHeightPercent: 0.5,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                              ),
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                  ),
                  child: const Text('Выбрать цвет'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Цвет вершин',style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color:Color(selectedColorVertices),
                        border: Border.all(
                            color: Colors.black,
                            width: 1
                        )
                    )
                ),
                const Expanded(child: SizedBox(width: 100,)),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Выберите цвет'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: Color(selectedColorVertices),
                              onColorChanged: changeColorVertices,
                              pickerAreaHeightPercent: 0.5,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                              ),
                              child: const Text('OK'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                  ),
                  child: const Text('Выбрать цвет'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Название вершины',style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Цифра',style: TextStyle(fontSize: 14)),
                    leading: Radio<TypeEdges>(
                      value: TypeEdges.Digit,
                      groupValue: _typeEdges,
                      onChanged: (TypeEdges? value) {
                        setState(() {
                          _typeEdges = value;
                          setTypeEdges();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Буква',style: TextStyle(fontSize: 14)),
                    leading: Radio<TypeEdges>(
                      value: TypeEdges.Letter,
                      groupValue: _typeEdges,
                      onChanged: (TypeEdges? value) {
                        setState(() {
                          _typeEdges = value;
                          setTypeEdges();
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ]
        ),
      )
    );
  }
}