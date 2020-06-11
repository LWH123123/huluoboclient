//import 'package:client/home/tijiaodingdan.dart';
import 'dart:async';
import 'package:client/pages/home/xiangqing.dart';

import '../../common/color.dart';
import '../../routers/Navigator_util.dart';
import '../../config/fluro_convert_util.dart';

// import 'package:client/home/xiangqing.dart';
// import 'package:client/zhibo/live_goods.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../../widgets/loading.dart';
import '../../widgets/cached_image.dart';

// import '../zhibo/zhiboshop.dart';
import '../../common/Utils.dart';
import '../../utils/toast_util.dart';

//直播结束页面
//import './liveover.dart';
import 'package:flutter/services.dart';
import 'package:qntools/view/QNPlayerView.dart';
import 'package:qntools/controller/QNPlayerViewController.dart';
import 'package:qntools/enums/qiniucloud_player_listener_type_enum.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './TikTokFavoriteAnimationIcon.dart';
import 'live_gift.dart';
import 'live_rank.dart';
import 'live_report.dart';
import 'live_send_gift.dart';
import 'live_share.dart';
import '../../service/live_service.dart';
import '../../service/user_service.dart';
import './live_goods.dart';

class ZhiboPage extends StatefulWidget {
  final String live;
  final String url;

  ZhiboPage({this.live, this.url});

  @override
  ZhiboPageState createState() => ZhiboPageState();
}

class ZhiboPageState extends State<ZhiboPage>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  ScrollController _controller = ScrollController();
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;
  bool isAnimating = false;
  bool isGift = false; // 控制动效出现
  Map giftData = {};
  String isGly = ''; //是否是管理员
  // socket
  IOWebSocketChannel channel;
  List listview = [];
  Map lives;
  String jwt = '';
  List sendList = [];
  Map room = {
    "id": 1,
    "is_close": 0,
    "live_stream": "muyuzb1585133648_409597",
    "live_type": 1,
    "uid": 409597,
    "sort": 0,
    "is_top": 0,
    "location": "",
    "goods_id": 5,
    "goods_list": "6",
    "img": "imgimgmig",
    "desc": "名称",
    "type": 1,
    "is_notice": 1,
    "def": 0,
    "is_open": 0,
    "is_try": 0,
    "online": 17,
    "max_online": 0,
    "like": 0,
    "order_num": 0,
    "c_order_num": 0,
    "c_total": 0,
    "total": 0,
    "share": 0,
    "click": 0,
    "interact": 0,
    "views": 0,
    "start_time": 1585122791,
    "end_time": 0,
    "create_at": 1585121561
  };
  Map anchor = {
    "id": 0,
    "shangji": 0,
    "phone": 0,
    "openid": "",
    "unionid": "",
    "accountstatus": 0,
    "nickname": "",
    "headimgurl": "",
    "sex": 0,
    "province": "",
    "city": "",
    "country": "",
    "wxqrcode": "",
    "coin": 0,
    "balance": "",
    "achievement": 0,
    "is_live": 0,
    "is_store": 0,
    "store_name": "",
    "store_desc": "",
    "store_headimg": "",
    "store_img": "",
    "is_open": 1,
    "fans": 0,
    "location": "",
    "createtime": 1585028164,
    "updatetime": 1585028164
  };

  ///***************** socket *******************/
  Map userinfo = {
    "id": 0,
    "nickname": "",
    "headimgurl": "",
  };
  bool isFirst = true;

  String joinroom = '';

  List<Offset> icons = [];
  GlobalKey _key = GlobalKey();

  Offset _p(Offset p) {
    RenderBox getBox = _key.currentContext.findRenderObject();
    return getBox.globalToLocal(p);
  }

  bool canAddFavorite = false;
  bool justAddFavorite = false;

  bool attention = false;

  Timer timer;

  ///***************** socket *******************/
  int isFollow = 0;
  int count = 0;
  int like = 0;
  String online = "0";
  List timeList = [];
  int is_admin, is_jinyan;

  /*  直播相关 */

  /// 播放控制器
  QNPlayerViewController controller;

  /// 描述信息
  String hint;

  /// 状态
  int status;

  /// 错误信息
  String error;

  /// 视频宽度
  int width = 0;

  /// 视频高度
  int height = 0;
  String url = '';
  int timeOut = 0, timesOut = 0, timesCount = 0, timesNum = 0;
  Timer giveLikeTime;

  /*  直播相关 */
  @override
  void initState() {
    super.initState();
    lives = FluroConvertUtils.string2map(widget.live);
    url = FluroConvertUtils.string2map(widget.url)['url'];
    getLiveLog(lives["id"]);
    print('url---->>>$url');
    animatecontroller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getLocal();
  }

  // 观看足迹
  getLiveLog(id) {
    LiveServer().getLiveLog({"room_id": id}, (onSuccess) {
      print('观看足迹--------------------${onSuccess}');
      setState(() {
        timeOut = onSuccess['like']['time'];
        timesOut = onSuccess['like']['times'];
      });
      giveLikeTime = new Timer.periodic(new Duration(seconds: 1), (timers) {
        setState(() => timesCount += 1);
        if (timesCount == timeOut) {
          setState(() {
            timesCount = 0;
            timesNum = 0;
          });
        }
      });
    }, (onFail) {});
  }

// 进入直播间动画
  void _gestureTap() {
    _statusListener = (AnimationStatus status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        isAnimating = false;
        animatecontroller.reset();
        animation.removeStatusListener(_statusListener);
      }
    };

    animation = Tween<double>(
      begin: -ScreenUtil.instance.setWidth(410),
      end: ScreenUtil.instance.setWidth(25),
    ).animate(
      CurvedAnimation(
        parent: animatecontroller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(_statusListener);
    animatecontroller.reset();
    animatecontroller.forward();
    isAnimating = true;
  }

  void getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      jwt = prefs.getString('jwt');
    });
    await initwebsocket();
    await getliveurl();
    // await getList();
  }

  void unFouce() {
    _commentFocus.unfocus(); // input失去焦点
  }

  initwebsocket() async {
    print('channel--------==========================1');
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      userinfo = success['user'];
      channel = IOWebSocketChannel.connect(Utils.getsocket());
      print('channel--------==========================2');
      var data = {
        "type": 'login',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "nickname": userinfo['nickname'],
          "headimgurl": userinfo['headimgurl'],
          "room_id": lives['id']
        }
      };
      print("channel-------data-==========================${data}");
      channel.sink.add(jsonEncode(data));
      channel.stream.listen(this.onData, onError: onError, onDone: onDone);
    }, (onFail) async {
      print('channel--------==========================3');
      ToastUtil.showToast(onFail);
    });
  }

// 送礼人列表
  getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().theList(map, (success) async {
      setState(() {
        sendList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  onData(response) async {
    var data = jsonDecode(response);
    print('datalook--->>>>$data');
    if (data['errcode'] != 0) {
      ToastUtil.showToast(data['errmsg']);
      return;
    }
    if (data['type'] == 'black' && userinfo['id'] == data['bid']) {
      print('直播间拉黑 ${userinfo['id']}---------${data['bid']}');
      channel.sink.add(jsonEncode({
        "type": 'out',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "room_id": lives['id'],
        }
      }));
      ToastUtil.showToast("您已被主播拉黑");
      await Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    } else if (data['type'] == 'out') {
      print('离开直播间');
      setState(() {
        joinroom = data['msg'];
        count = int.parse(data['follow'].toString());
        like = int.parse(data['like'].toString());
        online = data['people'].toString();
      });
    } else if (data['type'] == 'login') {
      if (mounted) {
        setState(() {
          joinroom = data['msg'];
          count = int.parse(data['follow'].toString());
          like = int.parse(data['like'].toString());
          online = data['people'].toString();
        });
      }
      _gestureTap();
      // 历史消息
      if (data['history'].length != 0) {
        setState(() {
          listview = data['history'];
          if (_controller.position.maxScrollExtent - _controller.offset < 100) {
            _controller.animateTo(_controller.position.maxScrollExtent + 100,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          }
        });
      }
    } else if (data['type'] == 'msg') {
      if (mounted) {
        var userID = userinfo['id'].toString();
        String sxID = data['sxuid'].toString();
        print("${sxID}--------------------------- ${userID}");
        setState(() {
          if (sxID == userID) {
            print("私信>>>>>>>>>>>>>>>>>>>>>>>>>>${data}");
            listview.insert(listview.length, data);
          } else if (sxID == 'null' || sxID == null || sxID == '') {
            print("信息>>>>>>>>>>>>>>>>>>>>>>>>>>${data}");
            listview.insert(listview.length, data);
          } else {
            print("else信息>>>>>>>>>>>>>>>>>>>>>>>>>>${data}");
          }
          if (_controller.position.maxScrollExtent - _controller.offset < 100) {
            _controller.animateTo(_controller.position.maxScrollExtent + 100,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          }
        });
      }
    } else if (data['type'] == 'follow') {
      setState(() {
        ToastUtil.showToast(data["msg"]);
        isFollow == 1 ? isFollow = 0 : isFollow = 1;
        Timer(Duration(seconds: 1), () => setState(() => attention = false));
//        if (data['follow'].toString() == "1") {
//
//
//        } else {
//          isFollow = 0;
//          ToastUtil.showToast('已取消成功');
//        }
        count = int.parse(data['follow'].toString());
      });
    } else if (data['type'] == 'like') {
      setState(() {
        like = int.parse(data['like'].toString());
      });
    } else if (data['type'] == 'gift') {
      setState(() {
        isGift = true;
        giftData = data;
      });
    }
  }

  onError(err) {
    print('channel----err----==========================');
    // debugPrint('this is error');
    // WebSocketChannelException ex = err;
    // debugPrint(ex.message);
  }

  onDone() {
    channel.stream.listen(this.onData, onError: onError, onDone: onDone);
  }

  getliveurl() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().inRoom(map, (success) async {
      print("inRoom---------------------${success}");
      setState(() {
        isloading = false;
        room = success['room'];
        anchor = success['anchor'];
        isFollow = success['is_follow'];
      });
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  //直播间禁言
  void estoppelApi(uid) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("jid", () => uid);
    map.putIfAbsent("room_id", () => lives['id']);
    map.putIfAbsent("type", () => is_jinyan == 0 ? 1 : 0);
    LiveServer().getJinyan(map, (success) {
      ToastUtil.showToast(is_jinyan == 0 ? '禁言成功' : '已解除禁言');
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // 获取拉黑时常
  getTimeAbout() {
    LiveServer().getTimeAbout({}, (onSuccess) {
      Map map = onSuccess['data']['lahei'];
      List arr = [];
      map.forEach((key, value) {
        arr.add({"time": value});
      });
      setState(() {
        timeList = arr;
      });
    }, (onFail) {});
  }

  // 查询管理员状态
  Future getCheckadmin() async {
    await LiveServer().getCheckadmin(
        {"adid": userinfo['id'], "room_id": lives['id']}, (onSuccess) {
      setState(() {
        is_admin = onSuccess['is_admin'];
        is_jinyan = onSuccess['is_jinyan'];
      });
    }, (onFail) {});
    return is_admin;
  }

  @override
  void dispose() {
    onStopPlayback();
    if (controller != null) {
      controller.removeListener(onListener);
    }
    if (channel != null) {
      channel.sink.close();
    }
    timer?.cancel();
    giveLikeTime?.cancel();
    animatecontroller?.dispose();
    print('页面已销毁!!!!!!!!!!!');
    super.dispose();
  }

  /// 控制器初始化
  onViewCreated(QNPlayerViewController controller) {
    Future.delayed(Duration(milliseconds: 2000), () {
      onStart();
    });
    this.controller = controller;
    controller.addListener(onListener);

    if (Platform.isAndroid) {
      // 设置视频路径
      controller.setVideoPath(url: this.url);
    }
  }

  /// 监听器
  onListener(type, params) {
    // 错误
    if (type == QiniucloudPlayerListenerTypeEnum.Error) {
      ToastUtil.showToast('主播已关闭');
      // Navigator.pop(context);
      this.setState(() => error = params.toString());
    }

    // 状态改变
    if (type == QiniucloudPlayerListenerTypeEnum.Info) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      this.setState(() => status = paramsObj["what"]);
    }

    // 大小改变
    if (type == QiniucloudPlayerListenerTypeEnum.VideoSizeChanged) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      this.setState(() {
        width = paramsObj["width"];
        height = paramsObj["height"];
      });
    }
  }

  /// 获得状态文本
  getStatusText() {
    if (status == null) {
      return "等待中";
    }

    switch (status) {
      case 1:
        return "未知消息";
      case 3:
        return "第一帧视频已成功渲染";
      case 200:
        return "连接成功";
      case 340:
        return "读取到 metadata 信息";
      case 701:
        return "开始缓冲";
      case 702:
        return "停止缓冲";
      case 802:
        return "硬解失败，自动切换软解";
      case 901:
        return "预加载完成";
      case 8088:
        return "loop 中的一次播放完成";
      case 10001:
        return "获取到视频的播放角度";
      case 10002:
        return "第一帧音频已成功播放";
      case 10003:
        return "获取视频的I帧间隔";
      case 20001:
        return "视频的码率统计结果";
      case 20002:
        return "视频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 20003:
        return "音频的帧率统计结果";
      case 10004:
        return "视频帧的时间戳";
      case 10005:
        return "音频帧的时间戳";
      case 1345:
        return "离线缓存的部分播放完成";
      case 565:
        return "上一次 seekTo 操作尚未完成";
      default:
        return "未知状态";
    }
  }

  /// 获得状态文本
  getErrorText() {
    switch (error) {
      case "-1":
        return "未知错误";
      case "-2":
        return "播放器打开失败";
      case "-3":
        return "网络异常";
      case "-4":
        return "拖动失败";
      case "-5":
        return "预加载失败";
      case "-2003":
        return "硬解失败";
      case "-2008":
        return "播放器已被销毁，需要再次 setVideoURL 或 prepareAsync";
      case "-9527":
        return "so 库版本不匹配，需要升级";
      case "-4410":
        return "AudioTrack 初始化失败，可能无法播放音频";
      default:
        return "未知错误";
    }
  }

  /// 开始播放
  onStart() async {
    print('开始直播');
    await controller.start();
  }

  /// 暂停播放
  onPause() async {
    await controller.pause();
  }

  /// 停止播放
  onStopPlayback() async {
    await controller.stopPlayback();
  }

  /// 获得视频时间戳
  onGetRtmpVideoTimestamp() async {
    int time = await controller.getRtmpVideoTimestamp();
    this.setState(() => hint = "视频时间戳为:$time");
  }

  /// 获得音频时间戳
  onGetRtmpAudioTimestamp() async {
    int time = await controller.getRtmpAudioTimestamp();
    this.setState(() => hint = "音频时间戳为:$time");
  }

  /// 获取已经缓冲的长度
  onGetHttpBufferSize() async {
    String size = await controller.getHttpBufferSize();
    this.setState(() => hint = "已经缓冲的长度:$size");
  }

  // 礼物
  void showGift(userInfo, giftItem) {
    var data = {
      "type": 'gift',
      "data": {
        "img": giftItem['img'],
        "num": 1,
        "nickname": userInfo['nickname'],
        "headimgurl": userInfo['headimgurl'],
        "gid": giftItem['id'],
        "uid": userInfo['id'],
        "roomId": lives['id'],
        "name": giftItem['name']
      }
    };
    print('data--->>>>${jsonEncode(data)}');
    channel.sink.add(jsonEncode(data));
  }

  //礼物结束
  void giftEnd() {
    setState(() {
      isGift = false;
    });
  }

  //检查是否被禁言
  void checkisJy() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);

    LiveServer().getCheckJy(map, (success) async {
      unFouce();
      if (_textEditingController.text != "") {
        var data = {
          "type": 'msg',
          "data": {
            "jwt": jwt,
            "uid": userinfo['id'],
            "nickname": userinfo['nickname'],
            "headimgurl": userinfo['headimgurl'],
            "msg": _textEditingController.text,
            "room_id": lives['id'],
            "level": userinfo['level'],
            "sex": userinfo['sex']
          }
        };
        print(data);
        print('????????????????????????');
        // print('-------------->' +
        //     jsonEncode(data));
        channel.sink.add(jsonEncode(data));
        _textEditingController.text = "";
        _controller.animateTo(
          _controller.position.maxScrollExtent + 100,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      }
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  //检查是否是管理员
  void checkIsGly() {
    Map<String, dynamic> map = Map();

    map.putIfAbsent("room_id", () => lives['id']);

    LiveServer().getCheckGly(map, (success) async {
      isGly = success['is_admin'].toString();
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  //拉黑
  void blockApi(uid) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("hours", () => 5);
    map.putIfAbsent("room_id", () => lives['id']);
    map.putIfAbsent("jid", () => uid);
    LiveServer().getLahei(map, (success) async {
      ToastUtil.showToast('拉黑成功');
      channel.sink.add(jsonEncode({
        "type": "black",
        "data": {"bid": uid, "room_id": lives['id']}
      }));
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  void closePopup() {
    Navigator.of(context).pop();
  }

  Widget liaotianitem(BuildContext context, item, index) {
    return Container(
      child: new InkWell(
        onTap: () {
          print('???----------${lives}');
          String uID = userinfo['id'].toString(),
              itID = item['uid'].toString(),
              liID = lives['uid'];
          getCheckadmin().then((onValue) {
            if (onValue == 1 && uID != itID && itID != liID) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        padding: EdgeInsets.only(top: 25, left: 30, right: 30),
                        height: ScreenUtil().setWidth(200),
                        child: new Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: new InkWell(
                                    onTap: () {
                                      print('禁言');
                                      print(item);
                                      estoppelApi(item['uid']);
                                      Navigator.of(context).pop();
                                    },
                                    child: new Column(children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Image.asset(
                                          "assets/live/icon_jinyan.png",
                                          width: ScreenUtil().setWidth(57),
                                          height: ScreenUtil().setSp(57),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                          child: Text(
                                              is_jinyan == 0 ? '禁言' : '解除禁言'))
                                    ])),
                              ),
                              Container(
                                child: new InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      print('拉黑');
                                      blockApi(item['uid']);
                                    },
                                    child: new Column(children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Image.asset(
                                          "assets/live/icon_lahei.png",
                                          width: ScreenUtil().setWidth(57),
                                          height: ScreenUtil().setSp(57),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(child: Text('拉黑'))
                                    ])),
                              )
                            ]),
                      ),
                    );
                  });
            }
          });
        },
        child: new Column(children: [
          new Row(
            children: <Widget>[
              CachedImageView(
                  ScreenUtil.instance.setWidth(55.0),
                  ScreenUtil.instance.setWidth(55.0),
                  item['headimgurl'],
                  null,
                  BorderRadius.all(Radius.circular(50))),
              new SizedBox(width: ScreenUtil.instance.setWidth(16.0)),
              Expanded(
                flex: 1,
                child: Text(
                  item['nickname'],
                  style: TextStyle(
                      color: Color(0xffff16c65),
                      fontSize: ScreenUtil.instance.setWidth(30.0)),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
          Container(
            width: ScreenUtil.instance.setWidth(580.0),
            child: Text(item['msg'],
                softWrap: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.instance.setWidth(30.0))),
          ),
          new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    var iconStack = Stack(
    children: icons
        .map<Widget>(
          (p) => TikTokFavoriteAnimationIcon(
        key: Key(p.toString()),
        position: p,
        onAnimationComplete: () {
          icons.remove(p);
        },
      ),
    ).toList(),
  );
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      body: Container(
              child: Swiper(
                loop: false,
                autoplay: false,
                onIndexChanged: (index) {
                  debugPrint("index:$index");
                },
                itemCount: 1,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {

                  return Stack(children: <Widget>[
                    Container(
                      height: ScreenUtil.instance.setHeight(1334.0),
                      width: ScreenUtil.instance.setWidth(750.0),
                      color: Colors.black,
                      child: this.url != ''
                          ? QNPlayerView(
                              url: this.url,
                              onViewCreated: onViewCreated,
                            )
                          : Text(''),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: ScreenUtil.instance.setWidth(750.0),
                        height: ScreenUtil.instance.setWidth(300.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              new SizedBox(
                                height: ScreenUtil.instance.setWidth(70.0),
                              ),
                              Container(
                                width: ScreenUtil.instance.setWidth(750.0),
                                height: ScreenUtil.instance.setWidth(120.0),
                                padding: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(15),
                                  left: ScreenUtil().setWidth(15),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                      child: Row(children: [
                                        Container(
                                          width: ScreenUtil.instance
                                              .setWidth(420.0),
                                          height: ScreenUtil.instance
                                              .setWidth(80.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.0),
                                            ),
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                          child: Row(children: [
                                            SizedBox(
                                              width: ScreenUtil.instance
                                                  .setWidth(90.0),
                                            ),
                                            Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(195.0),
                                              height: ScreenUtil.instance
                                                  .setWidth(80.0),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        anchor['nickname'], //昵称
                                                        softWrap: true,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: ScreenUtil
                                                                .instance
                                                                .setWidth(
                                                                    28.0))),
                                                    Text(
                                                      (count > 10000
                                                              ? ((count ~/
                                                                              1000) /
                                                                          10)
                                                                      .toString() +
                                                                  'w'
                                                              : count
                                                                  .toString()) +
                                                          '关注 ' +
                                                          (like > 10000
                                                              ? ((like ~/ 1000) /
                                                                          10)
                                                                      .toString() +
                                                                  'w'
                                                              : like
                                                                  .toString()) +
                                                          '点赞',
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil
                                                            .instance
                                                            .setWidth(22.0),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                            InkWell(
                                              child: Container(
                                                width: ScreenUtil().setWidth(
                                                    attention ? 130 : 80.0),
                                                height: ScreenUtil.instance
                                                    .setWidth(50.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  color: PublicColor.themeColor,
//                                                color: Colors.blue
                                                ),
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    attention
                                                        ? Container(
                                                            width: ScreenUtil
                                                                .instance
                                                                .setWidth(25),
                                                            height: ScreenUtil
                                                                .instance
                                                                .setWidth(25),
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              backgroundColor:
                                                                  Color(
                                                                      0x00000001),
                                                              valueColor:
                                                                  new AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                        width:
                                                            attention ? 5 : 0),
                                                    Text(
                                                        isFollow == 1
                                                            ? '取关'
                                                            : '关注',
                                                        style: TextStyle(
                                                            color: PublicColor
                                                                .btnColor,
                                                            fontSize: ScreenUtil
                                                                .instance
                                                                .setWidth(
                                                                    28.0)))
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                if (attention) return;
                                                setState(() {
                                                  attention = true;
                                                });
                                                print(
                                                    "user---------------------${userinfo}");
                                                unFouce();
                                                int type = 1;
                                                if (isFollow == 1) {
                                                  //取关
                                                  // follow(2);
                                                  type = 2;
                                                } else {
                                                  // 关注
                                                  // follow(1);
                                                  type = 1;
                                                }
                                                var data = {
                                                  "type": 'follow',
                                                  "data": {
                                                    "jwt": jwt,
                                                    "uid": userinfo['id'],
                                                    "nickname":
                                                        userinfo['nickname'],
                                                    "headimgurl":
                                                        userinfo['headimgurl'],
                                                    "type":
                                                        isFollow == 1 ? 2 : 1,
                                                    "room_id": lives['id'],
                                                  }
                                                };
                                                print('关注事件-------------->' +
                                                    jsonEncode(data));
                                                channel.sink
                                                    .add(jsonEncode(data));
                                              },
                                            )
                                          ]),
                                        ),
                                        new SizedBox(
                                            width: ScreenUtil.instance
                                                .setWidth(10.0)),
                                        listbuild(),
                                        InkWell(
                                          child: Container(
                                            width: ScreenUtil.instance
                                                .setWidth(58.0),
                                            height: ScreenUtil.instance
                                                .setWidth(58.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              online,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil.instance
                                                    .setWidth(24.0),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            // showModalBottomSheet(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return RankWidget(
                                            //         sendList: sendList);
                                            //   },
                                            // );
                                          },
                                        ),
                                      ]),
                                      left: ScreenUtil.instance.setWidth(10.0),
                                      top: ScreenUtil.instance.setWidth(5.0),
                                    ),
                                    Positioned(
                                      child: InkWell(
                                        onTap: () {
                                          NavigatorUtils.goInformationLivePage(
                                              context, anchor['id']);
                                        },
                                        child: anchor['headimgurl'] == ""
                                            ? Container()
                                            : CachedImageView(
                                                ScreenUtil.instance
                                                    .setWidth(90.0),
                                                ScreenUtil.instance
                                                    .setWidth(90.0),
                                                anchor['headimgurl'],
                                                null,
                                                BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                              ),
                                      ),
                                      left: 0,
                                      top: 0,
                                    ),
                                    Positioned(
                                      child: Image.asset(
                                        'assets/zhibo/sj.png',
                                        width:
                                            ScreenUtil.instance.setWidth(70.0),
                                      ),
                                      left: ScreenUtil.instance.setWidth(13.0),
                                      top: ScreenUtil.instance.setWidth(75.0),
                                    ),
                                    Positioned(
                                      right: ScreenUtil.instance.setWidth(13.0),
                                      top: ScreenUtil.instance.setWidth(20.0),
                                      child: InkWell(
                                        child: Container(
                                          width: ScreenUtil.instance
                                              .setWidth(58.0),
                                          height: ScreenUtil.instance
                                              .setWidth(58.0),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            "assets/zhibo/close.png",
                                            width: ScreenUtil().setWidth(42),
                                          ),
                                        ),
                                        onTap: () {
                                          var data = {
                                            "type": 'out',
                                            "data": {
                                              "jwt": jwt,
                                              "uid": userinfo['id'],
                                              "room_id": lives['id'],
                                            }
                                          };
                                          print('退出事件-------------->' +
                                              jsonEncode(data));
                                          channel.sink.add(jsonEncode(data));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              new SizedBox(
                                height: ScreenUtil.instance.setWidth(20.0),
                              ),
                              Container(
                                width: ScreenUtil.instance.setWidth(290.0),
                                height: ScreenUtil.instance.setWidth(50.0),
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(15),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '直播间ID:' + lives['id'].toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(28.0),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: ScreenUtil.instance.setWidth(750.0),
                        height: ScreenUtil.instance.setWidth(800.0),
                        child: Stack(
                          children: <Widget>[
                            isGift
                                ? SendGift(giftData: giftData, giftEnd: giftEnd)
                                : Container(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(30.0)),
                                // 进入直播间
                                Container(
                                  width: ScreenUtil.instance.setWidth(380.0),
                                  height: ScreenUtil.instance.setWidth(50.0),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        top: 0,
                                        left: animation != null
                                            ? animation.value
                                            : -ScreenUtil.instance
                                                .setWidth(400.0),
                                        child: Container(
                                          width: ScreenUtil.instance
                                              .setWidth(320.0),
                                          height: ScreenUtil.instance
                                              .setWidth(50.0),
                                          color: Colors.red.withOpacity(0.6),
                                          margin: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(25),
                                          ),
                                          child: Row(children: [
                                            new SizedBox(
                                                width: ScreenUtil.instance
                                                    .setWidth(10.0)),
                                            joinroom != ""
                                                ? Icon(
                                                    Icons.videocam,
                                                    size: ScreenUtil.instance
                                                        .setWidth(40.0),
                                                    color: Colors.white,
                                                  )
                                                : Text(''),
                                            new SizedBox(
                                              width: ScreenUtil.instance
                                                  .setWidth(10.0),
                                            ),
                                            Container(
                                              width: ScreenUtil.instance
                                                  .setWidth(240.0),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                joinroom,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil
                                                        .instance
                                                        .setWidth(26.0)),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(30.0)),
                                Row(children: [
                                  Container(
                                    width: ScreenUtil.instance.setWidth(632.0),
                                    height: ScreenUtil.instance.setWidth(400.0),
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(25),
                                      right: ScreenUtil().setWidth(25),
                                    ),
                                    child: ListView.builder(
                                      itemCount: listview.length,
                                      controller: _controller,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return liaotianitem(
                                            context, listview[index], index);
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil.instance.setWidth(80.0),
                                    height: ScreenUtil.instance.setWidth(400.0),
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: ScreenUtil.instance
                                              .setWidth(200.0),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            print(
                                                '礼物------------------${room}');
                                            unFouce();
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return GiftsWidget(
                                                    showGift: showGift,
                                                    live_type:
                                                        room["live_type"],
                                                    roomId:
                                                        lives['id'].toString());
                                              },
                                            );
                                          },
                                          child: Image.asset(
                                            'assets/zhibo/lwzx.png',
                                            width: ScreenUtil.instance
                                                .setWidth(80.0),
                                          ),
                                        ),
                                        Container(
                                          width: ScreenUtil.instance
                                              .setWidth(80.0),
                                          height: ScreenUtil.instance
                                              .setWidth(100.0),
                                          child: Stack(
                                            children: <Widget>[
                                              iconStack,
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                                new SizedBox(
                                    height: ScreenUtil.instance.setWidth(30.0)),
                                Row(
                                  children: <Widget>[
                                    new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(25.0)),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil.instance
                                              .setWidth(280.0),
                                          height: ScreenUtil.instance
                                              .setWidth(65.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            color:
                                                Colors.white.withOpacity(0.5),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(15),
                                              left: ScreenUtil().setWidth(15)),
                                          child: Container(
                                            width: ScreenUtil.instance
                                                .setWidth(240.0),
                                            child: TextField(
                                              controller:
                                                  _textEditingController,
                                              keyboardType: TextInputType.text,
                                              focusNode: _commentFocus,
                                              style: TextStyle(
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(28.0),
                                                  color: Colors.black),
                                              decoration: new InputDecoration(
                                                  hintText: '说点什么~~~',
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: ScreenUtil().setWidth(20),
                                          top: ScreenUtil().setWidth(10),
                                          child: InkWell(
                                            onTap: () {
                                              checkisJy();

                                              print('发送消息000->>' +
                                                  _textEditingController.text);
                                            },
                                            child: Text(
                                              '发送',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(28),
                                                  color:
                                                      PublicColor.whiteColor),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    new SizedBox(
                                      width: ScreenUtil.instance.setWidth(20.0),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        print('商品');
                                        print(lives);
                                        unFouce();
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return LiveGoods(
                                              roomId: lives['id'],
                                              shipId: lives['uid'],
                                              // userId: anchor['id']
                                            );
                                          },
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/gwd.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                    new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(20.0)),
                                    InkWell(
                                      onTap: () {
                                        print('其他');
                                        unFouce();
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ReportWidget(
                                                  roomId: lives['id']);
                                            });
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/qt.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                    new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(20.0)),
                                    InkWell(
                                      onTap: () {
                                        //ToastUtil.showToast('暂未开放');
                                        // unFouce();
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return LiveShare();
                                            });
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/fx.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                    new SizedBox(
                                      width: ScreenUtil.instance.setWidth(20.0),
                                    ),
                                    GestureDetector(
                                      key: _key,
                                      onTapDown: (detail) {
                                        if (timesNum == timesOut) return;
                                        print('onTapDown-----------');
                                        //'添加爱心，当前爱心数量:${icons.length}');
                                        if (canAddFavorite) {
                                          icons.add(_p(detail.globalPosition));
                                          setState(
                                              () => justAddFavorite = true);
                                        } else
                                          setState(
                                              () => justAddFavorite = false);
                                        setState(() => timesNum += 1);
                                        channel.sink.add(jsonEncode({
                                          "type": 'like',
                                          "data": {
                                            "jwt": jwt,
                                            "uid": userinfo['id'],
                                            "nickname": userinfo['nickname'],
                                            "headimgurl":
                                                userinfo['headimgurl'],
                                            "room_id": lives['id']
                                          }
                                        }));
                                      },
                                      onTapUp: (detail) {
                                        if (timesNum == timesOut) return;
                                        print(
                                            'onTapUp---------------------------');
                                        timer?.cancel();
                                        var delay = canAddFavorite ? 1200 : 600;
                                        timer = Timer(
                                            Duration(milliseconds: delay), () {
                                          canAddFavorite = false;
                                          timer = null;
                                          if (!justAddFavorite) {
                                            // widget.onSingleTap?.call();
                                          }
                                        });
                                        canAddFavorite = true;
                                      },
                                      onTapCancel: () {
                                        print(
                                            'onTapCancel---------------------------');
                                        print('onTapCancel');
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/dz.png',
                                        width:
                                            ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                  ],
                                ),
                                new SizedBox(
                                  height: ScreenUtil.instance.setWidth(50.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ]);
                },
              ),
            ),
    );
  }
  Widget listbuild() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (sendList.length > 0) {
      for (var i = 0; i < sendList.length; i++) {
        if (i < 3) {
          arr.add(
            InkWell(
              child: Container(
                width: ScreenUtil.instance.setWidth(58.0),
                height: ScreenUtil.instance.setWidth(58.0),
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: CachedImageView(
                    ScreenUtil.instance.setWidth(58.0),
                    ScreenUtil.instance.setWidth(58.0),
                    'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2837820063,351118816&fm=111&gp=0.jpg',
                    null,
                    BorderRadius.all(Radius.circular(50))),
              ),
            ),
          );
        }
      }
    } else {
      arr.add(Container());
    }

    content = Row(
      children: arr,
    );
    return content;
  }

  Widget live_view () {
    return Stack(children: <Widget>[
      Container(
        height: ScreenUtil.instance.setHeight(1334.0),
        width: ScreenUtil.instance.setWidth(750.0),
        color: Colors.black,
        child: this.url != ''
            ? QNPlayerView(
          url: this.url,
          onViewCreated: onViewCreated,
        )
            : Text(''),
      ),
      Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: ScreenUtil.instance.setWidth(750.0),
          height: ScreenUtil.instance.setWidth(300.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new SizedBox(
                  height: ScreenUtil.instance.setWidth(70.0),
                ),
                Container(
                  width: ScreenUtil.instance.setWidth(750.0),
                  height: ScreenUtil.instance.setWidth(120.0),
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(15),
                    left: ScreenUtil().setWidth(15),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        child: Row(children: [
                          Container(
                            width: ScreenUtil.instance
                                .setWidth(420.0),
                            height: ScreenUtil.instance
                                .setWidth(80.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                              color:
                              Colors.black.withOpacity(0.5),
                            ),
                            child: Row(children: [
                              SizedBox(
                                width: ScreenUtil.instance
                                    .setWidth(90.0),
                              ),
                              Container(
                                width: ScreenUtil.instance
                                    .setWidth(195.0),
                                height: ScreenUtil.instance
                                    .setWidth(80.0),
                                child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          anchor['nickname'], //昵称
                                          softWrap: true,
                                          overflow: TextOverflow
                                              .ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil
                                                  .instance
                                                  .setWidth(
                                                  28.0))),
                                      Text(
                                        (count > 10000
                                            ? ((count ~/
                                            1000) /
                                            10)
                                            .toString() +
                                            'w'
                                            : count
                                            .toString()) +
                                            '关注 ' +
                                            (like > 10000
                                                ? ((like ~/ 1000) /
                                                10)
                                                .toString() +
                                                'w'
                                                : like
                                                .toString()) +
                                            '点赞',
                                        softWrap: true,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil
                                              .instance
                                              .setWidth(22.0),
                                        ),
                                      ),
                                    ]),
                              ),
                              InkWell(
                                child: Container(
                                  width: ScreenUtil().setWidth(
                                      attention ? 130 : 80.0),
                                  height: ScreenUtil.instance
                                      .setWidth(50.0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            50.0)),
                                    color: PublicColor.themeColor,
//                                                color: Colors.blue
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      attention
                                          ? Container(
                                        width: ScreenUtil
                                            .instance
                                            .setWidth(25),
                                        height: ScreenUtil
                                            .instance
                                            .setWidth(25),
                                        child:
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                          backgroundColor:
                                          Color(
                                              0x00000001),
                                          valueColor:
                                          new AlwaysStoppedAnimation<
                                              Color>(
                                              Colors
                                                  .white),
                                        ),
                                      )
                                          : SizedBox(),
                                      SizedBox(
                                          width:
                                          attention ? 5 : 0),
                                      Text(
                                          isFollow == 1
                                              ? '取关'
                                              : '关注',
                                          style: TextStyle(
                                              color: PublicColor
                                                  .btnColor,
                                              fontSize: ScreenUtil
                                                  .instance
                                                  .setWidth(
                                                  28.0)))
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  if (attention) return;
                                  setState(() {
                                    attention = true;
                                  });
                                  print(
                                      "user---------------------${userinfo}");
                                  unFouce();
                                  int type = 1;
                                  if (isFollow == 1) {
                                    //取关
                                    // follow(2);
                                    type = 2;
                                  } else {
                                    // 关注
                                    // follow(1);
                                    type = 1;
                                  }
                                  var data = {
                                    "type": 'follow',
                                    "data": {
                                      "jwt": jwt,
                                      "uid": userinfo['id'],
                                      "nickname":
                                      userinfo['nickname'],
                                      "headimgurl":
                                      userinfo['headimgurl'],
                                      "type":
                                      isFollow == 1 ? 2 : 1,
                                      "room_id": lives['id'],
                                    }
                                  };
                                  print('关注事件-------------->' +
                                      jsonEncode(data));
                                  channel.sink
                                      .add(jsonEncode(data));
                                },
                              )
                            ]),
                          ),
                          new SizedBox(
                              width: ScreenUtil.instance
                                  .setWidth(10.0)),
                          listbuild(),
                          InkWell(
                            child: Container(
                              width: ScreenUtil.instance
                                  .setWidth(58.0),
                              height: ScreenUtil.instance
                                  .setWidth(58.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(50.0)),
                                color:
                                Colors.black.withOpacity(0.5),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                online,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil.instance
                                      .setWidth(24.0),
                                ),
                              ),
                            ),
                            onTap: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return RankWidget(
                              //         sendList: sendList);
                              //   },
                              // );
                            },
                          ),
                        ]),
                        left: ScreenUtil.instance.setWidth(10.0),
                        top: ScreenUtil.instance.setWidth(5.0),
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () {
                            NavigatorUtils.goInformationLivePage(
                                context, anchor['id']);
                          },
                          child: anchor['headimgurl'] == ""
                              ? Container()
                              : CachedImageView(
                            ScreenUtil.instance
                                .setWidth(90.0),
                            ScreenUtil.instance
                                .setWidth(90.0),
                            anchor['headimgurl'],
                            null,
                            BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                        left: 0,
                        top: 0,
                      ),
                      Positioned(
                        child: Image.asset(
                          'assets/zhibo/sj.png',
                          width:
                          ScreenUtil.instance.setWidth(70.0),
                        ),
                        left: ScreenUtil.instance.setWidth(13.0),
                        top: ScreenUtil.instance.setWidth(75.0),
                      ),
                      Positioned(
                        right: ScreenUtil.instance.setWidth(13.0),
                        top: ScreenUtil.instance.setWidth(20.0),
                        child: InkWell(
                          child: Container(
                            width: ScreenUtil.instance
                                .setWidth(58.0),
                            height: ScreenUtil.instance
                                .setWidth(58.0),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/zhibo/close.png",
                              width: ScreenUtil().setWidth(42),
                            ),
                          ),
                          onTap: () {
                            var data = {
                              "type": 'out',
                              "data": {
                                "jwt": jwt,
                                "uid": userinfo['id'],
                                "room_id": lives['id'],
                              }
                            };
                            print('退出事件-------------->' +
                                jsonEncode(data));
                            channel.sink.add(jsonEncode(data));
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                new SizedBox(
                  height: ScreenUtil.instance.setWidth(20.0),
                ),
                Container(
                  width: ScreenUtil.instance.setWidth(290.0),
                  height: ScreenUtil.instance.setWidth(50.0),
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(50.0)),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '直播间ID:' + lives['id'].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                      ScreenUtil.instance.setWidth(28.0),
                    ),
                  ),
                ),
              ]),
        ),
      ),
      Positioned(
        left: 0,
        bottom: 0,
        child: Container(
          width: ScreenUtil.instance.setWidth(750.0),
          height: ScreenUtil.instance.setWidth(800.0),
          child: Stack(
            children: <Widget>[
              isGift
                  ? SendGift(giftData: giftData, giftEnd: giftEnd)
                  : Container(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new SizedBox(
                      height: ScreenUtil.instance.setWidth(30.0)),
                  // 进入直播间
                  Container(
                    width: ScreenUtil.instance.setWidth(380.0),
                    height: ScreenUtil.instance.setWidth(50.0),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: animation != null
                              ? animation.value
                              : -ScreenUtil.instance
                              .setWidth(400.0),
                          child: Container(
                            width: ScreenUtil.instance
                                .setWidth(320.0),
                            height: ScreenUtil.instance
                                .setWidth(50.0),
                            color: Colors.red.withOpacity(0.6),
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(25),
                            ),
                            child: Row(children: [
                              new SizedBox(
                                  width: ScreenUtil.instance
                                      .setWidth(10.0)),
                              joinroom != ""
                                  ? Icon(
                                Icons.videocam,
                                size: ScreenUtil.instance
                                    .setWidth(40.0),
                                color: Colors.white,
                              )
                                  : Text(''),
                              new SizedBox(
                                width: ScreenUtil.instance
                                    .setWidth(10.0),
                              ),
                              Container(
                                width: ScreenUtil.instance
                                    .setWidth(240.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  joinroom,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil
                                          .instance
                                          .setWidth(26.0)),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new SizedBox(
                      height: ScreenUtil.instance.setWidth(30.0)),
                  Row(children: [
                    Container(
                      width: ScreenUtil.instance.setWidth(632.0),
                      height: ScreenUtil.instance.setWidth(400.0),
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(25),
                        right: ScreenUtil().setWidth(25),
                      ),
                      child: ListView.builder(
                        itemCount: listview.length,
                        controller: _controller,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return liaotianitem(
                              context, listview[index], index);
                        },
                      ),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(80.0),
                      height: ScreenUtil.instance.setWidth(400.0),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: ScreenUtil.instance
                                .setWidth(200.0),
                          ),
                          InkWell(
                            onTap: () {
                              print(
                                  '礼物------------------${room}');
                              unFouce();
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return GiftsWidget(
                                      showGift: showGift,
                                      live_type:
                                      room["live_type"],
                                      roomId:
                                      lives['id'].toString());
                                },
                              );
                            },
                            child: Image.asset(
                              'assets/zhibo/lwzx.png',
                              width: ScreenUtil.instance
                                  .setWidth(80.0),
                            ),
                          ),
                          Container(
                            width: ScreenUtil.instance
                                .setWidth(80.0),
                            height: ScreenUtil.instance
                                .setWidth(100.0),
                            child: Stack(
                              children: icons
                                  .map<Widget>(
                                    (p) => TikTokFavoriteAnimationIcon(
                                  key: Key(p.toString()),
                                  position: p,
                                  onAnimationComplete: () {
                                    icons.remove(p);
                                  },
                                ),
                              ).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                  new SizedBox(
                      height: ScreenUtil.instance.setWidth(30.0)),
                  Row(
                    children: <Widget>[
                      new SizedBox(
                          width:
                          ScreenUtil.instance.setWidth(25.0)),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.instance
                                .setWidth(280.0),
                            height: ScreenUtil.instance
                                .setWidth(65.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50.0)),
                              color:
                              Colors.white.withOpacity(0.5),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(
                                right: ScreenUtil().setWidth(15),
                                left: ScreenUtil().setWidth(15)),
                            child: Container(
                              width: ScreenUtil.instance
                                  .setWidth(240.0),
                              child: TextField(
                                controller:
                                _textEditingController,
                                keyboardType: TextInputType.text,
                                focusNode: _commentFocus,
                                style: TextStyle(
                                    fontSize: ScreenUtil.instance
                                        .setWidth(28.0),
                                    color: Colors.black),
                                decoration: new InputDecoration(
                                    hintText: '说点什么~~~',
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          Positioned(
                            right: ScreenUtil().setWidth(20),
                            top: ScreenUtil().setWidth(10),
                            child: InkWell(
                              onTap: () {
                                checkisJy();

                                print('发送消息000->>' +
                                    _textEditingController.text);
                              },
                              child: Text(
                                '发送',
                                style: TextStyle(
                                    fontSize:
                                    ScreenUtil().setSp(28),
                                    color:
                                    PublicColor.whiteColor),
                              ),
                            ),
                          )
                        ],
                      ),
                      new SizedBox(
                        width: ScreenUtil.instance.setWidth(20.0),
                      ),
                      InkWell(
                        onTap: () {
                          print('商品');
                          print(lives);
                          unFouce();
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return LiveGoods(
                                roomId: lives['id'],
                                shipId: lives['uid'],
                                // userId: anchor['id']
                              );
                            },
                          );
                        },
                        child: Image.asset(
                          'assets/zhibo/gwd.png',
                          width:
                          ScreenUtil.instance.setWidth(80.0),
                        ),
                      ),
                      new SizedBox(
                          width:
                          ScreenUtil.instance.setWidth(20.0)),
                      InkWell(
                        onTap: () {
                          print('其他');
                          unFouce();
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ReportWidget(
                                    roomId: lives['id']);
                              });
                        },
                        child: Image.asset(
                          'assets/zhibo/qt.png',
                          width:
                          ScreenUtil.instance.setWidth(80.0),
                        ),
                      ),
                      new SizedBox(
                          width:
                          ScreenUtil.instance.setWidth(20.0)),
                      InkWell(
                        onTap: () {
                          //ToastUtil.showToast('暂未开放');
                          // unFouce();
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return LiveShare();
                              });
                        },
                        child: Image.asset(
                          'assets/zhibo/fx.png',
                          width:
                          ScreenUtil.instance.setWidth(80.0),
                        ),
                      ),
                      new SizedBox(
                        width: ScreenUtil.instance.setWidth(20.0),
                      ),
                      GestureDetector(
                        key: _key,
                        onTapDown: (detail) {
                          if (timesNum == timesOut) return;
                          print('onTapDown-----------');
                          //'添加爱心，当前爱心数量:${icons.length}');
                          if (canAddFavorite) {
                            icons.add(_p(detail.globalPosition));
                            setState(
                                    () => justAddFavorite = true);
                          } else
                            setState(
                                    () => justAddFavorite = false);
                          setState(() => timesNum += 1);
                          channel.sink.add(jsonEncode({
                            "type": 'like',
                            "data": {
                              "jwt": jwt,
                              "uid": userinfo['id'],
                              "nickname": userinfo['nickname'],
                              "headimgurl":
                              userinfo['headimgurl'],
                              "room_id": lives['id']
                            }
                          }));
                        },
                        onTapUp: (detail) {
                          if (timesNum == timesOut) return;
                          print(
                              'onTapUp---------------------------');
                          timer?.cancel();
                          var delay = canAddFavorite ? 1200 : 600;
                          timer = Timer(
                              Duration(milliseconds: delay), () {
                            canAddFavorite = false;
                            timer = null;
                            if (!justAddFavorite) {
                              // widget.onSingleTap?.call();
                            }
                          });
                          canAddFavorite = true;
                        },
                        onTapCancel: () {
                          print(
                              'onTapCancel---------------------------');
                          print('onTapCancel');
                        },
                        child: Image.asset(
                          'assets/zhibo/dz.png',
                          width:
                          ScreenUtil.instance.setWidth(80.0),
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: ScreenUtil.instance.setWidth(50.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
