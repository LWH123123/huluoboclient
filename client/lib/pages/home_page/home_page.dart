import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../widgets/loading.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/swiper.dart';
import '../../service/home_service.dart';
import '../../widgets/home_product.dart';
import '../../utils/toast_util.dart';
import '../../widgets/home_topbar.dart';
import '../../widgets/cached_image.dart';
import 'package:permission_handler/permission_handler.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin{
  DateTime lastPopTime;
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;
  List bannerList = [];
  // List categoryList = [];
  List recommendList = [];

  List tabView = [];
  List categoryList = [];
  String newsTitle = '';
  @override
  void initState() {
    super.initState();
    getHome();
    _handleCameraAndMic();
  }

  _handleCameraAndMic() async {
    // 请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );

    // // 申请结果
    // PermissionStatus camera =
    //     await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    // PermissionStatus phone = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.microphone);

    //校验权限
    if (permissions[PermissionGroup.camera] != PermissionStatus.granted) {
      ToastUtil.showToast('相机权限获取失败');
      return false;
    }
    if (permissions[PermissionGroup.microphone] != PermissionStatus.granted) {
      ToastUtil.showToast('麦克风权限获取失败');
      return false;
    }
    // return true;
  }


  void getHome() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    HomeServer().getHome(map, (success) async {
      setState(() {
        isLoading = false;
      });
      bannerList = success['banner'];
      categoryList = success['category'];
      recommendList = success['course'];
      newsTitle = success['news'];
      tabView = success['live'];

      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        WillPopScope(
          child: Scaffold(
            appBar: new AppBar(
                elevation: 0,
                title: TopBar(),
                backgroundColor: PublicColor.themeColor,
                automaticallyImplyLeading: false),
            body: contentWidget(),
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
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return true;
            }
          },
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  //新闻动态
  Widget _newState() {
    return InkWell(
      onTap: () {
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
                        '新闻动态',
                        style: TextStyle(
                            color: PublicColor.textColor,
                            fontSize: ScreenUtil().setSp(32)),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(43)),
                    Container(
                      child: Text(newsTitle,
                          style: TextStyle(
                              color: PublicColor.textColor,
                              fontSize: ScreenUtil().setSp(28))),
                    )
                  ],
                ),
              ),
            ));
      },
      child: Container(
        height: ScreenUtil().setWidth(71),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 14,
              child: Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(28),
                    right: ScreenUtil().setWidth(27)),
                child: Text(
                  '新闻动态',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Color(0xffE71419),
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(24)),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: ScreenUtil().setWidth(56),
                width: ScreenUtil().setWidth(1),
                decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: Color(0xffE7E7E7)))),
              ),
            ),
            Expanded(
              flex: 85,
              child: Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(25), right: 100),
                child: Text(
                  newsTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff4E4E4E),
                    fontSize: ScreenUtil().setSp(24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //阴影
  Widget _homeShadow() {
    return Container(
      height: ScreenUtil().setWidth(2),
      decoration: BoxDecoration(
          // color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 2.0), //偏移
              color: Color.fromRGBO(4, 0, 0, 0.08),
              blurRadius: 2, //模糊度
              spreadRadius: 4.0, //扩散程度
            )
          ]),
    );
  }

  Widget _box() {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(10),
      color: Color(0xfff5f5f5),
    );
  }

  //推荐课程标题
  Widget _classTitle() {
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
            child: Image.asset(
              'assets/home/icon_biaoqian.png',
              width: ScreenUtil().setWidth(10),
              height: ScreenUtil().setWidth(35),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(13), top: 3),
            child: Text(
              '推荐课程',
              style: TextStyle(
                  color: Color(0xffE71419),
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  //推荐课程
  Widget _recomMend() {
    List<Widget> arr = <Widget>[];
    Widget content;
    for (var item in recommendList) {
      arr.add(Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xfff5f5f5))),
          ),
          child: new InkWell(
            onTap: () {
              String id = item['id'];
              //点击跳转课程详情页面
              NavigatorUtils.goCurriculumDetail(context, id);
            },
            child: Row(
              children: <Widget>[
                // //图片
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(15)),
                      child: Image.network(item['img'],
                          width: ScreenUtil().setWidth(267),
                          height: ScreenUtil().setWidth(171))),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(387),
                        // height: ScreenUtil().setWidth(67),
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                        child: Text(
                          item['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(30),
                              color: Color(0xff4E4E4E)),
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(387),
                        // height: ScreenUtil().setWidth(67),
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(27),
                          top: ScreenUtil().setWidth(40),
                        ),
                        child: Text(
                          '讲师:' + item['real_name'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xffc6c6c6),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )));
    }
    content = new Column(
      children: arr,
    );
    return content;
  }

  //推荐直播标题
  Widget _homeLive() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(27), top: 15),
            child: Image.asset(
              'assets/home/icon_biaoqian.png',
              width: ScreenUtil().setWidth(10),
              height: ScreenUtil().setWidth(35),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(13), top: 16),
            child: Text(
              '推荐直播',
              style: TextStyle(
                  color: Color(0xffEB9A1A),
                  fontSize: ScreenUtil().setSp(28),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  //推荐直播
  Widget _zhiboList() {
    return ProductView(tabView);
  }

  //课程分类
  Widget classArea() {
    return Container(
      child: new Container(
        height: ScreenUtil.instance.setWidth(220.0),
        width: ScreenUtil.instance.setWidth(750.0),
        padding:
            EdgeInsets.only(left: ScreenUtil.instance.setWidth(25.0), top: 20),
        color: Color(0xffffffff),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return buildListData(context, categoryList[index], index);
          },
        ),
      ),
    );
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
          children: <Widget>[
            SwiperView(
              bannerList,
              bannerList.length,
              ScreenUtil.instance.setWidth(360.0),
                onClick: (index){
                  print(bannerList[index]);
                  NavigatorUtils.goCurriculumDetail(context,bannerList[index]['goods_id']);
                }
            ),
            _newState(),
            _homeShadow(),
            classArea(),
            _box(),
            _classTitle(),
            _recomMend(),
            _box(),
            _homeLive(),
            _zhiboList()
          ],
        )),
        onRefresh: () async {
          getHome();
        },
      ),
    );
  }

  Widget buildListData(context, item, index) {
    return Container(
      height: ScreenUtil.instance.setWidth(260.0),
      // width: ScreenUtil.instance.setWidth(150.0),
      padding: EdgeInsets.only(right: ScreenUtil.instance.setWidth(50.0)),
      child: InkWell(
        onTap: () {
          String id = item['id'];
          NavigatorUtils.goClassification(context, id);
        },
        child: new Column(
          children: <Widget>[
            CachedImageView(
                ScreenUtil.instance.setWidth(102.0),
                ScreenUtil.instance.setWidth(102.0),
                item['img'],
                new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: new Border.all(color: Color(0xfffcccccc), width: 0.5),
                ),
                BorderRadius.circular(10)),
            new Container(
              // width: ScreenUtil.instance.setWidth(220.0),
              height: ScreenUtil.instance.setWidth(65.0),
              padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(10.0)),
              alignment: Alignment.topCenter,
              child: Text(item['name'],
                  style: TextStyle(
                      fontSize: ScreenUtil.instance.setWidth(28.0),
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
