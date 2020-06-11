import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class KechengScreen extends StatefulWidget {
  @override
  _KechengScreenState createState() => _KechengScreenState();
}

class _KechengScreenState extends State<KechengScreen>
    with SingleTickerProviderStateMixin {
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
  int tabIndex = 0, tabCount = 0, page = 1;
  List list = [];
  List purchase = [];
  List lecturer = [];

  getMyCourse() {
    CourseService().getMyCourse(
        {"page": this.page, "limit": 10, "type": this.tabIndex + 1},
        (onSuccess) {
      setState(() {
        _controller.finishRefresh();
        if (onSuccess.length == 0) return;
        this.tabIndex == 0
            ? list.addAll(onSuccess)
            : this.tabIndex == 1 ? purchase.addAll(onSuccess) : lecturer.addAll(onSuccess);
      });
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  requestList() {
    setState(() {
      page = 1;
      this.getMyCourse();
    });
  }

  indexset() {
    print("_tabController----${_tabController.animation.value}----${_tabController.index}");
    setState(() {
      list = [];
      purchase = [];
      lecturer = [];
      tabIndex = _tabController.index;
      _tabController.index == _tabController.animation.value.toInt() ? this.requestList() : '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(() => indexset());
    this.requestList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
            title: Text('我的课程')),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: TabBar(
                controller: _tabController,
                labelColor: PublicColor.themeColor,
                unselectedLabelColor: Color(0xff5E5E5E),
                indicatorColor: PublicColor.themeColor,
                labelStyle: TextStyle(fontSize: ScreenUtil().setSp(30)),
                tabs: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(93),
                    child: Center(
                      child: Text('收藏课程'),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(93),
                    child: Center(
                      child: Text('已购课程'),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(93),
                    child: Center(
                      child: Text('收藏讲师'),
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
                        children: list.length > 0 ? list.map((item) => _itemView(item)).toList() : [
                          Container(
                            child: Center(
                              child: Text('暂无数据'),
                            ),
                            height: 200,
                          )
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          this.requestList();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            page += 1;
                            this.getMyCourse();
                          });
                        });
                      },
                    ),
                  ),
                  Container(
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
                        children: purchase.length>0? purchase.map((item) => _itemView(item)).toList():[
                          Container(
                            child: Center(
                              child: Text('暂无数据'),
                            ),
                            height: 200,
                          )
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          this.requestList();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            page += 1;
                            this.getMyCourse();
                          });
                        });
                      },
                    ),
                  ),
                  Container(
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
                        children:
                        lecturer.length>0?lecturer.map((item) => _collectView(item)).toList():[
                          Container(
                            child: Center(
                              child: Text('暂无数据'),
                            ),
                            height: 200,
                          )
                        ],
                      ),
                      onRefresh: () async {
                        setState(() {
                          this.requestList();
                        });
                      },
                      onLoad: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            page += 1;
                            this.getMyCourse();
                          });
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemView(item) {
    return InkWell(
      onTap: () {
        print('课程点击${item['id']}');
        NavigatorUtils.goCurriculumDetail(context, item['course_id']);
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: PublicColor.borderColor)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10)),
                    child: Image.network(item['img'],
                        fit: BoxFit.cover,
                        width: ScreenUtil().setWidth(267),
                        height: ScreenUtil().setWidth(171))),
                Positioned(
                  bottom: 0,
                  child: Offstage(
                    offstage: item['see_num'] == 0,
                    child: Container(
                      width: ScreenUtil().setWidth(267),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        top: ScreenUtil().setWidth(7),
                        bottom: ScreenUtil().setWidth(7),
                      ),
                      child: Text('${item['see_num']}人已学习',
                          style: TextStyle(color: Colors.white)),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(ScreenUtil().setWidth(10)),
                            bottomRight:
                                Radius.circular(ScreenUtil().setWidth(10))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(19)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
                      child: Text(item['title'],
                          style: TextStyle(
                              color: PublicColor.textColor,
                              fontSize: ScreenUtil().setSp(28)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                      child: Text(
                        '￥${item['price'].toString()}',
                        style: TextStyle(
                            color: PublicColor.themeColor,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text('共',
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(24))),
                                Text(item['child_num'].toString(),
                                    style: TextStyle(
                                        color: PublicColor.yellowColor,
                                        fontSize: ScreenUtil().setSp(24))),
                                Text('节课',
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(24)))
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Text('${item['good_lv'].toString()}%',
                                    style: TextStyle(
                                        color: PublicColor.yellowColor,
                                        fontSize: ScreenUtil().setSp(24))),
                                Text('好评',
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(24)))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _collectView(item) {
    return InkWell(
        onTap: () {
          print('收藏点击');
          NavigatorUtils.goLecturer(context, id: item['teacher_id']);
        },
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: PublicColor.borderColor)),
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: Image.network(
                  item['headimgurl'],
                  fit: BoxFit.cover,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(120),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(21)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(item['real_name']),
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setWidth(17)),
                      ),
                      Container(
                        child: Text(item['desc'],
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
