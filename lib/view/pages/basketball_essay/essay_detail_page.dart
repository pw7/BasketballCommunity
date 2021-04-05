import 'package:flutter/material.dart';

class EssayDetailPage extends StatelessWidget {
  final String title;
  final String content;

  EssayDetailPage(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.all(8),
          child: Text(content),
        ));
  }
}
