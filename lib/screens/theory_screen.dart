import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/algorithms/kruskal_algorithm.dart';
import 'package:test_project/screens/instruction_screen.dart';
import 'package:test_project/screens/rules_game.dart';
import 'package:test_project/screens/settings_screen.dart';
import 'package:test_project/screens/theory_screen_2.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({Key? key}) : super(key: key);

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {

  int itemCount = 10; // Number of players in the list


  @override
  Widget build(BuildContext context) {

    double containerHeight = itemCount.toDouble() * 25.0;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              height: 150.0,
              decoration: BoxDecoration(
                color:Colors.deepOrange[500],
                borderRadius: BorderRadius.circular(10.0)
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                appBar: AppBar(
                                      title: const Text('Теория'),
                                ),
                                body: const TheoryScreen2(),
                              ),
                          ),
                        );
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color:Colors.deepOrange[500],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/list-theory.svg',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Text(
                              'Теория',
                              style: TextStyle(
                                  fontSize: 25.0
                              ),
                            )
                          ],
                        ),
                      ),
                      // Add your child widgets or content here
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Правила'),
                          ),
                          body: const InstructionScreen(),
                        ),
                      ),
                      );
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color:Colors.deepOrange[500],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/images/rules_app.svg',
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            const Text(
                              'Правила',
                              style: TextStyle(
                                  fontSize: 25.0
                              ),
                            )
                          ],
                        ),
                      ),
                      // Add your child widgets or content here
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.deepOrange[500],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const Text(
                        'ТОП-10',
                      style: TextStyle(
                          fontSize: 25.0
                      ),
                    ),
                    Expanded( // Wrap ListView.builder with Expanded
                      child: ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 3.0),
                                borderRadius: BorderRadius.circular(50.0)
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image.asset('assets/images/logo_avatar.jpg',width: 50.0,height: 50.0,)
                              ),
                            ),
                            title: Text('Player ${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
