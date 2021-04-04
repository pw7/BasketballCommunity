import 'package:flutter/material.dart';
import 'package:flutter_application/view/pages/post/common_post_page.dart';
import 'package:flutter_application/widget/MyAppbar.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  List<Widget> _pageList = List(); //列表存放页面
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageList
      ..add(CommonPostPage(type: 6))
      ..add(CommonPostPage(type: 5))
      ..add(CommonPostPage(type: 2));

    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var _tabBar = TabBar(
      onTap: (index) {
        _pageController.jumpToPage(index);
      },
      controller: _tabController,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
      tabs: <Widget>[
        Tab(text: '热门'),
        Tab(text: '最新'),
        Tab(text: '关注'),
      ],
    );
    return Scaffold(
      appBar: MyAppbar.build(context, _tabBar),
      body: PageView(
        controller: _pageController,
        children: _pageList,
        onPageChanged: (index) {
          _tabController.animateTo(index);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
