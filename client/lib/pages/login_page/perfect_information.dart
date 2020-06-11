import 'dart:convert';

import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerfectInformation extends StatefulWidget {
  String id;

  PerfectInformation({Key key, String this.id}) : super(key: key);

  @override
  _PerfectInformationState createState() => _PerfectInformationState();
}

class _PerfectInformationState extends State<PerfectInformation> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _referralCode = TextEditingController(),
      _nickname = TextEditingController(),
      _sex = TextEditingController(),
      _birthday = TextEditingController();
  int sex = 1;
  String startTime = '';

  @override
  void initState() {
    // TODO: implement initState
    print('PerfectInformation----------${widget.id}');
    _sex.text = '1';
    super.initState();
  }

  submitClick() {
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      // Map<String, dynamic> mapName = new Map();
      // mapName.putIfAbsent('uid', () => widget.id);
      // mapName.putIfAbsent('shangji', () => _referralCode.text.trim());
      // mapName.putIfAbsent('nickname', () => _nickname.text.trim());
      // mapName.putIfAbsent('birthday', () => _birthday.text);
      // mapName.putIfAbsent('sex', () => _sex.text);
      Map obj = {
        "uid":widget.id,
        "shangji":_referralCode.text,
        "nickname":_nickname.text,
        "birthday":_birthday.text,
        "sex":_sex.text
      };
      NavigatorUtils.interestPage(context, obj);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                child: Image.asset('assets/login/bg_wanshanxinxi.png',
                    fit: BoxFit.cover)),
            Center(
                child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(180)),
                    child: Text('完善信息',
                        style: TextStyle(
                            color: PublicColor.whiteColor,
                            fontSize: ScreenUtil().setSp(56))))),
            Container(
              padding: StyleUtil.padding(top: 50),
              child: IconButton(
                icon: Icon(Icons.navigate_before,color: Colors.white,size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            )
          ],
        ),
        Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(28),
                right: ScreenUtil().setWidth(28),
                top: ScreenUtil().setWidth(18)),
            decoration: new BoxDecoration(
                color: PublicColor.whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(108, 108, 108, 0.46),
                      offset: Offset(0.0, 2), //阴影xy轴偏移量
                      blurRadius: 15.0, //阴影模糊程度
                      spreadRadius: 1.0 //阴影扩散程度
                      )
                ]),
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(28),
                          right: ScreenUtil().setWidth(28)),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: PublicColor.borderColor,
                                width: 0.5)), // 边色与边宽度
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('上级推荐码',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(28))),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              autofocus: false,
                              controller: _referralCode,
                              keyboardType: TextInputType.number,
                              validator: (val) => null,
                              onSaved: (val) => (_referralCode.text = val),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入上级推荐码",
                                  hintStyle: TextStyle(
                                      color: PublicColor.inputHintColor,
                                      fontSize: ScreenUtil().setSp(28))),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(28),
                          right: ScreenUtil().setWidth(28)),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: PublicColor.borderColor,
                                width: 0.5)), // 边色与边宽度
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('昵称',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(28))),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              autofocus: false,
                              controller: _nickname,
                              validator: (val) => (val == '' ? "请输入昵称" : null),
                              onSaved: (val) => (_nickname.text = val),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入昵称",
                                  hintStyle: TextStyle(
                                      color: PublicColor.textColor,
                                      fontSize: ScreenUtil().setSp(28))),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: PublicColor.borderColor,
                                width: 0.5)), // 边色与边宽度
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('性别',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(28))),
                          ),
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: <Widget>[
                                Container(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _sex.text = '1';
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                                _sex.text == '1'
                                                    ? 'assets/login/icon_xuanzhong.png'
                                                    : 'assets/login/icon_weixuanzhong.png',
                                                width:
                                                    ScreenUtil().setWidth(34),
                                                height:
                                                    ScreenUtil().setWidth(34)),
                                            Container(
                                              child: Text('男',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(28),
                                                      color: PublicColor
                                                          .inputHintColor)),
                                              margin: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(20)),
                                            )
                                          ],
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(120)),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _sex.text = '2';
                                          });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                                _sex.text == '2'
                                                    ? 'assets/login/icon_xuanzhong.png'
                                                    : 'assets/login/icon_weixuanzhong.png',
                                                width:
                                                    ScreenUtil().setWidth(34),
                                                height:
                                                    ScreenUtil().setWidth(34)),
                                            Container(
                                              child: Text('女',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(28),
                                                      color: PublicColor
                                                          .inputHintColor)),
                                              margin: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(20)),
                                            )
                                          ],
                                        ))),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: StyleUtil.paddingTow(left: 28),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text('出生年月',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(28))),
                          ),
                          Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(1960, 1, 1),
                                    maxTime: DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        0), onConfirm: (date) {
                                  setState(() {
                                    _birthday.text =
                                        date.toString().split(' ')[0];
                                  });
                                }, locale: LocaleType.zh);
                              },
                              child: TextFormField(
                                autofocus: false,
                                controller: _birthday,
                                enabled: false,
                                validator: (val) {
                                  if (val == '') ToastUtil.showToast('请选择生日');
                                  return null;
                                },
                                onSaved: (val) => (_birthday.text = val),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "请选择生日",
                                    hintStyle: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(28))),
                              ),
                            ), /*Container(
                            child: GestureDetector(
                                onTap: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(1960, 1, 1),
                                      maxTime: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          0), onConfirm: (date) {
                                    print(startTime == '' ? '1' : '2');
                                    setState(() {
                                      startTime = date.toString().split(' ')[0];
                                    });
                                  }, locale: LocaleType.zh);
                                },
                                child: Text(
                                    startTime == '' ? '出生日期' : startTime,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: PublicColor.inputHintColor))))*/
                          )
                        ],
                      ),
                    )
                  ],
                )) // Column(),
            ),
        Container(
            width: ScreenUtil().setWidth(570),
            height: ScreenUtil().setWidth(92),
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(96)),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(46))),
              color: PublicColor.themeColor,
              textColor: PublicColor.whiteColor,
              child: new Text('下一步'),
              onPressed: () {
                submitClick();
                //NavigatorUtils.interestPage(context);
              },
            ))
      ]),
      resizeToAvoidBottomPadding: false,
    );
  }
}
