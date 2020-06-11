import 'package:client/service/home_service.dart';
import 'package:client/service/live_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../routers/Navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/loading.dart';
import '../../widgets/zhibo_topbar.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../widgets/swiper.dart';
import '../../utils/toast_util.dart';
import 'package:flutter/services.dart';
import '../../common/color.dart';

class Live extends StatefulWidget {
  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> with SingleTickerProviderStateMixin {
  DateTime lastPopTime;
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
  bool isloading = false;
  List bannerList = [];
  List tabView = [];
  List liveItem = [];
  int page = 1;
  // tab 切换事件
  tabIndexSet() {
    _tabController.index == _tabController.animation.value.toInt()
        ? resList(null)
        : '';
  }

  resList(int num) {
    setState(() {
      if (num != null) {
        page += num;
      } else {
        page = 1;
        liveItem = [];
      }
    });
    getLiveList(tabView[_tabController.index]['id']);
  }
 
  // 获取直播分类
  getLiveType() {
    LiveServer().getLiveType({"type": 2}, (onSuccess) {
      setState(() {
        tabView = onSuccess;
      });
      _tabController = TabController(vsync: this, length: onSuccess.length);
      _tabController.addListener(() => tabIndexSet());
      resList(null);
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // 获取直播列表
  getLiveList(id) {
    LiveServer().getLiveList({"type": id, "page": this.page, "limit": 10},
        (onSuccess) {
      _controller.finishRefresh();
      List arr = onSuccess['list'];
      if (arr.length == 0) return;
      setState(() {
        liveItem.addAll(arr);
      });
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  // 轮播
  getBanner() {
    HomeServer().getBanner({}, (onSuccess) {
      setState(() => bannerList = onSuccess['banner']);
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getBanner();
    this.getLiveType();
    super.initState();
  }

  // 获得推流地址
  getliveurl(productEntity) async { 
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => productEntity['id']);
    LiveServer().inRoom(map, (success) async {
      Map obj = {'url': success['res']['rtmp_url']};
      // print(obj);
      // NavigatorUtils.goLookZhibo(context, productEntity, obj);
      NavigatorUtils.goSlideLookZhibo(context,room_id: productEntity['id'].toString());
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
          "productEntity": productEntity
        };
        ToastUtil.showToast(onFail['errmsg']);
        NavigatorUtils.goLivePay(context,obj);
      } else {
        ToastUtil.showToast(onFail['errmsg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: tabView.length,
      child: Stack(
        children: <Widget>[
          WillPopScope(
            child: Scaffold(
                appBar: new AppBar(
                    elevation: 0,
                    title: TopBar(),
                    backgroundColor: PublicColor.themeColor,
                    automaticallyImplyLeading: false),
                body: contentWidget()),
            onWillPop: () async {
              // 点击返回键的操作
              if (lastPopTime == null ||
                  DateTime.now().difference(lastPopTime) >
                      Duration(seconds: 2)) {
                lastPopTime = DateTime.now();
                ToastUtil.showToast('再按一次退出');
                return false;
              } else {
                lastPopTime = DateTime.now();
                // 退出app
                await SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
                return true;
              }
            },
          ),
          isloading ? LoadingDialog() : Container(),
        ],
      ),
    );
  }

  Widget contentWidget() {
    return Container(
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
          Container(
            width: double.infinity,
            height: StyleUtil.width(80),
            color: Colors.white,
            child: TabBar(
              isScrollable: true,
              controller: _tabController,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.blueGrey,
              indicatorColor: Colors.red,
              labelStyle: TextStyle(fontSize: 14),
              tabs: tabView
                  .map((item) => Container(
                        height: ScreenUtil().setWidth(88),
                        child: Center(
                          child: Text(item['name'],
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(28))),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
                controller: _tabController,
                children: tabView.map((item) => tabviewList(item)).toList()),
          )
        ],
      ),
    );
  }

  Widget tabviewList(item) {
    return EasyRefresh(
      controller: _controller,
      header: BezierCircleHeader(
        backgroundColor: PublicColor.themeColor,
      ),
      footer: BezierBounceFooter(
        backgroundColor: PublicColor.themeColor,
      ),
      enableControlFinishRefresh: true,
      enableControlFinishLoad: false,
      child: liveItem.length != 0
          ? GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: ScreenUtil().setWidth(5),
              crossAxisSpacing: ScreenUtil().setWidth(5),
              childAspectRatio: 3.0 / 4,
              children: liveItem.map((item) => viewItem(item)).toList(),
            )
          : ListView(
              children: <Widget>[
                SizedBox(height: StyleUtil.width(300)),
                Center(
                  child: Text('暂无数据'),
                )
              ],
            ),
      onRefresh: () async {
        resList(null);
      },
      onLoad: () async {
        resList(1);
      },
    );
  }

  Widget viewItem(item) {
    return Container(
      child: InkWell(
          onTap: () {
            getliveurl(item);
          },
          child: Card(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(StyleUtil.width(10)),
                      child: Image.network(
                        item['img'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: StyleUtil.width(335),
                      ),
                    ),
                    Container(
                      width: StyleUtil.width(231),
                      height: StyleUtil.width(29),
                      margin: StyleUtil.padding(left: 14, top: 16),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          borderRadius:
                              BorderRadius.circular(StyleUtil.width(14))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: StyleUtil.width(96),
                            height: StyleUtil.width(29),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 0.85),
                                borderRadius:
                                    BorderRadius.circular(StyleUtil.width(14))),
                            child: Center(
                                child: Text(
                              item['is_open'] == '0'
                                  ? '预告'
                                  : item['is_open'] == '1' ? '直播中' : '已结束',
                              style: StyleUtil.tontStyle(
                                  color: PublicColor.themeColor, num: 18),
                            )),
                          ),
                          SizedBox(width: StyleUtil.width(9)),
                          Text(
                            '${item['online']}人观看',
                            style: StyleUtil.tontStyle(
                                color: PublicColor.whiteColor, num: 18),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      left: StyleUtil.width(15),
                      bottom: 2,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: StyleUtil.width(61),
                              height: StyleUtil.width(61),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    StyleUtil.width(30.5)),
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromRGBO(255, 255, 255, 0.6)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    StyleUtil.width(30.5)),
                                child: Image.network(
                                  item['headimgurl'],
                                ),
                              ),
                            ),
                            SizedBox(width: StyleUtil.width(17)),
                            Text(item['real_name'],
                                style: StyleUtil.tontStyle(
                                    color: PublicColor.whiteColor,
                                    num: 28,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: StyleUtil.width(10)),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: StyleUtil.paddingTow(left: 18),
                  child: Text(item['name'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleUtil.tontStyle(
                          color: PublicColor.textColor,
                          num: 28,
                          fontWeight: FontWeight.bold)),
                ),// fre
                Container(
                  alignment: Alignment.centerLeft,
                  padding: StyleUtil.paddingTow(left: 18),
                  child: Text('免费等级: ${item['freelvl'] == '1' ?
                  '白金' : item['freelvl'] == '2' ? '铂金':'钻石'}',
                      style: StyleUtil.tontStyle(
                        color: PublicColor.textColor,
                          num: 28, fontWeight: FontWeight.bold)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: StyleUtil.paddingTow(left: 18),
                  child: Text('￥ ${item['amount']}',
                      style: StyleUtil.tontStyle(
                          num: 28, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )),
    );
  }
}
