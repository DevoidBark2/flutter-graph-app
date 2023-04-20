import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_project/screens/login_screen.dart';
import 'package:test_project/screens/sign_screen.dart';

import '../service/snack_bar.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if(user == null){
//       return const LoginScreen();
//     }else{
//       return const Center(child: Text('Профиль'));
//     }
//   }
// }
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
  late Map<String,dynamic> currentUserData;
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
  Future<void> login() async {

    final isValid = formOneKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }
    setState(() {});
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {});
  }

  Future<void> addUserDetails(String firstName,String lastName,String email,String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first_name': firstName,
      'last_name': lastName,
      'email' : email,
      'uid': userId
    });
  }
  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formTwoKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(
        context,
        'Пароли должны совпадать',
        true,
      );
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      String? userId = userCredential.user?.uid;
      //add user details
        addUserDetails(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        emailTextInputController.text.trim(),
          userId!
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'Такой Email уже используется, повторите попытку с использованием другого Email',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }
    navigator.pop();
    setState(() {});
  }
  Future<Object?> getCurrentUserData() async {
    try {
      // получаем текущего пользователя из Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;

      // получаем его UID
      String? userId = currentUser?.uid;

      // получаем его данные из Firestore
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // возвращаем данные текущего пользователя в виде Map<String, dynamic>
      print(userData.data().runtimeType);
      return userData.data();
    } catch (e) {
      print('Ошибка при получении данных текущего пользователя: $e');
      return null;
    }
  }
  getUser() async {
    return await getCurrentUserData();
  }
  @override
  initState() {
    super.initState();
    getUser().then((data) {
      setState(() {
        currentUserData = data;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formOneKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    controller: emailTextInputController,
                    validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Введите правильный Email'
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите Email',
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    autocorrect: false,
                    controller: passwordTextInputController,
                    obscureText: isHiddenPassword,
                    validator: (value) => value != null && value.length < 6
                        ? 'Минимум 6 символов'
                        : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Введите пароль',
                      suffix: InkWell(
                        onTap: togglePasswordView,
                        child: Icon(
                          isHiddenPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: login,
                    child: const Center(child: Text('Войти')),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) {
                      return  Scaffold(
                        resizeToAvoidBottomInset: false,
                        appBar: AppBar(
                          title: const Text('Зарегистрироваться'),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Form(
                            key: formTwoKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  controller: firstNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Введите имя',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  controller: lastNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Введите фамилию',
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  controller: emailTextInputController,
                                  validator: (email) =>
                                  email != null && !EmailValidator.validate(email)
                                      ? 'Введите правильный Email'
                                      : null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Введите Email',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autocorrect: false,
                                  controller: passwordTextInputController,
                                  obscureText: isHiddenPassword,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Минимум 6 символов'
                                      : null,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Введите пароль',
                                    suffix: InkWell(
                                      onTap: togglePasswordView,
                                      child: Icon(
                                        isHiddenPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  autocorrect: false,
                                  controller: passwordTextRepeatInputController,
                                  obscureText: isHiddenPassword,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                  value != null && value.length < 6
                                      ? 'Минимум 6 символов'
                                      : null,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: 'Введите пароль еще раз',
                                    suffix: InkWell(
                                      onTap: togglePasswordView,
                                      child: Icon(
                                        isHiddenPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: signUp,
                                  child: const Center(child: Text('Регистрация')),
                                ),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text(
                                    'Войти',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
                    child: const Text(
                      'Регистрация',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) {
                      return  Scaffold(
                        appBar: AppBar(
                          title: const Text('Сброс пароля'),
                        ),
                        body: const Text('тут будет Восстановление пароля'),
                      );
                    })),
                    child: const Text('Сбросить пароль'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }else{
      return  Column(
        children: [
          Text(currentUserData.runtimeType.toString()),
          ElevatedButton(onPressed: signOut, child: const Text('Out'))
        ],
      );
    }
  }
}
class UserDate{
  late String uid;
  late String first_name;
  late String laste_name;
  late String email;
}
