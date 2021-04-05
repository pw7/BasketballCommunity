import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/model/essay.dart';
import 'package:flutter_application/widget/MyGridView.dart';
import 'package:http/http.dart' as http;

class EssayListPage extends StatefulWidget {
  @override
  _EssayListPageState createState() => _EssayListPageState();
}

class _EssayListPageState extends State<EssayListPage> {
  List<Essay> _essaydata1 = [];
  List<Essay> _essaydata2 = [];
  List<Essay> _essaydata3 = [];
  List<Essay> _essaydata5 = [];
  List<Essay> _essaydata6 = [];

  @override
  void initState() {
    super.initState();

    loadData('篮球概述').then((List<Essay> essaydata) {
      setState(() {
        _essaydata1 = essaydata; //初始化state 重新刷新页面
      });
    });

    loadData('篮球规则').then((List<Essay> essaydata) {
      setState(() {
        _essaydata2 = essaydata; //初始化state 重新刷新页面
      });
    });

    loadData('球员合同类型').then((List<Essay> essaydata) {
      setState(() {
        _essaydata3 = essaydata; //初始化state 重新刷新页面
      });
    });

    loadData('交易规则').then((List<Essay> essaydata) {
      setState(() {
        _essaydata5 = essaydata; //初始化state 重新刷新页面
      });
    });

    loadData('工资帽').then((List<Essay> essaydata) {
      setState(() {
        _essaydata6 = essaydata; //初始化state 重新刷新页面
      });
    });
  }

  //get请求
  Future<List<Essay>> loadData(String type) async {
    final res = await http
        .get('http://172.17.150.225:8080/essay/getEssayByType?type=$type');
    Utf8Decoder decode = new Utf8Decoder();
    Map<String, dynamic> result = jsonDecode(decode.convert(res.bodyBytes));
    //print(result);
    List<Essay> datas; //转列表
    datas = result['data'].map<Essay>((item) => Essay.fromJson(item)).toList();
    return datas; //返回 初始化
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('篮球知识库')),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '篮球概述',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    MyGridView(_essaydata1),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      child: Text('篮球规则',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    MyGridView(_essaydata2),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      child: Text('球员合同类型',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    MyGridView(_essaydata3),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      child: Text('交易规则',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    MyGridView(_essaydata5),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 8),
                      child: Text('工资帽',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    MyGridView(_essaydata6),
                  ],
                ))));
  }
}
