import 'dart:async';
import 'dart:convert';
import 'package:client/common/Utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:wakelock/wakelock.dart';
// import 'package:client/home/xiangqing.dart';
import '../../common/color.dart';
import 'package:client/config/fluro_convert_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/user_service.dart';
import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../widgets/loading.dart';
import 'package:qntools/view/QNStreamView.dart';
import 'package:qntools/controller/QNStreamViewController.dart';
import 'package:qntools/entity/camera_streaming_setting_entity.dart';
import 'package:qntools/entity/streaming_profile_entity.dart';
import 'package:qntools/entity/face_beauty_setting_entity.dart';
import 'package:qntools/entity/video_capture_configration.dart';
import 'package:qntools/enums/qiniucloud_encoding_size_level_enum.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../utils/toast_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/svgasample.dart';
// import 'live_rank.dart';
import 'live_goods.dart';
import 'live_send_gift.dart';
// import './live_share.dart';
// import './zb_goods.dart';
import './feature.dart';
import '../../routers/Navigator_util.dart';
import 'live_share.dart';

class OpenZhibo extends StatefulWidget {
  final String live;
  OpenZhibo({this.live});
  @override
  ZhiboPageState createState() => ZhiboPageState();
}

class ZhiboPageState extends State<OpenZhibo>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;
  bool isAnimating = false;

  bool isloading = false;
  ScrollController _controller = ScrollController();
  ScrollController scrollController = ScrollController();
  TextEditingController _textEditingController = new TextEditingController();
  FocusNode _commentFocus = FocusNode();
  String jwt = '';
  bool iskaiqi = false;
  Map lives = {};
  int count = 0;
  int like = 0;
  String online = "0";
  int isFollow = 0;
  String joinroom = '';
  //socket
  IOWebSocketChannel channel;
  List listview = [];
  List sendList = [];
  String url = '';
  Map userinfo = {
    "id": 0,
    "nickname": "",
    "headimgurl": "",
  };
  bool isGift = false; // 控制动效出现
  Map giftData = {};
  Timer timer,periodic;
  int time = 0,groupGrade=0,sxuid,is_admin,is_jinyan;
  String videoOften = '';
  List timeList = [];
  QNStreamViewController controller;

  // 美颜对象
  FaceBeautySettingEntity faceBeautySettingEntity =
      FaceBeautySettingEntity(beautyLevel: 0, redden: 0, whiten: 0);

  /// 控制器初始化
  onViewCreated(QNStreamViewController controller) async {
    this.controller = controller;
    this.controller.addListener(onListener);
    bool result = await controller.resume();
    debugPrint("result-----=" + result.toString());
    // this.setState(() => info = "预览执行结果: $result");
    await Future.delayed(Duration(seconds: 2), () {
      startLive();
    });
  }

  /// 监听器
  onListener(type, params) {
    // debugPrint("----------------------->" +
    //     "type=" +
    //     type.toString() +
    //     ",params=" +
    //     params.toString());
  }

  onTimer() {
    setState(() {
      timer = new Timer.periodic(new Duration(seconds: 1), (timers) {
        setState(() => time +=1);
        var h = (this.time / 3600).toInt(),m = ((this.time - h * 3600) / 60).toInt(),s = this.time - h * 3600 - m * 60;
        String hh = h < 10 ? '0$h' : h.toString(),mm = m < 10 ? '0$m' : m.toString(),ss = s < 10 ? '0$s' : s.toString();
        setState(() => videoOften = '${hh}:${mm}:${ss}');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    onTimer();
    lives = FluroConvertUtils.string2map(widget.live);
    animatecontroller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    getLocal();
    // 获取拉黑时常
    getTimeAbout();
    getuserType();
  }

  getuserType () {
    periodic = new Timer.periodic(new Duration(seconds: 5), (timers) {
      LiveServer().getRedisUser({}, (onSuccess) async {
        print('直播轮询---------${onSuccess["user"]["is_open"]}----------------${onSuccess}');
        String is_open = onSuccess["user"]["is_open"].toString();
        List arr = ['您已被关播', '', '您已被禁播'];
        if (is_open == '0' || is_open == '2') {
          periodic.cancel();
          ToastUtil.showToast(arr[int.parse(is_open)]);
          await Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
        }
      }, (onFail) {});
    });
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
    jwt = prefs.getString('jwt');
    if (jwt == '') {
      ToastUtil.showToast('请先登录');
      // 跳转登录页
      return;
    }
    await initwebsocket();
    await getList();
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

  //礼物结束
  void giftEnd() {
    setState(() {
      isGift = false;
    });
  }

  //---------------webscoket----------------
  initwebsocket() async {
    Map<String, dynamic> map = Map();
    UserServer().getPersonalData(map, (success) async {
      print('????????');
      print(success['user']);
      print('????????');
      userinfo = success['user'];
      channel = IOWebSocketChannel.connect(Utils.getsocket());
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
      // print('-------------->' + jsonEncode(data));
      channel.sink.add(jsonEncode(data));
      channel.stream.listen(this.onData, onError: onError, onDone: onDone);
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  onData(response) {
    var data = jsonDecode(response);
    print('dataopen--->>>>$data');
    if (data['errcode'] != 0) {
      ToastUtil.showToast(data['errmsg']);
      return;
    }
    if (data['type'] == 'black') {
      print('直播间拉黑 ${userinfo['id']}---------${data['bid']}');
    }else if (data['type'] == 'out') {
      print('离开直播间');
      setState(() {
        joinroom = data['msg'];
        count = int.parse(data['follow'].toString());
        like = int.parse(data['like'].toString());
        online = data['people'].toString();
      });
    } else if (data['type'] == 'login') {
      print('有人进入直播间');
      setState(() {
        joinroom = data['msg'];
        count = int.parse(data['follow'].toString());
        like = int.parse(data['like'].toString());
        online = data['people'].toString();
      });
      _gestureTap();
      // 历史消息
      if (data['history'].length != 0) {
        setState(() {
          listview = data['history'];
          if (scrollController.position.maxScrollExtent -
                  scrollController.offset <
              100) {
            scrollController.animateTo(
                scrollController.position.maxScrollExtent + 100,
                curve: Curves.ease,
                duration: Duration(milliseconds: 500));
          }
        });
      }
    } else if (data['type'] == 'msg') {
      setState(() {
        listview.insert(listview.length, data);
        if (scrollController.position.maxScrollExtent -
                scrollController.offset <
            100) {
          scrollController.animateTo(
              scrollController.position.maxScrollExtent + 100,
              curve: Curves.ease,
              duration: Duration(milliseconds: 500));
        }
      });
    } else if (data['type'] == 'follow') {
      setState(() {
        if (data['msg'] != "取关了") {
          joinroom = data['msg'];
          _gestureTap();
        }
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
    ToastUtil.showToast('网络问题');
    // debugPrint('this is error');
    // WebSocketChannelException ex = err;
    // debugPrint(ex.message);
  }

  onDone() {
    // debugPrint('this is close');
    channel = IOWebSocketChannel.connect(Utils.getsocket());
    var data = {
      "type": "login",
      "data": {
        "jwt": jwt,
        "uid": userinfo['id'],
        "nickname": userinfo['nickname'],
        "headimgurl": userinfo['headimgurl'],
        "room_id": lives['id']
      }
    };
    // print('-------------->' + jsonEncode(data));
    channel.sink.add(jsonEncode(data));
    channel.stream.listen(this.onData, onError: onError, onDone: onDone);
  }
  //----------------scoket------------------

  // 开始直播
  void startLive() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("live_stream", () => lives['live_stream']);
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().startLive(map, (success) async {
      print('推流url======${success['url']}');
      controller.startStreaming(publishUrl: success['url']);
      ToastUtil.showToast('直播开始');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  // 关闭直播
  void closeLive() {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().closeLive(map, (success) async {
      ToastUtil.showToast('关闭成功');
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  void startmeiyan() async {
    print('开启美颜');
    if (iskaiqi) {
      setState(() {
        iskaiqi = false;
      });
      controller.updateFaceBeautySetting(
          FaceBeautySettingEntity(beautyLevel: 0, redden: 0, whiten: 0));
    } else {
      setState(() {
        iskaiqi = true;
      });
      controller.updateFaceBeautySetting(
          FaceBeautySettingEntity(beautyLevel: 1, redden: 1, whiten: 1));
    }
  }

  void setfenbianlv(int index) async {
    print('设置分辨率');
  }

  void switchCamera() async {
    controller.switchCamera(target: null);
  }

  void unFouce() {
    _commentFocus.unfocus(); // input失去焦点
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
  getTimeAbout () {
    LiveServer().getTimeAbout({}, (onSuccess){
      Map map = onSuccess['data']['lahei'];
      List arr = [];
      map.forEach((key,value){
        arr.add({
          "time": value
        });
      });
      setState(() {
        timeList = arr;
      });
    }, (onFail){});
  }
  // 查询管理员状态
  Future getCheckadmin(id)  async {
    await LiveServer().getCheckadmin({
      "adid": id,
      "room_id": lives['id']
    }, (onSuccess) {
      setState(() {
        is_admin = onSuccess['is_admin'];
        is_jinyan = onSuccess['is_jinyan'];
      });
    }, (onFail) {});
    return is_admin;
  }
  //拉黑
  void blockApi(user) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("hours", () => groupGrade);
    map.putIfAbsent("room_id", () => lives['id']);
    map.putIfAbsent("jid", () => user['uid']);
    LiveServer().getLahei(map, (success) async {
      ToastUtil.showToast('拉黑成功');
      channel.sink.add(jsonEncode({
        "type": "black",
        "data": {
          "bid": user['uid'],
          "room_id": lives['id']
        }
      }));
      // Navigator.of(context).pop();
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  //设置管理员
  void getSetApi(uid) {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("fid", () => uid);
    map.putIfAbsent("room_id", () => lives['id']);
    LiveServer().getSetPerson(map, (success) async {
      ToastUtil.showToast('设置成功');
      // Navigator.pop(context, true);
    }, (onFail) => ToastUtil.showToast(onFail));
  }
  // 解除管理员
  getDeladmin (uid) {
    LiveServer().getDeladmin({
      "fid": uid,
      "room_id": lives['id']
    }, (onSuccess){
      ToastUtil.showToast('解除成功');
    }, (onFail) {});
  }
  @override
  void dispose() {
    Wakelock.disable();
    controller?.pause();
    controller?.destroy();
    controller?.stopStreaming();
    timer?.cancel();
    animatecontroller?.dispose();
    if (channel != null) {
      channel.sink.close();
    }
    closeLive();
    periodic?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
      body: contentWidget(),
    );
  }

  Widget buildStreamView() {
    if (Platform.isAndroid) {
      return QNStreamView(
        cameraStreamingSetting:
            CameraStreamingSettingEntity(faceBeauty: faceBeautySettingEntity),
        streamingProfile: StreamingProfileEntity(),
        onViewCreated: onViewCreated,
      );
    } else if (Platform.isIOS) {
      return QNStreamView(
          videoCaptureConfiguration: VideoCaptureConfiguration(
            videoFrameRate: 20,
          ),
          onViewCreated: onViewCreated,
          streamingProfile: StreamingProfileEntity(
              encodingSizeLevel:
                  QiniucloudEncodingSizeLevelEnum.VIDEO_ENCODING_HEIGHT_1088));
    } else {
      return Text("不支持的平台");
    }
  }

  // 聊天
  Widget liaotianitem(BuildContext context, item, index) {
    return Container(
      child: InkWell(
        onTap: () {
          print('????????${item}');
          getCheckadmin(item['uid']).then((onValue) => UserDialog(context, item));
        },
        child: new Column(children: [
          new Row(
            children: <Widget>[
              CachedImageView(
                ScreenUtil.instance.setWidth(55.0),
                ScreenUtil.instance.setWidth(55.0),
                item['headimgurl'] == '' ? '' : item['headimgurl'],
                null,
                BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              new SizedBox(
                width: ScreenUtil.instance.setWidth(16.0),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  item['nickname'],
                  style: TextStyle(
                    color: Color(0xffff16c65),
                    fontSize: ScreenUtil.instance.setWidth(30.0),
                  ),
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

  UserDialog (BuildContext context, item) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              // padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                height: ScreenUtil().setWidth(650),
                child: new Column(children: <Widget>[
                  Container(
                    child: new Column(children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0xffdddddd))),
                        ),
                        child: new Row(children: <Widget>[
                          Container(
                            child: CachedImageView(
                                ScreenUtil().setWidth(118.0),
                                ScreenUtil().setWidth(118.0),
                                item['headimgurl'],
                                null,
                                BorderRadius.all(Radius.circular(50.0))),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  item['nickname'],
                                  style: StyleUtil.tontStyle(color: PublicColor.textColor,num: 30,fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Text(
                                    '性别: ${item['sex'].toString() == '0'
                                        ? '未设置'
                                        : item['sex'].toString() ==
                                        '1'
                                        ? '男'
                                        : item['sex']
                                        .toString() ==
                                        '2'
                                        ? '女'
                                        : ''}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:
                                      ScreenUtil().setSp(28),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Image.asset(
                                item['level'].toString() == '1'
                                    ? 'assets/mine/icon_baiyin.png'
                                    : item['level'].toString() ==
                                    '2'
                                    ? 'assets/mine/icon_bojin.png'
                                    : item['level']
                                    .toString() ==
                                    '3'
                                    ? 'assets/mine/icon_zuanshi.png'
                                    : '',
                                width: StyleUtil.width(100),
                                height: StyleUtil.width(48),
                              ),
                            ),
                          ),
                        ]),
                      )
                    ]),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(350),
                    padding: EdgeInsets.only(top: 30),
                    child: new Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: new InkWell(
                                onTap: () {
                                  print('禁言');
                                  print(item);
                                  Navigator.pop(context);
                                  estoppelApi(item['uid']);
                                },
                                child: new Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Image.asset(
                                      "assets/live/icon_jinyan2.png",
                                      width: ScreenUtil().setWidth(57),
                                      height: ScreenUtil().setSp(57),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(child: Text(is_jinyan == 0 ? '禁言' : '解除禁言'))
                                ])),
                          ),
                          Container(
                            child: new InkWell(
                                onTap: () {
                                  print('拉黑');
                                  Navigator.pop(context);
                                  //blockApi(item['uid']);
                                  showBottom(context, item);
                                },
                                child: new Column(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Image.asset(
                                      "assets/live/icon_lahei2.png",
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
                  InkWell(
                      onTap: () {
                        print('私信${item}');
                        setState(() {
                          sxuid = item['uid'];
                          _textEditingController.text = '@${item['nickname']}  ';
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        width: ScreenUtil.instance.setWidth(518.0),
                        height: ScreenUtil.instance.setWidth(92.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                          color: PublicColor.yellowColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '私信',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      )),
                  SizedBox(height: 10,),
                  InkWell(
                      onTap: () {
                        print('设为管理员');
                        Navigator.of(context).pop();
                        is_admin == 1 ? getDeladmin(item['uid']) : getSetApi(item['uid']);
                      },
                      child: Container(
                        width: ScreenUtil.instance.setWidth(518.0),
                        height: ScreenUtil.instance.setWidth(92.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                          color: PublicColor.themeColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          is_admin == 1 ? '取消管理员' : '设为管理员',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ))
                ])
            ),
          );
        });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Container(
                child: new Wrap(
              children: <Widget>[
                new Container(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(300),
                  child: new Center(
                      child: SVGASampleScreen(
                    image: "assets/zhubozhenmei.svga",
                  )),
                ),
                new Container(
                  width: ScreenUtil().setWidth(400),
                  height: ScreenUtil().setHeight(70),
                  margin:
                      EdgeInsets.fromLTRB(ScreenUtil().setWidth(70), 0, 0, 0),
                  child: InkWell(
                    child: new Container(
                      width: ScreenUtil().setWidth(400),
                      height: ScreenUtil().setHeight(70),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child: Text('确定',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(50.0)),
                  ),
                ),
              ],
            )),
            title: Center(
                child: Text(
              '这是一个弹窗',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
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

  // 列表部分
  Widget contentWidget() {
    return isloading
        ? LoadingDialog()
        : Container(
            height: ScreenUtil.instance.setHeight(1334.0),
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
                    child: buildStreamView(),
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
                                        width:
                                            ScreenUtil.instance.setWidth(380.0),
                                        height:
                                            ScreenUtil.instance.setWidth(80.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                          color: Colors.black.withOpacity(0.5),
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
                                                      userinfo['nickname'], //昵称
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil
                                                              .instance
                                                              .setWidth(28.0))),
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
                                                            : like.toString()) +
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
                                        ]),
                                      ),
                                      new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(10.0),
                                      ),
                                      listbuild(),
                                      InkWell(
                                        child: Container(
                                          width: ScreenUtil.instance
                                              .setWidth(58.0),
                                          height: ScreenUtil.instance
                                              .setWidth(58.0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(50.0),
                                            ),
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
                                          print('123');
                                          onTimer();
                                          // print('榜单');
                                          // showModalBottomSheet(
                                          //   context: context,
                                          //   builder: (BuildContext context) {
                                          //     return RankWidget();
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
                                        print('123');
                                        NavigatorUtils.goInformationLivePage(
                                            context, userinfo['id']);
                                      },
                                      child: userinfo['headimgurl'] == ""
                                          ? Container()
                                          : CachedImageView(
                                              ScreenUtil.instance
                                                  .setWidth(90.0),
                                              ScreenUtil.instance
                                                  .setWidth(90.0),
                                              userinfo['headimgurl'],
                                              null,
                                              BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                            ),
                                    ),
                                    left: 0,
                                    top: 0,
                                  ),
                                  /*Positioned(
                                    child: Image.asset(
                                      'assets/zhibo/sj.png',
                                      width: ScreenUtil.instance.setWidth(70.0),
                                    ),
                                    left: ScreenUtil.instance.setWidth(13.0),
                                    top: ScreenUtil.instance.setWidth(75.0),
                                  ),*/
                                  Positioned(
                                    top: StyleUtil.width(10),
                                    right: ScreenUtil.instance.setWidth(13.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: StyleUtil.width(10),
                                          height: StyleUtil.width(10),
                                          margin: StyleUtil.padding(right: 10),
                                          decoration: BoxDecoration(
                                            color: PublicColor.themeColor,
                                            borderRadius: BorderRadius.circular(StyleUtil.width(5))
                                          ),
                                        ),
                                        Text(videoOften,style: StyleUtil.tontStyle(color: PublicColor.whiteColor),)
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: ScreenUtil.instance.setWidth(13.0),
                                    top: ScreenUtil().setWidth(40),
                                    child: InkWell(
                                      child: Container(
                                        width:
                                            ScreenUtil.instance.setWidth(58.0),
                                        height:
                                            ScreenUtil.instance.setWidth(58.0),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/zhibo/close.png",
                                          width: ScreenUtil().setWidth(42),
                                        ),
                                      ),
                                      onTap: () {
                                        NavigatorUtils.goPastLive(context,true);
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
                              child: Row(
                                children: <Widget>[
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
                                        fontSize: ScreenUtil.instance.setWidth(28.0),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: ScreenUtil.instance.setWidth(230.0),
                                    height: ScreenUtil.instance.setWidth(50.0),
                                    margin: StyleUtil.padding(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.rss_feed,
                                        size: StyleUtil.fontSize(30),
                                        color: PublicColor.whiteColor,),
                                        Text('良好',
                                            style: StyleUtil.tontStyle(color: PublicColor.whiteColor)),
                                        Container(
                                          width: StyleUtil.width(10),
                                          height: StyleUtil.width(10),
                                          decoration: BoxDecoration(
                                            color: PublicColor.whiteColor,
                                            borderRadius: BorderRadius.circular(StyleUtil.width(5))
                                          ),
                                        ),
                                        Text('135kbps',
                                        style: StyleUtil.tontStyle(color: PublicColor.whiteColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
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
                                        width:
                                            ScreenUtil.instance.setWidth(320.0),
                                        height:
                                            ScreenUtil.instance.setWidth(50.0),
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
                                                  fontSize: ScreenUtil.instance
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
                                    controller: scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return liaotianitem(
                                          context, listview[index], index);
                                    },
                                  ),
                                ),
                              ]),
                              new SizedBox(
                                  height: ScreenUtil.instance.setWidth(30.0)),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    new SizedBox(
                                        width:
                                            ScreenUtil.instance.setWidth(25.0)),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          width: ScreenUtil.instance
                                              .setWidth(300.0),
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
                                                .setWidth(300.0),
                                            child: TextField(
                                              controller:
                                                  _textEditingController,
                                              focusNode: _commentFocus,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  fontSize: ScreenUtil.instance
                                                      .setWidth(28.0),
                                                  color: Colors.white),
                                              decoration: new InputDecoration(
                                                  hintText: '请填写内容',
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: ScreenUtil().setWidth(20),
                                          top: ScreenUtil().setWidth(10),
                                          child: InkWell(
                                            onTap: () {
                                              print('发送消息000->>' +
                                                  _textEditingController.text);
                                              if (_textEditingController.text != "") {
                                                Map<String, dynamic> map = Map();
                                                map.putIfAbsent('jwt', () => jwt);
                                                map.putIfAbsent('uid', () => userinfo['id']);
                                                map.putIfAbsent('nickname', () => userinfo['nickname']);
                                                map.putIfAbsent('headimgurl', () => userinfo['headimgurl']);
                                                map.putIfAbsent('msg', () => _textEditingController
                                                    .text);
                                                map.putIfAbsent('room_id', () => lives['id']);
                                                if(sxuid != null && _textEditingController.text.indexOf('@') != -1){
                                                  map.putIfAbsent('sxuid', () => sxuid);
                                                }
                                                var data = {
                                                  "type": 'msg',
                                                  "data": map
                                                };
                                                // print('-------------->' +
                                                //     jsonEncode(data));
                                                channel.sink
                                                    .add(jsonEncode(data));
                                                setState(() {
                                                  sxuid = null;
                                                  _textEditingController.text =
                                                  "";
                                                });
                                                _controller.animateTo(
                                                  _controller.position
                                                          .maxScrollExtent +
                                                      100,
                                                  curve: Curves.ease,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                );
                                                unFouce();
                                              }
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
                                    SizedBox(width:StyleUtil.width(20)),
                                    Container(
                                       width:ScreenUtil().setWidth(80.0),
                                       height:ScreenUtil().setWidth(80.0),
                                       decoration: BoxDecoration(
                                         color: Color.fromRGBO(0,0,0,0.3),
                                         borderRadius: BorderRadius.circular(ScreenUtil().setWidth(40))
                                       ),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.center,
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: <Widget>[
                                           Text(lives['def']== 0 ? '标准' : lives['def']== 1 ? '高清' : '超清',
                                             style: StyleUtil.tontStyle(color: PublicColor.whiteColor)),
                                           Text('清晰度',style: StyleUtil.tontStyle(color: PublicColor.whiteColor,num: 18),),
                                         ],
                                       ),
                                     ),
                                    SizedBox(width:StyleUtil.width(20)),
                                    InkWell(
                                      onTap: () {
                                        print('其他');
                                        unFouce();
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return FeatureWidget(
                                                switchCamera: switchCamera,
                                                startmeiyan: startmeiyan,
                                                controller: controller,
                                              );
                                            });
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/qt.png',
                                        width:
                                        ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                    SizedBox(width:StyleUtil.width(20)),
                                    InkWell(
                                      onTap: () {
                                        print('分享');
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return LiveShare();
                                            });
                                        unFouce();
                                      },
                                      child: Image.asset(
                                        'assets/zhibo/fx.png',
                                        width:
                                        ScreenUtil.instance.setWidth(80.0),
                                      ),
                                    ),
                                    ...(userinfo['is_live'] == 1 ?[] :
                                    [SizedBox(width:StyleUtil.width(20)),
                                      InkWell(
                                        onTap: () {
                                          print('商品---------${lives}');
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
                                          unFouce();
                                        },
                                        child: Image.asset(
                                          'assets/zhibo/gwd.png',
                                          width:
                                          ScreenUtil.instance.setWidth(80.0),
                                        ),
                                      ),])
                                  ],
                                ),
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
          );
  }



  showBottom (BuildContext context, item) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder (
              builder: (context, setDialogState) {
                return Container(
            height: StyleUtil.width(1200),
            child: Column(
              children: <Widget>[
                Container(
                  padding: StyleUtil.paddingTow(left: 20,top: 20),
                  decoration: BoxDecoration(
                    border: Border(bottom: StyleUtil.borderBottom())
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('禁言时间选择',
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                      IconButton(
                        icon: Icon(Icons.cancel,color: Colors.black12),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: timeList.map((item) => RadioListTile<int>(
                        value: item['time'],
                        groupValue: groupGrade,
                        onChanged: (int value) {
                          setDialogState(() {
                            groupGrade = value;
                          });
                          //Navigator.of(context).pop();
                        },
                        title: Text(item['time'].toString() + 'h',
                            style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                        dense: false,
                        activeColor: PublicColor.themeColor,
                        isThreeLine: false,
                        selected: true,
                        controlAffinity: ListTileControlAffinity.trailing)).toList()
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: StyleUtil.width(100),
                  padding: StyleUtil.paddingTow(left: 100),
                  margin: StyleUtil.paddingTow(top: 20),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(46)),
                    color: PublicColor.themeColor,
                    child: Text('确定',style: StyleUtil.tontStyle(color: PublicColor.whiteColor),),
                    onPressed: () {
                      print('OK');
                      blockApi(item);
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          );
              }
          );
        }
    );
  }
}
