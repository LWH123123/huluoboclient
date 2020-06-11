import 'package:client/common/color.dart';
import 'package:flutter/cupertino.dart';
import '../../routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/user_service.dart';
import '../../utils/toast_util.dart';
import '../../widgets/loading.dart';
import '../../service/live_service.dart';
import './liveVideoWIdget.dart';

class InformationLive extends StatefulWidget {
  final oid;
  String room_id;
  InformationLive({this.oid, String this.room_id});
  @override
  _InformationLiveState createState() => _InformationLiveState();
}

class _InformationLiveState extends State<InformationLive>
    with TickerProviderStateMixin {
  var historyContentList = [], jwt, listLength = 1;
  bool isLoading = false;
  Map auchor = {
    "headimgurl": "",
    "nickname": "",
    "store_img": "",
    "fans": "",
  };
  int fans = 0, is_open = 0;
  var list = [];
  String uid = "";

  @override
  void initState() {
    super.initState();
    getHistoryList();
    getInfo();
  }

  void getInfo() async {
    Map<String, dynamic> map = Map();
    UserServer().getMyApi(map, (success) async {
      setState(() {
        uid = success['user']['id'].toString();
        is_open = success['user']['is_open'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void getHistoryList() async { 
    Map<String, dynamic> map = Map();
    map.putIfAbsent("aid", () => widget.oid);
    map.putIfAbsent("room_id", () => widget.room_id);
    LiveServer().getHistory(map, (success) async {
      for (var item in success["list"]) {
        if (!item.containsKey('isplay')) {
          item['isplay'] = false;
        }
      }
      setState(() {
        auchor = success["anchor"];
        fans = success["anchor"]["fans"];
        list = success["list"];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void changePlay(item) {
    setState(() {
      for (var i in list) {
        if (i['id'] != item['id']) {
          i['isplay'] = false;
        }
      }
    });
  }

  Widget topPart (BuildContext context) {
    return Container(
      width: ScreenUtil.instance.setWidth(750.0),
      height: ScreenUtil.instance.setWidth(300.0),
      color:Colors.red,
      padding: EdgeInsets.only(top: ScreenUtil.instance.setWidth(40)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child:  IconButton(
              icon: Icon(Icons.navigate_before, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ),
          SizedBox(height: StyleUtil.width(30)),
          //下半图片部分
          Container(
            padding: EdgeInsets.only(
              bottom: ScreenUtil.instance.setWidth(30),
              right: ScreenUtil.instance.setWidth(290),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(65)),
                  child: ClipOval(
                    child: auchor["headimgurl"] != ""
                        ? Image.network(
                      auchor["headimgurl"],
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setWidth(100),
                      fit: BoxFit.cover,
                    )
                        : Container(),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(20),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${auchor["nickname"]}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30)),
                        ),
                      ),
                      Text(
                        '主播ID: ${auchor["id"]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      ),
                      Text(
                        '粉丝 ' +
                            (fans > 10000
                                ? ((fans ~/ 1000) / 10).toString() + 'w'
                                : fans.toString()),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(26),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget centerPart (BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: ScreenUtil.instance.setWidth(17),
        left: ScreenUtil.instance.setWidth(15),
        bottom: ScreenUtil.instance.setWidth(18),
      ),
      margin: EdgeInsets.only(
        left: ScreenUtil.instance.setWidth(26),
        right: ScreenUtil.instance.setWidth(27),
        top: ScreenUtil.instance.setWidth(20),
      ),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(10),
      //   border: Border.all(
      //     color: Color(0xffe9e9e9),
      //     width: 1,
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //   正在直播 ���看数量
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //正在直播
                InkWell(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil.instance.setWidth(24),
                      right: ScreenUtil.instance.setWidth(20),
                    ),
                    margin: EdgeInsets.only(
                      right: ScreenUtil.instance.setWidth(18),
                    ),
                    width: ScreenUtil.instance.setWidth(205),
                    height: ScreenUtil.instance.setWidth(54),
                    decoration: BoxDecoration(
                      color: PublicColor.themeColor,
                      // gradient: PublicColor.linear,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          'assets/zhibo/video.png',
                          width: ScreenUtil().setWidth(42),
                          height: ScreenUtil().setWidth(28),
                          fit: BoxFit.cover,
                        ),
                        Text(
                          is_open == 0 ? '未开播' : is_open == 1 ?  '正在直播' : '被禁播',
                          style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(24),
                            color: Color(0xffffffff),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Text(
                //   '观看人数10086',
                //   style: TextStyle(
                //     fontSize: ScreenUtil.instance.setWidth(26),
                //     color: Color(0xff969696),
                //   ),
                // )
              ],
            ),
          ),
          // Container(
          //   child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: <Widget>[
          //         Text(
          //           '新春衣服，等你来选!!!',
          //           style: TextStyle(
          //               fontSize: ScreenUtil.instance.setWidth(28),
          //               color: Color(0xff474747)),
          //         )
          //       ]),
          // ),
        ],
      ),
    );
  }

  Widget live() {
    List<Widget> arr = <Widget>[];
    Widget content;
    for (var item in list) {
      arr.add(LiveVideo(listItem: item, changePlay: changePlay));
    }
    content = new Column(
      mainAxisSize: MainAxisSize.max,
      children: arr,
    );
    return content;
  }
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: isLoading
            ? LoadingDialog()
            : new ListView(
          padding: EdgeInsets.all(0),
                children: <Widget>[
                  topPart(context),
                  centerPart(context),
                  Container(
                    margin: EdgeInsets.only(
                      left: ScreenUtil.instance.setWidth(26),
                      right: ScreenUtil.instance.setWidth(27),
                      top: ScreenUtil.instance.setWidth(20),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color(0xffe9e9e9),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            top: ScreenUtil().setWidth(30),
                            left: ScreenUtil().setWidth(20),
                            bottom: ScreenUtil().setWidth(30),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff474747),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          width: ScreenUtil().setWidth(156),
                          height: ScreenUtil().setWidth(55),
                          child: Text(
                            '历史回放',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(30),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        live(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
