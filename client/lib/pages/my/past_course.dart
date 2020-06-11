import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/routers/application.dart';
import 'package:client/service/course_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PastCourse extends StatefulWidget {
  @override
  _PastCourseState createState() => _PastCourseState();
}

class _PastCourseState extends State<PastCourse> {
  EasyRefreshController _controller = EasyRefreshController();
  DateTime lastPopTime;
  List list = [];
  int page = 1;

  getHistoryCourse() {
    CourseService().getHistoryCourse({"page": this.page, "limit": 10},
        (onSuccess) {
      if (onSuccess.length == 0) return ToastUtil.showToast('已加载全部数据');
      setState(() {
        list.addAll(onSuccess);
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  requestList() {
    setState(() {
      page = 1;
      list = [];
    });
    this.getHistoryCourse();
  }

  @override
  void initState() {
    // TODO: implement initState
    this.requestList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('历史课程'),
          backgroundColor: PublicColor.themeColor,
        ),
        body: EasyRefresh(
          controller: _controller,
          header: BezierCircleHeader(
            backgroundColor: PublicColor.themeColor,
          ),
          footer: BezierBounceFooter(
            backgroundColor: PublicColor.themeColor,
          ),
          enableControlFinishRefresh: true,
          enableControlFinishLoad: false,
          child:
              ListView(children: list.map((item) => _itemView(item)).toList()),
          onRefresh: () async {
            setState(() {
              this.requestList();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                page += 1;
                this.getHistoryCourse();
              });
            });
          },
        ),
      ),
    );
  }

  Widget _itemView(item) {
    return InkWell(
      onTap: () {
        print('课程点击');
        String id = item['id'];
        //点击跳转课程详情页面
        NavigatorUtils.goCurriculumDetail(context, id);
        // NavigatorUtils.goCurriculumDetail(context);
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
                    offstage: item['popularity'] == '0',
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
                        '￥${item['price']}',
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
                              child: Row(children: <Widget>[
                            Text('共',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(24))),
                            Text(item['child_num'],
                                style: TextStyle(
                                    color: PublicColor.yellowColor,
                                    fontSize: ScreenUtil().setSp(24))),
                            Text('节课',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(24))),
                            SizedBox(width: ScreenUtil().setWidth(23)),
                            Text('${item['good_lv']}%',
                                style: TextStyle(
                                    color: PublicColor.yellowColor,
                                    fontSize: ScreenUtil().setSp(24))),
                            Text('好评',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(24)))
                          ])),
                          /* Container(
                            width: ScreenUtil().setWidth(117),
                            height: ScreenUtil().setWidth(43),
                            child: OutlineButton(
                              shape: StadiumBorder(),
                              borderSide: BorderSide(
                                  color: PublicColor.themeColor),
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                    color: PublicColor.themeColor),
                              ),
                              onPressed: () {
                                print('点击编辑事件');
                                NavigatorUtils.goCreateCourse(context);
                              }
                            )
                          )*/
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
}
