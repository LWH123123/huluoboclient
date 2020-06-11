import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import 'package:flutter/services.dart';
import '../../utils/toast_util.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberPage extends StatefulWidget {
  @override
  MemberPageState createState() => MemberPageState();
}

class MemberPageState extends State<MemberPage> with TickerProviderStateMixin {
  //保持页面状态
  bool get wantKeepAlive => true;
  DateTime lastPopTime;
  bool isLoading = false;
  String headImg = '', name = '', id = '', msg = '', balance = '';
  String level = '', isagent='';
  List<dynamic> qrcode=List<dynamic>();
  Map user;

  @override
  void initState() {
    super.initState();
    getMy();
  }

  void signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } finally {}
  }

  void getMy() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    UserServer().getMyApi(map, (success) async {
      setState(() {
        isLoading = false;
        user = success['user'];
        headImg = success['user']['headimgurl'];
        name = success['user']['nickname'];
        id = success['user']['mall_id'].toString();
        msg = success['user']['msg'];
        balance = success['user']['balance'];
        isagent = success['user']['agent']['isagent'];
        qrcode = success['user']['agent']['qrcode'];
        print('是否为会员  ====>> $isagent');
        print('本人的昵称为====>>  $name');
        print('本人的ID为====>>  $id');
        print('邀请码为   ====>>  '+qrcode[0]);
        level = success['user']['level'].toString();
        success['user']['is_open'] == 1 ? guanbi(success['user']['msg']) : '';
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // 关闭直播提示
  guanbi (msg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("直播提示"),
            ),
            content: Container(
              height: StyleUtil.width(250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(msg,
                  style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                  SizedBox(height: StyleUtil.width(30)),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: PublicColor.themeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(46)),
                      child: Text('确定关闭',
                        style: StyleUtil.tontStyle(color: PublicColor.whiteColor),),
                      onPressed: () {
                        LiveServer().getGuanbo({}, (onSuccess) {
                          Navigator.of(context).pop();
                          ToastUtil.showToast('已关闭');
                        }, (onFail) => ToastUtil.showToast(onFail));
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        WillPopScope(
          child: Scaffold(
            body: contentWidget(),
          ),
          onWillPop: () async {
            // 点击返回键的操作
            if (lastPopTime == null ||
                DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
              lastPopTime = DateTime.now();
              ToastUtil.showToast('再按一次退出');
              return false;
            } else {
              lastPopTime = DateTime.now();
              // 退出app
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              return true;
            }
          },
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget topArea() {
    return Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(580),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: ScreenUtil().setWidth(750),
                height: ScreenUtil().setWidth(400),
                color: Color(0xffE71419),
                child: new Column(children: <Widget>[
                  Container(
                    child: new Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 70, left: 20),
                        child: CachedImageView(
                            ScreenUtil.instance.setWidth(130.0),
                            ScreenUtil.instance.setWidth(130.0),
                            headImg == '' ? '' : headImg,
                            null,
                            BorderRadius.all(Radius.circular(50.0))),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 70, left: 10),
                        child: Column(
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(34),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Text(
                                '学号：' + id,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(26),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 80, 0, 0),
                              child: Column(
                                children: <Widget>[
                                  new Image.asset(
                                    level == '1'
                                        ? 'assets/mine/icon_baiyin.png'
                                        : level == '2'
                                            ? 'assets/mine/icon_bojin.png'
                                            : level == '3'
                                                ? 'assets/mine/icon_zuanshi.png'
                                                : '',
                                    width: 70,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 80, left: 20),
                        child: Tooltip(
                          message: msg,
                          child: Image.asset(
                            'assets/mine/icon_shuoming.png',
                            width: ScreenUtil().setWidth(40),
                            height: ScreenUtil().setWidth(40),
                          ),
                        ),
                      ),
                    ]),
                  )
                ]),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                child: new InkWell(
                  onTap: () {
                    NavigatorUtils.goSetting(context)
                        .then((res) => this.getMy());
                  },
                  child: new Image.asset(
                    'assets/mine/settings.png',
                    width: ScreenUtil().setWidth(70),
                    height: ScreenUtil().setWidth(70),
                  ),
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                left: 13,
                child: Container(
                  width: ScreenUtil().setWidth(695),
                  height: ScreenUtil().setWidth(250),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: new Column(children: <Widget>[
                    InkWell(
                        child: new Container(
                      // alignment: Alignment.centerRight,
                      height: ScreenUtil().setWidth(80),
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0xffdddddd)))),
                      child: new Row(children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: new Text(
                            '我的订单',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            child: Text(
                              '查看全部',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                color: Color(0xff999999),
                              ),
                            ),
                            onTap: () {
                              print('查看全部');
                              String type = "0";
                              NavigatorUtils.goMyOrder(context, type);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: new Icon(
                            Icons.navigate_next,
                            color: Color(0xff999999),
                          ),
                        )
                      ]),
                    )),
                    new Container(
                        child: new Row(children: <Widget>[
                      InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(155.0),
                          width: ScreenUtil.instance.setWidth(170.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(30.0),
                              ),
                              Expanded(
                                flex: 0,
                                child: Image.asset(
                                  "assets/mine/icon_dfk.png",
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(50),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0),
                              ),
                              Expanded(
                                child: Text(
                                  '待付款',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color(0xff7b7b7b),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('待付款');
                          NavigatorUtils.goMyOrder(context, '1');
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(155.0),
                          width: ScreenUtil.instance.setWidth(170.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(30.0),
                              ),
                              Expanded(
                                flex: 0,
                                child: Image.asset(
                                  "assets/mine/icon_dfh.png",
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(55),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0),
                              ),
                              Expanded(
                                child: Text(
                                  '待发货',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color(0xff7b7b7b),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('待发货');
                          NavigatorUtils.goMyOrder(context, '2');
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(155.0),
                          width: ScreenUtil.instance.setWidth(170.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(30.0),
                              ),
                              Expanded(
                                flex: 0,
                                child: Image.asset(
                                  "assets/mine/icon_dsh.png",
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(50),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0),
                              ),
                              Expanded(
                                child: Text(
                                  '待收货',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color(0xff7b7b7b),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('待收货');
                          NavigatorUtils.goMyOrder(context, '3');
                        },
                      ),
                      InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(155.0),
                          width: ScreenUtil.instance.setWidth(170.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(30.0),
                              ),
                              Expanded(
                                flex: 0,
                                child: Image.asset(
                                  "assets/mine/icon_ywc.png",
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(50),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil.instance.setWidth(10.0),
                              ),
                              Expanded(
                                child: Text(
                                  '已完成',
                                  style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color(0xff7b7b7b),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          print('已完成');
                          NavigatorUtils.goMyOrder(context, '4');
                        },
                      )
                    ]))
                  ]),
                ))
          ],
        ));
  }

  Widget listArea() {
    return Container(
      width: ScreenUtil().setWidth(700),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: new Column(children: <Widget>[
        new InkWell(//余额
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/mine/icon_yue.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: StyleUtil.width(25)),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        '余额',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                     Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        '￥' + balance,
                        style: TextStyle(
                          color: Color(0xffE71419),
                          fontWeight: FontWeight.w600,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: new Icon(
                        Icons.navigate_next,
                        color: Color(0xff999999),
                      ),
                    )
                  ],
                ),
              ),
            ]),
          ),
          onTap: () {
            print('余额');
            NavigatorUtils.goBalance(context);
            // NavigatorUtils.rechargeCentrePage(context);
          },
        ),
        new InkWell(//积分
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/mine/jifen.png",
                          width: ScreenUtil().setWidth(42),
                          height: ScreenUtil().setSp(42),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: StyleUtil.width(25)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            '积分',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: new Text('0',
                            style: TextStyle(
                              color: Color(0xffE71419),
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: new Icon(
                            Icons.navigate_next,
                            color: Color(0xff999999),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
          ),
          onTap: () {
            print('积分');
            NavigatorUtils.goIntegral(context);
            // NavigatorUtils.rechargeCentrePage(context);
          },
        ),
        new InkWell(//我的足迹
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_zuji.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '我的足迹',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goZujiScreen(context);
          },
        ),
        new InkWell(//我的课程  暂时隐藏
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(0),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_kecheng.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(0),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '我的课程',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    height: 0,
                    width: 0,
                    alignment: Alignment.centerRight,
                   /*child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),*/
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goMyCurriculum(context);
          },
        ),
        new InkWell(//推广二维码
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_jiangshi.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '推广二维码',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )
                 ),
                  ])),
          onTap: () {
            /*user['is_lecturer'] == 0
                ? NavigatorUtils.goLecturerCentre(context).then((res) => this.getMy())
                : NavigatorUtils.goCreateCourse(context);*/
            //推广二维码
            //传值一定要Uri.encodeComponent()  包裹
            //推广二维码
            NavigatorUtils.goPromoteCode(context,Uri.encodeComponent(qrcode[0]));
          //邀请二维码
//            NavigatorUtils.goInviteQrCode(context);

          },
        ),
        new InkWell(//讲师中心 暂时隐藏
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(0),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_jiangshi.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(0),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '讲师中心',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    height: 0,
                    width: 0,
                    alignment: Alignment.centerRight,
                    /*child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),*/
                  )),
            ]),
          ),
          onTap: () {
            user['is_lecturer'] == 0
                ? NavigatorUtils.goLecturerCentre(context).then((res) => this.getMy())
                : NavigatorUtils.goCreateCourse(context);
          },
        ),
        new InkWell(//创建直播
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_chuangjian.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '创建直播',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            print('是否为会员  ====>> $isagent');

           bool a= isagent.contains('0');
            print('这是相同的吗===  $a');
           if(a){
             NavigatorUtils.goToBuyMember(context);
             return;
           }else {
             user['is_live'] == 0 ? NavigatorUtils.goApplyLive(context)
                 .then(() => getMy())
                 : NavigatorUtils.goCreateLive(context).then(() => getMy());
           }
          },
        ),
        new InkWell(//直播历史
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_lishi.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '直播历史',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goPastLive(context);
          },
        ),
        new InkWell(//分销中心
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_fenxiao.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '分销中心',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            NavigatorUtils.goSecondScreen(context);
          },
        ),
        new InkWell(//退出登录
          child: new Container(
            //  alignment: Alignment.centerLeft,
            height: ScreenUtil().setWidth(100),
            width: ScreenUtil().setWidth(700),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30), 0, ScreenUtil().setWidth(20), 0),

            child: new Row(children: <Widget>[
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      "assets/mine/icon_tuichu.png",
                      width: ScreenUtil().setWidth(42),
                      height: ScreenUtil().setSp(42),
                      fit: BoxFit.cover,
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      '退出登录',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: new Container(
                    alignment: Alignment.centerRight,
                    child: new Icon(
                      Icons.navigate_next,
                      color: Color(0xff999999),
                    ),
                  )),
            ]),
          ),
          onTap: () {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return MyDialog(
                      width: ScreenUtil.instance.setWidth(600.0),
                      height: ScreenUtil.instance.setWidth(300.0),
                      queding: () {
                        signOut();
                        NavigatorUtils.gologinPage(context);
                      },
                      quxiao: () {
                        Navigator.of(context).pop();
                      },
                      title: '温馨提示',
                      message: '确定要退出登录吗？');
                });
          },
        ),
      ]),
    );
  }

  Widget contentWidget() {
    return Container(
      child: new ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[topArea(), listArea()]),
    );
  }
}
