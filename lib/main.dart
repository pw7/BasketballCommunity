import 'package:flutter/material.dart';
import 'package:flutter_application/state/ProfileChangeNotifier.dart';
import 'package:flutter_application/state/global.dart';
import 'package:flutter_application/view/pages/IndexRoute.dart';
import 'package:flutter_application/view/pages/Login/ForgetRoute.dart';
import 'package:flutter_application/view/pages/Login/LoginRoute.dart';
import 'package:flutter_application/view/pages/Login/RegisterRoute.dart';
import 'package:flutter_application/view/pages/OpenPic.dart';
import 'package:flutter_application/view/pages/community_page.dart';
import 'package:flutter_application/view/pages/post/send_post_page.dart';
import 'package:flutter_application/view/pages/setting_page.dart';
import 'package:flutter_application/view/pages/theme_change_page.dart';
import 'package:flutter_application/view/pages/user/update_user_details_page.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final user = UserModel();
  final theme = ThemeModel();
  Global.init();
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserModel>.value(value: user),
      ChangeNotifierProvider<ThemeModel>.value(value: theme),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      child:
          Consumer<ThemeModel>(builder: (BuildContext context, themeModel, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '篮途',
          home: OpenPicRoute(),
          theme: themeModel.isDark
              ? ThemeData(brightness: Brightness.dark)
              : ThemeData(
                  primarySwatch: themeModel.theme,
                  scaffoldBackgroundColor: Color(0xfff2f2f6)),
          routes: {
            'register_page': (context) => RegisterRoute(),
            'index_page': (context) => IndexRoute(),
            'forget_page': (context) => ForgetRoute(),
            'login_page': (context) => LoginRoute(),
            'edit_msg_page': (context) => SendPostPage(type: 1),
            'post_page': (context) => CommunityPage(),
            'theme_page': (context) => ThemeChangeRoute(),
            'setting_page': (context) => SettingPage(),
            'update_userdetail_page': (context) => UpdateUserDetailPage()
          },
        );
      }),
    );
  }
}
