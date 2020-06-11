import 'dart:async';
import 'package:client/common/color.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/verification.dart';

class RetrievePassword extends StatefulWidget {
  @override
  _RetrievePasswordState createState() => _RetrievePasswordState();
}

class _RetrievePasswordState extends State<RetrievePassword> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _realname = TextEditingController(),
      _phone = TextEditingController(),
      _code = TextEditingController(),
      _password = TextEditingController(),
      _qrpassword = TextEditingController();
  String phone = '';
  bool codeActive = false; //获取验证码按钮状态
  bool isButtonEnable = true; //按钮状态 是否可点击
  String buttonText = '获取验证码'; //初始文本
  int count = 60; //初始倒计时时间
  Timer timer; //倒计时的计时器
  // void _buttonClickListen() {
  //   Map<String, dynamic> map = Map();
  //   map.putIfAbsent("phone", () => _phone.text);
  //   UserServer().getCode(map, (success) async {
  //     print(success['errcode']);
     
  //   }, (onFail) async {});
  
  // }

  // void _initTimer() {
  //   timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     count--;
  //     setState(() {
  //       if (count == 0) {
  //         timer.cancel(); //倒计时结束取消定时器
  //         isButtonEnable = true; //按钮可点击
  //         count = 60; //重置时间
  //         buttonText = '获取验证码'; //重置按钮文本
  //       } else {
  //         buttonText = '重新发送($count)'; //更新文本内容
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    timer?.cancel(); //销毁计时器
    timer = null;
    super.dispose();
  }

  register() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      Map<String, dynamic> map = Map();
      map.putIfAbsent("real_name", () => _realname.text.trim());
      map.putIfAbsent("phone", () => _phone.text.trim());
      map.putIfAbsent("code", () => _code.text.trim());
      map.putIfAbsent("newpassword", () => _password.text.trim());
      print(map.toString());
      UserServer().getForgetPassword(map, (success) async {
        ToastUtil.showToast('操作成功');
        await Future.delayed(
            Duration(seconds: 1), () => Navigator.pop(context));
      }, (onFail) => ToastUtil.showToast(onFail));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      child: Scaffold(
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(231, 20, 25, 1),
          centerTitle: true, //标题居中
          title:
              Text('找回密码', style: TextStyle(fontSize: ScreenUtil().setSp(33))),
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: StyleUtil.padding(left: 28, right: 28, top: 15),
              color: Color(0xfffF5F5F5),
              child: Column(children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(694),
                  decoration: BoxDecoration(
                    color: Color(0xfffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        //用户名
                        decoration: BoxDecoration(
                            border: Border(
                          bottom:
                              BorderSide(color: Color(0XffE5E5E5), width: 1),
                        )),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: StyleUtil.width(200),
                              padding: StyleUtil.paddingTow(left: 27),
                              child: Text(
                                '用户名',
                                style: StyleUtil.tontStyle(
                                    color: PublicColor.textColor),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                  autofocus: false,
                                  controller: _realname,
                                  validator: (val) =>
                                      (val == '' ? "请输入用户名" : null),
                                  onSaved: (val) => (_realname.text = val),
                                  decoration: new InputDecoration(
                                      hintText: '请输入用户名',
                                      border: InputBorder.none)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0XffE5E5E5), width: 1))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: StyleUtil.width(200),
                              padding: StyleUtil.paddingTow(left: 27),
                              child: Text(
                                '手机号',
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(28)),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _phone,
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  validator: (val) {
                                    RegExp regMobile = new RegExp(
                                        '^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\$');
                                    return val == ''
                                        ? "请输入手机号码"
                                        : !regMobile.hasMatch(val)
                                            ? "手机号码格式不对"
                                            : null;
                                  },
                                  onSaved: (val) => (_phone.text = val),
                                  decoration: new InputDecoration(
                                    hintText: '请输入手机号码',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      codeActive =
                                          value.length == 0 ? false : true;
                                      phone = value;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: StyleUtil.borderBottom())),
                        child: Row(children: <Widget>[
                          Container(
                            width: StyleUtil.width(200),
                            padding: StyleUtil.paddingTow(left: 27),
                            child: Text(
                              '短信验证码',
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(28)),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: new TextFormField(
                                controller: _code,
//                                keyboardType: TextInputType.number,
                                autofocus: false,
                                validator: (val) =>
                                    (val == '' ? "请输入短信验证码" : null),
                                onSaved: (val) => (_code.text = val),
                                decoration: new InputDecoration(
                                  hintText: '请输入短信验证码',
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                ),
                              )),
                          Container(
                            height: StyleUtil.width(40),
                            margin: StyleUtil.padding(right: 27),
                            decoration: BoxDecoration(
                                border: Border(left: StyleUtil.borderBottom())),
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              textColor: Color(0xff545454),
                              color: Color(0xffffffff),
                              splashColor: isButtonEnable
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                              shape: StadiumBorder(side: BorderSide.none),
                              onPressed: () {
                                // setState(() {
                                //   _buttonClickListen();
                                // });
                              },
                              child: FormCode(
                                countdown: 60,
                                phone: phone,
                                type: "login",
                                available: codeActive,
                              ),
                              // child: Text(
                              //   '$buttonText',
                              //   style: TextStyle(
                              //     fontSize: 13,
                              //   ),
                              // ),
                            ),
                          )
                        ]),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Color(0XffE5E5E5), width: 1))),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: StyleUtil.width(200),
                              padding: StyleUtil.paddingTow(left: 27),
                              child: Text(
                                '登录密码',
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(28)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _password,
                                obscureText: true,
                                autofocus: false,
                                validator: (val) =>
                                    (val == '' ? "请输入登录密码" : null),
                                onSaved: (val) => (_password.text = val),
                                decoration: new InputDecoration(
                                  hintText: '请输入登陆密码',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: StyleUtil.width(200),
                              padding: StyleUtil.paddingTow(left: 27),
                              child: Text(
                                '确认密码',
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(28)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _qrpassword,
                                  autofocus: false,
                                  obscureText: true,
                                  validator: (val) {
                                    return val == ''
                                        ? '请输入确认密码'
                                        : val != _password.text
                                            ? '密码不一致'
                                            : null;
                                  },
                                  onSaved: (val) => (_qrpassword.text = val),
                                  decoration: new InputDecoration(
                                    hintText: '请输入确认密码',
                                    border: InputBorder.none,
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  //立即注册
                  width: double.infinity,
                  height: ScreenUtil().setHeight(92),
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(114)),
                  child: RaisedButton(
                    color: Color(0xffE71419),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(46)),
                    child: Text(
                      "立即找回",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          color: Colors.white),
                    ),
                    onPressed: () {
                      print('立即注册按钮');
                      register();
//                  NavigatorUtils.perfectInformationPage(context);
                    },
                  ),
                ),
              ]),
            )),
        resizeToAvoidBottomPadding: false,
      ),
    );
  }
}

