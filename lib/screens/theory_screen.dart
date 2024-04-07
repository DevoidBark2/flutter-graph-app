import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/models/User.dart';
import 'package:test_project/screens/instruction_screen.dart';
import 'package:test_project/screens/news_screen.dart';
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
                            viewportFraction: 1,
                            enableInfiniteScroll: news.length > 1
                        ),
                        itemCount: news.length,
                        itemBuilder: (context,index,realIndex){
                          final newsItem = news[index];

                          return buildNews(newsItem);
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
                                color:const Color(0xFF819db5),
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
                                color:const Color(0xFF819db5),
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
                      color: const Color(0xFF819db5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            'ТОП игроков',
                            style: TextStyle(
                                fontSize: 25.0,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          const SizedBox(height: 10),
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

                              final sortedUsers = users
                                  .where((user) => user.user_total != null)
                                  .toList()
                                ..sort((a, b) => b.user_total.compareTo(a.user_total));

                              final top5Users = sortedUsers.take(5).toList();

                              return Container(
                                height:150,
                                width: double.infinity,
                                child: ListView.builder(
                                  itemCount: top5Users.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final user = top5Users[index];
                                    print(user.uid);
                                    print(user.second_name);
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10.0),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.only(left: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: index == 0 ? Colors.amber : const Color(0xFF678094),
                                            ),
                                            child: Center(
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          CircleAvatar(
                                            radius: 27,
                                            backgroundImage: NetworkImage(user.profile_image),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${user.second_name} ${user.first_name}',
                                                  style: const TextStyle(fontSize: 18),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, color: Colors.amber),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      '${user.user_total} очков',
                                                      style: const TextStyle(color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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

  Widget buildNews(News newsItem) => GestureDetector(
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
              title: Text(newsItem.title),
            ),
            body: NewsScreen(content: newsItem.content,),
          ),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xFF819db5),
          borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:  Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SvgPicture.network(
                    newsItem.news_image,
                    width: 100,
                    height: 100,
                  ),
                )
              ],
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 170,
              child: Column(
                children: [
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                      newsItem.sub_title,
                    style: const TextStyle(
                      fontSize: 15
                    ),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          'Читать подробнее',
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ),
  );
}
