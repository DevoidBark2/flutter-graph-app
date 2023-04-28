import 'package:flutter/material.dart';

class MatrixField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction action;
  const MatrixField({
    Key? key,
    required this.controller,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        textAlign: TextAlign.center,
        controller: controller,
        textInputAction: action,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(5.0)
        ),
    );
  }
}