import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // List<int> color = [0xfffcba03,0xff8cfc03,0xff0320fc,0xfffc03df,0xfffc031c,0xffc6fc03,0xffff6a00];
  // int indexColorVertices = 0;
  // int indexColorEdges = 0;
  // Color selectedColor = Colors.red;
  int selectedColorVertices = Colors.red.value;
  int selectedColorEdges = Colors.green.value;
  @override
  void initState() {
    super.initState();
    getColorVertices();
    getColorEdges();
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
      selectedColorEdges = storage.getInt("indexColorEdges") ?? Colors.red.value;
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

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                height: 100,
                width: 100,
                color:Color(selectedColorEdges)
            ),
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
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Выбрать цвет'),
            ),
            Container(
              height: 100,
              width: 100,
              color:Color(selectedColorVertices)
            ),
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
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Выбрать цвет'),
            ),
          ],
        ),
      )
    );
  }
}


// Column(
//   children: [
//     const Text('Цвет вершин',style: TextStyle(fontWeight: FontWeight.w600)),
//     const SizedBox(height: 15),
//     Container(
//       height: 50,
//       decoration: const BoxDecoration(
//         color: Colors.green,
//       ),
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: color.length,
//         itemBuilder: (BuildContext context, int index) =>
//             Padding(
//               padding: const EdgeInsets.all(7.5),
//               child: GestureDetector(
//                 onTap: (){
//                   setColorVertices(index);
//                 },
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Color(color[index]),
//                     border: index == indexColorVertices ?  Border.all(color: Colors.orange,width: 2.0) : Border.all(color: Colors.black,width: 2.0),
//                     borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                   ),
//                 ),
//               ),
//             ),
//       ),
//     ),
//   ],
// ),
// const SizedBox(height: 15),
// Column(
//   children: [
//     const Text('Цвет граней',style: TextStyle(fontWeight: FontWeight.w600)),
//     const SizedBox(height: 15),
//     Container(
//       height: 50,
//       decoration: const BoxDecoration(
//         color: Colors.green,
//       ),
//       child: ListView.builder(
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: color.length,
//         itemBuilder: (BuildContext context, int index) =>
//             Padding(
//               padding: const EdgeInsets.all(7.5),
//               child: GestureDetector(
//                 onTap: (){
//                   setColorEdges(index);
//                 },
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: Color(color[index]),
//                     border: index == indexColorEdges ?  Border.all(color: Colors.orange,width: 2.0) : Border.all(color: Colors.black,width: 2.0),
//                     borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                   ),
//                 ),
//               ),
//             ),
//       ),
//     ),
//   ],
// ),
// const SizedBox(height: 15),