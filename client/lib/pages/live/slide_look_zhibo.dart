import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:client/common/Utils.dart';
import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qntools/view/QNPlayerView.dart';
import 'package:qntools/controller/QNPlayerViewController.dart';
import 'package:qntools/enums/qiniucloud_player_listener_type_enum.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';

import 'TikTokFavoriteAnimationIcon.dart';
import 'live_gift.dart';
import 'live_goods.dart';
import 'live_report.dart';
import 'live_send_gift.dart';
import 'live_share.dart';

class SlideLookZhibo extends StatefulWidget {
  String room_id;

  SlideLookZhibo({Key key, String this.room_id}) : super(key: key);

  @override
  _SlideLookZhiboState createState() => _SlideLookZhiboState();
}

class _SlideLookZhiboState extends State<SlideLookZhibo> {
  Map room = {}, anchor = {}, userinfo = {},giftData = {};
  // liveArr直播列表  // listview历史聊天
  List liveArr = [],listview = [],timeList = [],sendList = [];
  List<Offset> icons = [];
  int swiper_index = 0; // 轮播索引
  int isFollow = 0,count = 0,like = 0;
  int is_admin, is_jinyan,timeOut = 0, timesOut = 0, timesCount = 0, timesNum = 0;
  String liveUrl = ''; // 视频流地址
  String jwt = '',joinroom = '',online = "0";
  // 控制动效出现
  bool isGift = false,attention = false,canAddFavorite = false,justAddFavorite = false;
  bool isAnimating = false, fullScreen = true;
  Timer timer;
  Timer giveLikeTime;
  GlobalKey _key = GlobalKey();
  QNPlayerViewController _QNPlayercontroller; // 播放控制器
  IOWebSocketChannel channel; // Socket对象
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  ScrollController _controller = ScrollController();
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;


  Offset _p(Offset p) {
    RenderBox getBox = _key.currentContext.findRenderObject();
    return getBox.globalToLocal(p);
  }

  // 监听器
  onListener(type, params) {
    // 错误
    if (type == QiniucloudPlayerListenerTypeEnum.Error) {
      ToastUtil.showToast('主播已关闭');
      print("主播已关闭--------------${getErrorText(params.toString())}");
    }
    // 状态改变
    if (type == QiniucloudPlayerListenerTypeEnum.Info) {
      Map<String, dynamic> paramsObj = jsonDecode(params);
      //this.setState(() => status = paramsObj["what"]);
      print("状态改变----------${getStatusText(paramsObj["what"])}");
    }
  }

  /// 获得状态文本
  getStatusText(status) {
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
  getErrorText(error) {
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

  // 获得推流地址_直播间信息,主播信息
  getliveurl(room_id) async {
    getLiveLog(room_id);
    LiveServer().inRoom({"room_id": room_id}, (success) async {
      setState(() {
        liveUrl = success['res']['rtmp_url']; // 视频流地址
        room = success['room']; // room直播间信息对象
        anchor = success['anchor']; // anchor主播信息对象
      });
      initwebsocket();
    }, (onFail) async {
      print('getliveurl----------${onFail}');
      if (onFail['errcode'].toString() == '10108') {
        Map obj = {
          'bgImg': onFail['room']['img'], //背景图
          'headimgurl': onFail['anchor']['headimgurl'], //头像
          'realName': onFail['anchor']['real_name'], //讲师名
          'name': onFail['room']['name'], //直播名称
          'price': onFail['room']['amount'], //直播价格
          'balance': onFail['user']['balance'], //余额
          'roomId': onFail['room']['id'],
        };
        ToastUtil.showToast(onFail['errmsg']);
        NavigatorUtils.goLivePay(context,obj, true);
      } else ToastUtil.showToast(onFail['errmsg']);
    });
  }

  // 获取直播列表
  getAllRoom(room_id) {
    LiveServer().getAllRoom({"room_id": room_id}, (onSuccess) {
      setState(() {
        liveArr.addAll(onSuccess['list']);
      });
    }, (onFail) {
      ToastUtil.showToast(onFail);
    });
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

  // 获取 jwt
  void getJwt() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => jwt = prefs.getString('jwt'));
  }

  // 初始化socket
  initwebsocket() async {
    UserServer().getPersonalData({}, (success) async {
      setState(() => userinfo = success['user']);
      channel = IOWebSocketChannel.connect(Utils.getsocket());
      channel.sink.add(jsonEncode({
        "type": 'login',
        "data": {
          "jwt": jwt,
          "uid": userinfo['id'],
          "nickname": userinfo['nickname'],
          "headimgurl": userinfo['headimgurl'],
          "room_id": liveArr[swiper_index]['id']
        }
      }));
      channel.stream.listen(onData, onError: onError, onDone: onDone);
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // socket 消息事件
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
          "room_id": liveArr[swiper_index]['id'],
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

  // socket 错误事件
  onError(err) {
    print('channel----err----==========================${err}');
  }

  onDone() {
    channel.stream.listen(this.onData, onError: onError, onDone: onDone);
  }

  // 礼物
  void showGift(userInfo, giftItem) {
    channel.sink.add(jsonEncode({
      "type": 'gift',
      "data": {
        "img": giftItem['img'],
        "num": 1,
        "nickname": userInfo['nickname'],
        "headimgurl": userInfo['headimgurl'],
        "gid": giftItem['id'],
        "uid": userInfo['id'],
        "roomId": liveArr[swiper_index]['id'],
        "name": giftItem['name']
      }
    }));
  }

  //礼物结束
  void giftEnd() {
    setState(() {
      isGift = false;
    });
  }

  // 查询管理员状态
  Future getCheckadmin() async {
    await LiveServer().getCheckadmin({"adid": userinfo['id'], "room_id": liveArr[swiper_index]['id']}, (onSuccess) {
      setState(() {
        is_admin = onSuccess['is_admin'];
        is_jinyan = onSuccess['is_jinyan'];
      });
    }, (onFail) {});
    return is_admin;
  }

  //直播间禁言
  estoppelApi(uid) {
    LiveServer().getJinyan({
      "jid": uid,
      "room_id": liveArr[swiper_index]['id'],
      "type": is_jinyan == 0 ? 1 : 0
    }, (success) => ToastUtil.showToast(is_jinyan == 0 ? '禁言成功' : '已解除禁言'), (onFail) => ToastUtil.showToast(onFail));
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

  //检查是否被禁言
  void checkisJy() {
    LiveServer().getCheckJy({"room_id": liveArr[swiper_index]['id']}, (success) async {
      if (_textEditingController.text != "") {
        channel.sink.add(jsonEncode({
          "type": 'msg',
          "data": {
            "jwt": jwt,
            "uid": userinfo['id'],
            "nickname": userinfo['nickname'],
            "headimgurl": userinfo['headimgurl'],
            "msg": _textEditingController.text,
            "room_id": liveArr[swiper_index]['id'],
            "level": userinfo['level'],
            "sex": userinfo['sex']
          }
        }));
        _textEditingController.text = "";
        _controller.animateTo(
          _controller.position.maxScrollExtent + 100,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      }
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  //拉黑
  void blockApi(uid) {
    LiveServer().getLahei({
      "hours": 5,
      "room_id": liveArr[swiper_index]['id'],
      "jid": uid
    }, (success) async {
      ToastUtil.showToast('拉黑成功');
      channel.sink.add(jsonEncode({
        "type": "black",
        "data": {"bid": uid, "room_id": liveArr[swiper_index]['id']}
      }));
    }, (onFail) => ToastUtil.showToast(onFail));
  }

// 销毁函数
  deactivateFun() {
    Wakelock.disable();
    if (channel != null) {
      channel.sink.close();
    }
    if (_QNPlayercontroller != null) {
      _QNPlayercontroller.stopPlayback();
      _QNPlayercontroller.removeListener(onListener);
    }
    timer?.cancel();
    giveLikeTime?.cancel();
    animatecontroller?.dispose();
  }

  // swiper 变化事件
  swiperChanged(index) {
    setState(() {
      swiper_index = index;
      liveUrl = '';
      deactivateFun();
      this.getliveurl(liveArr[index]['id']);
    });
  }

  @override
  void initState() {
    Wakelock.enable();
    getJwt();
    setState(() => liveArr = [
          {"id": widget.room_id}
        ]);
    this.getAllRoom(widget.room_id);
    this.getliveurl(widget.room_id);
    super.initState();
  }

  @override
  void deactivate() {
    deactivateFun();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Material(
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          print("itemBuilder----------$index");
          return Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: live_view(index),
          );
        },
        onIndexChanged: (valie) => swiperChanged(valie),
        loop: false,
        scrollDirection: Axis.vertical,
        itemCount: liveArr.length,
      ),
    );
  }

  Widget live_view(int idx) {
    return this.liveUrl != '' && idx == swiper_index
        ? Stack(children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: QNPlayerView(
                url: this.liveUrl,
                onViewCreated: (QNPlayerViewController controller) {
                  setState(() => this._QNPlayercontroller = controller);
                  controller.addListener(onListener);
                  _QNPlayercontroller.setVideoPath(url: this.liveUrl);
                  Future.delayed(
                      Duration(milliseconds: 2000), () => controller.start());
                },
              ),
            ),
      ...(fullScreen ? [topView(),bottomView()] : [fSbottom()])
          ])
        : backdrop();
  }

  // 顶部view (头像 主播名称,点赞关注数量, 关注按钮, 退出直播间)
  Widget topView() {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        padding: StyleUtil.paddingTow(left: 28, top: 56),
        width: StyleUtil.width(750),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: StyleUtil.width(85),
                          padding: StyleUtil.paddingTow(left: 20, top: 12),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                              borderRadius:
                                  BorderRadius.circular(StyleUtil.width(40))),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: StyleUtil.width(80)),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: StyleUtil.width(162),
                                      child: Text(anchor['nickname'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: StyleUtil.tontStyle(
                                              color: Colors.white,
                                              num: 24,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              '${count > 10000 ? ((count ~/ 1000) / 10).toString() + 'W' : count}人关注',
                                              style: StyleUtil.tontStyle(
                                                  color: PublicColor.whiteColor,
                                                  num: 18)),
                                          SizedBox(width: 5),
                                          Text(
                                              '${like > 10000 ? ((like ~/ 1000) / 10).toString() + 'w' : like}点赞',
                                              style: StyleUtil.tontStyle(
                                                  color: PublicColor.whiteColor,
                                                  num: 18))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: StyleUtil.width(29)),
                              Container(
                                width: StyleUtil.width(130),
                                child: RaisedButton(
                                  color: PublicColor.themeColor,
                                  padding: StyleUtil.paddingTow(left: 0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          StyleUtil.width(35))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ...(attention ? [
                                        Container(
                                          width: StyleUtil.width(25),
                                          height: StyleUtil.width(25),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            backgroundColor: Color(0x00000001),
                                            valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: StyleUtil.width(10)),
                                      ] : []),
                                      Text(isFollow == 1 ? '取关' : '关注',
                                          style: StyleUtil.tontStyle(
                                              color: Colors.white,
                                              num: 24,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  onPressed: () {
                                    print('关注事件');
                                    if (attention) return;
                                    setState(() => attention = true);
                                    channel.sink.add(jsonEncode({
                                      "type": 'follow',
                                      "data": {
                                        "jwt": jwt,
                                        "uid": userinfo['id'],
                                        "nickname":userinfo['nickname'],
                                        "headimgurl":userinfo['headimgurl'],
                                        "type":isFollow == 1 ? 2 : 1,
                                        "room_id": liveArr[swiper_index]['id'],
                                      }
                                    }));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavigatorUtils.goInformationLivePage(context, anchor['id']);
                          },
                          child: ClipOval(
                            child: new Image.network(anchor['headimgurl'],
                                fit: BoxFit.cover,
                                width: StyleUtil.width(80),
                                height: StyleUtil.width(80)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: StyleUtil.width(19)),
                  Container(
                    padding: StyleUtil.paddingTow(left: 15,top: 13),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        borderRadius:
                        BorderRadius.circular(StyleUtil.width(24))),
                    alignment: Alignment.center,
                    child: Text(
                      '跨融直播ID${liveArr[swiper_index]['id']}',
                      style: StyleUtil.tontStyle(color: Colors.white, num: 21),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: StyleUtil.padding(top: 15),
                padding: StyleUtil.paddingTow(left: 20, top: 12),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius:
                    BorderRadius.circular(StyleUtil.width(40))),
              child: Text(online,
              style: StyleUtil.tontStyle(color: PublicColor.whiteColor, num: 24)),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                print('退出直播间');
                channel.sink.add(jsonEncode({
                  "type": 'out',
                  "data": {
                    "jwt": jwt,
                    "uid": userinfo['id'],
                    "room_id": liveArr[swiper_index]["id"],
                  }
                }));
                deactivateFun();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget bottomView () {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: ScreenUtil.instance.setWidth(750.0),
        height: ScreenUtil.instance.setWidth(800.0),
        child: Stack(
          children: <Widget>[
            isGift? SendGift(giftData: giftData, giftEnd: giftEnd): SizedBox(),
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
                        InkWell(
                          onTap: (){
                            print('全屏事件');
                            setState(() => fullScreen = fullScreen ? false : true);
                          },
                          child: Image.asset('assets/live/quanping.png',
                              width: StyleUtil.width(80)),
                        ),
                        SizedBox(
                          height: StyleUtil.width(20),
                        ),
                        InkWell(
                          onTap: () {
                            print('礼物------------------${room}');
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return GiftsWidget(
                                    showGift: showGift,
                                    live_type: room["live_type"],
                                    roomId: liveArr[swiper_index]['id'].toString());
                              },
                            );
                          },
                          child: Image.asset(
                            'assets/zhibo/lwzx.png',
                            width: ScreenUtil.instance
                                .setWidth(80.0),
                          ),
                        ),
                        Expanded(
                          flex: 1,
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
                    ...(anchor['is_live'] == 1 ? []:
                    [InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return LiveGoods(
                              roomId: liveArr[swiper_index]['id'],
                              shipId: room['uid'],
                            );
                          },
                        );
                      },
                      child: Image.asset(
                        'assets/zhibo/gwd.png',
                        width:
                        ScreenUtil.instance.setWidth(80.0),
                      ),
                    ),SizedBox(
                        width:
                        ScreenUtil.instance.setWidth(20.0))]),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return ReportWidget(
                                  roomId: liveArr[swiper_index]['id']);
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
                        //print('onTapDown----$timesNum-------$timesOut');
                        if (timesNum == timesOut) return;
                        print('添加爱心，当前爱心数量:${icons.length}');
                        if (canAddFavorite) {
                          icons.add(_p(detail.globalPosition));
                          setState(() => justAddFavorite = true);
                        } else {
                          setState(() => justAddFavorite = false);
                          setState(() => timesNum += 1);
                          channel.sink.add(jsonEncode({
                            "type": 'like',
                            "data": {
                              "jwt": jwt,
                              "uid": userinfo['id'],
                              "nickname": userinfo['nickname'],
                              "headimgurl":
                              userinfo['headimgurl'],
                              "room_id": liveArr[swiper_index]['id']
                            }
                          }));
                        }
                      },
                      onTapUp: (detail) {
                        if (timesNum == timesOut) return;
                        print('onTapUp---------------------------');
                        timer?.cancel();
                        var delay = canAddFavorite ? 1200 : 600;
                        timer = Timer(
                            Duration(milliseconds: delay), () {
                          canAddFavorite = false;
                          timer = null;
                        });
                        canAddFavorite = true;
                      },
                      onTapCancel: () {
                        print('onTapCancel---------------------------');
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
    );
  }

  Widget fSbottom () {
    return Positioned(
      bottom: 10,
      right: 10,
      child: InkWell(
        onTap: (){
          print('全屏事件');
          setState(() => fullScreen = fullScreen ? false : true);
        },
        child: Image.asset('assets/live/quanping.png',
            width: StyleUtil.width(80)),
      ),
    );
  }

  // 聊天记录
  Widget liaotianitem(BuildContext context, item, index) {
    return Container(
      child: new InkWell(
        onTap: () {
          String uID = userinfo['id'].toString(),
              itID = item['uid'].toString(),
              liID = liveArr[swiper_index]['id'];
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

  Widget backdrop() {
    return Stack(
      children: <Widget>[
        Image.asset('assets/home/bj1.png',
            width: double.infinity, height: double.infinity, fit: BoxFit.cover),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: new Container(
            color: Colors.white.withOpacity(0.1),
            height: double.infinity,
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromRGBO(0, 0, 0, 0.7),
        ),
      ],
    );
  }
}
