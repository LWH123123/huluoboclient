import 'dart:async';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

//充值金币
class RechargeWidget extends StatefulWidget {
  final String myCoin;
  final Function getInfo;
  RechargeWidget({this.myCoin, this.getInfo});
  @override
  RechargeWidgetState createState() => RechargeWidgetState();
}

class RechargeWidgetState extends State<RechargeWidget> {
  List rechargeList = [];
  String open = "1";
  bool isloading = false;
  Timer _timer;
  String orderId = '';

  @override
  void initState() {
    super.initState();
    // 监听 支付回调
    fluwx.responseFromPayment.listen((res) {
      print("pay============== :${res.errCode}");
      if (res.errCode == 0) {
        startTimer(orderId);
      } else {
        if (open == "1") {
          open = "2";
          ToastUtil.showToast('支付失败,请重试');
        }
      }
    });
    getRecharge();
  }

  void startTimer(orderId) {
    isloading = true;
    //设置 1 秒回调一次
    const period = const Duration(seconds: 2);
    _timer = Timer.periodic(period, (timer) {
      getPayStatus(orderId);
      //更新界面
    });
  }

  void popContent() {
    Navigator.pop(context);
  }

  // 充值回调
  void getPayStatus(orderId) async {
    print('支付中..');
    Map<String, dynamic> map = Map();
    map.putIfAbsent("order_id", () => orderId);
    map.putIfAbsent("type", () => "5");
    UserServer().getPayStatus(map, (success) async {
      isloading = false;
      widget.getInfo();
      cancelTimer();
      ToastUtil.showToast('充值成功');
      Navigator.pop(context);
    }, (onFail) async {
      // ToastUtil.showToast(onFail);
    });
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  void getRecharge() async {
    Map<String, dynamic> map = Map();
    LiveServer().getRecharge(map, (success) async {
      if (mounted) {
        setState(() {
          rechargeList = success['list'];
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 去充值
  void toRecharge(item) async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => item['id']);
    map.putIfAbsent("pay_state", () => 1);
    LiveServer().toRecharge(map, (success) async {
      setState(() {
        isloading = false;
      });
      orderId = success['res']['order_id'];
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 230)..init(context);

    Widget topnone = new SizedBox(
      height: ScreenUtil().setWidth(25),
    );

    Widget topArea = new Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      width: ScreenUtil().setWidth(750),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                Text('金币: '),
                Image.asset(
                  'assets/zhibo/jb.png',
                  height: ScreenUtil().setWidth(30),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(8),
                ),
                new Text(widget.myCoin),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text('充值'),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );

    Widget rechargeItem(item) {
      return InkWell(
        child: new Container(
          height: ScreenUtil().setWidth(120),
          width: ScreenUtil().setWidth(230),
          decoration: BoxDecoration(
            color: Color(0xffececec),
            borderRadius: new BorderRadius.circular(10),
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/zhibo/jb.png',
                    height: ScreenUtil().setWidth(45),
                  ),
                  Text(
                    ' ' + item['coin'],
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              Container(
                child: Text(
                  item['rmb'] + ' 元',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          print('充金币');
          toRecharge(item);
        },
      );
    }

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (rechargeList.length == 0) {
        arr.add(
          Container(
            height: ScreenUtil().setWidth(700),
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(300),
            ),
            child: Text(
              '暂无数据',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      for (var item in rechargeList) {
        arr.add(rechargeItem(item));
      }

      content = new Wrap(
        spacing: 10.0, // 主轴(水平)方向间距
        runSpacing: 10.0,
        alignment: WrapAlignment.start,
        children: arr,
      );
      return content;
    }

    Widget listcar = listArea();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                child:
                    new Column(children: <Widget>[topnone, topArea, listcar]),
              ),
            ],
          ),
          isloading ? LoadingDialog(types: "1") : Container()
        ],
      ),
    );
  }
}
