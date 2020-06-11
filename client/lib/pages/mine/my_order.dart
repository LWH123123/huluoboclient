import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/color.dart';
import '../../widgets/loading.dart';
import '../../widgets/cached_image.dart';
import '../../utils/toast_util.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/dialog.dart';
import '../../service/store_service.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class MyOrderPage extends StatefulWidget {
  final String type;
  MyOrderPage(this.type);
  @override
  MyOrderPageState createState() => MyOrderPageState();
}

class MyOrderPageState extends State<MyOrderPage> {
  bool isLoading = false;
  int _page = 0;
  String jwt = "";
  List listview = [];
  int clickIndex = 0;
  EasyRefreshController _controller = EasyRefreshController();
  String orderId = '';
  Timer _timer;
  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      _page = 0;
      // getList(clickIndex);
    }
  }

  @override
  void initState() {
    super.initState();
    print('传递过来的标识为'+widget.type);
    clickIndex = int.parse(widget.type);
    // getList(clickIndex);
    getOrserList(clickIndex);
    fluwx.responseFromPayment.listen((res) {
      print("pay============== :${res.toString()}");
      if (res.errCode == 0) {
        startTimer(orderId);
        print('errCode----${res.errCode}');
      }else{
        ToastUtil.showToast('支付失败,请重试');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void getOrserList(clickIndex) async {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      listview = [];
    }

    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => clickIndex);
    map.putIfAbsent("limit", () => 10);
    map.putIfAbsent("page", () => _page);

    StoreServer().getOrderApi(map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          listview = success['res'];
        } else {
          if (success['res'].length == 0) {
            ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['res'].length; i++) {
              listview.insert(listview.length, success['res'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  //取消订单
  void cancelApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => id);
    StoreServer().getCancelApi(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('订单已取消');
      listview.removeWhere((item) => item['order_id'] == id);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //确认收货
  void confirmApi(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => id);
    StoreServer().getConfirmSh(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('收货成功');
      listview.removeWhere((item) => item['order_id'] == id);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //去付款
  void payment(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => id);
    StoreServer().getTjOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }
  payMoney(id) {
    if (id == null) return ToastUtil.showToast('请选择支付订单');
    StoreServer().getTjOrder({
      "order_id": id
    }, (success) async {
      print(success);
      print(success['res']['appid']);
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
      orderId = success['res']['order_id'].toString();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }
  void startTimer(orderId) {
    setState(() {
      isLoading = true;
    });
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }
  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }
  void getPayStatus(orderId) async {
    print('支付中..');
    StoreServer().pay_type({
      "order_id": orderId,
      "type": 2
    }, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      await Future.delayed(Duration(seconds: 2), () {
        getOrserList(clickIndex);
      });
    }, (onFail) async {
      print('支付回调接口--------------------${onFail.toString()}');
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        new DefaultTabController(
          length: 5,
          initialIndex: int.parse(widget.type),
          child: new Scaffold(
            appBar: new AppBar(
                centerTitle: true,
                title: new Text(
                  '我的订单',
                  style: TextStyle(
                    color: PublicColor.headerTextColor,
                  ),
                ),
                backgroundColor: PublicColor.themeColor,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Material(
                    color: Colors.white,
                    child: TabBar(
                        onTap: ((index) {
                          clickIndex = index;
                          print(clickIndex);
                          listview = [];
                          _page = 0;
                          getOrserList(clickIndex);
                        }),
                        indicatorWeight: 3.0,
                        labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                        // indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: PublicColor.themeColor,
                        unselectedLabelColor: Color(0xff5e5e5e),
                        labelColor: PublicColor.themeColor,
                        tabs: <Widget>[
                          new Tab(
                            child: Text(
                              '全部',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '待付款',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '待发货',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '待收货',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              '已完成',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                  ),
                )),
            body: Container(
              width: ScreenUtil.getInstance().setWidth(750.0),
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil.instance.setWidth(25),
                  ScreenUtil.instance.setWidth(0),
                  ScreenUtil.instance.setWidth(25),
                  0),
              child: Container(
                width: ScreenUtil.getInstance().setWidth(700.0),
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
                  child: gouwuitem(context, listview),
                  onRefresh: () async {
                    _page = 0;
                    getOrserList(clickIndex);
                  },
                  onLoad: () async {
                    getOrserList(clickIndex);
                  },
                ),
              ),
            ),
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }

  Widget gouwuitem(BuildContext context, listview) {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listview.length == 0) {
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
      int index = 0;
      for (var item in listview) {
        index++;
        arr.add(Container(
          child: new Column(children: [
            new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: new Border.all(color: Color(0xfffececec), width: 0.5),
              ),
              child: Column(children: [
                Container(
                  height: ScreenUtil.getInstance().setWidth(80.0),
                  padding: EdgeInsets.only(
                      right: ScreenUtil.instance.setWidth(20.0)),
                  child: Row(children: [
                    new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                    new SizedBox(width: ScreenUtil.instance.setWidth(5.0)),
                    Text(
                      '订单号:  ' + item['order_id'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.instance.setWidth(26.0)),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                            item['pay_status'] == "0"
                                ? '待付款'
                                : item['pay_status'] == "1"
                                    ? '配货中'
                                    : item['pay_status'] == "2"
                                        ? '待收货'
                                        : item['pay_status'] == "3"
                                            ? '已完成'
                                            : item['pay_status'] == "4"
                                                ? '已取消'
                                                : '',
                            style: TextStyle(
                                color: item['pay_status'] == "3"
                                    ? Color(0xffa0a0a0):item['pay_status'] == "4"
                                    ? Color(0xffa0a0a0)
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil.instance.setWidth(26.0))),
                        alignment: Alignment.centerRight,
                      ),
                      flex: 1,
                    )
                  ]),
                ),
                new Column(children: listBoxs(item['order_goods'], index)),
                Container(
                  height: ScreenUtil.getInstance().setWidth(120.0),
                  padding: EdgeInsets.only(top: 15),
                  decoration: ShapeDecoration(
                    shape: Border(
                        top: BorderSide(color: Color(0xfffececec), width: 1.0)),
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      InkWell(
                        child: Container(
                          height: ScreenUtil.getInstance().setWidth(60.0),
                          width: ScreenUtil.getInstance().setWidth(175.0),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            border: new Border.all(
                                color: Color(0xfff979797), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text('查看详情',
                              style: TextStyle(
                                  color: Color(0xfff979797),
                                  fontSize:
                                      ScreenUtil.instance.setWidth(28.0))),
                        ),
                        onTap: () {
                          print('查看详情');
                          String id = item['order_id'];
                          NavigatorUtils.toOrderDetail(context, id);
                        },
                      ),
                      // new SizedBox(width: ScreenUtil.instance.setWidth(25.0)),
                      item['pay_status'] == "0"
                          ? InkWell(
                              child: Container(
                                height: ScreenUtil.getInstance().setWidth(60.0),
                                width: ScreenUtil.getInstance().setWidth(175.0),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: new Border.all(
                                      color: Color(0xfff979797), width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text('取消订单',
                                    style: TextStyle(
                                        color: Color(0xfff979797),
                                        fontSize: ScreenUtil.instance
                                            .setWidth(28.0))),
                              ),
                              onTap: () {
                                print('取消订单');
                                print(item['order_id']);
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return MyDialog(
                                          width: ScreenUtil.instance
                                              .setWidth(600.0),
                                          height: ScreenUtil.instance
                                              .setWidth(300.0),
                                          queding: () {
                                            cancelApi(item['order_id']);
                                            Navigator.of(context).pop();
                                          },
                                          quxiao: () {
                                            Navigator.of(context).pop();
                                          },
                                          title: '温馨提示',
                                          message: '确定要取消订单吗？');
                                    });
                              },
                            )
                          : Container(),
                      item['pay_status'] == "0"
                          ? InkWell(
                              child: Container(
                                height: ScreenUtil.getInstance().setWidth(60.0),
                                width: ScreenUtil.getInstance().setWidth(175.0),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: new Border.all(
                                      color: PublicColor.themeColor, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text('去付款',
                                    style: TextStyle(
                                        color: PublicColor.themeColor,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(28.0))),
                              ),
                              onTap: () {
                                print('去付款');
                                print(item['order_id']);
                                payMoney(item['order_id']);
                              },
                            )
                          : Container(),
                      item['pay_status'] == "2"
                          ? InkWell(
                              child: Container(
                                height: ScreenUtil.getInstance().setWidth(60.0),
                                width: ScreenUtil.getInstance().setWidth(175.0),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: new Border.all(
                                      color: PublicColor.themeColor, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text('确认收货',
                                    style: TextStyle(
                                        color: PublicColor.themeColor,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(28.0))),
                              ),
                              onTap: () {
                                print('确认收货');
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return MyDialog(
                                          width: ScreenUtil.instance
                                              .setWidth(600.0),
                                          height: ScreenUtil.instance
                                              .setWidth(300.0),
                                          queding: () {
                                            confirmApi(item['order_id']);
                                            Navigator.of(context).pop();
                                          },
                                          quxiao: () {
                                            Navigator.of(context).pop();
                                          },
                                          title: '温馨提示',
                                          message: '确认收货吗？');
                                    });
                              },
                            )
                          : Container(),
                    ]),
                  ]),
                )
              ]),
            ),
          ]),
        ));
      }
    }
    content = new ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: arr,
    );
    return content;
  }

  List<Widget> listBoxs(listView, listindex) =>
      List.generate(listView.length, (index) {
        return Container(
            width: ScreenUtil.instance.setWidth(700),
            height: ScreenUtil.instance.setWidth(245),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: Border(
                top: BorderSide(color: Color(0xfffececec), width: 1),
              ),
            ),
            child: new InkWell(
              child: new Row(
                children: <Widget>[
                  new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                  CachedImageView(
                      ScreenUtil.instance.setWidth(204.0),
                      ScreenUtil.instance.setWidth(204.0),
                      listView[index]['thumb'],
                      null,
                      BorderRadius.all(Radius.circular(0))),
                  new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
                  Container(
                    width: ScreenUtil.instance.setWidth(420.0),
                    height: ScreenUtil.instance.setWidth(204.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new SizedBox(
                              height: ScreenUtil.instance.setWidth(10.0)),
                          Text(
                            listView[index]['name'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                            ),
                          ),
                          new SizedBox(
                            height: ScreenUtil.instance.setWidth(10.0),
                          ),
                          new Row(children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                height: ScreenUtil.instance.setWidth(75.0),
                                alignment: Alignment.bottomLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥${listView[index]['price']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xffE71419),
                                        fontSize:
                                            ScreenUtil.instance.setWidth(28.0)),
                                  ),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: ScreenUtil.instance.setWidth(75.0),
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "x" + listView[index]['num'],
                                    style: TextStyle(
                                        color: Color(0xfffcccccc),
                                        fontSize:
                                            ScreenUtil.instance.setWidth(27.0)),
                                  ),
                                ),
                                flex: 1),
                          ])
                        ]),
                  )
                ],
              ),
              onTap: () {
                print('商品详情');
                String shipId = listView[index]['ship_id'];
                String roomId = listView[index]['room_id'];
                String id = listView[index]['goods_id'];
                NavigatorUtils.goXiangQing(context, id, shipId, roomId);
              },
            ));
      });
}
