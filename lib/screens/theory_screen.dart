import 'package:bulleted_list/bulleted_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/algorithms/kruskal_algorithm.dart';
import 'package:test_project/models/User.dart';
import 'package:test_project/screens/instruction_screen.dart';
import 'package:test_project/screens/rules_game.dart';
import 'package:test_project/screens/settings_screen.dart';
import 'package:test_project/screens/theory_screen_2.dart';

import '../models/News.dart';

class TheoryScreen extends StatefulWidget {
  const TheoryScreen({Key? key}) : super(key: key);

  @override
  State<TheoryScreen> createState() => _TheoryScreenState();
}

class _TheoryScreenState extends State<TheoryScreen> {

  int itemCount = 9; // Number of players in the list
  final List<UserData> tasks = [];
  List<News> news = [];
  final user = FirebaseAuth.instance.currentUser;

  final _collectionRef = FirebaseFirestore.instance.collection('users-list');
  final _newsRef = FirebaseFirestore.instance.collection('news');

  Future<void> _refreshData() async {
    QuerySnapshot querySnapshot = await _newsRef.get();
    final newsList = querySnapshot.docs
        .map((doc) => News.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    setState(() {
      news = newsList;
    });
  }

  // final urlImage = [
  //   'https://cdn-user84060.skyeng.ru/uploads/5fdb29509a644288566818.png',
  //   'https://cdn-user84060.skyeng.ru/uploads/5fdb29510e700334196189.png'
  // ];
  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {

    // double containerHeight = itemCount.toDouble() * 25.0;
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: _refreshData,
          displacement: 100.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _newsRef.snapshots(),
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

                      final news = snapshot.data!.docs
                          .map((doc) => News.fromMap(doc.data() as Map<String, dynamic>))
                          .toList();

                      return CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 200,
                            autoPlay: false,
                            viewportFraction: 1
                        ),
                        itemCount: news.length,
                        itemBuilder: (context,index,realIndex){
                          final newsItem = news[index];

                          return buildImage(newsItem);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text('Теория'),
                                ),
                                body: const TheoryScreen2(),
                              ),
                            ),
                            );
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                color:Colors.deepOrange[500],
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/list-theory.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text(
                                    'Теория',
                                    style: TextStyle(
                                        fontSize: 25.0
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Add your child widgets or content here
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text('Правила'),
                                ),
                                body: const InstructionScreen(),
                              ),
                            ),
                            );
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                                color:Colors.deepOrange[500],
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/rules_app.svg',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  const Text(
                                    'Правила',
                                    style: TextStyle(
                                        fontSize: 25.0
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Add your child widgets or content here
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange[500],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            'ТОП игроков',
                            style: TextStyle(
                                fontSize: 25.0
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: _collectionRef.snapshots(),
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
                                return Text('Нет доступных задач.');
                              }

                              final users = snapshot.data!.docs
                                  .map((doc) => UserData.fromMap(doc.data() as Map<String, dynamic>))
                                  .toList();

                              return Container(
                                height: MediaQuery.of(context).size.height / 3,
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final user = users[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10.0),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(user.profile_image),
                                          ),
                                          const SizedBox(width: 10,),
                                          Text('${user.second_name} ${user.first_name}'),
                                         const SizedBox(width: 40,),
                                         Align(
                                           alignment: Alignment.centerRight,
                                           child:  Text('${user.total_user}'),
                                         )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          // Expanded( // Wrap ListView.builder with Expanded
                          //   child: ListView.builder(
                          //     itemCount: itemCount,
                          //     itemBuilder: (context, index) {
                          //       return ListTile(
                          //         leading: Container(
                          //           decoration: BoxDecoration(
                          //               border: Border.all(color: Colors.black,width: 3.0),
                          //               borderRadius: BorderRadius.circular(50.0)
                          //           ),
                          //           child: Padding(
                          //               padding: EdgeInsets.all(10.0),
                          //               child: Image.asset('assets/images/logo_avatar.jpg',width: 50.0,height: 50.0,)
                          //           ),
                          //         ),
                          //         title: Text('Player ${index + 1}'),
                          //       );
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  Widget buildImage(News news_item) => GestureDetector(
    onTap: (){
      print(news_item);
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color:Colors.deepOrange[500],
          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child:  Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  news_item.news_image,
                  width: 120,
                )
              ],
            ),
            const SizedBox(width: 20),
            Container(
              width: 160,
              child: Column(
                children: [
                  Text(
                    '${news_item.title}',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                      '${news_item.sub_title}',
                    style: TextStyle(

                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    ),
  );
}
