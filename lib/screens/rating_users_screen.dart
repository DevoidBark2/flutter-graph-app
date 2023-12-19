import 'package:flutter/material.dart';

class RatingUsersScreen extends StatefulWidget {
  const RatingUsersScreen({Key? key}) : super(key: key);

  @override
  State<RatingUsersScreen> createState() => _RatingUsersScreenState();
}

class _RatingUsersScreenState extends State<RatingUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
        child: Text('Rating users'),
      ),
    );
  }
}
