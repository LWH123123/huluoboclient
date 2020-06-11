
import 'package:client/common/color.dart';
import 'package:client/common/select_picture.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TeacherScreen extends StatefulWidget {
  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _name = TextEditingController(), //
      _realname = TextEditingController(),
      _idcard = TextEditingController(),
      _phone = TextEditingController(),
      _desc = TextEditingController(),
      _img1 = TextEditingController(),
      _img2 = TextEditingController(),
      _img3 = TextEditingController(),
      _qq = TextEditingController(),
      _qqqun = TextEditingController(),
      _qrcode = TextEditingController(),
      _pic = TextEditingController(),
      _kid = TextEditingController();
  int groupValuea = 1;
  int groupLiveType;
  List courseType = [];
  bool radio = false;
  String agree;
  // 课程分类
  getCourseType() {
    CourseService().getCourseType(
        {"page": 1},
        (onSuccess) => setState(() {
              courseType = onSuccess;
            }),
        (onFail) => ToastUtil.showToast(onFail));
  }

  // 身份证正面
  setIdentityImgOne(setImg) {
    setState(() {
      _img1.text = setImg['url'];
    });
  }

  // 身份证反面
  setIdentityImgTow(setImg) {
    setState(() {
      _img2.text = setImg['url'];
    });
  }

  // 身份证手持
  setIdentityImgThree(setImg) {
    setState(() {
      _img3.text = setImg['url'];
    });
  }

  // 二维码图片
  setQRcodeImg(setImg) {
    setState(() {
      _qrcode.text = setImg['url'];
    });
  }

  // 讲师头像
  setHeadPortrait(setImg) {
    setState(() {
      _pic.text = setImg['url'];
    });
  }

  submit() {
    var _form = _formKey.currentState;
    if (_kid.text == '')
      return ToastUtil.showToast('请选择课程');
    else if (_name.text == '')
      return ToastUtil.showToast('请输入姓名');
    else if (_phone.text == '')
      return ToastUtil.showToast('请输入手机号');
    else if (_desc.text == '')
      return ToastUtil.showToast('请输入介绍信息');
    else if (_img1.text == '')
      return ToastUtil.showToast('请上传身份证正面图片');
    else if (_img2.text == '')
      return ToastUtil.showToast('请上传身份证反面图片');
    else if (_img3.text == '')
      return ToastUtil.showToast('请上传身份证手持图片');
    else if (_qrcode.text == '')
      return ToastUtil.showToast('请上传二维码');
    else if (_pic.text == '')
      return ToastUtil.showToast('请上传讲师头像');
    else if (_form.validate()) {
      if (!radio) return ToastUtil.showToast('请同意并查看跨融直播协议');
      _form.save();
      UserServer().getApplylecturer({
        "name": _name.text,
        "phone": _phone.text,
        "desc": _desc.text,
        "img1": _img1.text,
        "img2": _img2.text,
        "img3": _img3.text,
        "kid": groupLiveType,
        "realname": _realname.text,
        "idcard": _idcard.text,
        "qq": _qq.text,
        "qqqun": _qqqun.text,
        "qrcode": _qrcode.text,
        "pic": _pic.text
      }, (success) async {
        ToastUtil.showToast('审核中');
        
        await Future.delayed(Duration(seconds: 1), () {
          // NavigatorUtils.goCreateCourse(context);
           Navigator.of(context).pop();
        });
      }, (onFail) => ToastUtil.showToast(onFail));
    }
  }
  getAbout () {
    CourseService().getAbout({}, (onSuccess) {
      setState(() {
        agree = onSuccess['res']['agree'];
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }
  @override
  void initState() {
    // TODO: implement initState
    this.getAbout();
    this.getCourseType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('申请讲师'),
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
                              '选择课程',
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
                                  controller: _kid,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "请选择课程类型",
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
                                controller: _name,
                                keyboardType: TextInputType.text,
                                validator: (val) =>
                                    (val == '' ? "请输入姓名" : null),
                                onSaved: (val) => (_name.text = val),
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
                                controller: _phone,
                                keyboardType: TextInputType.phone,
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
                    maxLines: 6,
                    validator: (val) => (val == '' ? "请输入介绍信息" : null),
                    onSaved: (val) => (_desc.text = val),
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogImageType(setIdentityImgOne));
                            },
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogImageType(setIdentityImgTow));
                            },
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
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogImageType(setIdentityImgThree));
                            },
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
                                    (val == '' ? "请输入真实姓名" : null),
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
                    Container(
                      padding: EdgeInsetsFromLTRB(30, 0, 30, 0),
                      decoration: boxDe(),
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              'QQ号',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _qq,
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    (val == '' ? "请输入个人QQ" : null),
                                onSaved: (val) => (_qq.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入个人QQ",
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
                              'QQ群',
                              style: textStyle(PublicColor.textColor, 28),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                autofocus: false,
                                controller: _qqqun,
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    (val == '' ? "请输入聊天QQ群" : null),
                                onSaved: (val) => (_qqqun.text = val),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入聊天QQ群",
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 28),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(29)),
                    Container(
                      padding: EdgeInsetsFromLTRB(100, 0, 100, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setWidth(34)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            DialogImageType(setQRcodeImg));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      _qrcode.text != ''
                                          ? Image.network(
                                              _qrcode.text,
                                              fit: BoxFit.cover,
                                              width: ScreenUtil().setWidth(182),
                                              height:
                                                  ScreenUtil().setWidth(182),
                                            )
                                          : Image.asset(
                                              'assets/teacher/icon_tianjia@2x.png',
                                              width: ScreenUtil().setWidth(182),
                                              height:
                                                  ScreenUtil().setWidth(182),
                                            ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(24)),
                                        child: Text('上传讲师二维码',
                                            style: textStyle(
                                                PublicColor.textColor, 28)),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            DialogImageType(setHeadPortrait));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      _pic.text != ''
                                          ? Image.network(
                                              _pic.text,
                                              fit: BoxFit.cover,
                                              width: ScreenUtil().setWidth(182),
                                              height:
                                                  ScreenUtil().setWidth(182),
                                            )
                                          : Image.asset(
                                              'assets/teacher/icon_tianjia@2x.png',
                                              width: ScreenUtil().setWidth(182),
                                              height:
                                                  ScreenUtil().setWidth(182),
                                            ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(24)),
                                        child: Text('上传讲师照片',
                                            style: textStyle(
                                                PublicColor.textColor, 28)),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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

  // 课程类型
  Widget DialogType() {
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
                Text('课程类型',
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
              children: courseType
                  .map((item) => RadioListTile<int>(
                        value: int.parse(item['id']),
                        dense: true,
                        isThreeLine: false,
                        selected: false,
                        activeColor: PublicColor.themeColor,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(item['name'],
                            style: StyleUtil.tontStyle(
                                color: PublicColor.textColor)),
                        groupValue: groupLiveType,
                        onChanged: (int value) {
                          setState(() {
                            groupLiveType = value;
                            _kid.text = item['name'];
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
}
