// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "dart:convert";

import '../graph/graph_view.dart';
import '../service/snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController passwordTextRepeatInputController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  final formOneKey = GlobalKey<FormState>();
  final formTwoKey = GlobalKey<FormState>();


  Map<String,dynamic>? currentUserData;
  List<Map<String, dynamic>> graphsUser = [];

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  // Future<void> login() async {
  //   currentUserData = null;
  //   final isValid = formOneKey.currentState!.validate();
  //   if (!isValid) return;
  //
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailTextInputController.text.trim(),
  //       password: passwordTextInputController.text.trim(),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //       SnackBarService.showSnackBar(
  //         context,
  //         'Неправильный email или пароль. Повторите попытку',
  //         true,
  //       );
  //       return;
  //     } else {
  //       SnackBarService.showSnackBar(
  //         context,
  //         'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
  //         true,
  //       );
  //       return;
  //     }
  //   }
  //   setState(() {
  //   });
  // }
  //
  // Future<void> signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   setState(() {});
  // }
  //
  // Future<void> signUp() async {
  //   final navigator = Navigator.of(context);
  //
  //   final isValid = formTwoKey.currentState!.validate();
  //   if (!isValid) return;
  //
  //   if (passwordTextInputController.text !=
  //       passwordTextRepeatInputController.text) {
  //     SnackBarService.showSnackBar(
  //       context,
  //       'Пароли должны совпадать',
  //       true,
  //     );
  //     return;
  //   }
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailTextInputController.text.trim(),
  //       password: passwordTextInputController.text.trim(),
  //     );
  //     String? userId = userCredential.user?.uid;
  //     //add user details
  //       addUserDetails(
  //       firstNameController.text.trim(),
  //       lastNameController.text.trim(),
  //       emailTextInputController.text.trim(),
  //         userId!
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       SnackBarService.showSnackBar(
  //         context,
  //         'Такой Email уже используется, повторите попытку с использованием другого Email',
  //         true,
  //       );
  //       return;
  //     } else {
  //       SnackBarService.showSnackBar(
  //         context,
  //         'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
  //         true,
  //       );
  //     }
  //   }
  //   navigator.pop();
  //   setState(() {
  //     currentUserData = null;
  //   });
  // }
  //
  // Future<void> addUserDetails(String firstName,String lastName,String email,String userId) async {
  //   await FirebaseFirestore.instance.collection('users').doc(userId).set({
  //     'first_name': firstName,
  //     'last_name': lastName,
  //     'email' : email,
  //     'uid': userId
  //   });
  // }
  // Future<List<Map<String, dynamic>>> getUserDataGraph() async {
  //   // Получаем ссылку на коллекцию "userData" для текущего пользователя
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   String? userId = currentUser?.uid;
  //   final userRef = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('userData');
  //
  //   // Получаем все документы в коллекции "userData"
  //   final snapshot = await userRef.get();
  //
  //   // Создаем список для хранения данных
  //   final dataList = <Map<String, dynamic>>[];
  //
  //   // Перебираем все документы и добавляем данные и время добавления в список
  //   for (final doc in snapshot.docs) {
  //     final data = doc.data()['data'] as String;
  //     final timestamp = doc.data()['timestamp'] as Timestamp;
  //     final dateTime = timestamp.toDate();
  //     dataList.add({'data': data, 'timestamp': dateTime});
  //   }
  //
  //   return dataList;
  // }
  // // Future<List<String>> getUserDataGraph() async {
  // //   User? currentUser = FirebaseAuth.instance.currentUser;
  // //   String? userId = currentUser?.uid;
  // //   // Получаем ссылку на коллекцию "userData" для текущего пользователя
  // //   final userRef = FirebaseFirestore.instance
  // //       .collection('users')
  // //       .doc(userId)
  // //       .collection('userData');
  // //
  // //   // Получаем все документы в коллекции "userData"
  // //   final snapshot = await userRef.get();
  // //
  // //   // Создаем список для хранения данных
  // //   final dataList = <String>[];
  // //
  // //   // Перебираем все документы и добавляем данные в список
  // //   for (final doc in snapshot.docs) {
  // //     final data = doc.data()['data'] as String;
  // //     dataList.add(data);
  // //   }
  // //   return dataList;
  // // }
  //
  // Future<Map<String, dynamic>?> getCurrentUserData() async {
  //   try {
  //     User? currentUser = FirebaseAuth.instance.currentUser;
  //     String? userId = currentUser?.uid;
  //     DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  //     return userData.data() as Map<String, dynamic>;
  //   } catch (e) {
  //     print('Ошибка при получении данных текущего пользователя: $e');
  //     return null;
  //   }
  // }
  //
  // Future<void> getUser() async {
  //   Map<String, dynamic>? userData = await getCurrentUserData();
  //   setState(() {
  //     currentUserData = userData;
  //   });
  // }
  //
  // Future<void> loadUserData() async {
  //   final userData = await getUserDataGraph();
  //   setState(() {
  //     graphsUser = userData;
  //   });
  // }


  // void updateUserData(String newFirstName,String newSecondName,String newEmail) async {
  //   final navigator = Navigator.of(context);
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   String? userId = currentUser?.uid;
  //   final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  //
  //   await userRef.update({
  //     'first_name': newFirstName,
  //     'last_name': newSecondName,
  //     'email':newEmail
  //   });
  //   navigator.pop();
  //   currentUserData = null;
  //   setState(() {});
  // }

  @override
  initState() {
    super.initState();
    // getUser();
    // loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    final firstNameController1 = TextEditingController(text: currentUserData?['first_name']);
    final lastNameController2 = TextEditingController(text: currentUserData?['last_name']);
    final emailController = TextEditingController(text: currentUserData?['email']);
    return const Scaffold();
    // if(user == null){
    //   return Scaffold(
    //     resizeToAvoidBottomInset: false,
    //     body: SingleChildScrollView(
    //       child: Padding(
    //         padding: const EdgeInsets.all(30.0),
    //         child: Form(
    //           key: formOneKey,
    //           child: Column(
    //             children: [
    //               TextFormField(
    //                 keyboardType: TextInputType.emailAddress,
    //                 autocorrect: false,
    //                 controller: emailTextInputController,
    //                 validator: (email) =>
    //                 email != null && !EmailValidator.validate(email)
    //                     ? 'Введите правильный Email'
    //                     : null,
    //                 decoration: const InputDecoration(
    //                   border: OutlineInputBorder(),
    //                   hintText: 'Введите Email',
    //                 ),
    //               ),
    //               const SizedBox(height: 30),
    //               TextFormField(
    //                 autocorrect: false,
    //                 controller: passwordTextInputController,
    //                 obscureText: isHiddenPassword,
    //                 validator: (value) => value != null && value.length < 6
    //                     ? 'Минимум 6 символов'
    //                     : null,
    //                 autovalidateMode: AutovalidateMode.onUserInteraction,
    //                 decoration: InputDecoration(
    //                   border: const OutlineInputBorder(),
    //                   hintText: 'Введите пароль',
    //                   suffix: InkWell(
    //                     onTap: togglePasswordView,
    //                     child: Icon(
    //                       isHiddenPassword
    //                           ? Icons.visibility_off
    //                           : Icons.visibility,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(height: 30),
    //               ElevatedButton(
    //                 onPressed: login,
    //                 child: const Center(child: Text('Войти')),
    //               ),
    //               const SizedBox(height: 30),
    //               TextButton(
    //                 onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) {
    //                   return  Scaffold(
    //                     resizeToAvoidBottomInset: false,
    //                     appBar: AppBar(
    //                       title: const Text('Регистрация'),
    //                     ),
    //                     body: Padding(
    //                       padding: const EdgeInsets.all(30.0),
    //                       child: Form(
    //                         key: formTwoKey,
    //                         child: Column(
    //                           children: [
    //                             TextFormField(
    //                               keyboardType: TextInputType.emailAddress,
    //                               autocorrect: false,
    //                               controller: firstNameController,
    //                               decoration: const InputDecoration(
    //                                 border: OutlineInputBorder(),
    //                                 hintText: 'Введите имя',
    //                               ),
    //                             ),
    //                             const SizedBox(height: 5),
    //                             TextFormField(
    //                               keyboardType: TextInputType.emailAddress,
    //                               autocorrect: false,
    //                               controller: lastNameController,
    //                               decoration: const InputDecoration(
    //                                 border: OutlineInputBorder(),
    //                                 hintText: 'Введите фамилию',
    //                               ),
    //                             ),
    //                             const SizedBox(height: 5),
    //                             TextFormField(
    //                               keyboardType: TextInputType.emailAddress,
    //                               autocorrect: false,
    //                               controller: emailTextInputController,
    //                               validator: (email) =>
    //                               email != null && !EmailValidator.validate(email)
    //                                   ? 'Введите правильный Email'
    //                                   : null,
    //                               decoration: const InputDecoration(
    //                                 border: OutlineInputBorder(),
    //                                 hintText: 'Введите Email',
    //                               ),
    //                             ),
    //                             const SizedBox(height: 10),
    //                             TextFormField(
    //                               autocorrect: false,
    //                               controller: passwordTextInputController,
    //                               obscureText: isHiddenPassword,
    //                               autovalidateMode: AutovalidateMode.onUserInteraction,
    //                               validator: (value) =>
    //                               value != null && value.length < 6
    //                                   ? 'Минимум 6 символов'
    //                                   : null,
    //                               decoration: InputDecoration(
    //                                 border: const OutlineInputBorder(),
    //                                 hintText: 'Введите пароль',
    //                                 suffix: InkWell(
    //                                   onTap: togglePasswordView,
    //                                   child: Icon(
    //                                     isHiddenPassword
    //                                         ? Icons.visibility_off
    //                                         : Icons.visibility,
    //                                     color: Colors.black,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             const SizedBox(height: 10),
    //                             TextFormField(
    //                               autocorrect: false,
    //                               controller: passwordTextRepeatInputController,
    //                               obscureText: isHiddenPassword,
    //                               autovalidateMode: AutovalidateMode.onUserInteraction,
    //                               validator: (value) =>
    //                               value != null && value.length < 6
    //                                   ? 'Минимум 6 символов'
    //                                   : null,
    //                               decoration: InputDecoration(
    //                                 border: const OutlineInputBorder(),
    //                                 hintText: 'Введите пароль еще раз',
    //                                 suffix: InkWell(
    //                                   onTap: togglePasswordView,
    //                                   child: Icon(
    //                                     isHiddenPassword
    //                                         ? Icons.visibility_off
    //                                         : Icons.visibility,
    //                                     color: Colors.black,
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                             const SizedBox(height: 10),
    //                             ElevatedButton(
    //                               onPressed: signUp,
    //                               child: const Center(child: Text('Регистрация')),
    //                             ),
    //                             const SizedBox(height: 10),
    //                             TextButton(
    //                               onPressed: () => Navigator.of(context).pop(),
    //                               child: const Text(
    //                                 'Войти',
    //                                 style: TextStyle(
    //                                   decoration: TextDecoration.underline,
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   );
    //                 })),
    //                 child: const Text(
    //                   'Регистрация',
    //                   style: TextStyle(
    //                     decoration: TextDecoration.underline,
    //                   ),
    //                 ),
    //               ),
    //               TextButton(
    //                 onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) {
    //                   return  Scaffold(
    //                     appBar: AppBar(
    //                       title: const Text('Сброс пароля'),
    //                     ),
    //                     body: const Text('тут будет Восстановление пароля'),
    //                   );
    //                 })),
    //                 child: const Text('Сбросить пароль'),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }
    // else{
    //   if(currentUserData == null){
    //     return const Center(child: Text('Loading...'));
    //   }
    //   else{
    //     return  Scaffold(
    //       body: SingleChildScrollView(
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 5,left: 15.0,right: 15.0,bottom: 15.0),
    //           child: Column(
    //             children: [
    //               ElevatedButton(
    //                   onPressed: ()  {
    //                     getUser();
    //                     setState(() {});
    //                     Navigator.push(context,MaterialPageRoute(builder: (context) {
    //                       return Scaffold(
    //                         appBar: AppBar(title: const Text('Обновить данные'),),
    //                         body:  Form(
    //                         key: formTwoKey,
    //                         child: SingleChildScrollView(
    //                           child: Padding(
    //                             padding: EdgeInsets.all(10.0),
    //                             child: Column(
    //                               children: [
    //                                 TextFormField(
    //                                   keyboardType: TextInputType.emailAddress,
    //                                   autocorrect: false,
    //                                   decoration: const InputDecoration(
    //                                     border: OutlineInputBorder(),
    //                                     hintText: 'Введите имя',
    //                                   ),
    //                                   controller: firstNameController1,
    //                                 ),
    //                                 const SizedBox(height: 5),
    //                                 TextFormField(
    //                                   keyboardType: TextInputType.emailAddress,
    //                                   autocorrect: false,
    //                                   decoration: const InputDecoration(
    //                                     border: OutlineInputBorder(),
    //                                     hintText: 'Введите фамилию',
    //                                   ),
    //                                   controller: lastNameController2,
    //                                 ),
    //                                 const SizedBox(height: 5),
    //                                 TextFormField(
    //                                   keyboardType: TextInputType.emailAddress,
    //                                   autocorrect: false,
    //                                   controller: emailController,
    //                                   validator: (email) =>
    //                                   email != null && !EmailValidator.validate(email)
    //                                       ? 'Введите правильный Email'
    //                                       : null,
    //                                   decoration: const InputDecoration(
    //                                     border: OutlineInputBorder(),
    //                                     hintText: 'Введите Email',
    //                                   ),
    //                                 ),
    //                                 const SizedBox(height: 10),
    //                                 ElevatedButton(
    //                                   onPressed:() => updateUserData(firstNameController1.text,lastNameController2.text,emailController.text),
    //                                   child: const Center(child: Text('Обновить данные')),
    //                                 ),
    //                               ],
    //                             ),
    //                           )
    //                         ),
    //                       ),
    //                       );
    //                     }));
    //                   },
    //                   child: const Text('Обновить')
    //               ),
    //               Row(
    //                 children: [
    //                   const SizedBox(width:85,child: Text('Имя:')),
    //                   Text(currentUserData?['first_name']),
    //                 ],
    //               ),
    //               const SizedBox(height: 10,),
    //               Row(
    //                 children: [
    //                   const SizedBox(width:85,child: Text('Фамилия:')),
    //                   Text(currentUserData?['last_name']),
    //                 ],
    //               ),
    //               const SizedBox(height: 10,),
    //               Row(
    //                 children: [
    //                   const SizedBox(width:85,child: Text('Email:')),
    //                   Text(currentUserData?['email']),
    //                 ],
    //               ),
    //               const SizedBox(height: 10),
    //               const Text('Список графов',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
    //               const SizedBox(height: 10),
    //               graphsUser.isNotEmpty ? ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: graphsUser.length,
    //                 itemBuilder: (context, index) {
    //                   final data = graphsUser[index]['data'];
    //                   final timestamp = graphsUser[index]['timestamp'].toString();
    //
    //                   return Padding(
    //                     padding: const EdgeInsets.only(bottom: 10.0),
    //                     child: ElevatedButton(
    //                       onPressed: (){
    //                         String str = data;
    //                         List<List<TextEditingController>> controllersList = [];
    //                         List<dynamic> jsonList = json.decode(str);
    //                         for (var i = 0; i < jsonList.length; i++) {
    //                           List<dynamic> innerList = jsonList[i];
    //                           List<TextEditingController> innerControllersList = [];
    //                           for (var j = 0; j < innerList.length; j++) {
    //                             TextEditingController controller = TextEditingController(text: innerList[j].toString());
    //                             innerControllersList.add(controller);
    //                           }
    //                           controllersList.add(innerControllersList);
    //                         }
    //                         Navigator.push(context,MaterialPageRoute(builder: (context) {
    //                           return GraphView(controllers:controllersList,isCheckedWeight: false,isCheckedOriented: false);
    //                         }));
    //                       },
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(10.0),
    //                         child: Row(
    //                           children: [
    //                             Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text("Граф ${index + 1} "),
    //                                 const SizedBox(height: 5),
    //                                 Text(timestamp.split('.')[0])
    //                               ],
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ) : const Center(child: Text('Графов нет'))
    //             ],
    //           ),
    //         ),
    //       ),
    //       floatingActionButton: FloatingActionButton(
    //         tooltip: 'Выход',
    //         onPressed: signOut,
    //         child: const Icon(Icons.logout),
    //       ),
    //     );
    //   }
    // }
  }
}