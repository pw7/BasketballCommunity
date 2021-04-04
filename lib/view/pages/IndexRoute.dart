import 'package:flutter/material.dart';
import 'package:flutter_application/conf/my_icon.dart';
import 'package:flutter_application/utils/click.dart';
import 'package:flutter_application/view/pages/community_page.dart';
import 'package:flutter_application/view/pages/home_page.dart';
import 'package:flutter_application/view/pages/me_page.dart';
import 'package:flutter_application/view/pages/notification_page.dart';
import 'package:flutter_application/view/pages/post/send_post_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexRoute extends StatefulWidget {
  @override
  _IndexRouteState createState() => _IndexRouteState();
}

class _IndexRouteState extends State<IndexRoute> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _pageList = List(); //列表存放页面
  int _selectedIndex; //bar下标
  PageController _pageController;

  @override
  initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController();
    //初始化页面列表
    _pageList
      ..add(HomePage())
      ..add(CommunityPage())
      ..add(SendPostPage(type: 1))
      ..add(NotificationPage())
      ..add(MePage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MyIcons.home,
                size: ScreenUtil().setWidth(75),
              ),
              title: Text('首页'),
              activeIcon:
                  Icon(MyIcons.home_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyIcons.explore,
                size: ScreenUtil().setWidth(75),
              ),
              title: Text('发现'),
              activeIcon:
                  Icon(MyIcons.explore_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setWidth(90),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(45)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(MyIcons.plus,
                    color: Colors.white, size: ScreenUtil().setWidth(66)),
              ),
              title: Text(''),
            ),
            BottomNavigationBarItem(
              icon: Icon(MyIcons.bell, size: ScreenUtil().setWidth(75)),
              title: Text('通知'),
              activeIcon:
                  Icon(MyIcons.bell_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(MyIcons.user, size: ScreenUtil().setWidth(75)),
              title: Text('我'),
              activeIcon:
                  Icon(MyIcons.user_fill, size: ScreenUtil().setWidth(75)),
            ),
          ],
          backgroundColor: Theme.of(context).bottomAppBarColor,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedIndex,
          onTap: onTap,
        ),
      ),
      onWillPop: () {
        return ClickUtils.exitBy2Click(status: _scaffoldKey.currentState);
      },
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future onTap(int index) async {
    if (index == 2) {
      Navigator.pushNamed(context, 'edit_msg_page');
    } else {
      _pageController.jumpToPage(index);
    }
  }
}
