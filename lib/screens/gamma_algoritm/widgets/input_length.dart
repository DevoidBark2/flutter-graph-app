import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/screens/gamma_algoritm/gamma_task.dart';
import 'package:test_project/screens/gamma_algoritm/widgets/input_graph.dart';

import '../../../home_page.dart';
import '../../../models/GammaTask.dart';


class InputLength extends StatefulWidget {
  const InputLength({Key? key}) : super(key: key);

  @override
  State<InputLength> createState() => _GammaAlgoritmState();
}

class _GammaAlgoritmState extends State<InputLength> {

  final gammaTasks = FirebaseFirestore.instance.collection('gamma-tasks');
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return user != null ? Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Демонстрация'),
                    ),
                    body: InputGraph(),
                  ),
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text("Демострационный вариант"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: gammaTasks.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Ошибка получения данных: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitFadingCircle(
                  color: Colors.orange,
                  size: 100.0,
                  duration: Duration(milliseconds: 3000),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Text('Нет доступных новостей.');
              }

              final gammaTasks = snapshot.data!.docs
                  .map((doc) => GammaTask.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();

              return ListView.builder(shrinkWrap:true,itemCount: gammaTasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final gammaItem = gammaTasks[index];
                  return buildNews(gammaItem);
                },
              );
            },
          ),
        ],
      ),
    ) : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/lock.svg',
              height: 120,
              width: 120,
            ),
            const Center(
              child: Text('Доступ к игре ограничен!'),
            ),
            Center(
              child: Column(
                children: [
                  const Text('Войдите в свой аккаунт.'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return HomePage(selectedIndex: 6);
                          })
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                    ),
                    child: const Text('Войти'),
                  )
                ],
              ),
            )
          ],
        )
    );;
  }

  Widget buildNews(GammaTask gammaItem) => GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                    ),
                  ),
                ),
                title: Text(
                  "Вопрос #${gammaItem.id}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              body: GammaTaskScreen(
                  graph:gammaItem.graph,
                  listQuistion:gammaItem.list_answer,
                  question:gammaItem.question,
                  answer: gammaItem.answer,
                  total_count: gammaItem.total
              )
            ),
          ),
        );
      },
      child: Container(
        height: 80.0,
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFF819db5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Вопрос #${gammaItem.id}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/money.svg',
                      height: 40.0,
                      width: 40.0,
                    ),
                    const SizedBox(width: 5.0),
                    Text("${gammaItem.total}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
  );
}