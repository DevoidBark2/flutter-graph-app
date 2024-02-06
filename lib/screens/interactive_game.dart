import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_project/db/database.dart';
import 'package:test_project/models/Task.dart';
import 'package:test_project/models/User.dart';
import 'package:test_project/screens/level_game_screen.dart';
import 'package:test_project/screens/rating_users_screen.dart';
import 'package:test_project/screens/rules_game.dart';

import '../home_page.dart';
import '../service/snack_bar.dart';
import 'change_profile_screen.dart';

class InteractiveGame extends StatefulWidget {
  const InteractiveGame({Key? key}) : super(key: key);

  @override
  State<InteractiveGame> createState() => _InteractiveGameState();
}

class _InteractiveGameState extends State<InteractiveGame> {

  late User? user = FirebaseAuth.instance.currentUser;
  late List<Task> data = [];
  Uint8List? _selectedImage;
  final _collectionRef = FirebaseFirestore.instance.collection('users-list');
  String? firstName;
  String? secondName;
  String? profileImage;
  var userDataProfile;

  Future<void> getUserData() async{
    try {
      QuerySnapshot querySnapshot = await _collectionRef.where('uid', isEqualTo: user?.uid ?? '').get();
      final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        firstName = userData[0]['first_name'];
        secondName = userData[0]['second_name'];
        profileImage = userData[0]['profile_image'];
        userDataProfile = userData;
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0)),
    );
    SnackBarService.showSnackBar(
        context,
        'Вы вышли из профиля!',
        false
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // setState(() {
      //    _selectedImage = pickedImage.readAsBytes() as Uint8List?;
      // });

      // Сохранение выбранного изображения в базе данных
      // Здесь вы можете добавить свой код для сохранения изображения в базе данных пользователей
      // Например, вы можете использовать какой-то пакет для работы с базой данных, наподобие sqflite или Firebase

      print('Изображение сохранено в базе данных');
    }
  }

  void changeProfileData(){
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ChangeProfileData(userData:userDataProfile)
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RefreshIndicator(
        onRefresh: getUserData,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child:  Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImage != null
                              ? NetworkImage(profileImage!) as ImageProvider<Object>?
                              : const AssetImage('placeholder_image.jpg') as ImageProvider<Object>?,
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
                                  icon: const Icon(Icons.add_a_photo),
                                  onPressed: _pickImage
                              ),
                            )
                        ),
                      ],
                    )
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[Colors.orange, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child:  Column(
                      children: [
                        // Text("${firstName!} ${secondName!}"),
                        ElevatedButton(
                            onPressed: changeProfileData,
                            child: Text('Изменить данные')
                        ),
                      ],
                    )
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: logout,
              child: Text('Выйти'),
            )
          ],
        ),
      ),
    );
  }
}
