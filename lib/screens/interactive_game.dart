import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../home_page.dart';
import '../service/snack_bar.dart';

class InteractiveGame extends StatefulWidget {
  const InteractiveGame({Key? key}) : super(key: key);

  @override
  State<InteractiveGame> createState() => _InteractiveGameState();
}

class _InteractiveGameState extends State<InteractiveGame> {

  late User? user = FirebaseAuth.instance.currentUser;
  final _collectionRef = FirebaseFirestore.instance.collection('users-list');
  // final _globalSettings = FirebaseFirestore.instance.collection('settings').doc('global_settings');
  String? firstName;
  String? secondName;
  String? profileImage;
  var userDataProfile;
  var placeholderImage;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  var userDataTitle = 'Учетные данные'.toUpperCase();
  var accountTitle = 'Аккаунт'.toUpperCase();

  Future<void> getUserData() async{
    try {
      QuerySnapshot querySnapshot = await _collectionRef.where('uid', isEqualTo: user?.uid ?? '').get();
      final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      if (userData.isNotEmpty) {
        firstName = userData[0]['first_name'];
        secondName = userData[0]['second_name'];
        profileImage = userData[0]['profile_image'];
        userDataProfile = userData;

        firstNameController.text = firstName ?? '';
        secondNameController.text = secondName ?? '';

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

  Future<void> _pickImageAndUpload() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${user?.uid}_${Timestamp.now().toString()}.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users-list').doc(user?.uid).update({
        'profile_image': imageUrl,
      });
      print('Изображение успешно загружено и ссылка сохранена в базе данных: $imageUrl');
      setState(() {
        profileImage = imageUrl;
      });


    }
  }

  void changeProfileData(){
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Имя'
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: secondNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Фамилия'
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: saveUserData,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                      ),
                      child: const Text('Сохранить'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveUserData() async {
    if(firstNameController.text.trim() == ""){
      Navigator.of(context).pop();
      firstNameController.text = firstName!;
      secondNameController.text = secondName!;
      SnackBarService.showSnackBar(
          context,
          'Имя не может быть пустым,попробуйте еще раз!',
          true
      );
      return;
    }
    if(secondNameController.text.trim() == ""){
      Navigator.of(context).pop();
      firstNameController.text = firstName!;
      secondNameController.text = secondName!;
      SnackBarService.showSnackBar(
          context,
          'Фамилия не может быть пустым,попробуйте еще раз!',
          true
      );
      return;
    }
    await FirebaseFirestore.instance.collection('users-list').doc(user?.uid).update({
      'first_name': firstNameController.text.trim(),
      'second_name': secondNameController.text.trim(),
    });
    setState(() {
      firstName = firstNameController.text;
      secondName = secondNameController.text;
    });
    Navigator.of(context).pop();
    SnackBarService.showSnackBar(
        context,
        'Данные успешно сохранены',
        false
    );
  }

  Future<void> _deleteAccountHandler() async {
    var user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore.instance.collection('users-list').doc(user.uid).delete();
    await user.delete();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0)),
    );
    SnackBarService.showSnackBar(
        context,
        'Вы успешно удалили аккаунт!',
        false
    );
  }

  Future<void> deleteAccount() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/warning_icon.svg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('При удалении аккаунта все данные пропадут навсегда!'),
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: _deleteAccountHandler,
              child: const Text('Удалить'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      if(profileImage != null && profileImage != "")
                        Positioned.fill(
                          child: Image.network(
                            profileImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      // Blur effect
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // CircularAvatar
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: (profileImage != null && profileImage != "")
                              ? NetworkImage(profileImage!)
                              : null,
                          child: (profileImage == null || profileImage == "")
                              ? const Icon(Icons.person)
                              : null,
                        ),
                      ),
                      // Add Photo Button
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF678094),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: _pickImageAndUpload,
                              color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Text(
                userDataTitle,
                style: const TextStyle(
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child:  Column(
                      children: [
                        GestureDetector(
                          onTap: changeProfileData,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color:Colors.white38,
                                            width: 1.0
                                        )
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${firstName ?? ""} ${secondName ?? ""}"),
                                        SvgPicture.asset(
                                          'assets/images/right_icon.svg',
                                          width: 15,
                                          height: 15,
                                          color:Colors.white38,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
              child: Text(
                accountTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: logout,
                        child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:Colors.white38,
                                        width: 1.0
                                    )
                                )
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Выйти',
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/right_icon.svg',
                                    width: 15,
                                    height: 15,
                                    color:Colors.white38,
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: deleteAccount,
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:Colors.white38,
                                      width: 1.0
                                  )
                              )
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Удалить аккаунт',
                                  style: TextStyle(
                                      color: Color(0xFFdb4653)
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/images/right_icon.svg',
                                  width: 15,
                                  height: 15,
                                  color:Colors.white38,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
