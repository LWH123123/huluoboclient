import 'dart:convert';
import 'package:client/common/color.dart';
import 'package:client/common/regExp.dart';
import 'package:client/common/select_picture.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ApplyLive extends StatefulWidget {
  @override
  _ApplyLiveState createState() => _ApplyLiveState();
}

class _ApplyLiveState extends State<ApplyLive> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _userName = TextEditingController(),
      _userPhone = TextEditingController(),
      _desc = TextEditingController(),
      _img1 = TextEditingController(),
      _img2 = TextEditingController(),
      _img3 = TextEditingController(),
      _realname = TextEditingController(),
      _idcard = TextEditingController(),
      liveType = TextEditingController(),
      classify = TextEditingController();

  bool radio = false;
  //讲师分类
  int lecturerClassify;
  // 直播分类
  int groupClassify;

  // 主播类型
  int groupLiveType;

  List typeLive = [], courseType = [];
  String agree;

  getLiveType() {
    LiveServer().getLiveType({"type": 2}, (onSuccess) {
      setState(() {
        typeLive = onSuccess;
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }
  // 课程分类
  getCourseType() {
    CourseService().getCourseType(
        {"page": 1},
            (onSuccess) => setState(() {
          courseType = onSuccess;
        }),
            (onFail) => ToastUtil.showToast(onFail));
  }
  getAbout () {
    CourseService().getAbout({}, (onSuccess) {
      setState(() {
        agree = onSuccess['res']['agree'];
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }
  submit() {
    var _form = _formKey.currentState;
    if (groupLiveType == null) return ToastUtil.showToast('请选择主播类型');
    else if (groupLiveType == 1 && groupClassify == null) return ToastUtil.showToast('请选择课程分类');
    else if (groupLiveType == 2 && groupClassify == null) return ToastUtil.showToast('请选择主播分类');
    else if (_img1.text == '') return ToastUtil.showToast('请上传身份证正面图片');
    else if (_img2.text == '') return ToastUtil.showToast('请上传身份证反面图片');
    else if (_img3.text == '') return ToastUtil.showToast('请上传身份证手持图片');
    if (_form.validate()) {
      if (!radio) return ToastUtil.showToast('请同意并查看跨融直播协议');
      Map<String, dynamic> entity = {
        "type": groupLiveType,
        "name": _userName.text,
        "phone": _userPhone.text,
        "desc": _desc.text,
        "img1": _img1.text,
        "img2": _img2.text,
        "img3": _img3.text,
        "kid": groupClassify,
        "realname": _realname.text,
        "idcard": _idcard.text
      };
      print(entity);
      getApplyOpen(entity);
    }
  }

//申请直播
  getApplyOpen(map) {
    LiveServer().getApplyOpen(
        map, (onSuccess) async {
      ToastUtil.showToast('已申请等待审核');
      await Future.delayed(Duration(seconds: 1), () =>Navigator.of(context).pop());
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getCourseType();
    this.getLiveType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('申请直播'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsetsFromLTRB(24, 24, 24, 7),
                decoration: BoxShadow_style(),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '主播类型',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DialogType());
                              },
                              child: TextFormField(
                                  autofocus: false,
                                  controller: liveType,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "请选择主播类型",
                                    hintStyle: textStyle(
                                        PublicColor.inputHintColor, 28),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              groupLiveType == 2 || groupLiveType == null ? '直播分类' : '课程分类',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogDefinition()),
                              child: TextFormField(
                                  autofocus: false,
                                  controller: classify,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: groupLiveType == 2 || groupLiveType == null ? "请选择直播分类" : '请选择课程分类',
                                    hintStyle: textStyle(
                                        PublicColor.inputHintColor, 28),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '姓名',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _userName,
                                validator: (val) =>
                                    (val == '' ? "请输入姓名":
                                    !RegExpTest.checkformate.hasMatch(val) ? '姓名格式不对': null
                                    ),
                                onSaved: (val) => (_userName.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入姓名",
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 28),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '手机号',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _userPhone,
                                keyboardType: TextInputType.phone,
                                validator: (val) =>
                                    (val == '' ? "请输入手机号" : !RegExpTest.regMobile.hasMatch(val) ? '手机号格式不对' : null),
                                onSaved: (val) => (_userPhone.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入手机号",
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 28),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsetsFromLTRB(24, 24, 24, 7),
                padding: EdgeInsetsFromLTRB(25, 0, 25, 0),
                decoration: BoxShadow_style(),
                child: TextFormField(
                    autofocus: false,
                    controller: _desc,
                    validator: (val) => (val == '' ? "请输入介绍信息" : !RegExpTest.checkformate.hasMatch(val) ? '介绍信息格式不对': null),
                    onSaved: (val) => (_desc.text = val),
                    maxLines: 6,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "请输入介绍信息",
                      hintStyle: textStyle(PublicColor.inputHintColor, 28),
                    )),
              ),
              Container(
                margin: EdgeInsetsFromLTRB(24, 24, 24, 7),
                padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                decoration: BoxShadow_style(),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(29)),
                      alignment: Alignment.centerLeft,
                      child: Text('身份证信息',
                          style: textStyle(PublicColor.textColor, 28)),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(34)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogImageType((item) => setState(
                                        () => _img1.text = item['url']))),
                            child: Column(
                              children: <Widget>[
                                _img1.text != ''
                                    ? Image.network(
                                        _img1.text,
                                        fit: BoxFit.cover,
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      )
                                    : Image.asset(
                                        'assets/teacher/img_sfzzm@2x.png',
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(24)),
                                  child: Text('点击上传身份证正面',
                                      style:
                                          textStyle(PublicColor.textColor, 28)),
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogImageType((item) => setState(
                                        () => _img2.text = item['url']))),
                            child: Column(
                              children: <Widget>[
                                _img2.text != ''
                                    ? Image.network(
                                        _img2.text,
                                        fit: BoxFit.cover,
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      )
                                    : Image.asset(
                                        'assets/teacher/img_sfzfm@2x.png',
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(24)),
                                  child: Text('点击上传身份证反面',
                                      style:
                                          textStyle(PublicColor.textColor, 28)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogImageType((item) => setState(
                                        () => _img3.text = item['url']))),
                            child: Column(
                              children: <Widget>[
                                _img3.text != ''
                                    ? Image.network(
                                        _img3.text,
                                        fit: BoxFit.cover,
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      )
                                    : Image.asset(
                                        'assets/teacher/img_scsfzd@2x.png',
                                        width: ScreenUtil().setWidth(313),
                                        height: ScreenUtil().setWidth(199),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil().setWidth(24)),
                                  child: Text('点击上传手持身份证',
                                      style:
                                          textStyle(PublicColor.textColor, 28)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsetsFromLTRB(24, 24, 24, 7),
                decoration: BoxShadow_style(),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '真实姓名',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _realname,
                                validator: (val) =>
                                    (val == '' ? "请输入真实姓名" : !RegExpTest.checkformate.hasMatch(val) ? '真实姓名格式不对': null),
                                onSaved: (val) => (_realname.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入真实姓名",
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 28),
                                )),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '身份证号',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _idcard,
                                validator: (val) =>
                                    (val == '' ? "请输入身份证号" : null),
                                onSaved: (val) => (_idcard.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入身份证号",
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 28),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setWidth(29)),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                            child: Image.asset(radio ? 'assets/login/icon_xuanzhong.png':'assets/login/icon_weixuanzhong.png',
                                width: StyleUtil.width(32),
                                height: StyleUtil.width(32)),
                            onTap: () {
                              setState(() {
                                radio ? radio = false : radio = true;
                              });
                            },
                          ),
                          SizedBox(width: StyleUtil.width(20),),
                          InkWell(
                            onTap: () {
                              this.agreement();
                            },
                            child: Row(
                              children: <Widget>[
                                Text('同意并查看',
                                    style: textStyle(PublicColor.textColor, 28)),
                                Text('【跨融直播】',
                                    style: textStyle(PublicColor.themeColor, 28)),
                                Text('协议',
                                    style: textStyle(PublicColor.textColor, 28))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(29)),
                    Container(
                      width: ScreenUtil().setWidth(640),
                      height: ScreenUtil().setWidth(85),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(46))),
                        color: PublicColor.themeColor,
                        textColor: PublicColor.whiteColor,
                        child: Text('提交'),
                        onPressed: () {
                          // 创建课程
                          print('提交点击事件');
                          submit();
                          //NavigatorUtils.goCreateLive(context);
                        },
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(29)),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // 上传图片弹出
  Widget DialogImageType(succeed) {
    return Container(
      height: StyleUtil.width(350),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
            BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('上传图片',
                    style: StyleUtil.tontStyle(
                        color: PublicColor.textColor,
                        num: 28,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset('assets/mine/icon_guanbi.png',
                      width: StyleUtil.width(40)),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: StyleUtil.width(200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: StyleUtil.width(150),
                    height: StyleUtil.width(150),
                    child: RaisedButton(
                      shape: CircleBorder(
                          side: BorderSide(color: PublicColor.themeColor)),
                      color: PublicColor.themeColor,
                      child: new Text(
                        '相册',
                        style: new TextStyle(color: PublicColor.whiteColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        SelectPicture().getImageGallery((res) => succeed(res));
                      },
                    )),
                SizedBox(width: StyleUtil.width(150)),
                Container(
                    width: StyleUtil.width(150),
                    height: StyleUtil.width(150),
                    child: RaisedButton(
                      shape: CircleBorder(
                          side: BorderSide(color: PublicColor.themeColor)),
                      color: PublicColor.themeColor,
                      child: new Text(
                        '拍照',
                        style: new TextStyle(color: PublicColor.whiteColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        SelectPicture().getImageCamera((res) => succeed(res));
                      },
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  // 直播分类
  Widget DialogDefinition() {
    return Container(
      height: StyleUtil.width(600),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
                BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(groupLiveType == 2 || groupLiveType == null ? '直播分类' : '课程分类',
                    style: StyleUtil.tontStyle(
                        color: PublicColor.textColor,
                        num: 28,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset('assets/mine/icon_guanbi.png',
                      width: StyleUtil.width(40)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView( // courseType
              children: groupLiveType == 2 || groupLiveType == null ? typeLive
                  .map((item) => RadioListTile<int>(
                        value: item['id'],
                        dense: true,
                        isThreeLine: false,
                        selected: false,
                        activeColor: PublicColor.themeColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(item['name'],
                            style: StyleUtil.tontStyle(
                                color: PublicColor.textColor)),
                        groupValue: groupClassify,
                        onChanged: (int value) {
                          setState(() {
                            groupClassify = value;
                            classify.text = item['name'];
                          });
                          Navigator.of(context).pop();
                        },
                      ))
                  .toList() : courseType.map((item) => RadioListTile<int>(
                value: int.parse(item['id']),
                dense: true,
                isThreeLine: false,
                selected: false,
                activeColor: PublicColor.themeColor,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(item['name'],
                    style: StyleUtil.tontStyle(
                        color: PublicColor.textColor)),
                groupValue: groupClassify,
                onChanged: (int value) {
                  setState(() {
                    groupClassify = value;
                    classify.text = item['name'];
                  });
                  Navigator.of(context).pop();
                },
              ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  // 直播类型
  Widget DialogType() {
    return Container(
      height: StyleUtil.width(350),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
                BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('主播类型',
                    style: StyleUtil.tontStyle(
                        color: PublicColor.textColor,
                        num: 28,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset('assets/mine/icon_guanbi.png',
                      width: StyleUtil.width(40)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                RadioListTile<int>(
                  value: 1,
                  dense: true,
                  isThreeLine: false,
                  selected: false,
                  activeColor: PublicColor.themeColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text("讲师",
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                  groupValue: groupLiveType,
                  onChanged: (int value) {
                    setState(() {
                      groupLiveType = value;
                      liveType.text = '讲师';
                      classify.text = '';
                      groupClassify = null;
                      lecturerClassify = null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<int>(
                    value: 2,
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text("主播",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    groupValue: groupLiveType,
                    onChanged: (int value) {
                      setState(() {
                        groupLiveType = value;
                        liveType.text = '主播';
                        classify.text = '';
                        groupClassify = null;
                        lecturerClassify = null;
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

// 协议弹出
  agreement () {
    showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            height: ScreenUtil().setWidth(697),
            width: ScreenUtil().setWidth(697),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    '跨融直播协议',
                    style: TextStyle(
                        color: PublicColor.textColor,
                        fontSize: ScreenUtil().setSp(32)),
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(43)),
                Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Text(agree!= null ? agree : '',
                          style: TextStyle(
                              color: PublicColor.textColor,
                              fontSize: ScreenUtil().setSp(28))),
                    )
                )
              ],
            ),
          ),
        ));
  }


  BoxDecoration boxDe() {
    return BoxDecoration(
      border: Border(bottom: BorderSide(color: PublicColor.borderColor)),
    );
  }

  BoxDecoration BoxShadow_style() {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(108, 108, 108, 0.46),
              offset: Offset(0.0, 2), //阴影xy轴偏移量
              blurRadius: 5, //阴影模糊程度
              spreadRadius: 1 //阴影扩散程度
              )
        ]);
  }

  EdgeInsets EdgeInsetsFromLTRB(
      double left, double top, double right, double bottom) {
    return EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(left),
        ScreenUtil().setWidth(top),
        ScreenUtil().setWidth(right),
        ScreenUtil().setWidth(bottom));
  }

  TextStyle textStyle(Color col, double size) {
    return TextStyle(color: col, fontSize: ScreenUtil().setSp(size));
  }
}
