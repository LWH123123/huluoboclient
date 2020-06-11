import 'dart:async';
import 'dart:convert';

import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/service/live_service.dart';
import 'package:client/service/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/loading.dart';
import '../../service/home_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../../widgets/cached_image.dart';

class curriculumDetail extends StatefulWidget {
  final String id;

  curriculumDetail({this.id});

  @override
  _curriculumDetailState createState() => _curriculumDetailState();
}

class _curriculumDetailState extends State<curriculumDetail>
    with SingleTickerProviderStateMixin {
  VideoPlayerController _controller;
  IjkMediaController controller = IjkMediaController();
  bool isPlaying = false;
  bool isLoading = false;
  bool _flag = false;
  int tabIndex = 0;
  String detailImg = '', title = '', level = '', description = '';
  String nickname = '', desc = '', headimgurl = '', isOpen = '';
  Map<String, dynamic> course = new Map();
  List child = [], course_eval = [];
  String videoImg = '';
  Timer _timer;
  String orderId = '', _videoUrl = '';

  void updateGroupValue(v) {
    setState(() {
      _flag = v;
    });
  }

  TabController tabController;

  void initState() {
    super.initState();
    // 添加监听器
    tabController = TabController(vsync: this, length: 3);
    tabController.addListener(() => indexset());
    getDetailApi();
    fluwx.responseFromPayment.listen((res) {
      print("pay============== :${res.toString()}");
      if (res.errCode == 0) {
        startTimer(orderId);
        print('errCode----${res.errCode}');
      } else {
        ToastUtil.showToast('支付失败,请重试');
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  indexset() {
    setState(() => {
      tabIndex = tabController.index
    });
    if (tabController.index == 2) getDetailApiTow();
  }
  //课程详情
  void getDetailApi() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("course_id", () => widget.id);
    HomeServer().getCourseDetailApi(map, (success) async {
      setState(() {
        isLoading = false;
        CourseService().getCourseLog({
          "course_id": success['course']['id']
        }, (onSuccess) {}, (onFail) {});
        course = success['course'];
        child = success['course']['child'];
        course_eval = success['course']['course_eval'];
        detailImg = success['course']['img'];
        title = success['course']['title'];
        level = success['course']['level'];
        nickname = success['course']['user']['real_name'];
        desc = success['course']['user']['desc'];
        description = success['course']['description'];
        headimgurl = success['course']['user']['headimgurl'];
        isOpen = success['course']['user']['is_open'].toString();
        videoImg = success['course']['img'];
        success['course']['collect_status'] == 0 ? _flag = false : _flag = true;
        print(success['course']['collect_status']);
        print('??????收藏${_flag}');
      });
    }, (onFail) async {});
  }
  void getDetailApiTow() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("course_id", () => widget.id);
    HomeServer().getCourseDetailApi(map, (success) async {
      setState(() {
        course = success['course'];
      });
    }, (onFail) async {});
  }

  //课程收藏
  void getCollectionApi() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("course_id", () => widget.id);
    HomeServer().getCourseCollectionApi(map, (success) async {
      success['status'] == 0
          ? ToastUtil.showToast('取消收藏')
          : ToastUtil.showToast('收藏成功');
      getDetailApi();
    }, (onFail) async {});
  }

  void videoPlay(url) async {
    setState(() {
      _videoUrl = url;
    });
    // _controller = VideoPlayerController.network(url)
    //   ..initialize().then((_) {
    //     print('加载完毕');
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //     _controller.play();
    //   });
    // await _controller.setLooping(true); // 换换播放
  }

  subscriptPlayFinish() {
    // subscription = controller.playFinishStream.listen((data) {
    //   print('视频播放完毕!!!!!!!!');
    //   controller.play(); //监听视频播放完毕,重新播放
    // });
    controller.ijkStatusStream.listen((data) {
      print('data---->>>>$data');
      if (mounted) {
        setState(() {
          if (data == IjkStatus.prepared ||
              data == IjkStatus.error ||
              data == IjkStatus.preparing) {
            // isPlaying = false;
          } else {
            // isPlaying = true;
          }
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
    StoreServer().pay_type({"order_id": orderId, "type": 3}, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      await Future.delayed(Duration(seconds: 2), () {
        getDetailApi();
      });
    }, (onFail) async {
      print('支付回调接口--------------------${onFail.toString()}');
//      ToastUtil.showToast(onFail);
//      setState(() {
//        isLoading = false;
//      });
    });
  }
  getCourseLook () {
    LiveServer().getCourseLook({
      "course_id": course["id"]
    }, (onSuccess) {}, (onFail)=>ToastUtil.showToast(onFail));
  }

  //购买课程
  payMoney() {
    if (course['id'] == null || course['id'] == '')
      return ToastUtil.showToast('请选择课程');
    CourseService().getBuyCourse({"course_id": course['id']}, (success) {
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
    }, (onFail) {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    cancelTimer();
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget videoModule(String s) {
      return Container(
        width: ScreenUtil().setWidth(750),
        child: Container(
            child: Column(
          children: tabIndex == 1
              ? [
                  Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(367),
                    child: isPlaying
                        ? IjkPlayer(
                            mediaController: controller,
                            controllerWidgetBuilder: (mediaController) {
                              return DefaultIJKControllerWidget(
                                controller: controller,
                                doubleTapPlay: true,
                                verticalGesture: false,
                                horizontalGesture: false,
                                showFullScreenButton: false,
                              ); // 自定义
                            },
                          )
                        : Container(
                            width: ScreenUtil().setWidth(750),
                            height: ScreenUtil().setWidth(367),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 0,
                                  child: CachedImageView(
                                      ScreenUtil.instance.setWidth(750.0),
                                      ScreenUtil.instance.setWidth(367.0),
                                      videoImg,
                                      null,
                                      BorderRadius.all(Radius.circular(0))),
                                ),
                                Positioned(
                                  top: 50,
                                  left: 150,
                                  child: InkWell(
                                      onTap: () {
                                        print('播放---------$_videoUrl');
                                        if (_videoUrl == '') return ToastUtil.showToast('请选择视频');
                                        controller.setNetworkDataSource(
                                          _videoUrl,
                                          autoPlay: true,
                                        );
                                        setState(() {
                                          isPlaying = true;
                                        });
                                        getCourseLook();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: _videoUrl != ''?Image.asset(
                                          'assets/zhibo/bofang.png',
                                          width: ScreenUtil().setWidth(115),
                                          height: ScreenUtil().setWidth(115),
                                        ): SizedBox(),
                                      )),
                                )
                              ],
                            ),
                          ),
                  )
                ]
              : [
                  Container(
                    child: CachedImageView(
                        ScreenUtil.instance.setWidth(750.0),
                        ScreenUtil.instance.setWidth(367.0),
                        detailImg,
                        null,
                        BorderRadius.all(Radius.circular(0))),
                  )
                ],
        )),
      );
    }

    Widget tabbarModule(String s) {
      return new Expanded(
          flex: 1,
          child: new DefaultTabController(
            length: 3,
            child: new Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ScreenUtil().setHeight(100)),
                child: new AppBar(
                  elevation: 0,
                  // leading: Text(''),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  title: new TabBar(
                    controller: tabController,
                    labelColor: Colors.red,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Colors.red,
                    tabs: [
                      new Tab(
                        child: Text('详情',
                            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                      ),
                      new Tab(
                        child: Text('目录',
                            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                      ),
                      new Tab(
                        child: Text(
                            '评价' +
                                (course['course_eval_count'] != 0
                                    ? '(' +
                                        course['course_eval_count'].toString() +
                                        ')'
                                    : ''),
                            style: TextStyle(fontSize: ScreenUtil().setSp(28))),
                      ),
                    ],
                  ),
                ),
              ),
              body: new TabBarView(
                controller: tabController,
                children: [
                  new Container(
                    width: ScreenUtil().setWidth(750),
                    child: new ListView(children: <Widget>[
                      //显示头像及部分
                      InkWell(
                        onTap: () {
                          print(course["user"]['id']);
                          NavigatorUtils.goLecturer(context, id: course["user"]['id'].toString());
                        },
                        child: Container(
                            width: ScreenUtil().setWidth(750),
                            height: ScreenUtil().setHeight(150),
                            margin: StyleUtil.padding(top: 20),
                            color: Colors.white,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //头像
                                Align(
                                  child: Container(
                                      width: ScreenUtil().setWidth(120),
                                      height: ScreenUtil().setHeight(120),
                                      child: new Stack(
                                        children: <Widget>[
                                          headimgurl == ''
                                              ? ClipOval(
                                            child: Image.network(
                                              "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=468727759,3818736238&fm=26&gp=0.jpg",
                                              fit: BoxFit.fill,
                                              width: ScreenUtil()
                                                  .setWidth(130),
                                              height: ScreenUtil()
                                                  .setWidth(130),
                                            ),
                                          )
                                              : ClipOval(
                                            child: Image.network(
                                              headimgurl,
                                              fit: BoxFit.fill,
                                              width: ScreenUtil()
                                                  .setWidth(130),
                                              height: ScreenUtil()
                                                  .setWidth(130),
                                            ),
                                          ),
                                          //头像上直播中图片 应该是单独组件 做判断
                                          new Positioned(
                                            bottom: 5,
                                            left: ScreenUtil().setWidth(10),
                                            child: Image.asset(
                                              isOpen == '0'
                                                  ? 'assets/home/wzb.png'
                                                  : isOpen == '1'
                                                  ? 'assets/home/zhibozhong.png'
                                                  : isOpen == '2'
                                                  ? 'assets/home/jb.png'
                                                  : '',
                                              fit: BoxFit.fill,
                                            ),
                                            width: ScreenUtil().setWidth(100),
                                            height: ScreenUtil().setHeight(30),
                                          )
                                        ],
                                      )),
                                ),
                                new Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  width: ScreenUtil().setWidth(540),
                                  child: new Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Container(
                                          child: new Text(nickname,
                                              style: TextStyle(
                                                  color: Color(0xff454545),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize:
                                                  ScreenUtil().setSp(30))),
                                          margin: StyleUtil.padding(bottom: 12),
                                        ),
                                        new Container(
                                            alignment: Alignment.bottomLeft,
//                                            height: ScreenUtil().setHeight(60),
                                            child: new Text(desc,
                                                style: TextStyle(
                                                    color: Color(0xff787878),
                                                    fontSize:
                                                    ScreenUtil().setSp(30))))
                                      ]),
                                )
                              ],
                            )),
                      ),
                      new Container(
                          margin: StyleUtil.padding(top: 20),
                          color: Colors.white,
                          padding: StyleUtil.paddingTow(left: 25,top: 15),
                          alignment: Alignment.topLeft,
                          width: ScreenUtil().setWidth(750),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text( title,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.w600),
                              ),
                              new Text('课程难度: ${course['nandu'].toString() == '1' ?
                              '简单' : course['nandu'] == '2' ? '一般' : '困难'}',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color.fromRGBO(69, 69, 69, 0.73)),
                              )
                            ],
                          )),
                      new Container(
                          alignment: Alignment.topLeft,
                          margin: StyleUtil.padding(top: 20),
                          color: Colors.white,
                          padding: StyleUtil.paddingTow(left: 25,top: 15),
                          width: ScreenUtil().setWidth(750),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  '课程介绍',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(30),
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Container(
                                child: Text(description),
                              )
                            ],
                          )),
                    ]),
                  ),
                  //目录
                  new Container(
                      width: ScreenUtil().setWidth(750),
                      child: new ListView(children: <Widget>[
                        new Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 10.0),
                          width: ScreenUtil().setWidth(750),
                          height: ScreenUtil().setHeight(70),
                          child: new Row(children: <Widget>[
                            new Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Image.asset(
                                'assets/home/icon_liebiao.png',
                                width: ScreenUtil().setWidth(30),
                                height: ScreenUtil().setHeight(28),
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: new Text(
                                '如何把握职场新机会【共${course['child_num']}节】',
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                            )
                          ]),
                        ),
                        ...child
                            .map((item) => Container(
                                  width: ScreenUtil().setWidth(750),
                                  //循环此层 只写了一个
                                  child: InkWell(
                                    onTap: () {
                                      print(
                                          "${item['is_try']}----------${course["is_see"]}");
                                      setState(() {
                                        isPlaying = false;
                                      });
//                                      controller.dispose();
                                      item['is_try'] == '1'
                                          ? videoPlay(item['url'])
                                          : course["is_see"] == 0
                                              ? showDialog_pay(context)
                                              : videoPlay(item['url']);
                                    },
                                    child: new Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Color(0XFFf3f3f3)),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(top: 10.0),
                                      width: ScreenUtil().setWidth(750),
                                      height: ScreenUtil().setHeight(70),
                                      child: new Row(children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          child: Image.asset(
                                            item['is_try'] == '1'
                                                ? 'assets/home/icon_bofang.png'
                                                : 'assets/home/icon_bofang2@2x.png',
                                            width: ScreenUtil().setWidth(36),
                                            height: ScreenUtil().setHeight(36),
                                          ),
                                        ),
                                        //试看图标显示 此处显示
                                        item['is_try'] == '1'
                                            ? new Container(
                                                margin:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Image.asset(
                                                  'assets/home/icon_shikan.png',
                                                  width:
                                                      ScreenUtil().setWidth(46),
                                                  height: ScreenUtil()
                                                      .setHeight(28),
                                                ),
                                              )
                                            : SizedBox(),
                                        new Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          width: ScreenUtil().setWidth(500),
                                          child: new Text(
                                            item['course_child_name'],
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            //文字颜色红色或黑色 此处红色
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                                color: item['is_try'] == '1'
                                                    ? PublicColor.themeColor
                                                    : PublicColor.textColor),
                                          ),
                                        ),
                                        new Container(
                                          margin: EdgeInsets.only(left: 10.0),
                                          child: new Text(
                                            item['time'] == null
                                                ? ''
                                                : item['time'],
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(28),
                                                color: Color.fromRGBO(
                                                    69, 69, 69, 0.8)),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ])),
                  //下面是评价
                  new Container(
                      width: ScreenUtil().setWidth(750),
                      child: new ListView(children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('点击去评价');
                            course['look_log'] == 0
                                ? ToastUtil.showToast('请观看视频后进行去评价!')
                                : NavigatorUtils.goAppraise(context,
                                        id: course['id'].toString())
                                    .then((res) => {getDetailApi()});
                          },
                          child: new Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 10.0),
                              width: ScreenUtil().setWidth(750),
                              height: ScreenUtil().setHeight(100),
                              child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '有什么想要说的赶紧',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          color: Color(0xff454545)),
                                    ),
                                    Text(
                                      '\t去评价~',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(30),
                                          color: Color(0xffE71419)),
                                    ),
                                  ])),
                        ),
                        ...course_eval
                            .map((item) => Container(
                                color: Colors.white,
                                margin: EdgeInsets.only(top: 10.0),
                                width: ScreenUtil().setWidth(750),
                                height: ScreenUtil().setHeight(140),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //头像
                                    Align(
                                      child: ClipOval(
                                        child: Image.network(
                                          item['headimgurl'],
                                          width: ScreenUtil().setWidth(120),
                                          height: ScreenUtil().setWidth(120),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    new Container(
                                      margin: EdgeInsets.only(left: 10.0),
                                      width: ScreenUtil().setWidth(540),
                                      height: ScreenUtil().setHeight(120),
                                      child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                              //名字和日期一行 中间的评价没图片
                                              child: new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  new Container(
                                                    height: ScreenUtil()
                                                        .setHeight(40),
                                                    child: new Text(
                                                        item['real_name'],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff454545),
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        30))),
                                                  ),
                                                  new Container(
                                                    height: ScreenUtil()
                                                        .setHeight(40),
                                                    child: new Text(
                                                        item['createtime'],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff787878),
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        26))),
                                                  )
                                                ],
                                              ),
                                            ),
                                            new Container(
                                                alignment: Alignment.bottomLeft,
                                                height:
                                                    ScreenUtil().setHeight(60),
                                                child: new Text(item['content'],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff787878),
                                                        fontSize: ScreenUtil()
                                                            .setSp(28))))
                                          ]),
                                    )
                                  ],
                                )))
                            .toList()
                      ]))
                ],
              ),
            ),
          ));
    }

    Widget bottomModule(String s) {
      return new Container(
          color: Colors.white,
          height: ScreenUtil().setHeight(98),
          padding: EdgeInsets.only(left: ScreenUtil().setHeight(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    Container(
                      child: InkWell(
                        onTap: () {
                          updateGroupValue(!_flag);
                          getCollectionApi();
                        },
                        child: Image.asset(
                          _flag
                              ? 'assets/home/icon_yishoucang.png'
                              : 'assets/home/icon_shoucanghui.png',
                          width: ScreenUtil().setWidth(38),
                          height: ScreenUtil().setHeight(30),
//                          fit: BoxFit.cover,
                          // fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    new Text(
                      '收藏',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                      ),
                    ),
                  ])),
              //此处立即购买文字和颜色需要变化
              Expanded(
                flex: 1,
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setHeight(304),
                      height: ScreenUtil().setHeight(98),
                      child: RaisedButton(
                          // padding: EdgeInsets.fromLTRB(15.0,15.0,15.0,15.0),
                          color: PublicColor.themeColor,
                          child: new Text(
                            '立即购买',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Colors.white),
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                //购买弹窗出现
                                return diaDogCart();
                              },
                            );
                          }),
                    )
                  ],
                )),
              )
            ],
          ));
    }

    return Stack(children: <Widget>[
      Scaffold(
          appBar: new AppBar(
            backgroundColor: Color.fromRGBO(231, 20, 25, 1),
            centerTitle: true, //标题居中
            title: Text('课程详情',
                style: TextStyle(fontSize: ScreenUtil().setSp(33))),
            leading: IconButton(
              //返回按钮
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); //连接上下文
              },
            ),
          ),
          body: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                videoModule('课程详情视频'),
                tabbarModule('课程详情tabbar'),
                bottomModule('底部购买收藏')
              ],
            ),
          )),
      isLoading ? LoadingDialog() : Container(),
    ]);
  }

  showDialog_pay(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text('付费',
                style: StyleUtil.tontStyle(
                    color: PublicColor.textColor,
                    num: 32,
                    fontWeight: FontWeight.bold)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: StyleUtil.width(60)),
                      Text('观看此视频需要花费',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      Text(
                        '￥${course['price']}',
                        style: StyleUtil.tontStyle(),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('是否继续观看',
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                print('yes...');
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              onPressed: () {
                print('yes...');
                payMoney();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  //购买弹窗
  Widget diaDogCart() {
    return Container(
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setHeight(600),
        alignment: Alignment.topCenter,
        child: Column(children: <Widget>[
          new Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setHeight(200),
            margin: EdgeInsets.only(top: 10.0),
            // color: Colors.red,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(200),
                    child: CachedImageView(
                        ScreenUtil.instance.setWidth(200.0),
                        ScreenUtil.instance.setWidth(200.0),
                        detailImg,
                        null,
                        BorderRadius.all(Radius.circular(0))),
                  ),
                  new Container(
                      width: ScreenUtil().setWidth(400),
                      height: ScreenUtil().setHeight(200),
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.bottomLeft,
                      child: new Text(
                        '￥\t${course['price']}',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: ScreenUtil().setSp(32)),
                      )),
                  new Container(
                      alignment: Alignment.topCenter,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setHeight(200),
                      child: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )),
                ]),
          ),
          //规格
          new Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setHeight(240),
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 10.0),
              child: new Row(
                children: <Widget>[
                  new Text(
                    '规格：',
                    style: TextStyle(color: Color(0xff787878)),
                  ),
                  Container(
                      child: Text(
                        '长期有效',
                        style: TextStyle(
                          color: Color(0xffE71419),
                          fontSize: ScreenUtil.instance.setWidth(28),
                        ),
                      ),
                      padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //默认选中第一个 应添加另一个字段 进行判断切换不同规格
                        border: new Border.all(
                          color: Color(0xffE71419),
                        ),
                      ))
                ],
              )),
          new Container(
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setHeight(100),
            child: new RaisedButton(
              child: new Text("立即购买"),
              color: Color(0xffE71419),
              textColor: Colors.white,
              onPressed: () {
                Navigator.pop(context);
                payMoney();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //圆角大小
            ),
          )
        ]));
  }

  //循环规格
  List<Widget> listBoxs(list) => List.generate(list.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //默认选中第一个 应添加另一个字段 进行判断切换不同规格
              border: new Border.all(
                  color: index == 0 ? Color(0xffE71419) : Color(0xfffececec),
                  width: 0.5),
            ),
            child: Text(
              //此处绑定具体规格
              list[index],
              style: TextStyle(
                color: index == 0 ? Color(0xffE71419) : Colors.black45,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            print('切换规格了老弟');
          },
        );
      });
}
