import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/service/home_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Appraise extends StatefulWidget {
  String id;
  Appraise({Key key, String this.id}) : super(key: key);
  @override
  _AppraiseState createState() => _AppraiseState();
}

class _AppraiseState extends State<Appraise> {
  int status = 1;
  TextEditingController _content = TextEditingController();
  Map<String, dynamic> course = new Map();
  //课程详情
  void getDetailApi() async {
    HomeServer().getCourseDetailApi({
      "course_id": widget.id
    }, (success) async {
      setState(() {
        course = success['course'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  getEvalCourse () {
    if (_content.text == '') return ToastUtil.showToast('请输入评价内容');
    CourseService().getEvalCourse({
      "type": status,
      "course_id": course['id'],
      "content": _content.text
    }, (onSuccess) async {
      ToastUtil.showToast('评价成功');
      await Future.delayed(Duration(seconds: 2), () =>Navigator.of(context).pop());
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getDetailApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('评价'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: course != null ?ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(ScreenUtil().setWidth(28)),
              decoration: BoxShadow_style(),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                    decoration: boxDe(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(10)),
                          child: Image.network(course['img'] != null ? course['img'] : '',
                              fit: BoxFit.cover,
                              width: ScreenUtil().setWidth(119),
                              height: ScreenUtil().setWidth(119)),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(22)),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                course['title'] != null ? course['title'] : '',
                                style: textStyle(PublicColor.textColor, 28),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(40)),
                              Text('￥${course['price']}',
                                  style: textStyle(PublicColor.themeColor, 30))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsetsFromLTRB(0, 40, 0, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            setState(() {
                              status = 1;
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                'assets/home/icon_henhao1@2x.png',
                                width: ScreenUtil().setWidth(66),
                                height: ScreenUtil().setWidth(108),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(66),
                                  height: ScreenUtil().setWidth(108),
                                  decoration: BoxDecoration(
                                      color:
                                      Color.fromRGBO(255, 255, 255, status != 1 ? 0.5 : 0))
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(79)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              status = 2;
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                'assets/home/icon_yiban1@2x.png',
                                width: ScreenUtil().setWidth(66),
                                height: ScreenUtil().setWidth(108),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(66),
                                  height: ScreenUtil().setWidth(108),
                                  decoration: BoxDecoration(
                                      color:
                                      Color.fromRGBO(255, 255, 255, status != 2 ? 0.5 : 0))
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(79)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              status = 3;
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Image.asset(
                                'assets/home/icon_bumany1@2x.png',
                                width: ScreenUtil().setWidth(66),
                                height: ScreenUtil().setWidth(108),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(66),
                                  height: ScreenUtil().setWidth(108),
                                  decoration: BoxDecoration(
                                      color:
                                      Color.fromRGBO(255, 255, 255, status != 3 ? 0.5 : 0))
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsFromLTRB(62, 0, 60, 71),
                    padding: EdgeInsetsFromLTRB(21, 0, 21, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(245,245,245,0.75),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                    ),
                    child: TextField(
                        autofocus: false,
//                        controller: _content,
                        maxLines: 6,
                        onChanged: (val) {
                          _content.text = val;
                        },
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: "请输入评价内容",
                          hintStyle: textStyle(PublicColor.inputHintColor, 28),
                        )),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsetsFromLTRB(86, 77, 86, 77),
              height: ScreenUtil().setWidth(92),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(46))),
                color: PublicColor.themeColor,
                textColor: PublicColor.whiteColor,
                child: Text('提交评价'),
                onPressed: () {
                  getEvalCourse();
                  print('提交评价点击事件');
                  // NavigatorUtils.goCreateCourse(context);
                },
              ),
            ),
          ],
        ) : Text(''));
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
