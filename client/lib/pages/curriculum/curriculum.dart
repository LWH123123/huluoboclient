import 'package:client/common/color.dart';
import 'package:client/service/course_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../routers/Navigator_util.dart';

class Curriculum extends StatefulWidget {
  @override
  _CurriculumState createState() => _CurriculumState();
}

class _CurriculumState extends State<Curriculum> with SingleTickerProviderStateMixin {
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
  DateTime lastPopTime;
  bool isLoading = false;
  int id,type,order = 0,page = 1,limit = 10,tabIndex = 0,tabCount = 0;
  String keywords;
  List courseList = [];
  List courseType = [];
  List courseTeacher = [];
  getCourseList () {
    CourseService().getCourseList({
      "page": this.page,
      "id": this.id,
      "type": this.type,
      "order": this.order,
      "keywords": this.keywords,
      "limit": this.limit
    }, (onSuccess) {
      setState(() {
        onSuccess.length > 0 ? courseList.addAll(onSuccess) : ToastUtil.showToast('已加载全部数据');
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }
  getCourseType () {
    CourseService().getCourseType({
      "page": 1,
    }, (onSuccess) {
      setState(() {
        courseType = onSuccess;
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }
  requestList() {
    setState(() {
      page = 1;
      courseList = [];
    });
    tabIndex == 0 ? this.getCourseList() : getCourseTeacher();
  }
  getCourseTeacher () {
    CourseService().getCourseTeacher({
      "keywords": this.keywords
    }, (onSuccess) {
      setState(() {
        courseTeacher = onSuccess;
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    // 添加监听器
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => indexset());
    this.getCourseList();
    this.getCourseType();
    super.initState();
  }
  indexset() {
    setState(() {
      tabIndex = _tabController.index;
      _tabController.index == _tabController.animation.value.toInt() ? tabIndex == 0 ? this.requestList(): this.getCourseTeacher() : '';
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return WillPopScope(
      child: DefaultTabController(
        length: 2,
        child: new Scaffold(
            body: new Container(
                child: Column(children: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(140),
                    color: PublicColor.themeColor,
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Container(
                            margin: EdgeInsets.only(top: 25, left: 10),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 35,
                              ),
                              child: TextField(
                                onSubmitted: (value) {
                                  setState(() {
                                    keywords = value;
                                  });
                                  this.requestList();
                                },
                                decoration: InputDecoration(
                                  hintText: '请输入课程名称及讲师名称搜索',
                                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                                  fillColor: Color(0XFFFFF8F4),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    /*边角*/
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20), //边角为5
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.white, //边线颜色为白色
                                      width: 1, //边线宽度为2
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white, //边框颜色为白色
                                      width: 1, //宽度为5
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30), //边角为30
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                NavigatorUtils.goAllClassify(context);
                              },
                              child: new Column(children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(top: 35),
                                    child: Image.asset('assets/home/fenlei.png',
                                        width: ScreenUtil().setWidth(30),
                                        height: ScreenUtil().setWidth(30))),
                                Container(
                                    child: Text('分类',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(24))))
                              ])),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        width: ScreenUtil().setWidth(750),
                        child: DefaultTabController(
                          length: 2,
                          child: Container(
                            child: Column(children: [
                              Container(
                                height: ScreenUtil().setWidth(88),
                                padding:StyleUtil.paddingTow(left: 98),
                                decoration: BoxDecoration(
                                    color: PublicColor.whiteColor,
                                    border: Border(bottom: StyleUtil.borderBottom())),
                                child: TabBar(
                                  controller: _tabController,
                                  labelColor: Colors.red,
                                  unselectedLabelColor: Colors.blueGrey,
                                  indicatorColor: Colors.red,
                                  labelStyle: TextStyle(fontSize: 14),
                                  tabs: <Widget>[
                                    Container(
                                      height: ScreenUtil().setWidth(88),
                                      child: Center(
                                        child: Text('课程',
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(28))),
                                      ),
                                    ),
                                    Container(
                                      height: ScreenUtil().setWidth(88),
                                      child: Center(
                                        child: Text('讲师',
                                            style: TextStyle(
                                                fontSize: ScreenUtil().setSp(28))),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TabBarView(
                                  controller: _tabController,
                                  children: <Widget>[
                                    Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              height: StyleUtil.width(74),
                                              child: ListView(
                                                scrollDirection: Axis.horizontal,
                                                children: courseType.map((item) => FlatButton(
                                                  child: Text(item['name'],
                                                      style: StyleUtil.tontStyle(color: type == int.parse(item['id']) ? PublicColor.themeColor : PublicColor.textColor)),
                                                  onPressed: () {
                                                    setState(() {
                                                      type = int.parse(item['id']);
                                                      this.requestList();
                                                    });
                                                  },
                                                )).toList(),
                                              ),
                                            ),
                                            Container(
                                                padding: StyleUtil.paddingTow(left: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(bottom: StyleUtil.borderBottom())
                                                ),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  style: StyleUtil.tontStyle(color: PublicColor.textColor),
                                                  underline: Container(height: 0, color: PublicColor.borderColor),
                                                  hint: Text('请选择'),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      order = value;
                                                      this.requestList();
                                                    });
                                                  },
                                                  value: order,
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Padding(
                                                        padding: StyleUtil.paddingTow(left: 20),
                                                        child: Text('综合排序'),
                                                      ),
                                                      value: 0,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Padding(
                                                        padding: StyleUtil.paddingTow(left: 20),
                                                        child: Text('免费课程'),
                                                      ),
                                                      value: 1,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Padding(
                                                        padding: StyleUtil.paddingTow(left: 20),
                                                        child: Text('价格优先'),
                                                      ),
                                                      value: 2,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Padding(
                                                        padding: StyleUtil.paddingTow(left: 20),
                                                        child: Text('人气优先'),
                                                      ),
                                                      value: 3,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Padding(
                                                        padding: StyleUtil.paddingTow(left: 20),
                                                        child: Text('好评优先'),
                                                      ),
                                                      value: 4,
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: EasyRefresh(
                                                controller: _controller,
                                                header: BezierCircleHeader(
                                                  backgroundColor: PublicColor.themeColor,
                                                ),
                                                footer: BezierBounceFooter(
                                                  backgroundColor: PublicColor.themeColor,
                                                ),
                                                enableControlFinishRefresh: true,
                                                enableControlFinishLoad: false,
                                                child: ListView(
                                                    padding: EdgeInsets.all(0),
                                                    children: courseList.map((item) => Container(
                                                      padding: StyleUtil.paddingTow(left: 27,top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border(bottom: StyleUtil.borderBottom())
                                                      ),
                                                      child: InkWell(
                                                        onTap: () {
                                                          NavigatorUtils.goCurriculumDetail(context,item['id']);
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              //图片
                                                              Stack(
                                                                children: <Widget>[
                                                                  ClipRRect(
                                                                      borderRadius: BorderRadius.circular(
                                                                          ScreenUtil().setWidth(10)),
                                                                      child: Image.network(item['img'],
                                                                          fit: BoxFit.cover,
                                                                          width: ScreenUtil().setWidth(267),
                                                                          height: ScreenUtil().setWidth(171))),

                                                                  Positioned(
                                                                    bottom: 0,
                                                                    child: Offstage (
                                                                        offstage: int.parse(item['popularity']) == 0, // 设置是否可见：true:不可见 false:可见
                                                                        child: Container(
                                                                          width: ScreenUtil().setWidth(267),
                                                                          padding: EdgeInsets.only(
                                                                            left: ScreenUtil().setWidth(15),
                                                                            top: ScreenUtil().setWidth(7),
                                                                            bottom: ScreenUtil().setWidth(7),
                                                                          ),
                                                                          child: Text('${item['popularity']}人已学习',
                                                                              style: TextStyle(color: Colors.white)),
                                                                          decoration: BoxDecoration(
                                                                            color: Color.fromRGBO(0, 0, 0, 0.5),
                                                                            borderRadius: BorderRadius.only(
                                                                                bottomLeft: Radius.circular(
                                                                                    ScreenUtil().setWidth(10)),
                                                                                bottomRight: Radius.circular(
                                                                                    ScreenUtil().setWidth(10))),
                                                                          ),
                                                                        )
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    Container(
                                                                      width: ScreenUtil().setWidth(387),
                                                                      // height: ScreenUtil().setWidth(67),
                                                                      margin: EdgeInsets.only(
                                                                          left: ScreenUtil().setWidth(27)),
                                                                      child: Text(
                                                                        item['title'],
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: ScreenUtil().setSp(30),
                                                                            color: Color(0xff4E4E4E)),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: ScreenUtil().setWidth(387),
                                                                      // height: ScreenUtil().setWidth(67),
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          ScreenUtil().setWidth(27),
                                                                          ScreenUtil().setWidth(27),
                                                                          0,
                                                                          0),
                                                                      child: Text(
                                                                        double.parse(item['price'])
                                                                         <= 0 ? '免费' : item['price'],
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: ScreenUtil().setSp(30),
                                                                            color: Colors.red),
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child: Row(children: [
                                                                        Container(
                                                                          width: ScreenUtil().setWidth(387),
                                                                          // height: ScreenUtil().setWidth(67),
                                                                          margin: EdgeInsets.only(
                                                                            left: ScreenUtil().setWidth(27),
                                                                            top: ScreenUtil().setWidth(40),
                                                                          ),
                                                                          child: Row(children: [
                                                                            Container(
                                                                              child: Text(
                                                                                '共',
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: ScreenUtil().setSp(28),
                                                                                  color: Color(0xffc6c6c6),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                item['child_num'],
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: ScreenUtil().setSp(28),
                                                                                  color: Color(0xffF88718),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                '节课',
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: ScreenUtil().setSp(28),
                                                                                  color: Color(0xffc6c6c6),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.only(
                                                                                  left: ScreenUtil().setWidth(130)),
                                                                              child: Text(
                                                                                '${item['good_lv']}%  好评',
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: ScreenUtil().setSp(28),
                                                                                  color: Color(0xffF88718),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                        ),
                                                                      ]),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )).toList()
                                                ),
                                                onRefresh: () async {
                                                  setState(() {
                                                    this.requestList();
                                                  });
                                                },
                                                onLoad: () async {
                                                  await Future.delayed(Duration(seconds: 1), () {
                                                    setState(() {
                                                      page+=1;
                                                      this.getCourseList();
                                                    });
                                                  });
                                                },
                                              ),
                                            )
                                          ],
                                        )//courseList.length > 0 ? Curriculumkc(course: courseList) : Text('暂无数据'),
                                    ),
                                    Container(
                                      child: EasyRefresh(
                                          controller: _controller,
                                          header: BezierCircleHeader(
                                            backgroundColor: PublicColor.themeColor,
                                          ),
                                          enableControlFinishRefresh: true,
                                          child: ListView(
                                              padding: EdgeInsets.all(0),
                                              children:courseTeacher.map((item) => InkWell(
                                                onTap: () {
                                                  NavigatorUtils.goLecturer(context, id: item['id']);
                                                },
                                                child: Container(
                                                  width: ScreenUtil().setWidth(750),
                                                  height: ScreenUtil().setHeight(175),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                                                  ),
                                                  child: Row(children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                                                      child: ClipOval(
                                                        // child:Image.asset("assets/mine/avatar.png"),
                                                        child: Image.network(item['headimgurl'],width: ScreenUtil().setWidth(120),
                                                          height: ScreenUtil().setWidth(120),fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(top: 20),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              width: ScreenUtil().setWidth(500),
                                                              // margin: EdgeInsets.only(bottom: 10),
                                                              child: Text(item["real_name"],
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: ScreenUtil().setSp(28),
                                                                  )),
                                                            ),
                                                            Container(
                                                              width: ScreenUtil().setWidth(500),
                                                              child: Text(item['desc'],textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  color: Colors.grey[400],
                                                                  fontSize: ScreenUtil().setSp(26),
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ))
                                                  ]),
                                                ),
                                              )).toList()
                                          ),
                                          onRefresh: () async {
                                            this.getCourseTeacher();
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        )),
                  )
                ]))),
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
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    );
  }
}
