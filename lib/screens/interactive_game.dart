import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late User? user = FirebaseAuth.instance.currentUser;
  final db = DatabaseManager();
  late List<Task> data = [];
  FileImage? _selectedImage;
  final _collectionRef = FirebaseFirestore.instance.collection('users-list');
  String? firstName;
  String? secondName;

  Future<void> getUserData() async{
    try {
      QuerySnapshot querySnapshot = await _collectionRef.where('uid', isEqualTo: user?.uid ?? '').get();
      final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        firstName = userData[0]['first_name'];
        secondName = userData[0]['second_name'];
        setState(() {});
      }

      print(userData);
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
  Future<void> logout() async{
    await FirebaseAuth.instance.signOut();
    setState(() {
      user = null;
    });
  }

  Future<void> _pickImage() async {
    // final picker = ImagePicker();
    // final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedImage != null) {
    //   setState(() {
    //     // _selectedImage = FileImage(File(pickedImage.path));
    //   });
    //
    //   // Сохранение выбранного изображения в базе данных
    //   // Здесь вы можете добавить свой код для сохранения изображения в базе данных пользователей
    //   // Например, вы можете использовать какой-то пакет для работы с базой данных, наподобие sqflite или Firebase
    //
    //   print('Изображение сохранено в базе данных');
    // }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    print(firstName);
    print(secondName);

    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: getUserData,
        child: Column(
          children: [
            // Stack(
            //   children: [
            //     Align(  // Расположение по правому нижнему углу
            //         alignment: Alignment.topLeft,
            //         child: Text(
            //           'Профиль',
            //           style: TextStyle(
            //             fontSize: 26
            //           )
            //         )
            //     ),
            //     Align(  // Расположение по правому нижнему углу
            //       alignment: Alignment.bottomRight,
            //       child: ElevatedButton(
            //         onPressed: logout,
            //         child: Row(mainAxisSize:MainAxisSize.min,
            //             children: [
            //               Text('Выйти'),
            //               Icon(Icons.arrow_forward_sharp),
            //             ]
            //         ),
            //       )
            //     ),
            //   ],
            // ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.blue
              ),
              child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage('assets/images/logo_avatar.jpg'),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: _pickImage
                            ),
                          )
                      ),
                    ],
                  )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child:  Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введите Имя',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Введите фамилию',
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    child: Text('Изменить пароль')
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    child: Text('Выйти'),
                  )
                ],
              )
            ),
            Row(
              children: [
                const SizedBox(width: 50.0,),
                // Column(
                //   children: [
                //     Text('${firstName ?? ''}'),
                //     Text('${secondName ?? ''}')
                //   ],
                // )
              ],
            ),
            const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     GestureDetector(
            //       child: const Row(
            //         children: [
            //           Icon(Icons.list),
            //           Text(
            //             'Рейтинг игроков',
            //           ),
            //         ],
            //       ),
            //       onTap: (){
            //         Navigator.push(context, MaterialPageRoute<void>(
            //           builder: (BuildContext context) {
            //             return Scaffold(
            //                 appBar: AppBar(
            //                   title: const Text('Рейтинг игроков'),
            //                 ),
            //                 body: const RatingUsersScreen()
            //             );
            //           },
            //         ));
            //       },
            //     ),
            //     GestureDetector(
            //       child: const Row(
            //         children: [
            //           Icon(Icons.list),
            //           Text(
            //             'Правила игры',
            //           ),
            //         ],
            //       ),
            //       onTap: (){
            //         Navigator.push(context, MaterialPageRoute<void>(
            //           builder: (BuildContext context) {
            //             return Scaffold(
            //                 appBar: AppBar(
            //                   title: const Text('Правила игры'),
            //                 ),
            //                 body: const RulesGameScreen()
            //             );
            //           },
            //         ));
            //       },
            //     ),
            //   ],
            // ),
            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16.0),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.blueAccent.shade200,
            //         offset: const Offset(
            //           5.0,
            //           5.0,
            //         ),
            //         blurRadius: 5.0,
            //         spreadRadius: 2.0,
            //       ),
            //       const BoxShadow(
            //         color: Colors.white,
            //         offset: Offset(0.0, 0.0),
            //         blurRadius: 0.0,
            //         spreadRadius: 0.0,
            //       ),
            //     ],
            //     color: Colors.blueAccent.shade200,
            //   ),
            //   child: Padding(
            //       padding: EdgeInsets.all(10.0),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Уровень:' ' Новичок',
            //             style: TextStyle(color: Colors.white),
            //           ),
            //           Row(
            //             children: [
            //               Image.asset(
            //                   'assets/images/coins.png',
            //                 width: 30,
            //                 height: 30,
            //               ),
            //               const SizedBox(width: 10.0),
            //               Text(
            //                   '2000',
            //                 style: TextStyle(color:Colors.white),
            //               )
            //             ],
            //           )
            //         ],
            //       )
            //     ),
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height / 2,
            //   child: ListView.builder(
            //     itemCount: data.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       final item = data[index];
            //
            //       return GestureDetector(
            //         onTap: (){
            //           showDialog(
            //               context: context,
            //               builder: (BuildContext context){
            //                 return AlertDialog(
            //                     title: Text('Модальное окно'),
            //                     content: Text('Здесь может быть ваше модальное содержимое.'),
            //                     actions: [
            //                       TextButton(
            //                         onPressed: () {
            //                           Navigator.of(context).pop();
            //                         },
            //                         child: Text('Закрыть'),
            //                       ),
            //                       TextButton(
            //                         onPressed: () {
            //                           Navigator.push(context, MaterialPageRoute<void>(
            //                             builder: (BuildContext context) {
            //                               return Scaffold(
            //                                   appBar: AppBar(
            //                                     title: Text('Уровень${index + 1}'),
            //                                   ),
            //                                   body: LevelGameScreen(task:item)
            //                               );
            //                             },
            //                           ));
            //                         },
            //                         child: Text('asdad'),
            //                       )
            //                     ]
            //                 );
            //               }
            //           );
            //         },
            //
            //         child: Padding(
            //           padding: EdgeInsets.all(10.0),
            //           child: Container(
            //             height: 50.0,
            //             margin: EdgeInsets.only(top: 10.0),
            //             decoration: BoxDecoration(
            //                 color: Colors.grey,
            //                 borderRadius: BorderRadius.circular(8.0)
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Column(
            //                   children: [
            //                     Text('Уровень ${index + 1}'),
            //                     Text('Сложность ${item.level} из 10'),
            //                   ],
            //                 ),
            //                 Row(
            //                   children: [
            //                     Image.asset(
            //                       'assets/images/coins.png',
            //                       width: 30,
            //                       height: 30,
            //                     ),
            //                     const SizedBox(width: 10.0),
            //                     Text(
            //                       item.total.toString(),
            //                       style: TextStyle(color:Colors.black),
            //                     )
            //                   ],
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
