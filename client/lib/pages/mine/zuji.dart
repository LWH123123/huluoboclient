import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:client/common/color.dart';
import '../../service/user_service.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../widgets/loading.dart';
import '../../widgets/zuji_list.dart';
import '../../routers/Navigator_util.dart';
class ZujiScreen extends StatefulWidget {
  @override
  ZujiScreenState createState() => ZujiScreenState();
}

class ZujiScreenState extends State<ZujiScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
 
  int tabIndex = 0, page = 1;
  List courseList = [];
  List tabView = [];
  indexset() {
    setState(() {
      courseList = [];
      tabView = [];
      tabIndex = _tabController.index;
      _tabController.index == _tabController.animation.value.toInt()
          ? this.getCourse()
          : '';
          
    });
  }
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => indexset());
    getCourse();
    super.initState();
  }

// 获得推流地址
  getliveurl(room) async {
    Map<String, dynamic> map = Map();
    LiveServer().inRoom({"room_id": room['room_id']}, (success) async {
      List typeArr = ['未开播', '直播中', '已结束'];
      int tyep = success['room']['is_open'];
      tyep != 1 ? ToastUtil.showToast(typeArr[tyep]) :
      NavigatorUtils.goSlideLookZhibo(context,room_id: room['room_id'].toString());
    }, (onFail) async {
      if (onFail['errcode'].toString() == '10108') {
        Map obj= {
          'bgImg':onFail['room']['img'],//背景图
          'headimgurl':onFail['anchor']['headimgurl'],//头像
          'realName':onFail['anchor']['real_name'],//讲师名
          'name':onFail['room']['name'],//直播名称
          'price':onFail['room']['amount'],//直播价格
          'balance':onFail['user']['balance'],//余额
          'roomId':onFail['room']['id'],
          "productEntity": room
        };
        ToastUtil.showToast(onFail['errmsg']);
        NavigatorUtils.goLivePay(context,obj);
      } else {
        ToastUtil.showToast(onFail['errmsg']);
      }
    });
  }

  void getCourse() async {
     setState(() {
      isLoading = true;
    });
    UserServer().getZujiApi({
      "type": tabIndex + 1,
      "page": page,
      "limit": 10
    }, (success) async {
       setState(() {
      isLoading = false;
    });
       _controller.finishRefresh();
       success['list'].length ==0 ? ToastUtil.showToast('已加载全部数据') : tabIndex == 0 ? courseList.addAll(success['list']) : tabView.addAll(success['list']);
    }, (onFail) async {
      _controller.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        new DefaultTabController(
        length: 2,
        child: new Stack(children: <Widget>[
          Scaffold( 
            appBar: new AppBar(
                title: Text('我的足迹'),
                centerTitle: true,
                backgroundColor: PublicColor.themeColor,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                       controller: _tabController,
                        indicatorWeight: 3.0,
                        labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                        // indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: PublicColor.themeColor,
                        unselectedLabelColor: Color(0xff5e5e5e),
                        labelColor: PublicColor.themeColor,
                        tabs: <Widget>[
                          new Tab(
                            child: Text(
                              '课程记录',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '直播记录',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),  
                        ]),
                  ),
                )              
                ),
            body: Container(
                child: TabBarView( controller:_tabController,children: <Widget>[
                  EasyRefresh(
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
                      children:courseArea(),
                    ),
                    onRefresh: () async {
                      setState(() {
                        page = 1;
                        courseList = [];
                        tabView = [];
                        this.getCourse();
                      });
                    },
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          page += 1;
                          this.getCourse();
                        });
                      });
                    },
                  ),
                  EasyRefresh(
                    controller: _controller,
                    header: BezierCircleHeader(
                      backgroundColor: PublicColor.themeColor,
                    ),
                    footer: BezierBounceFooter(
                      backgroundColor: PublicColor.themeColor,
                    ),
                    enableControlFinishRefresh: true,
                    enableControlFinishLoad: false,
                    child: tabView.length > 0 ? GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: ScreenUtil().setWidth(5),
                      crossAxisSpacing: ScreenUtil().setWidth(5),
                      childAspectRatio: 4 / 5,
                      children: tabView.map((item) => _getGridViewItem(context, item)).toList(),
                    ): ListView(
                      children: <Widget>[
                        SizedBox(height: StyleUtil.width(300)),
                        Center(
                          child: Text('暂无数据',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                fontWeight: FontWeight.bold,
                              )),
                        )
                      ],
                    ),
                    onRefresh: () async {
                      setState(() {
                        page = 1;
                        courseList = [];
                        tabView = [];
                        this.getCourse();
                      });
                    },
                    onLoad: () async {
                      await Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          page += 1;
                          this.getCourse();
                        });
                      });
                    },
                  ),
            ])
            ),
          ),
          isLoading ? LoadingDialog() : Container(),
        ]))
      ],
    );
  }

  //课程
  List<Widget> courseArea() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (courseList.length == 0) {
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
      for (var item in courseList) {
        arr.add(Container(
            child: InkWell(
          onTap: () {
            print('课程点击');
             String id = item['course_id'].toString();
              //点击跳转课程详情页面
              NavigatorUtils.goCurriculumDetail(context, id);
          },
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(color: PublicColor.borderColor)),
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
                        child: Image.network(item['img'].toString(),
                            width: ScreenUtil().setWidth(267),
                            height: ScreenUtil().setWidth(171))),
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
                              bottomLeft:
                                  Radius.circular(ScreenUtil().setWidth(10)),
                              bottomRight:
                                  Radius.circular(ScreenUtil().setWidth(10))),
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
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(20)),
                          child: Text(item['title'],
                              style: TextStyle(
                                  color: PublicColor.textColor,
                                  fontSize: ScreenUtil().setSp(28)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(30)),
                          child: Text(
                            '￥' + item['price'].toString(),
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
                                    Text(item['good_lv'].toString() + '%',
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
        )));
      }
    }
    content = new Column(
      children: arr,
    );
    return arr;
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return InkWell(
        onTap: () => getliveurl(productEntity),
        child: Card(
          elevation: 4.0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
          child: Stack(children: [
            Container(
                child: CachedImageView(
                    ScreenUtil.instance.setWidth(340.0),
                    ScreenUtil.instance.setWidth(337.0),
                    productEntity['img'],
                    null,
                    BorderRadius.all(Radius.circular(10.0)))),
            Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.black.withOpacity(0.5)),
              width: ScreenUtil.instance.setWidth(200.0),
              height: ScreenUtil.instance.setWidth(40.0),
              margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                  ScreenUtil.instance.setWidth(25.0), 0, 0),
              child: new Row(children: [
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      height: ScreenUtil.instance.setWidth(40.0),
                      child: Text(productEntity['online'].toString() + '人观看',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                              fontWeight: FontWeight.w700)),
                    )),
              ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                  ScreenUtil.instance.setWidth(250.0), 0, 0),
              child: new Row(
                children: <Widget>[
                  new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
                  Container(
                    width: ScreenUtil.instance.setWidth(60.0),
                    height: ScreenUtil.instance.setWidth(60.0),
                    decoration: BoxDecoration(
                        color: Color(0xfffa5a5a5),
                        borderRadius:
                        BorderRadius.all(Radius.circular(50.0))),
                    child: CachedImageView(
                        ScreenUtil.instance.setWidth(55.0),
                        ScreenUtil.instance.setWidth(55.0),
                        productEntity['headimgurl'],
                        null,
                        BorderRadius.all(Radius.circular(50.0))),
                  ),
                  Container(
                      alignment: Alignment.center,
                      width: ScreenUtil.instance.setWidth(230.0),
                      height: ScreenUtil.instance.setWidth(70.0),
                      child: Text('  ' + productEntity['real_name'],
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                              fontWeight: FontWeight.w700))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                  ScreenUtil.instance.setWidth(350.0), 0, 0),
              child: new Column(children: <Widget>[
                Container(
                    width: ScreenUtil().setWidth(300),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20), top: 6),
                    child: Text(
                      productEntity['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    )),
              ]),
            )
          ]),
        ));
  }

}
