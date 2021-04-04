import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsdetailPage extends StatefulWidget {
  final String url;
  final String title;

  const NewsdetailPage({Key key, this.url, this.title}) : super(key: key);
  @override
  _NewsdetailPageState createState() => _NewsdetailPageState();
}

class _NewsdetailPageState extends State<NewsdetailPage> {
  bool loaded = false;
  String detailDataStr;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  _NewsdetailPageState({Key key});

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print("state: ${state.type}");
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      widget.title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 13.0),
    ));
    if (!loaded) {
      titleContent.add(CupertinoActivityIndicator());
    }
    titleContent.add(Container(width: 50.0));
    return WebviewScaffold(
      url: widget.url,
      appBar: AppBar(
          title: Expanded(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
      )),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
