import 'package:flutter/material.dart';

class HighlightsPage extends StatefulWidget {
  @override
  _HighlightsPageState createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('精彩集锦')),
      body: Center(
        child: Text('这是精彩集锦'),
      ),
    );
  }
}
