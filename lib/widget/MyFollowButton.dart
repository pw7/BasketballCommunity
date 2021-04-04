import 'package:flutter/material.dart';
import 'package:flutter_application/model/user.dart';
import 'package:flutter_application/services/MyApi.dart';
import 'package:flutter_application/services/NetRequester.dart';
import 'package:flutter_application/state/ProfileChangeNotifier.dart';
import 'package:flutter_application/state/global.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowButton extends StatefulWidget {
  final User user;

  const FollowButton({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FollowButtonState();
  }
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      height: ScreenUtil().setHeight(70),
      child: OutlineButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        textColor: Theme.of(context).primaryColor,
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        padding: EdgeInsets.all(0),
        child: Text(
          widget.user.isFollow == 1 ? '相互关注' : '未关注',
          style: TextStyle(fontSize: ScreenUtil().setSp(36)),
        ),
        onPressed: () async {
          var fanId = Global.profile.user.userId;
          var res = await NetRequester.request(widget.user.isFollow == 0
              ? Apis.followAUser(fanId, widget.user.userId)
              : Apis.cancelFollowAUser(fanId, widget.user.userId));
          if (res['code'] == '1') {
            setState(() {
              widget.user.isFollow = widget.user.isFollow == 1 ? 0 : 1;
            });
            widget.user.isFollow == 1
                ? Global.profile.user.followNum++
                : Global.profile.user.followNum--;
            UserModel().notifyListeners();
          }
        },
      ),
    );
  }
}
