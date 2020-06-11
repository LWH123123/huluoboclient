import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/cached_image.dart';
import '../../common/color.dart';
import '../../service/store_service.dart';
import '../../widgets/loading.dart';
import '../../utils/toast_util.dart';
import '../../widgets/dialog.dart';
import 'dart:async';
import 'package:fluwx/fluwx.dart' as fluwx;
class OrderDetailPage extends StatefulWidget {
  final String id;
  OrderDetailPage({this.id});
  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool isLoading = false;

  List listview = [];
  String status = '',
      name = '',
      tel = '',
      address = '',
      total = '',
      freight = '',
      amount = '';
  String time = '';
  String orderId = '';
  Timer _timer;
  @override
  void initState() {
    super.initState();
    print(widget.id);
    deteleApi();
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

  //订单详情
  void deteleApi() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => widget.id);
    StoreServer().getOrderDetails(map, (success) async {
      setState(() {
        isLoading = false;
        status = success['order']['pay_status'].toString();
        name = success['order']['receiver'];
        tel = success['order']['phone'];
        address = success['order']['full_address'];
        total = success['order']['total'];
        amount = success['order']['amount'];
        freight = success['order']['freight'];
        time = success['order']['create_at'];
        //商品
        listview = success['order']['order_goods'];
      });
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
       Navigator.of(context).pop();
      // listview.removeWhere((item) => item['order_id'] == id);
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
        deteleApi();
      });
    }, (onFail) async {
      print('支付回调接口--------------------${onFail.toString()}');
            //ToastUtil.showToast(onFail);
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  void dispose() {
    cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('订单详情'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: contentWidget());
  }

  Widget contentWidget() {
    return ListView(
      children: <Widget>[
        Container(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Container(
                // width: ScreenUtil.instance.setWidth(700.0),
                alignment: Alignment.center,
                child: new Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.instance.setWidth(750.0),
                      height: ScreenUtil.instance.setWidth(100.0),
                      color: Color(0xffE71419),
                      child: new Row(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Image.asset(
                            'assets/mine/icon_xq.png',
                            width: ScreenUtil.getInstance().setWidth(30.0),
                            height: ScreenUtil.getInstance().setWidth(44.0),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              status == '0'
                                  ? '待付款'
                                  : status == '1'
                                      ? '配货中'
                                      : status == '2'
                                          ? '待收货'
                                          : status == '3'
                                              ? '已完成'
                                              : status == '4' ? '已取消' : '',
                              style: TextStyle(
                                color: PublicColor.btnColor,
                                fontSize: ScreenUtil.instance.setWidth(28.0),
                              ),
                            ))
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: ScreenUtil.instance.setWidth(700.0),
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: new Column(children: <Widget>[
                        Container(
                          width: ScreenUtil.instance.setWidth(700.0),
                          child: Text(
                            name + '  ' + tel,
                            style: TextStyle(
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil.instance.setWidth(700.0),
                          child: Text(
                            address,
                            style: TextStyle(
                              color: Color(0xff7A7A7A),
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: ScreenUtil.instance.setWidth(700.0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            height: ScreenUtil.instance.setWidth(215.0) *
                                listview.length,
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(25),
                                right: ScreenUtil().setWidth(25)),
                            child: ListView.builder(
                                physics: new NeverScrollableScrollPhysics(),
                                itemCount: listview.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return dingdanitem(
                                      context, listview[index], index);
                                }),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(700.0),
                            padding: EdgeInsets.only(top: 5),
                            child: new Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '商品合计',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          color: Color(0xff2C2C2C),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '￥' + amount,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: Color(0xff454545),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(700.0),
                            padding: EdgeInsets.only(top: 5),
                            child: new Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '运费',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '+￥' + freight,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: Color(0xff454545),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(700.0),
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Color(0xffdddddd)))),
                            child: new Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '备注',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '中通快递',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: Color(0xff454545),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(700.0),
                            padding: EdgeInsets.only(top: 10),
                            child: new Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      '应付金额',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      '￥' + total,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setSp(28),
                                        color: Color(0xffE61414),
                                      ),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),

                    //订单编号
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: ScreenUtil.instance.setWidth(700.0),
                      height: ScreenUtil.instance.setWidth(130.0),
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, top: 15),
                      child: new Column(children: <Widget>[
                        Container(
                          width: ScreenUtil.instance.setWidth(700.0),
                          child: Text(
                            '订单编号' + '  ' + widget.id,
                            style: TextStyle(
                              color: Color(0xff7A7A7A),
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil.instance.setWidth(700.0),
                          child: Text(
                            '创建时间' + '    ' + time,
                            style: TextStyle(
                              color: Color(0xff7A7A7A),
                              fontSize: ScreenUtil.instance.setWidth(28.0),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(100.0)),
              //按钮
              status == '0'
                  ? Container(
                      width: ScreenUtil.instance.setWidth(750.0),
                      height: ScreenUtil.instance.setWidth(100.0),
                      padding: EdgeInsets.only(right: 30),
                      color: Colors.white,
                      child: new Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: Container()),
                          Container(
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              child: InkWell(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(65.0),
                                  width: ScreenUtil.instance.setWidth(180.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    border: new Border.all(
                                        color: Color(0xff6B6B6B), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('取消订单',
                                      style: TextStyle(
                                          color: Color(0xff6B6B6B),
                                          fontSize: ScreenUtil().setWidth(28))),
                                ),
                                onTap: () {
                                  print('取消订单');
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
                                              cancelApi(widget.id);
                                              Navigator.of(context).pop();
                                            },
                                            quxiao: () {
                                              Navigator.of(context).pop();
                                            },
                                            title: '温馨提示',
                                            message: '确定要取消订单吗？');
                                      });
                                },
                              ),
                            ),
                          ),
                          Container(
                            child: Container(
                              child: InkWell(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(65.0),
                                  width: ScreenUtil.instance.setWidth(180.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    border: new Border.all(
                                        color: Color(0xffE71419), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('去付款',
                                      style: TextStyle(
                                          color: Color(0xffE71419),
                                          fontSize: ScreenUtil().setWidth(28))),
                                ),
                                onTap: () {
                                  print('去付款');
                                  payMoney(widget.id);
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
              status == '2'
                  ? Container(
                      width: ScreenUtil.instance.setWidth(750.0),
                      height: ScreenUtil.instance.setWidth(100.0),
                      padding: EdgeInsets.only(right: 30),
                      color: Colors.white,
                      child: new Row(
                        children: <Widget>[
                          Expanded(flex: 1, child: Container()),
                          Container(
                            child: Container(
                              child: InkWell(
                                child: Container(
                                  height: ScreenUtil.instance.setWidth(65.0),
                                  width: ScreenUtil.instance.setWidth(180.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30.0)),
                                    border: new Border.all(
                                        color: Color(0xffE71419), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('确认收货',
                                      style: TextStyle(
                                          color: Color(0xffE71419),
                                          fontSize: ScreenUtil().setWidth(28))),
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
                                              confirmApi(widget.id);
                                              Navigator.of(context).pop();
                                            },
                                            quxiao: () {
                                              Navigator.of(context).pop();
                                            },
                                            title: '温馨提示',
                                            message: '确认收货吗？');
                                      });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Container()
            ]))
      ],
    );
  }

  Widget dingdanitem(BuildContext context, item, index) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffdddddd)))),
      child: Row(
        children: <Widget>[
          // //图片
          CachedImageView(
              ScreenUtil.instance.setWidth(167.0),
              ScreenUtil.instance.setWidth(167.0),
              item['thumb'],
              null,
              BorderRadius.all(Radius.circular(10))),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(377),
                  // height: ScreenUtil().setWidth(67),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                  child: Text(
                    item['name'],
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Color(0xff4E4E4E)),
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(357),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(27),
                    top: ScreenUtil().setWidth(40),
                  ),
                  child: new Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '￥${item['price']}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Color(0xff454545),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          child: Text(
                            'X' + item['num'],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: Color(0xff454545),
                            ),
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
