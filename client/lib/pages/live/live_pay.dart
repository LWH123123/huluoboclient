import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routers/fluro_convert_util.dart';
import '../../widgets/cached_image.dart';
import '../../service/live_service.dart';
import '../../utils/toast_util.dart';

class LivePay extends StatefulWidget {
  final String objs;
  LivePay({this.objs});
  @override
  _LivePayState createState() => _LivePayState();
}

class _LivePayState extends State<LivePay> {
  Map list = {};
  @override
  void initState() {
    list = FluroConvertUtils.string2map(widget.objs);
    super.initState();
  }

  void getPay() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => list['roomId']);
    LiveServer().livePay(map, (success) async {
      await Future.delayed(Duration(seconds: 1), () {
        // NavigatorUtils.goCreateCourse(context);
        getliveurl();
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  getliveurl() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => list['roomId']);
    LiveServer().inRoom(map, (success) async {
      //Map obj = {'url': success['res']['rtmp_url']};
      // print(obj);
      NavigatorUtils.goSlideLookZhibo(context,room_id: list['roomId'].toString(),boo: true);
      //NavigatorUtils.goLookZhibo(context, list['productEntity'], obj,true);
    }, (onFail) async {
      ToastUtil.showToast('请支付');
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(list['bgImg']),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7)),
            child: Column(
              children: <Widget>[
                FlatButton(
                  padding: StyleUtil.padding(left: 20, top: 50),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.navigate_before,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text('返回',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.whiteColor))
                    ],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: StyleUtil.width(159)),
                CachedImageView(
                    ScreenUtil.instance.setWidth(246.0),
                    ScreenUtil.instance.setWidth(246.0),
                    list['headimgurl'],
                    null,
                    BorderRadius.all(Radius.circular(10.0))),
                SizedBox(height: StyleUtil.width(27)),
                Text(list['realName'],
                    style: StyleUtil.tontStyle(
                        color: PublicColor.whiteColor, num: 36)),
                SizedBox(height: StyleUtil.width(107)),
                Container(
                  width: StyleUtil.width(600),
                  height: StyleUtil.width(199),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/live/paylivetext2.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text('直播名称：',
                                  style: StyleUtil.tontStyle(
                                      color: PublicColor.whiteColor)),
                              width: StyleUtil.width(150),
                            ),
                            Text(list['name'],
                                style: StyleUtil.tontStyle(
                                    color: PublicColor.whiteColor))
                          ],
                        ),
                        padding: StyleUtil.padding(left: 150),
                      ),
                      SizedBox(height: StyleUtil.width(21)),
                      Container(
                        padding: StyleUtil.padding(left: 150),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text('直播价格：',
                                  style: StyleUtil.tontStyle(
                                      color: PublicColor.whiteColor)),
                              width: StyleUtil.width(150),
                            ),
                            Text('￥' + list['price'].toString(),
                                style: StyleUtil.tontStyle(
                                    color: PublicColor.whiteColor))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: StyleUtil.width(117)),
                Text('当前余额：' + list['balance'],
                    style: StyleUtil.tontStyle(color: PublicColor.whiteColor)),
                SizedBox(height: StyleUtil.width(51)),
                Container(
                  width: StyleUtil.width(545),
                  height: StyleUtil.width(80),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(46))),
                    color: PublicColor.themeColor,
                    textColor: PublicColor.whiteColor,
                    child: Text('立即支付'),
                    onPressed: () {
                      getPay();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
