import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/home_page.dart';
import 'package:test_project/screens/auth/signup_screen.dart';
import 'package:test_project/screens/theory_screen.dart';
import 'package:test_project/service/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isHiddenPassword = true;
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

    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void togglePasswordView(){
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login (BuildContext context) async {
    final navigaor = Navigator.of(context);
    final isValid = formKey.currentState!.validate();

    if(!isValid) return;

    if(emailController.text.trim() == ""){
      SnackBarService.showSnackBar(
          context,
          'Введите E-mail!',
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

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(selectedIndex: 0,)),
      );

      SnackBarService.showSnackBar(
          context,
          'Вы вошли в профиль!',
          false
      );

    } on FirebaseAuthException catch (e) {
      print(e.code);

      if(e.code == "user-not-found" || e.code == "wrong-password"){
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль!',
          true
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(30.0),
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
                  ElevatedButton(
                      onPressed: (){
                        login(context);
                      },
                      child: const Center(child: Text('Войти'))
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Scaffold(
                              appBar: AppBar(
                                title: const Text('Регистрация'),
                                flexibleSpace: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: <Color>[Colors.orange, Colors.deepOrange],
                                    ),
                                  ),
                                ),
                              ),
                              body: const RegisterScreen(),
                            ),
                          ),
                        );
                      },
                      child: const Center(child: Text('Регистрация'))
                  )
                ]
              )
            )
        )
      )
    );
  }
}
