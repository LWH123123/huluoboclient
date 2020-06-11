import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/live_service.dart';
import 'live_recharge.dart';

//送礼物
class GiftsWidget extends StatefulWidget {
  final Function showGift;
  final String roomId;
  int live_type;
  GiftsWidget({this.showGift, this.roomId, this.live_type});
  @override
  GiftsWidgetState createState() => GiftsWidgetState();
}

class GiftsWidgetState extends State<GiftsWidget> {
  bool isLoading = false;
  String jwt = '';
  String giftCoin = '0', myCoin = '0';
  List giftsList = [];
  Map userInfo = {};
  Map giftItem = {};
  String isLive = '';
  @override
  void initState() {
    super.initState();
    getInfo().then((res) {
      getList(res);
    });
  }

  Future getInfo() async {
    Map<String, dynamic> map = Map();
    await UserServer().getMyApi({}, (success)  {
      print(success);
      setState(() {
        myCoin = success['user']['balance'].toString();
        isLive = success['user']['is_live'].toString();
        userInfo = success['user'];
      });
      map = success['user'];
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
    return map;
  }

  void getList(user) async {
    Map<String, dynamic> map = Map();
    print("a-------------------${user}");
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("type", () => widget.live_type == 1 ? 2 : 1);
    LiveServer().getLiveGift(map, (success) async {
      for (var item in success['list']) {
        item['choose'] = false;
      }
      setState(() {
        giftsList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 发送礼物
  void sendGift() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("amount", () => giftCoin);
    map.putIfAbsent("type", () => isLive == "1" ? 2 : 1);
    LiveServer().checkBalance(map, (success) async {
      ToastUtil.showToast('发送成功');
      widget.showGift(userInfo, giftItem);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void popGift([content]) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);

    Widget topArea = new Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      height: ScreenUtil().setWidth(90),
      child: new Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              padding: EdgeInsets.only(left: 20),
              width: ScreenUtil().setWidth(320),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: new Text(
                      '当前金币: ' + myCoin,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            left: 0,
            top: ScreenUtil().setWidth(22),
          ),
          Positioned(
            child: InkWell(
              onTap: () {
                NavigatorUtils.rechargeCentrePage(context).then((res) => getInfo());
                print('adasd');
//                showModalBottomSheet(
//                  context: context,
//                  builder: (BuildContext context) {
//                    return RechargeWidget(myCoin: myCoin, getInfo: getInfo);
//                  },
//                );
              },
              child: Container(
                height: ScreenUtil().setWidth(50),
                width: ScreenUtil().setWidth(115),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new Text(
                      '充值',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                    new Icon(
                      Icons.navigate_next,
                      color: Color(0xff7c7d82),
                    )
                  ],
                ),
              ),
            ),
            top: ScreenUtil().setWidth(22.0),
            right: ScreenUtil().setWidth(20.0),
          )
        ],
      ),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;

      for (var item in giftsList) {
        arr.add(
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(185),
              padding: EdgeInsets.only(
                top: ScreenUtil().setWidth(16),
              ),
              child: PhysicalModel(
                color: Colors.transparent, //设置背景底色透明
                borderRadius: BorderRadius.circular(
                  ScreenUtil().setWidth(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: <Widget>[
                    Image.network(
                      item['img'],
                      height: ScreenUtil().setWidth(90),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(8),
                    ),
                    item['choose']
                        ? Container()
                        : Container(
                            height: ScreenUtil().setWidth(50),
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(30),
                                  color: Colors.white),
                            ),
                          ),
                    Container(
                      child: Text(
                        item['amount'] + '金币',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(22),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    item['choose']
                        ? InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return MyDialog(
                                        width:
                                            ScreenUtil.instance.setWidth(600.0),
                                        height:
                                            ScreenUtil.instance.setWidth(300.0),
                                        queding: () {
                                          popGift();
                                          Navigator.pop(context);
                                          sendGift();
                                        },
                                        quxiao: () {
                                          Navigator.of(context).pop();
                                        },
                                        title: '温馨提示',
                                        message: '确定发送？');
                                  });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: ScreenUtil().setWidth(5),
                              ),
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(185),
                              height: ScreenUtil().setWidth(50),
                              decoration: BoxDecoration(
                                color: Color(0xffff0151),
                              ),
                              child: Text(
                                '发送',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
            ),
            onTap: () {
              for (var item in giftsList) {
                item['choose'] = false;
              }
              setState(() {
                item['choose'] = true;
                giftCoin = item['amount'].toString();
                giftItem = item;
              });
            },
          ),
        );
      }

      content = new Wrap(
        spacing: 1.0, // 主轴(水平)方向间距
        runSpacing: 7.0,
        alignment: WrapAlignment.start,
        children: arr,
      );
      return content;
    }

    return Scaffold(
      body: ListView(
        children: <Widget>[
          topArea,
          Container(
            height: ScreenUtil().setWidth(665.0),
            alignment: Alignment.topLeft,
            color: Colors.black87,
            child: listArea(),
          ),
        ],
      ),
    );
  }
}
