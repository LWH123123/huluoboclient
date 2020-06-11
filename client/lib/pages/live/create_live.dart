
import 'package:client/common/color.dart';
import 'package:client/common/regExp.dart';
import 'package:client/common/select_picture.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateLive extends StatefulWidget {
  @override
  _CreateLiveState createState() => _CreateLiveState();
}

class _CreateLiveState extends State<CreateLive> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _courseName = TextEditingController(),
      _courseIntroduce = TextEditingController(),
      definition = TextEditingController(),
      classType = TextEditingController(),
      _amount = TextEditingController(),
      _img = TextEditingController(),
      grade = TextEditingController();

  // 清晰度
  int groupValue = 2;

  // 免费等级
  int groupGrade;

  // 直播分类
  int groupClassType;
  int is_live;
  List typeLive = [];

  getLiveType() {
    LiveServer().getLiveType({"type": 2}, (onSuccess) {
      setState(() {
        typeLive = onSuccess;
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  submit() {
//    NavigatorUtils.goOpenZhibo(context,{},true);
//    return;
    var _form = _formKey.currentState;
    if (groupClassType == null)
      return ToastUtil.showToast('请选择直播分类');
    else if (groupValue == null)
      return ToastUtil.showToast('请选择清晰度');
    else if (groupGrade == null)
      return ToastUtil.showToast('请选择免费等级');
    else if (_img.text == '')
      return ToastUtil.showToast('请上传直播封面图');
    else if (_form.validate()) {
      Map<String, dynamic> entity = {
        "name": _courseName.text,
        "desc": _courseIntroduce.text,
        "amount": _amount.text,
        "freelvl": groupGrade,
        "def": groupValue,
        "img": _img.text,
        "type": groupClassType,
      };
      print(entity);
      getCreateLive(entity);
    }
  }

  getCreateLive(map) {
    LiveServer().getCreateLive(map, (success) async {
      ToastUtil.showToast('直播创建成功');
      _courseName.text = '';
      _courseIntroduce.text = '';
      _amount.text = '';
      groupGrade = null;
      groupValue = null;
      _img.text = '';
      groupClassType = null;

       await Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.goOpenZhibo(context, success['live'],true);
      });

      // await Future.delayed(
      //     Duration(seconds: 1), () => Navigator.of(context).pop());
    }, (onFail) => ToastUtil.showToast(onFail));
  }
   getMy() async {
    UserServer().getMyApi({}, (success) async {
      print('user----------------------${success['user']}');
      setState(() {
       is_live = success['user']["is_live"];
      });
    }, (onFail) async {});
  }
  @override
  void initState() {
    // TODO: implement initState
    definition.text = '超清';
    this.getLiveType();
    this.getMy();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('创建直播'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: StyleUtil.padding(
                      left: 24, right: 24, top: 24, bottom: 7),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
                  decoration: BoxShadow_style(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) => DialogImageType(
                                (item) =>
                                    setState(() => _img.text = item['url']))),
                        child: Container(
                          margin:
                              EdgeInsets.only(right: ScreenUtil().setWidth(26)),
                          child: _img.text != ''
                              ? Image.network(
                                  _img.text,
                                  fit: BoxFit.cover,
                                  width: ScreenUtil().setWidth(182),
                                  height: ScreenUtil().setWidth(182),
                                )
                              : Image.asset(
                                  'assets/teacher/icon_tianjia@2x.png',
                                  width: ScreenUtil().setWidth(182),
                                  height: ScreenUtil().setWidth(182),
                                ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            autofocus: false,
                            controller: _courseName,
                            maxLines: 3,
                            validator: (val) => (val == '' ? "请输直播名称" : !RegExpTest.checkformate.hasMatch(val) ? '直播名称格式不对': null),
                            onSaved: (val) => (_courseName.text = val),
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "名字起的棒，直播销量就上榜~~~",
                              hintStyle: TextStyle(
                                  color: PublicColor.inputHintColor,
                                  fontSize: ScreenUtil().setSp(28)),
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: StyleUtil.padding(
                      left: 24, right: 24, top: 24, bottom: 7),
                  padding: StyleUtil.paddingTow(left: 30),
                  decoration: BoxShadow_style(),
                  child: TextFormField(
                      autofocus: false,
                      controller: _courseIntroduce,
                      maxLines: 4,
                      validator: (val) => (val == '' ? "请输入直播介绍" : !RegExpTest.checkformate.hasMatch(val) ? '直播介绍格式不对': null),
                      onSaved: (val) => (_courseIntroduce.text = val),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入直播介绍",
                        hintStyle: TextStyle(
                            color: PublicColor.inputHintColor,
                            fontSize: ScreenUtil().setSp(28)),
                      )),
                ),
                Container(
                  margin: StyleUtil.padding(
                      left: 24, right: 24, top: 24, bottom: 7),
                  decoration: BoxShadow_style(),
                  child: Column(
                    children: <Widget>[
                      is_live == 1 ? SizedBox():
                      Container(
                        padding: StyleUtil.paddingTow(left: 30),
                        decoration: boxDe(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '直播带货',
                                style: StyleUtil.tontStyle(
                                    color: Color(0xff1D1D1D)),
                              ),
                              width: ScreenUtil().setWidth(184),
                              padding: StyleUtil.paddingTow(top: 30),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  NavigatorUtils.goLiveGoods(context);
                                },
                                child: TextFormField(
                                    autofocus: false,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请选择直播带货商品及店铺",
                                      hintStyle: TextStyle(
                                          color: PublicColor.inputHintColor,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30),
                          right: ScreenUtil().setWidth(30),
                        ),
                        decoration: boxDe(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '直播分类',
                                style: TextStyle(
                                    color: Color(0xff1D1D1D),
                                    fontSize: ScreenUtil().setSp(28)),
                              ),
                              width: ScreenUtil().setWidth(184),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogFenleiState();
                                      });
                                },
                                child: TextFormField(
                                    autofocus: false,
                                    controller: classType,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请选择直播分类",
                                      hintStyle: TextStyle(
                                          color: PublicColor.inputHintColor,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30),
                          right: ScreenUtil().setWidth(30),
                        ),
                        decoration: boxDe(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '清晰度',
                                style: TextStyle(
                                    color: Color(0xff1D1D1D),
                                    fontSize: ScreenUtil().setSp(28)),
                              ),
                              width: ScreenUtil().setWidth(184),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
//                                  showModalBottomSheet(
//                                      context: context,
//                                      builder: (BuildContext context) {
//                                        return DialogDefinition();
//                                      });
                                },
                                child: TextFormField(
                                    autofocus: false,
                                    controller: definition,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请选择清晰度",
                                      hintStyle: TextStyle(
                                          color: PublicColor.inputHintColor,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30),
                          right: ScreenUtil().setWidth(30),
                        ),
                        decoration: boxDe(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '门票费用',
                                style: TextStyle(
                                    color: Color(0xff1D1D1D),
                                    fontSize: ScreenUtil().setSp(28)),
                              ),
                              width: ScreenUtil().setWidth(184),
                            ),
                            Expanded(
                                flex: 1,
                                child: TextFormField(
                                    autofocus: false,
                                    controller: _amount,
                                    keyboardType: TextInputType.number,
                                    validator: (val) =>
                                        (val == '' ? "请设置名票费用" : !RegExpTest.num.hasMatch(val) ? '格式不对' : null),
                                    onSaved: (val) => (_amount.text = val),
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请设置名票费用",
                                      hintStyle: TextStyle(
                                          color: PublicColor.inputHintColor,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(30),
                          right: ScreenUtil().setWidth(30),
                        ),
                        decoration: boxDe(),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text(
                                '免费等级',
                                style: TextStyle(
                                    color: Color(0xff1D1D1D),
                                    fontSize: ScreenUtil().setSp(28)),
                              ),
                              width: ScreenUtil().setWidth(184),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return DialogGrade();
                                      });
                                },
                                child: TextFormField(
                                    autofocus: false,
                                    controller: grade,
                                    enabled: false,
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "请设置免费等级",
                                      hintStyle: TextStyle(
                                          color: PublicColor.inputHintColor,
                                          fontSize: ScreenUtil().setSp(28)),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(87),
                      right: ScreenUtil().setWidth(87),
                      top: ScreenUtil().setWidth(52),
                      bottom: ScreenUtil().setWidth(52)),
                  height: ScreenUtil().setWidth(92),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(46))),
                    color: PublicColor.themeColor,
                    textColor: PublicColor.whiteColor,
                    child: Text('创建直播'),
                    onPressed: () {
                      submit();
                      print('创建直播点击事件');
                    },
                  ),
                )
              ],
            )));
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

  // 清晰度选择弹出层
  Widget DialogDefinition() {
    return Container(
      height: StyleUtil.width(400),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
                BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '清晰度',
                  style: StyleUtil.tontStyle(
                      color: PublicColor.textColor,
                      num: 28,
                      fontWeight: FontWeight.bold),
                ),
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
                  value: 0,
                  dense: true,
                  isThreeLine: false,
                  selected: false,
                  activeColor: PublicColor.themeColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text("标清",
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                  groupValue: groupValue,
                  onChanged: (int value) {
                    setState(() {
                      groupValue = value;
                      definition.text = '标清';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<int>(
                    value: 1,
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text("高清",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    groupValue: groupValue,
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        definition.text = '高清';
                      });
                      Navigator.of(context).pop();
                    }),
                RadioListTile<int>(
                    value: 2,
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    groupValue: groupValue,
                    title: Text("超清",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        definition.text = '超清';
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

  // 免费等级弹出层
  Widget DialogGrade() {
    return Container(
      height: StyleUtil.width(400),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
                BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '免费等级',
                  style: StyleUtil.tontStyle(
                      color: PublicColor.textColor,
                      num: 28,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
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
                    groupValue: groupGrade,
                    onChanged: (int value) {
                      setState(() {
                        groupGrade = value;
                        grade.text = '白银';
                      });
                      Navigator.of(context).pop();
                    },
                    title: Text("白银",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    dense: true,
                    activeColor: PublicColor.themeColor,
                    // 指定选中时勾选框的颜色
                    isThreeLine: false,
                    // 是否空出第三行
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing),
                RadioListTile<int>(
                    value: 2,
                    groupValue: groupGrade,
                    title: Text("铂金",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        groupGrade = value;
                        grade.text = '铂金';
                      });
                      Navigator.of(context).pop();
                    }),
                RadioListTile<int>(
                    value: 3,
                    groupValue: groupGrade,
                    title: Text("钻石",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        groupGrade = value;
                        grade.text = '钻石';
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

  //直播分类
  Widget DialogFenleiState() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            decoration:
                BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '直播分类',
                  style: StyleUtil.tontStyle(
                      color: PublicColor.textColor,
                      num: 28,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/mine/icon_guanbi.png',
                      width: StyleUtil.width(40)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: typeLive
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
                        groupValue: groupClassType,
                        onChanged: (int value) {
                          setState(() {
                            groupClassType = value;
                            classType.text = item['name'];
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
}
