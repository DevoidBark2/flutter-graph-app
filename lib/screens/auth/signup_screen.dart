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

    if(!isValid) return;

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
        total_user: 0,
        profile_image: ''
      );

      FirebaseFirestore.instance.collection('users-list').doc(userID).set(userData.toJson());

      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pop();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
            context,
            'Пользователь с таким email уже существует!',
            true
        );
        return;
      } else {
        // Обработка других возможных исключений FirebaseAuthException
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
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите Имя'
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: secondName,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите E-mail'
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      controller: emailController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите E-mail'
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
                          border: const OutlineInputBorder(),
                          hintText: 'Введите пароль',
                          suffix: InkWell(
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
