
import 'package:client/common/color.dart';
import 'package:client/common/select_picture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import '../../utils/toast_util.dart';
class Setting extends StatefulWidget {
  final Function(String) onChanged;

  Setting({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _nickname = TextEditingController();
  TextEditingController _realName = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController age = TextEditingController();
  int groupValuea = 1;
  int groupValue = 1;
  String headImg = '',
      nickname = '',
      name = '',
      birthday = '',
      address = '',
      sex = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getMy();
  }

  void getMy() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    UserServer().getMyApi(map, (success) async {
      setState(() {
        isLoading = false;
        headImg = success['user']['headimgurl'];
        _nickname.text = success['user']['nickname'];
        _realName.text = success['user']['real_name'];
        _birthday.text = success['user']['birthday'];
        _address.text = success['user']['address'];
        String sex = success['user']['sex'].toString();
        if (sex == '2') {
          age.text = '女';
          groupValue = 2;
        } else {
          age.text = '男';
          groupValue = 1;
        }
      });
    }, (onFail) async {});
  }

  //上传图片
  void uploadImg(images) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("info", () => images);

    UserServer().uploadImg(map, (success) async {
      setState(() {
        isLoading = false;
        headImg = success['src'];
      });
      ToastUtil.showToast('上传成功');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  setHeadImg(item) {
    setState(() {
      headImg = item['url'];
    });
  }

  //保存
  void save() async {
    age.text == '女' ? sex == '2' : sex == '1';
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("nickname", () => _nickname.text);
    map.putIfAbsent("headimgurl", () => headImg);
    map.putIfAbsent("realname", () => _realName.text);
    map.putIfAbsent("nickname", () => _nickname.text);
    map.putIfAbsent("sex", () => sex);
    map.putIfAbsent("birthday", () => _birthday.text);
    map.putIfAbsent("address", () => _address.text);
    UserServer().getSetApi(map, (success) async {
      setState(() {
        isLoading = false;
      });

      ToastUtil.showToast('保存成功');
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              '个人头像',
                              style: textStyle(PublicColor.textColor, 30),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                ScreenUtil().setWidth(10),
                                0,
                                ScreenUtil().setWidth(10)),
                            child: InkWell(
                              onTap: () {
                                print('上传头像');
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DialogImageType(setHeadImg));
                              },
                              child: ClipOval(
                                child: new Image.network(
                                  headImg == ''
                                      ? 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=468727759,3818736238&fm=26&gp=0.jpg'
                                      : headImg,
                                  fit: BoxFit.cover,
                                  width: ScreenUtil().setWidth(75),
                                  height: ScreenUtil().setWidth(75),
                                ),
                              ),
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
                              '昵称',
                              style: textStyle(PublicColor.textColor, 30),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                textAlign: TextAlign.end,
                                autofocus: false,
                                controller: _nickname,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: nickname,
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 30),
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
                              '真实姓名',
                              style: textStyle(PublicColor.textColor, 30),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                textAlign: TextAlign.end,
                                autofocus: false,
                                controller: _realName,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: name,
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 30),
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
                              '性别',
                              style: textStyle(PublicColor.textColor, 30),
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
                                  textAlign: TextAlign.end,
                                  autofocus: false,
                                  enabled: false,
                                  controller: age,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "请输入性别",
                                    hintStyle: textStyle(
                                        PublicColor.inputHintColor, 30),
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
                              '出生日期',
                              style: textStyle(PublicColor.textColor, 30),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
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
                                  textAlign: TextAlign.end,
                                  autofocus: false,
                                  controller: _birthday,
                                  enabled: false,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: birthday,
                                    hintStyle: textStyle(
                                        PublicColor.inputHintColor, 30),
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
                              '居住地址',
                              style: textStyle(PublicColor.textColor, 30),
                            ),
                            width: ScreenUtil().setWidth(184),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                                textAlign: TextAlign.end,
                                autofocus: false,
                                controller: _address,
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  hintText: address,
                                  hintStyle:
                                      textStyle(PublicColor.inputHintColor, 30),
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
                    SizedBox(height: ScreenUtil().setWidth(80)),
                    Container(
                      width: ScreenUtil().setWidth(640),
                      height: ScreenUtil().setWidth(85),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(46))),
                        color: PublicColor.themeColor,
                        textColor: PublicColor.whiteColor,
                        child: Text('保存'),
                        onPressed: () {
                          // 创建课程
                          print('保存点击事件');
                          print(sex);
                          save();
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

  Widget DialogFenleiState() {
    return Container(
      height: StyleUtil.width(400),
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '选择性别',
                  style: StyleUtil.tontStyle(
                      color: PublicColor.textColor, num: 32),
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
                    groupValue: groupValue,
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        age.text = '男';
                      });
                      Navigator.of(context).pop();
                    },
                    title: Text("男",
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
                    groupValue: groupValue,
                    title: Text("女",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        age.text = '女';
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
}
