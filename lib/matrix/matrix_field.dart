import 'package:flutter/material.dart';

class MatrixField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction action;
  const MatrixField({
    Key? key,
    required this.controller,
    required this.action
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        textInputAction: action,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}