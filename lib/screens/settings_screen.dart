import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<int> color = [0xfffcba03,0xff8cfc03,0xff0320fc,0xfffc03df,0xfffc031c,0xffc6fc03,0xffff6a00];
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              const Text('Цвет вершин'),
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: color.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.all(5.5),
                        child: GestureDetector(
                          onTap: (){
                            setIndexColorVertices(index);
                          },
                          child: Container(
                            width: index == indexColorVertices ? 60 : 50,
                            height: index == indexColorVertices ? 60 : 50,
                            decoration: BoxDecoration(
                                color: Color(color[index]),
                                border: index == indexColorVertices ?  Border.all(color: Colors.orange,width: 2.0) : Border.all(color: Colors.black,width: 2.0),
                                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              const Text('Цвет граней'),
              const SizedBox(height: 15),
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: color.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.all(5.5),
                        child: GestureDetector(
                          onTap: (){
                            setIndexColorEdges(index);
                          },
                          child: Container(
                            width: index == indexColorEdges ? 60 : 50,
                            height: index == indexColorEdges ? 60 : 50,
                            decoration: BoxDecoration(
                              color: Color(color[index]),
                              border: index == indexColorEdges ?  Border.all(color: Colors.orange,width: 2.0) : Border.all(color: Colors.black,width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
