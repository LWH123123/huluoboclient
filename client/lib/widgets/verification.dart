import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/toast_util.dart';
import '../widgets/loading.dart';
import '../common/regExp.dart';
import '../service/user_service.dart';

/*
* 倒计时按钮
*/
class FormCode extends StatefulWidget {
  final int countdown; //倒计时的秒数，默认60秒
  final String phone;
  final String type;
  // final Function onTapCallback; //用户点击时的回调函数
  final bool available;

  FormCode({
    @required this.countdown,
    @required this.phone,
    @required this.type,
    // this.onTapCallback,
    @required this.available,
  }); //是否可以获取验证码，默认为"false"

  @override
  State createState() => _FormCodeState();
}

class _FormCodeState extends State<FormCode> {
  bool isLoading = false;
  String jwt = '';
  Timer _timer; //倒计时的计时器
  int _seconds; //当前倒计时的秒数
  String _verifyStr = "获取验证码"; ////当前墨水瓶（"InkWell"）的文本
  bool isClickDisable = false; //防止点击过快导致Timer出现无法停止的问题
  @override
  void initState() {
    super.initState();
    _seconds = widget.countdown;
  }

  @override
  void dispose() {
    // implement dispose
    super.dispose();
  }

  void sendSms() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("phone", () => widget.phone);
    map.putIfAbsent("t", () => widget.type);

    UserServer().getCode(map, (success) async {
      _startTimer();
      _verifyStr = "已发送$_seconds" + "s";
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //启动倒计时计时器
  void _startTimer() {
    isClickDisable = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        isClickDisable = false;
        _seconds = widget.countdown;
        _verifyStr = "重新发送";
        setState(() {});
        _cancleTimer();
        return;
      }
      _seconds--;
      _verifyStr = "已发送$_seconds" + "s";
      setState(() {});
    });
  }

  //取消到倒计时的计时器
  void _cancleTimer() {
    isClickDisable = false;
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //墨水瓶组件，响应触摸的矩形区域
    if (isClickDisable == null) {
      isClickDisable = false; //防止空指针异常
    }
    Widget loading = LoadingDialog();
    return Stack(
      children: <Widget>[
        widget.available
            ? InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: PublicColor.themeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$_verifyStr',
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: ScreenUtil().setSp(24),
                    ),
                  ),
                ),
                onTap: (_seconds == widget.countdown) && !isClickDisable
                    ? () {
                        if (!RegExpTest.exp.hasMatch(widget.phone)) {
                          ToastUtil.showToast('请输入正确的手机号');
                          return;
                        }
                        sendSms();
                        // 正在倒计时

                        setState(() {});
                      }
                    : null,
              )
            : InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: Color(0xffeeeeee),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "获取验证码",
                    style: TextStyle(
                      // color: Color(0xff999999),
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ),
                ),
                onTap: () {
                  ToastUtil.showToast('请输入手机号');
                },
              ),
        isLoading ? loading : Container()
      ],
    );
  }
}
