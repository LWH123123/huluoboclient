import 'dart:io';

import 'package:client/common/color.dart';
import 'package:client/common/select_picture.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _type_id = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _level = TextEditingController();
  TextEditingController _img = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _nandu = TextEditingController();


  // 课程分类 groupValue groupGrade _children _title
  int groupValue;
  // 免费等级
  int groupGrade;
  int nanduGrade;
  List courseType = [];
  List _children = [];
  bool isUp = true;
  bool isUpSuccess = false;
  double _process = 0.0;
  String token = "";
  String key = "";
  bool _switchValue = false;
  int isTry = 0;
// 课程分类
  getCourseType() {
    CourseService().getCourseType(
        {"page": 1},
        (onSuccess) => setState(() {
              courseType = onSuccess;
            }),
        (onFail) => ToastUtil.showToast(onFail));
  }

  void getToken() async {
    Map<String, dynamic> map = Map();
    CourseService().getToken(map, (success) {
      setState(() {
        token = success['token'];
        key = success['key'];
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }

  upload_video() async {
    print('上传视频');
    File file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    print(file);
    if (file == null) return;
    if (file.path.split('.')[1] != 'mp4') return ToastUtil.showToast('请选择Mp4格式视频');
    int index = _children.length;
    CourseService().getToken({}, (success) async{
      print('file---->>>>${file.path}');
      print('token---->>>>${success['token']}');
      print('key---->>>>${success['key']}');
      final syStorage = new SyFlutterQiniuStorage();
      String time = _title.text;
      String str = time + '-' + (_children.length + 1).toString();
      setState(() {
        isUp = false;
        _children.add({
          "course_child_name": str,
          "url":success['key'],
          "is_try": false,
          "redact": false,
          "progress": 0.0,
          "is_ok": false
        });
      });
      syStorage.onChanged().listen((dynamic percent)  {
        double progress = percent; // 上传进度
        setState(() {
          _children[index]['progress'] = progress;
        });
      });
      bool result = await syStorage.upload(file.path, success['token'], success['key']);
      print('result---->>>>$result');
      if (result) {
        setState(() {
          isUp = true;
          _children[index]['is_ok'] = true;
        });
        ToastUtil.showToast('上传成功');
      } else {
        setState(() {
          isUp = false;
          _children.removeAt(_children.length-1);
        });
        ToastUtil.showToast('视频上传失败');
      }
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
  }


  submit() {
    print(_name.text);
    print(isTry);
    var _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      if (_img == '')
        return ToastUtil.showToast('请上传课程封面图片');
      else if (_nandu.text == '')
        return ToastUtil.showToast('请输入课程名称');
      else if (nanduGrade == null)
        return ToastUtil.showToast('请选择课程难度');
      else if (groupValue == null)
        return ToastUtil.showToast('请选择课程分类');
      else if (groupGrade == null)
        return ToastUtil.showToast('请选择免费等级');
      else if (_children.length == 0) return ToastUtil.showToast('请上传课程视频');
      else if (!isUp) return ToastUtil.showToast('请等待视频上传');
      List arr = [];
      _children.forEach((item) => {
        arr.add({
          "course_child_name": item['course_child_name'],
          "url": item['url'],
          "is_try": item['is_try'] ? 1 : 2
        })
      });
      Map<String, dynamic> entity = {
        "title": _title.text,
        "description": _description.text,
        "type_id": groupValue,
        "price": _price.text,
        "level": groupGrade,
        "img": _img.text,
        "child": arr,
        "nandu": nanduGrade
      };
      getCreateCourse(entity);
    }
  }

  // 创建课程请求函数
  getCreateCourse(map) {
    CourseService().getCreateCourse(map, (onSuccess) async {
      ToastUtil.showToast('创建成功');
      _title.text = '';
      _description.text = '';
      groupValue = null;
      _price.text = '';
      groupGrade = null;
      _img.text = '';
      _level.text = '';
      _type_id.text = '';
      _children = [];
      await Future.delayed(Duration(seconds: 1), () {
        NavigatorUtils.goPastCourse(context,true);
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getCourseType();
    this.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget list = new Container(
      child: Container(
        margin: StyleUtil.padding(left: 24, right: 24, top: 24, bottom: 7),
        decoration: BoxShadow_style(),
        child: Column(
          children: <Widget>[
            Container(
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogFenleiState();
                        });
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(100),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    decoration: boxDe(),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '课程分类',
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
                              controller: _type_id,
                              enabled: false,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "请选择课程分类",
                                hintStyle: TextStyle(
                                    color: PublicColor.inputHintColor,
                                    fontSize: ScreenUtil().setSp(28)),
                              )),
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return nanduDialogGrade();
                        });
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(100),
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(30),
                      right: ScreenUtil().setWidth(30),
                    ),
                    decoration: boxDe(),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '课程难度',
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
                              controller: _nandu,
                              enabled: false,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: "请选择课程难度",
                                hintStyle: TextStyle(
                                    color: PublicColor.inputHintColor,
                                    fontSize: ScreenUtil().setSp(28)),
                              )),
                        )
                      ],
                    ),
                  )),
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
                        controller: _price,
                        keyboardType: TextInputType.number,
                        validator: (val) => (val == '' ? "请设置名票费用" : null),
                        onSaved: (val) => (_price.text = val),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "请设置名票费用",
                          hintStyle: TextStyle(
                              color: PublicColor.inputHintColor,
                              fontSize: ScreenUtil().setSp(28)),
                        )),
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
                            builder: (BuildContext context) => DialogGrade());
                      },
                      child: TextFormField(
                          autofocus: false,
                          controller: _level,
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
            Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '上传课程',
                          style: TextStyle(
                              color: Color(0xff1D1D1D),
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                        Text(
                          '请上传您要讲课的视频',
                          style: TextStyle(
                              color: Color(0xff1D1D1D),
                              fontSize: ScreenUtil().setSp(20)),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (!isUp) return;
                        _title.text != '' ? upload_video() : ToastUtil.showToast('请先输入课程名称');
                      },
                      child:  Container(
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setWidth(80),
                              alignment: Alignment.centerRight,
                              child: isUp ? Image.asset(
                                'assets/teacher/icon_sctp@2x.png',
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(80),
                              ) : Text('上传中请稍后')
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),

              ),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(30),
                  bottom: ScreenUtil().setWidth(30)),
              child: Column(
                children: <Widget>[
                   ..._children
                       .map((item) =>Container(
                     decoration: BoxDecoration(
                       borderRadius:
                       BorderRadius.circular(ScreenUtil().setWidth(10)),
                       color: Color.fromRGBO(245, 245, 245, 1),
                     ),
                     margin: EdgeInsets.only(
                         left: ScreenUtil().setWidth(30),
                         right: ScreenUtil().setWidth(30),
                         bottom: ScreenUtil().setWidth(30)),
                     child: item['is_ok'] ?
                     Column(
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.only(
                               left: ScreenUtil().setWidth(16),
                               right: ScreenUtil().setWidth(16)),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Expanded(
                                 flex: 1,
                                 child: TextFormField(
                                     autofocus: false,
                                     enabled: item['redact'],
                                     onChanged: (value) {
                                       setState(() {
                                         item['course_child_name'] = value;
                                       });
                                     },
                                     decoration: new InputDecoration(
                                        enabledBorder: item['redact'] ? UnderlineInputBorder(
                                        borderSide: BorderSide(color: PublicColor.borderColor),
                                        ): InputBorder.none,
                                      border: InputBorder.none,
                                       hintText: item['course_child_name'],
                                       hintStyle: TextStyle(
                                           color: PublicColor.inputHintColor,
                                           fontSize: ScreenUtil().setSp(28)),
                                     )),
                               ),
                               InkWell(
                                 onTap: () {
                                   setState(() {
                                     setState(() {
                                       item['redact'] = !item['redact'];
                                     });
                                   });
                                 },
                                 child: Row(
                                   children: <Widget>[
                                     Image.asset(
                                       'assets/teacher/icon_bianji@2x.png',
                                       width: ScreenUtil().setWidth(22),
                                       height: ScreenUtil().setWidth(24),
                                     ),
                                     SizedBox(width: ScreenUtil().setWidth(7)),
                                     Text(
                                       item['redact'] ? '保存' : '编辑',
                                       style: TextStyle(
                                           color: PublicColor.textColor,
                                           fontSize: ScreenUtil().setSp(28)),
                                     )
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                         Container(
                           padding: EdgeInsets.only(
                               left: ScreenUtil().setWidth(16),
                               right: ScreenUtil().setWidth(16),
                               bottom: ScreenUtil().setWidth(16)),
                           child: Row(
                             children: <Widget>[
                               Expanded(
                                 flex: 1,
                                 child: Text('是否设置试看视频'),
                               ),
                               Container(
                                 child: Switch(
                                     activeColor: PublicColor.themeColor,
                                     value: item['is_try'],
                                     onChanged: (value) {
                                       setState(() {
                                         item['is_try'] = value;
                                       });
                                     }),
                               )
                             ],
                           ),
                         )
                       ],
                     ) : Container(
                       alignment: Alignment.center,
                       padding: EdgeInsets.only(
                         left: ScreenUtil().setWidth(30),
                         right: ScreenUtil().setWidth(30),
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           LinearProgressIndicator(
                             value: item['progress'],
                           ),
                           SizedBox(height: ScreenUtil().setWidth(30)),
                           Text('上传中...')
                         ],
                       ),
                     ),
                   )).toList()
                ],
              ),
            ),

          ],
        ),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('创建课程'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
          actions: <Widget>[
            InkWell(
              onTap: () {
                NavigatorUtils.goPastCourse(context);
              },
              child: Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/teacher/icon_kecheng@2x.png',
                        width: ScreenUtil().setWidth(45),
                        height: ScreenUtil().setWidth(34),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(8)),
                        child: Text(
                          '历史',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      )
                    ],
                  )),
            )
          ],
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
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) =>
                                  DialogImageType((item) {
                                    setState(() {
                                      _img.text = item['url'];
                                    });
                                  }));
                        },
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
                                ), /*Image.asset(
                            'assets/teacher/icon_tianjia@2x.png',
                            width: ScreenUtil().setWidth(182),
                            height: ScreenUtil().setWidth(182),
                          ),*/
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                            autofocus: false,
                            maxLines: 3,
                            onChanged: (val) {
                              setState(() {
                                _title.text = val;
                              });
                            },
                            // onSaved: (val) => (_title.text = val),
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
                  padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(25), 0,
                      ScreenUtil().setWidth(25), 0),
                  decoration: BoxShadow_style(),
                  child: TextFormField(
                      autofocus: false,
                      controller: _description,
                      maxLines: 4,
                      validator: (val) => (val == '' ? "请输入直播介绍" : null),
                      onSaved: (val) => (_description.text = val),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入直播介绍",
                        hintStyle: TextStyle(
                            color: PublicColor.inputHintColor,
                            fontSize: ScreenUtil().setSp(28)),
                      )),
                ),
                list,
                Container(
                  margin: StyleUtil.padding(
                      left: 87, right: 87, top: 52, bottom: 92),
                  height: ScreenUtil().setWidth(92),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(46))),
                    color: PublicColor.themeColor,
                    textColor: PublicColor.whiteColor,
                    child: Text('创建课程'),
                    onPressed: () {
                      print('创建课程点击事件');
                      submit();
//                      NavigatorUtils.goPastCourse(context);
                    },
                  ),
                )
              ],
            )));
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

  //课程分类
  Widget DialogFenleiState() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '课程分类',
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
              children: courseType
                  .map((item) => RadioListTile<int>(
                      value: int.parse(item['id']),
                      groupValue: groupValue,
                      onChanged: (int value) {
                        setState(() {
                          groupValue = value;
                          _type_id.text = item['name'];
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(item['name'],
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      dense: true,
                      activeColor: PublicColor.themeColor,
                      // 指定选中时勾选框的颜色
                      isThreeLine: false,
                      // 是否空出第三行
                      selected: false,
                      controlAffinity: ListTileControlAffinity.trailing))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
// 课程难度弹出层
  Widget nanduDialogGrade() {
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
                  '请选择课程难度',
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
                    groupValue: nanduGrade,
                    onChanged: (int value) {
                      setState(() {
                        nanduGrade = value;
                        _nandu.text = '简单';
                      });
                      Navigator.of(context).pop();
                    },
                    title: Text("简单",
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
                    groupValue: nanduGrade,
                    title: Text("一般",
                        style:
                        StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        nanduGrade = value;
                        _nandu.text = '一般';
                      });
                      Navigator.of(context).pop();
                    }),
                RadioListTile<int>(
                    value: 3,
                    groupValue: nanduGrade,
                    title: Text("困难",
                        style:
                        StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        nanduGrade = value;
                        _nandu.text = '困难';
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
                  '请选择等级',
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
                        _level.text = '白银';
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
                        _level.text = '铂金';
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
                        _level.text = '钻石';
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
