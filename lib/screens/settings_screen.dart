import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<int> color = [0xfffcba03,0xff8cfc03,0xff0320fc,0xfffc03df,0xfffc031c,0xffc6fc03];
  int indexColorVertices = 0;
  int indexColorEdges = 0;
  @override
  void initState() {
    super.initState();
    getIndexColorVertices();
    getIndexColorEdges();
  }
  void setIndexColorVertices(index) async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setInt("indexColorVertices", index);
      storage.setInt("colorVertices", color[index]);
      indexColorVertices = index;
    });

  }
  void getIndexColorVertices() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      indexColorVertices = storage.getInt("indexColorVertices") ?? 0;
    });
  }

  void setIndexColorEdges(index) async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      storage.setInt("indexColorEdges", index);
      storage.setInt("colorEdges", color[index]);
      indexColorEdges = index;
    });
  }

  void getIndexColorEdges() async{
    var storage = await SharedPreferences.getInstance();
    setState(() {
      indexColorEdges = storage.getInt("indexColorEdges") ?? 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Text('Цвет вершин'),
              const SizedBox(height: 15),
              Container(
                height: 50,
                color: Colors.green,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: color.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.all(11.5),
                        child: GestureDetector(
                          onTap: (){
                            setIndexColorVertices(index);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Color(color[index]),
                                border: index == indexColorVertices ?  Border.all(color: Colors.orange) : Border.all(color: Colors.black),
                                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              const Text('Цвет граней'),
              const SizedBox(height: 15),
              Container(
                height: 50,
                color: Colors.green,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: color.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.all(11.5),
                        child: GestureDetector(
                          onTap: (){
                            setIndexColorEdges(index);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(color[index]),
                              border: index == indexColorEdges ?  Border.all(color: Colors.orange) : Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     const Text('Цвет граней'),
          //     SizedBox(
          //       height: 50,
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         scrollDirection: Axis.horizontal,
          //         itemCount: colors.length,
          //         itemBuilder: (BuildContext context, int index) =>
          //             Padding(
          //               padding: const EdgeInsets.only(right: 5.0),
          //               child: Container(
          //                 width: 50,
          //                 height: 50,
          //                 decoration: BoxDecoration(
          //                     color: colors[index],
          //                     border: Border.all(color: Colors.black),
          //                     borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          //                 ),
          //               ),
          //             ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
