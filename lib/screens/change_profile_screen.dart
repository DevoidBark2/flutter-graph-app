import 'package:flutter/material.dart';

class ChangeProfileData extends StatefulWidget {
  var userData;

  ChangeProfileData({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChangeProfileData> createState() => _ChangeProfileDataState();
}

class _ChangeProfileDataState extends State<ChangeProfileData> {

  late final user = widget.userData;

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменение профиля'),
      ),
      body: Container(
        child: Text("change data"),
      ),
    );
  }
}
