import 'package:flutter/material.dart';

TextFormField buildEmailTextField(TextEditingController c) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: c,
    decoration: InputDecoration(
        labelText: '账号', hintText: '请输入您的邮箱地址', icon: Icon(Icons.person)),
    validator: (String value) {
      var emailReg = RegExp(
          r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
      if (!emailReg.hasMatch(value)) {
        return '请输入正确的邮箱地址';
      }
    },
  );
} //邮箱输入框

TextFormField buildPasswordTextField(TextEditingController c) {
  return TextFormField(
    controller: c,
    decoration: InputDecoration(
      labelText: "密码",
      hintText: "请输入您的密码",
      icon: Icon(Icons.lock),
    ),
    obscureText: true,
    //校验密码
    validator: (v) => v.trim().length > 5 ? null : "登录密码不能小于6位",
  );
}
