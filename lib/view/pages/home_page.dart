import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/model/news.dart';
import 'package:flutter_application/utils/toast.dart';
import 'package:flutter_application/view/pages/basketball_article/article_list.dart';
import 'package:flutter_application/view/pages/basketball_essay/essay_list_page.dart';
import 'package:flutter_application/view/pages/basketball_highlights/highlights_page.dart';
import 'package:flutter_application/view/pages/basketball_part_item.dart';
import 'package:flutter_application/view/pages/basketball_video/video_page.dart';
import 'package:flutter_application/view/pages/news/news_detail_page.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _count = 5;
  int _preLoadingTime = 0;
  List<News> _newsdata = [];
  bool _cancelConnect = false; //多次请求
  List<Widget> _pageList = List(); //列表存放页面

  @override
  void initState() {
    super.initState();
    //初始化页面列表
    _pageList
      ..add(ArticleListPage())
      ..add(VideoPage())
      ..add(EssayListPage())
      ..add(HighlightsPage());

    getDatas()
        .then((List<News> newsdata) {
          if (!_cancelConnect) {
            setState(() {
              _newsdata = newsdata; //初始化state 重新刷新页面
            });
          }
        })
        .catchError((e) {
          print('error$e');
        })
        .whenComplete(() {
          print('完毕');
        })
        .timeout(Duration(seconds: 1))
        .catchError((timeOut) {
          //超时:TimeoutException after 0:00:00.010000: Future not completed
          // ignore: unnecessary_brace_in_string_interps
          print('超时:${timeOut}');
          //_cancelConnect = true;
        }); //设置超时时间
  }

  //get请求
  Future<List<News>> getDatas() async {
    final response = await http.get(
        'http://api.tianapi.com/nba/index?key=e49245ace9436793e8bac886e45acc94&num=50&page=1');
    Utf8Decoder decode = new Utf8Decoder();
    Map<String, dynamic> result =
        jsonDecode(decode.convert(response.bodyBytes));
    print(result);
    List<News> datas; //转列表
    datas =
        result['newslist'].map<News>((item) => News.fromJson(item)).toList();
    return datas; //返回 初始化
  }

  //新闻详情
  _onItemClick(int position, News data) {
    if (data.url == null || data.url.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: new Text('缺少新闻链接'),
        duration: Duration(seconds: 1),
      ));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => NewsdetailPage(
                url: data.url,
                title: data.title,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('首页')),
        body: EasyRefresh.custom(
          header: MaterialHeader(),
          footer: MaterialFooter(),
          onRefresh: () async {
            _preLoadingTime = DateTime.now().millisecond;
            await getDatas();
            int current = DateTime.now().millisecond;
            int flagTime = current - _preLoadingTime;
            if (flagTime < 1000) {
              await Future.delayed(Duration(milliseconds: 1000 - flagTime));
            }
            Toast.popToast('已刷新');
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                _count += 5;
              });
            });
          },
          slivers: <Widget>[
            //=====轮播图=====//
            SliverToBoxAdapter(child: getBannerWidget()),

            //=====网格菜单=====//
            SliverPadding(
                padding: EdgeInsets.only(top: 10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      //创建子widget
                      var action = actions[index];
                      return BasketballGridItem(
                          title: action.title,
                          color: action.color,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => _pageList[index]));
                            //Toast.popToast('点击-->${action.title}');
                          });
                    },
                    childCount: actions.length,
                  ),
                )),

            SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.sports_basketball,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0),
                        ),
                        Text(
                          '篮球资讯',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ))),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      _newsdata[index].title,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          _newsdata[index].source,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                        ),
                                        Text(
                                          _newsdata[index].ctime,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  child: Image.network(
                                    _newsdata[index].picUrl,
                                    width: 130,
                                    height: 85,
                                    fit: BoxFit.cover,
                                  ))),
                        ],
                      ),
                    ),
                    onTap: () {
                      _onItemClick(index, _newsdata[index]);
                    },
                  );
                },
                childCount: _count,
              ),
            ),
          ],
        ));
  }

  //轮播图演示
  final List<String> urls = [
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Finews.gtimg.com%2Fnewsapp_bt%2F0%2F11454234401%2F1000.jpg&refer=http%3A%2F%2Finews.gtimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618490136&t=d20498c0a554ae05f37d5b9c81d869c2",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi.52desktop.cn%3A81%2Fupimg%2Fallimg%2F20101111%2F2010111116225195177801.jpg&refer=http%3A%2F%2Fi.52desktop.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618490221&t=646260dc349623d8efa9ac2add774a64",
    "https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2020%2F0307%2Fbfccdcafj00q6s6vh001fc000p000f9m.jpg&thumbnail=650x2147483647&quality=80&type=jpg",
    "https://ss0.baidu.com/6ON1bjeh1BF3odCf/it/u=1440925027,3975236149&fm=15&gp=0.jpg",
    "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201612%2F19%2F20161219021550_iAW58.png&refer=http%3A%2F%2Fb-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1618490326&t=d4a61a0a41748626633134a1a3ce7ef4",
  ];

  Widget getBannerWidget() {
    return SizedBox(
      height: 220,
      child: Swiper(
        autoplay: true,
        duration: 2000,
        autoplayDelay: 5000,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.transparent,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image(
                  fit: BoxFit.fill,
                  image: CachedNetworkImageProvider(
                    urls[index],
                  ),
                )),
          );
        },
        onTap: (value) {
          Toast.popToast("点击--->" + value.toString());
        },
        itemCount: urls.length,
        pagination: SwiperPagination(),
      ),
    );
  }

  //这里是演示，所以写死
  final List<ActionItem> actions = [
    ActionItem('深度好文', Color(0xFFEF5362)),
    ActionItem('球星教学', Color(0xFFFE6D4B)),
    ActionItem('篮球知识库', Color(0xFFFFCF47)),
    ActionItem('精彩集锦', Color(0xFF9FD661)),
  ];

  @override
  bool get wantKeepAlive => true;
}
