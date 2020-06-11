import 'dart:async';
import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
class CaptchaLogin extends StatefulWidget {
  CaptchaLogin({Key key}) : super(key: key);

  @override
  _CaptchaLoginState createState() => _CaptchaLoginState();
}

class _CaptchaLoginState extends State<CaptchaLogin> {
  

  @override
  Widget build(BuildContext context) {
    String butText = '获取验证码';
    int butType = 0;
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget background = Container(
      //背景图片
      margin: EdgeInsets.only(top: 0),
      child: Stack(children: <Widget>[
        new Image.asset(
          'assets/login/bg_denglu.png',
          width: ScreenUtil().setWidth(750),
          height: ScreenUtil().setHeight(497),
          fit: BoxFit.fill,
        ),
        new Positioned(
          //logo图片
          top: ScreenUtil().setHeight(149),
          left: ScreenUtil().setWidth(146),
          child: Image.asset(
            'assets/login/icon_logo.png',
            width: ScreenUtil().setWidth(457),
            height: ScreenUtil().setHeight(253),
          ),
        ),
      ]),
    );
    
    Widget btnArea = Container(
      //width:double.infinity,
      height: ScreenUtil().setHeight(92),
      width: ScreenUtil().setWidth(571),
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(74)),
      child: RaisedButton(
        color: Color(0xffE71419),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(46)),
        child: Text(
          '登录',
          style:
              TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.white),
        ),
        onPressed: () {
          print('短信登录');
          //     registerForm();
          // NavigatorUtils.goHomePage(context);
        },
      ),
    );
    Widget findPassWord = Container(
      //找回密码，立即注册
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(119),
          right: ScreenUtil().setWidth(119),
          top: ScreenUtil().setHeight(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: InkWell(
              onTap: () => {
                NavigatorUtils.goRetrievePasswordPage(context)
              },
              child: Text(
                '找回密码',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
            ),
          ),
          Container(
            child: InkWell(
                onTap: () {
                  // LoginRegister();
                  print('注册按钮');
                  NavigatorUtils.registerPage(context);
                },
                child: Text(
                  '立即注册',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(26),
                  ),
                )),
          ),
        ],
      ),
    );
    Widget noteLogin = Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
      child: InkWell(
        onTap: () {
          NavigatorUtils.gologinPage(context);
        },
        child: Text(
          '账号密码登录',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(26),
            color: Color(0xffFA4240),
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );

    Widget socialContactID = Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(110)),

      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(1),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(124)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff545454)))),
          ),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(23),
            ),
            child: Text(
              '社交账号登录',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(26),
                color: Color(0xffFA4240),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setHeight(1),
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(124)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff545454)))),
          ),
        ],
      ),
    );

    Widget weChatQQ = Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(59)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Image.asset(
            'assets/login/icon_weixin.png',
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setWidth(80),
            fit: BoxFit.cover,
          ),
          new Image.asset(
            'assets/login/icon_qq.png',
            width: ScreenUtil().setWidth(80),
          )
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(),
        body: Stack(//body
            children: <Widget>[
          Container(
              child: Column(
            children: <Widget>[
              background,
              // passname,
              UserPas(),
              btnArea,
              findPassWord,
              noteLogin,
              socialContactID,
              weChatQQ
            ],
          ))
        ]),
      ),
    );
  }
}

class UserPas extends StatefulWidget {
  UserPas({Key key}) : super(key: key);

  @override
  _UserPasState createState() => _UserPasState();
}

class _UserPasState extends State<UserPas> {
  bool isLoading = false;
  String jwt = '', uid = '';
  String phone = '';
  String code = '';

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  //手机短信登录
  void phoneLogin() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("phone", () => _phoneController.text);
    map.putIfAbsent("code", () => _codeController.text);

    
  }

  String butText = '获取验证码';
  int butType = 0;
  int time = 60;
  Color butColor = Colors.white;
  Timer timeEntity;
  @override
  void dispose() {
    timeEntity?.cancel();
    timeEntity = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        new InkWell(
          child: new Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(
                left: ScreenUtil().setHeight(90),
                top: ScreenUtil().setHeight(19),
                right: ScreenUtil().setHeight(87)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    child: Image.asset(
                      'assets/login/icon_shouji.png',
                      height: ScreenUtil().setHeight(38),
                      width: ScreenUtil().setWidth(34),
                    ),
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: new TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      decoration: new InputDecoration(
                          hintText: '请输入手机号', border: InputBorder.none),
                    )),
              ],
            ),
          ),
        ),
        new InkWell(
          child: new Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(
                left: ScreenUtil().setHeight(90),
                right: ScreenUtil().setHeight(87)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new Container(
                    child: Image.asset(
                      'assets/login/icon_yanzhengma.png',
                      height: ScreenUtil().setHeight(38),
                      width: ScreenUtil().setWidth(34),
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: new TextField(
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      obscureText: true,
                      decoration: new InputDecoration(
                          hintText: '请输入验证码', border: InputBorder.none),
                    )),
                Expanded(
                    flex: 4,
                    child: RaisedButton(
                      child: Text(butText),
                      textColor: Color.fromRGBO(84, 84, 84, 1),
                      elevation: 0,
                      highlightElevation: 0,
                      disabledElevation: 0,
                      color: butColor,
                      onPressed: () {
                        setState(() {
                          if (butType == 1) {
                            butText = '获取验证码';
                            butType = 0;
                            return;
                          } else if (time < 60) {
                            return;
                          }
                          timeEntity = new Timer.periodic(
                              new Duration(seconds: 1), (timer) {
                            time -= 1;
                            print('$time--time时间');
                            setState(() {
                              if (time == 0) {
                                butText = '获取验证码';
                                butType = 1;
                                timeEntity.cancel();
                                time = 60;
                              } else {
                                butText = '($time)重新获取';
                              }
                            });
                          });
                          // if (butType == 0 && time < 60) return;
                          // if (butType == 0) {
                          //   butText = '($time)重新获取';

                          // } else {
                          //   butText = '获取验证码';
                          //   butType = 0;
                          // }
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
