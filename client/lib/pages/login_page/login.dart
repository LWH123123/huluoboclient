import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwxlogin;
import '../../widgets/verification.dart';
import 'package:flutter_qq/flutter_qq.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:apifm/apifm.dart' as Apifm;

class Login extends StatefulWidget {
  final String type;
  Login({this.type});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DateTime lastPopTime;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _realname = TextEditingController(),
      _password = TextEditingController(),
      _code = TextEditingController(),
      _phone = TextEditingController();

  String phone = '';
  int loginType = 1;
  bool codeActive = false; //获取验证码按钮状态
  bool isButtonEnable = true; //按钮状态 是否可点击
  String buttonText = '获取验证码'; //初始文本
  int count = 60; //初始倒计时时间
  Timer timer; //倒计时的计时器
  String type = 'login';
  String type1 = 'login';


  login() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      Map<String, dynamic> map = Map();
      if (loginType == 1) {
        map.putIfAbsent("real_name", () => _realname.text.trim());
        map.putIfAbsent("password", () => _password.text.trim());
        this.account_password(map);
      } else {
        map.putIfAbsent("phone", () => _phone.text.trim());
        map.putIfAbsent("code", () => _code.text.trim());
        this.note_login(map);
      }
    }
  }

  // 短信登录--请求
  note_login(e) {
    print('短信登录----' + e.toString());
    UserServer().getUserInfo(e, (onSuccess) async {
      ToastUtil.showToast('登录成功');
      print(onSuccess);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', onSuccess['jwt']);
      await prefs.setInt('uid', onSuccess['user']['id']);
      await Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.goHomePage(context);
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // 账号密码登录--请求
  account_password(map) {
    print("账号密码登录--" + map.toString());
    UserServer().getPwdLogin(map, (onSuccess) async {
      ToastUtil.showToast('登录成功');
      print(onSuccess);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt', onSuccess['jwt']);
      await prefs.setInt('uid', onSuccess['user']['id']);
      await Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.goHomePage(context);
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  info() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
    prefs.remove('uid');
  }

  @override
  void initState() {
    super.initState();
    wxLoginListen();
    type = 'login';
  }

  void wxLoginListen() {
    fluwxlogin.responseFromAuth.listen((data) async {
      print("payLoginaaaa ==================== ======== ======:$data");
      if (data.errCode.toString() == "0") {
        if (type == 'login' && type1 == 'login') {
          Map<String, dynamic> map = Map();
          map.putIfAbsent("code", () => data.code);

          UserServer().wxLogin(map, (success) async {
            ToastUtil.showToast('登录成功');
            final prefs = await SharedPreferences.getInstance();
            // 存值
            await prefs.setString('jwt', success['jwt']);
            await prefs.setInt('uid', success['user']['id']);
            await Future.delayed(Duration(seconds: 1), () {
              NavigatorUtils.goHomePage(context);
            });
          }, (onFail) async {
            ToastUtil.showToast(onFail);
          });
        }
      } else {
        ToastUtil.showToast('授权失败');
      }
    });
  }
  void processLoginSuccess (token, uid) async {
    // 登录成功后处理
    // await AuthHandle.login(token, uid);
    Fluttertoast.showToast(msg: "登录成功!", gravity: ToastGravity.CENTER, fontSize: 14);
    Navigator.pop(context);
  }


  loginQQ () async {
    FlutterQq.registerQQ('101876612');
    var result = await FlutterQq.isQQInstalled();
    print("isQQInstalled>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${result}");
    if (result) {
      print('QQ已安装');
      qq_callBack();
    } else {
      ToastUtil.showToast('请安装QQ');
    }
  }
  qq_callBack () async {
    try {
      var qqResult = await FlutterQq.login();
      var output;
      if (qqResult.code == 0) {
        output = "登录成功" + qqResult.response.toString();
      } else if (qqResult.code == 1) {
        output = "登录失败" + qqResult.message;
      } else {
        output = "用户取消";
      }
      print('qqResult>>>>>>>>>>>>>>>>>>>>>>>${output}');
    } catch (error) {
      print("flutter_plugin_qq_example:" + error.toString());
    }
//    var res = await Apifm.loginQQConnect(appid, qqResult.response['openid'], qqResult.response['accessToken']);
  }
  @override
  void dispose() {
    type = 'bind';
    super.dispose();
  }

  //微信登录
  void wechatLogin() async {
    fluwxlogin.isWeChatInstalled().then((installed) {
      if (installed) {
        fluwxlogin
            .sendWeChatAuth(
                scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
            .then((data) {});
      } else {
        ToastUtil.showToast("请先安装微信");
      }
    });
  }
  


  @override
  Widget build(BuildContext context) {
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
    Widget passname = Form(
      key: _formKey,
      // alignment: Alignment.center,
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setHeight(90),
              top: ScreenUtil().setHeight(19),
              right: ScreenUtil().setHeight(87)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
          child: new Row(
            children: <Widget>[
              Container(
                width: StyleUtil.width(60),
                child: Image.asset(
                  'assets/login/icon_shouji.png',
                  height: ScreenUtil().setHeight(38),
                  width: ScreenUtil().setWidth(34),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: TextFormField(
                    autofocus: false,
                    controller: _realname,
                    validator: (val) => (val == '' ? "请输入用户名" : null),
                    onSaved: (val) => (_realname.text = val),
                    decoration: new InputDecoration(
                        hintText: '请输入用户名', border: InputBorder.none),
                  )),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setHeight(90),
              right: ScreenUtil().setHeight(87)),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
          child: new Row(
            children: <Widget>[
              Container(
                width: StyleUtil.width(60),
                child: Image.asset(
                  'assets/login/icon_yanzhengma.png',
                  height: ScreenUtil().setHeight(38),
                  width: ScreenUtil().setWidth(34),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: new TextFormField(
                    autofocus: false,
                    controller: _password,
                    obscureText: true,
                    validator: (val) => (val == '' ? "请输入密码" : null),
                    onSaved: (val) => (_password.text = val),
                    decoration: new InputDecoration(
                        hintText: '请输入登录密码', border: InputBorder.none),
                  )),
            ],
          ),
        )
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
          //     registerForm();
          this.login();
//          NavigatorUtils.goHomePage(context);
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
              onTap: () => {NavigatorUtils.goRetrievePasswordPage(context)},
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
          setState(() {
            loginType == 1 ? loginType = 2 : loginType = 1;
            _realname.text = '';
            _password.text = '';
            _phone.text = '';
            _code.text = '';
            if (count < 60) {
              timer.cancel();
              count = 60;
            }
            buttonText = '获取验证码';
          });
        },
        child: Text(
          loginType == 1 ? '短信方式登录' : '账号密码登录',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(26),
              color: Color(0xffFA4240),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
    Widget socialContactID = Container(
      // alignment: Alignment.center,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(110)),

      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(0),//150
            height: ScreenUtil().setHeight(0),//1
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(124)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff545454)))),
          ),
          Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(0),//20
              right: ScreenUtil().setWidth(0),//23
            ),
            child: Text(
              '',//社交账号登录
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(26),
                color: Color(0xff545454),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(0),//150
            height: ScreenUtil().setHeight(0),//1
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(124)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff545454)))),
          ),
        ],
      ),
    );
    Widget weChatQQ = Container(
      width: 0,
      height: 0,
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(59)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              print('微信登录');
              wechatLogin();
            },
            child: new Image.asset(
              'assets/login/icon_weixin.png',
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              fit: BoxFit.cover,
            ),
          ),
          /*InkWell(
            onTap: () {
              print('qq登录');
              loginQQ();
            },
            child: new Image.asset(
              'assets/login/icon_qq.png',
              width: ScreenUtil().setWidth(80),
            ),
          )*/
        ],
      ),
    );
    Widget passlogin = Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setHeight(90),
                top: ScreenUtil().setHeight(19),
                right: ScreenUtil().setHeight(87)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
            child: new Row(
              children: <Widget>[
                Container(
                  width: StyleUtil.width(60),
                  child: Image.asset(
                    'assets/login/icon_shouji.png',
                    height: ScreenUtil().setHeight(38),
                    width: ScreenUtil().setWidth(34),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: new TextFormField(
                      controller: _phone,
                      validator: (val) => (val == '' ? "请输入手机号" : null),
                      onSaved: (val) => (_phone.text = val),
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      decoration: new InputDecoration(
                          hintText: '请输入手机号', border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          codeActive = value.length == 0 ? false : true;
                          phone = value;
                        });
                      },
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setHeight(90),
                right: ScreenUtil().setHeight(87)),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xffBFBFBF)))),
            child: new Row(
              children: <Widget>[
                Container(
                  width: StyleUtil.width(60),
                  child: Image.asset(
                    'assets/login/icon_yanzhengma.png',
                    height: ScreenUtil().setHeight(38),
                    width: ScreenUtil().setWidth(34),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _code,
                      autofocus: false,
                      validator: (val) => (val == '' ? "请输入验证码" : null),
                      onSaved: (val) => (_code.text = val),
                      decoration: new InputDecoration(
                        hintText: '验证码',
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
                    splashColor: isButtonEnable
                        ? Colors.white.withOpacity(0.1)
                        : Colors.transparent,
                    shape: StadiumBorder(side: BorderSide.none),
                    onPressed: () {
                      // setState(() {
                      //   _buttonClickListen();
                      // });
                      // _initTimer();
                      // sendCode();
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
              ],
            ),
          )
        ],
      ),
    );
    return WillPopScope(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Stack(//body
                children: <Widget>[
              Container(
                  child: Column(
                children: <Widget>[
                  background,
                  loginType == 1 ? passname : passlogin,
                  btnArea,
                  findPassWord,
                  noteLogin,
                  socialContactID,
                  weChatQQ
                ],
              ))
            ])
          ],
        ),
        resizeToAvoidBottomPadding: false,
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showToast('再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}
