import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../service/home_service.dart';
import '../../widgets/loading.dart';
import '../../utils/toast_util.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/cached_image.dart';

class Classification extends StatefulWidget {
  final String id;
  Classification({this.id});
  @override
  ClassificationState createState() => ClassificationState();
}

class ClassificationState extends State<Classification> {
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;

  List listView = [];

  @override
  void initState() {
    super.initState();

    getList();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      listView = [];
    }

    Map<String, dynamic> map = Map();

    map.putIfAbsent("id", () => widget.id);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);

    HomeServer().getClassApi(map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          listView = success['list'];
        } else {
          if (success['list'].length == 0) {
            ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['list'].length; i++) {
              listView.insert(listView.length, success['list'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('职场课程'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget listData() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listView.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in listView) {
        arr.add(Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
          ),
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
          child: Column(
            children: <Widget>[
              new InkWell(
                onTap: () {
                  String id = item['id'];
                  print(id);
                  //点击跳转课程详情页面
                  NavigatorUtils.goCurriculumDetail(context, id);
                },
                child: new Container(
                  child: Row(
                    children: <Widget>[
                      //图片
                      Stack(
                        children: <Widget>[
                          CachedImageView(
                              ScreenUtil.instance.setWidth(267.0),
                              ScreenUtil.instance.setWidth(171.0),
                              item['img'],
                              null,
                              BorderRadius.all(Radius.circular(0))),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: ScreenUtil().setWidth(267),
                              padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(15),
                                top: ScreenUtil().setWidth(7),
                                bottom: ScreenUtil().setWidth(7),
                              ),
                              child: Text(item['see_num'].toString() + '人已学习',
                                  style: TextStyle(color: Colors.white)),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(
                                        ScreenUtil().setWidth(10)),
                                    bottomRight: Radius.circular(
                                        ScreenUtil().setWidth(10))),
                              ),
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
                                '￥' + item['price'],
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
                                        item['good_lv'] + '  好评',
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
              )
            ],
          ),
        ));
      }
    }
    content = new Column(
      children: arr,
    );
    return content;
  }

  Widget contentWidget() {
    return Container(
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
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[listData()],
        )),
        onRefresh: () async {
          getList();
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            getList();
          });
        },
      ),
    );
  }
}
