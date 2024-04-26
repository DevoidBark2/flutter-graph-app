import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../models/DropDownItem.dart';

class DropDownScreen extends StatefulWidget {
  final String? type;
  const DropDownScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<DropDownScreen> createState() => _DropDownScreenState(type: type);
}

class _DropDownScreenState extends State<DropDownScreen>{
  late String? type;
  late CollectionReference _collectionRef;

  _DropDownScreenState({this.type});

  Future<bool> buySkills(DropDownItem item) async {
    int priceValue = item.price;
    final user = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users-list').where('uid', isEqualTo: user?.uid ?? '').get();
    final userData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    int totalCurrentUser = userData[0]['user_total'];

    List skills = userData[0]['skills'];
    print(userData[0]['skills']);
    skills.add(item.toJson());
    print("__________________________");
    print(skills);

    if(totalCurrentUser < priceValue){
      return false;
    }

    print(item.toJson());

    await FirebaseFirestore.instance.collection('users-list').doc(user?.uid).update({
      'user_total': totalCurrentUser - priceValue,
      'skills':skills
    });

    return true;
  }

  Future<void> handleBuySkill(DropDownItem item) async {
    var res = await buySkills(item);

    Navigator.of(context).pop();
    if (!res) {
      showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: 200,
          color: const Color(0xffffffff),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/error.svg',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 15.0),
                const Text("Недостаточно средств!"),
                const SizedBox(height: 35.0),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                  ),
                  child: const Text('Закрыть')
                ),
              ],
            ),
          ),
        );
      });
      return;
    }
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return Container(
        width: double.infinity,
        height: 200,
        color: const Color(0xffffffff),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/images/success_icon.svg',
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 15.0),
              const Text("Вы добавили новый навык!"),
              const SizedBox(height: 35.0),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                  ),
                  child: const Text('Закрыть')
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _collectionRef = FirebaseFirestore.instance.collection(type!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _collectionRef.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Ошибка получения данных: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitFadingCircle(
                    color: Color(0xFF819db5),
                    size: 100.0,
                    duration: Duration(milliseconds: 3000),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/empty_icon.svg',
                        height: 100.0,
                        width: 100.0,
                      ),
                      Text(
                        'Нет доступных ${type == "skills-list" ? 'навыков' : 'подсказок'}',
                        style: const TextStyle(
                            fontSize: 16
                        ),
                      )
                    ],
                  ),
                );
              }

              final items = snapshot.data!.docs
                  .map((doc) => DropDownItem.fromMap(doc.data() as Map<String, dynamic>))
                  .toList();

              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color:Colors.black,
                                  width: 1.0
                              )
                          )
                      ),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type == "skills-list" ? "Всего навыков (${items.length})" : "Всего подсказок (${items.length})",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,

                            ),
                          ),
                          GestureDetector(
                            onTap:(){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Навык"),
                                    content: Text("Навыки помогут помочь в выполнении задания"),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF678094)),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                            ),
                                            child: const Text('OK'),
                                            onPressed: () => Navigator.of(context).pop(),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/images/question_icon.svg',
                              height: 40.0,
                              width: 40.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(item.title),
                                  content: Text(item.sub_title),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.lightGreen
                                          ),
                                          onPressed: (){
                                            handleBuySkill(item);
                                          },
                                          child: Row(
                                            children: [
                                              Text(item.price.toString()),
                                              const SizedBox(width: 10,),
                                              SvgPicture.asset(
                                                'assets/images/money.svg',
                                                height: 40.0,
                                                width: 40.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.lightGreen
                                          ),
                                          child: const Text('OK'),
                                          onPressed: () => Navigator.of(context).pop(),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: <Color>[Color(0xFF819db5),Color(0xFF678094)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                SvgPicture.network(
                                  item.image_item,
                                  width: 75,
                                  height: 75,
                                ),
                                const SizedBox(height: 10),
                                Text(item.title),
                              ],//just for testing, will fill with image later
                            ),
                          ),
                        );
                      },
                    )
                  ],
                )
              );
            },
          ),
        ],
      )
    );
  }
}
