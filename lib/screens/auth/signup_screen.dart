import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/User.dart';
import '../../service/snack_bar.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isHiddenPassword = true;
  TextEditingController firstName = TextEditingController();
  TextEditingController secondName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    firstName.dispose();
    secondName.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordView(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signup(BuildContext context) async {
    final navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();

    if(firstName.text.trim() == ""){
      SnackBarService.showSnackBar(
          context,
          'Имя не может быть пустым!',
          true
      );
      return;
    }

    if(secondName.text.trim() == ""){
      SnackBarService.showSnackBar(
          context,
          'Фамилия не может быть пустым!',
          true
      );
      return;
    }

    if(emailController.text.trim() == ""){
      SnackBarService.showSnackBar(
          context,
          'E-mail не может быть пустым!',
          true
      );
      return;
    }

    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$");

    if (!regex.hasMatch(emailController.text.trim())) {
      SnackBarService.showSnackBar(
          context,
          'Неверный формат email!',
          true
      );
      return;
    }

    if(passwordController.text.trim() == ""){
      SnackBarService.showSnackBar(
          context,
          'Пароль не может быть пустым!',
          true
      );
      return;
    }

    try {
      UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String userID = user.user!.uid;

      UserData userData = UserData(
        uid: userID,
        email: emailController.text.trim(),
        first_name: firstName.text.trim(),
        second_name: secondName.text.trim(),
          user_total: 0,
        profile_image: 'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
        skills: [],
        tips: []
      );

      FirebaseFirestore.instance.collection('users-list').doc(userID).set(userData.toJson());

      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();

    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
            context,
            'Пользователь с таким email уже существует!',
            true
        );
        return;
      }  else if (e.code == 'weak-password') {
        SnackBarService.showSnackBar(
            context,
            'Пароль должен быть длиной не менее 6 символов!',
            true
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/Logo.svg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: firstName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF678094),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF678094),
                                width: 2.0
                            ),
                          ),
                          label: const Text('Введите имя'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF678094)
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: secondName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF678094),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF678094),
                                width: 2.0
                            ),
                          ),
                          label: const Text('Введите фамилию'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF678094)
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF678094),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFF678094),
                                width: 2.0
                            ),
                          ),
                          label: const Text('Введите E-mail'),
                          labelStyle: const TextStyle(
                              color: Color(0xFF678094)
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      autocorrect: false,
                      controller: passwordController,
                      obscureText: isHiddenPassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFF678094),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFF678094),
                              width: 2.0
                          ),
                        ),
                        label: const Text('Введите пароль'),
                        labelStyle: const TextStyle(
                            color: Color(0xFF678094)
                        ),
                        suffix: GestureDetector(
                            onTap: togglePasswordView,
                            child: Icon(
                                isHiddenPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility
                            ),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                        onPressed: (){
                          signup(context);
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                        ),
                        child: const Center(child: Text('Зарегистрироваться'))
                    )
                  ]
                )
              )
          )
        )
    );
  }
}
