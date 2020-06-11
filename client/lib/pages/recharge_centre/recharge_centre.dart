import 'dart:async';

import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/store_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:client/common/color.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class RechargeCentre extends StatefulWidget {
  @override
  RechargeCentreState createState() => RechargeCentreState();
}

class RechargeCentreState extends State<RechargeCentre> {
  bool isLoading = false;
  List list = [];
  int currentId = 1;
  String balance = '';
  String orderId = '';
  Timer _timer;
  @override
  void initState() {
    super.initState();
    getBalance();
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
      "type": 1
    }, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      await Future.delayed(Duration(seconds: 2), () {
        getBalance();
      });
    }, (onFail) async {
      print('支付回调接口--------------------${onFail.toString()}');
//      ToastUtil.showToast(onFail);
//      setState(() {
//        isLoading = false;
//      });
    });
  }
   payMoney() {
    var items = list.indexWhere((item) => (item['id'] == currentId));
    print('查找----$items');
    var money;
    items != -1 ? money = list[items]['name'] : ToastUtil.showToast('请选择支付金额');
    if (money == null) return;
    StoreServer().voucherPay({
      "amount": money
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
  void getBalance() async {
     setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    UserServer().getBalanceApi(map, (success) async {
       setState(() {
      isLoading = false;
    });
      balance = success['user']['balance'];
      list = success['res'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  void deactivate() {
    // TODO: implement deactivate
    cancelTimer();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      child: Container(
        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
        child: new Row(children: <Widget>[
          Container(
              child: Text(
            '当前余额:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: ScreenUtil().setSp(33),
            ),
          )),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                balance,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xffE71419),
                  fontSize: ScreenUtil().setSp(36),
                ),
              ))
        ]),
      ),
    );

    Widget balanceArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      for (var item in list) {
        arr.add(Container(
            child: InkWell(
          onTap: () {
            setState(() {
              currentId = item['id'];
            });
            print(currentId);
          },
          child: Container(
            margin: EdgeInsets.only(left: 12),
            width: ScreenUtil().setWidth(206),
            height: ScreenUtil().setWidth(73),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: currentId == item['id']
                    ? Color(0xffE71419)
                    : Color(0xfffffff),

                ///圆角
                border: Border.all(color: Color(0xff454545), width: 1)

                ///边框颜色、宽
                ),
            child: Text(
              item['name'].toString() + '元',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: currentId == item['id']
                    ? Color(0xffffffff)
                    : Color(0xff454545),
              ),
            ),
          ),
        )));
      }
      content = new Wrap(
        spacing: 8.0, // 主轴(水平)方向间距
        runSpacing: 8.0, // 纵轴（垂直）方向间距
        alignment: WrapAlignment.start,
        children: arr,
      );
      return content;
    }

    Widget btnArea = new Container(
        child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 50),
      child: InkWell(
          onTap: () {
            print('提交');
            payMoney();
          },
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(570),
            height: ScreenUtil().setWidth(92),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xffE71419),
            ),
            child: Text(
              '提交',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(28),
              ),
            ),
          )),
    ));

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
            title: Text('充值'),
            actions: <Widget>[
              InkWell(
                child: Container(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Text(
                      '充值记录',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(30),
                        height: 2.7,
                      ),
                    )),
                onTap: () {
                  NavigatorUtils.rechargeRecordPage(context);
                },
              )
            ],
          ),
          body: Container(
              child: new ListView(
                  children: <Widget>[topArea, balanceArea(), btnArea])),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
    
  }
}
