import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/model/user.dart';
import 'package:flutter_application/services/MyApi.dart';
import 'package:flutter_application/services/NetRequester.dart';
import 'package:flutter_application/state/ProfileChangeNotifier.dart';
import 'package:flutter_application/state/global.dart';
import 'package:flutter_application/utils/loading_dialog.dart';
import 'package:flutter_application/utils/toast.dart';
import 'package:flutter_application/widget/MyTextFormField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String email;
  String pwd;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight + 20.0,
                ), //顶部填充
                Image(
                  image: AssetImage("assets/images/flutter_logo.png"),
                  width: 70.0,
                  height: 70.0,
                ), //logo
                SizedBox(height: 40.0),
                buildEmailTextField(_nameController), //账号输入框
                TextFormField(
                  controller: _pwdController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '请输入密码',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: showPassWord),
                  ),
                  //校验密码
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密码不能少于6位";
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      '忘记密码？',
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'forget_page');
                    },
                  ),
                ), //忘记密码
                Padding(
                  padding:
                      const EdgeInsets.only(top: 35.0, left: 60.0, right: 40.0),
                  child: RaisedButton(
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Text("登录"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        if ((_formKey.currentState as FormState).validate()) {
                          email = _nameController.text;
                          pwd = _pwdController.text;
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return LoadingDialog(
                                  showContent: false,
                                  backgroundColor: Colors.black38,
                                  loadingView:
                                      SpinKitCircle(color: Colors.white),
                                );
                              });
                          var result = await NetRequester.request(
                              Apis.login(email, pwd));
                          //根据服务器返回结果进行提示
                          if (result["code"] == "0")
                            Toast.popToast("账户或密码输入错误，请重试");
                          else {
                            Navigator.pushNamedAndRemoveUntil(context,
                                'index_page', (route) => route == null);
                            User user = User.fromJson(result["data"]);
                            Global.profile.user = user;
                            UserModel().notifyListeners();
                          }
                        }
                      }),
                ), //登录按钮
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('没有账号？'),
                      GestureDetector(
                        child: Text(
                          '点击注册',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, 'register_page');
                        },
                      ),
                    ],
                  ),
                ), //注册跳转
              ],
            )),
      ),
    );
  }

  ///点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
}
