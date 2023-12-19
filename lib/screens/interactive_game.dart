import 'package:flutter/material.dart';
import 'package:test_project/db/database.dart';
import 'package:test_project/models/Task.dart';
import 'package:test_project/screens/level_game_screen.dart';
import 'package:test_project/screens/rating_users_screen.dart';
import 'package:test_project/screens/rules_game.dart';

class InteractiveGame extends StatefulWidget {
  const InteractiveGame({Key? key}) : super(key: key);

  @override
  State<InteractiveGame> createState() => _InteractiveGameState();
}

class _InteractiveGameState extends State<InteractiveGame> {

  final db = DatabaseManager();
  late List<Task> data = [];

  Future<void> getTasks() async{
    try {
      await db.connect();

      final result = await db.query('SELECT * FROM graph_app_tasks');
      print(result);
      final columnNames = result.columnDescriptions.map((c) => c.columnName).toList();

      List<Task> tasksList = createTaskList(result, columnNames);
      data = tasksList;

      setState(() {
        data = tasksList;
      });
    } catch (e) {
      print('Exception occurred: $e');
    } finally {
      await db.closeConnection();
    }
  }
  @override
  void initState() {
    getTasks();
    super.initState();
    print(data.length);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: getTasks,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0,right: 10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: const Row(
                      children: [
                        Icon(Icons.list),
                        Text(
                          'Рейтинг игроков',
                        ),
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                              appBar: AppBar(
                                title: const Text('Рейтинг игроков'),
                              ),
                              body: const RatingUsersScreen()
                          );
                        },
                      ));
                    },
                  ),
                  GestureDetector(
                    child: const Row(
                      children: [
                        Icon(Icons.list),
                        Text(
                          'Правила игры',
                        ),
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                              appBar: AppBar(
                                title: const Text('Правила игры'),
                              ),
                              body: const RulesGameScreen()
                          );
                        },
                      ));
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.shade200,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                  color: Colors.blueAccent.shade200,
                ),
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Уровень:' ' Новичок',
                          style: TextStyle(color: Colors.white),
                        ),
                        Row(
                          children: [
                            Image.asset(
                                'assets/images/coins.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                                '2000',
                              style: TextStyle(color:Colors.white),
                            )
                          ],
                        )
                      ],
                    )
                  ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = data[index];

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return Scaffold(
                                appBar: AppBar(
                                  title: Text('Уровень${index + 1}'),
                                ),
                                body: LevelGameScreen(task:item)
                            );
                          },
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          height: 50.0,
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('Уровень ${index + 1}'),
                                  Text('Сложность ${item.level} из 10'),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/coins.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    item.total.toString(),
                                    style: TextStyle(color:Colors.black),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
