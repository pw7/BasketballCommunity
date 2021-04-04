import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:extended_list/extended_list.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/conf/my_icon.dart';
import 'package:flutter_application/conf/net/net_config.dart';
import 'package:flutter_application/model/message.dart';
import 'package:flutter_application/model/receive_message.dart';
import 'package:flutter_application/model/user.dart';
import 'package:flutter_application/state/global.dart';
import 'package:flutter_application/widget/MyAppbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _textController = TextEditingController();
  double _keyboardHeight;
  FocusNode _focusNode = FocusNode();
  List<Message> _messageList = [];
  WebSocketChannel channel;
  @override
  void initState() {
    channel = IOWebSocketChannel.connect("ws://172.17.150.225:8003");
    var data = {
      "userId": Global.profile.user.userId.toString(),
      "type": "REGISTER"
    };
    //注册登录
    channel.sink.add(JsonEncoder().convert(data));
    channel.stream.listen((data) {
      Map res = jsonDecode(data);
      print(res);
      if (res['status'] != -1) {
        var receive = ReceiveMsg.fromJson(res['data']);
        if (receive.fromUserId != null &&
            receive.fromUserId == widget.user.userId.toString()) {
          _messageList.insert(0, Message(receive.content, 2));
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController?.dispose();
    _focusNode?.unfocus();
    _focusNode?.dispose();
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 0) {
      _keyboardHeight = keyboardHeight;
    }
    return Scaffold(
      appBar: MyAppbar.simpleAppbar(widget.user.username),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ExtendedListView.builder(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(30),
                  horizontal: ScreenUtil().setWidth(20)),
              reverse: true,
              extendedListDelegate: ExtendedListDelegate(closeToTrailing: true),
              itemBuilder: (context, index) {
                var msg = _messageList[index];
                return _buildMessage(msg);
              },
              itemCount: _messageList.length,
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _buildMessage(Message msg) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(12)),
      child: Row(
        mainAxisAlignment:
            msg.sender == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          msg.sender == 2 ? _buildAvatar(msg.sender) : SizedBox(width: 0),
          FLBubble(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(33),
                horizontal: ScreenUtil().setWidth(25)),
            from: msg.sender == 1 ? FLBubbleFrom.right : FLBubbleFrom.left,
            backgroundColor:
                msg.sender == 1 ? Theme.of(context).primaryColor : Colors.white,
            child: Container(
              constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(640)),
              child: Text(
                msg.text,
                maxLines: null,
              ),
            ),
          ),
          msg.sender == 1 ? _buildAvatar(msg.sender) : SizedBox(width: 0)
        ],
      ),
    );
  }

  _inputBar() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(310)),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(10),
            bottom: ScreenUtil().setHeight(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                controller: _textController,
                onEditingComplete: _changeRow,
                maxLines: null,
                decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.05),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(130),
              height: ScreenUtil().setWidth(120),
              child: FlatButton(
                child: Icon(MyIcons.send, color: Color(0xff757575)),
                padding: EdgeInsets.symmetric(horizontal: 0),
                onPressed: _sendHandler,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeRow() {
    _textController.text += '\n';
  }

  _sendHandler() {
    if (_textController.text.isNotEmpty) {
      var data = {
        "fromUserId": Global.profile.user.userId.toString(),
        "toUserId": widget.user.userId.toString(),
        "content": _textController.text,
        "type": "SINGLE_SENDING"
      };
      var msg = Message(_textController.text, 1);
      setState(() {
        _messageList.insert(0, msg);
      });
      channel.sink.add(JsonEncoder().convert(data));
      _textController.text = '';
    }
  }

  _buildAvatar(int type) {
    var avatar =
        type == 1 ? Global.profile.user.avatarUrl : widget.user.avatarUrl;
    return Container(
      height: ScreenUtil().setHeight(110),
      child: avatar == ''
          ? Image.asset("images/flutter_logo.png")
          : ClipOval(
              child: ExtendedImage.network(NetConfig.ip + '/images/' + avatar,
                  cache: true),
            ),
    );
  }
}
