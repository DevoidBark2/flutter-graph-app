import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsScreen extends StatefulWidget {
  final String? content;
  const NewsScreen({Key? key,required this.content}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    var html = widget.content;
    return Container(
      child: Html(
        data: html,
      ),
    );
  }
}
