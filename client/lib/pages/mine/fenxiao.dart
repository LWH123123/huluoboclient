import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:client/common/color.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import 'package:flutter/services.dart';
import '../../utils/toast_util.dart';
import '../../widgets/cached_image.dart';

class SecondScreen extends StatefulWidget {
  @override
  SecondScreenState createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  bool isLoading = false;
  String headImg = '', name = '', id = '', msg = '', balance = '',createtime = '';
  String level = '',sumCommission = '';

  @override
  void initState() {
    super.initState();
    getMy();
  }

  void getMy() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    UserServer().getMyApi(map, (success) async {
      setState(() {
        isLoading = false;
      });
      headImg = success['user']['headimgurl'];
      name = success['user']['real_name'];
      id = success['user']['id'].toString();
      msg = success['user']['msg'];
      balance = success['user']['commission'].toString();
      level = success['user']['level'].toString();
      createtime = success['user']['createtime'];
      sumCommission = success['user']['sum_commission'].toString();
    }, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(750),
        height: ScreenUtil().setWidth(500),
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
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: CachedImageView(
                          ScreenUtil.instance.setWidth(150.0),
                          ScreenUtil.instance.setWidth(150.0),
                          headImg == ''
                              ? 'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=468727759,3818736238&fm=26&gp=0.jpg'
                              : headImg,
                          null,
                          BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Column(
                          children: [
                            Container(
                              child: new Row(children: <Widget>[
                                Container(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(30),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                     level == '1'?'assets/mine/icon_baiyin.png':level == '2'?'assets/mine/icon_bojin.png':level == '3'?'assets/mine/icon_zuanshi.png':'',
                                    width: 60,
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(300),
                              margin: EdgeInsets.only(top: 5,),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '加入时间：'+ createtime,
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
                    ]),
                  ),
                  Container()
                ]),
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
                      height: ScreenUtil().setWidth(125),
                      padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Color(0xffdddddd)))),
                      child: new Row(children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: new Text(
                            '可提现佣金 ￥ ' + balance,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: InkWell(
                              onTap: () {
                                // print(balance);
                                String nums = balance;
                                NavigatorUtils.goWithdraw(context, nums).then((res)=>this.getMy());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 20),
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(50),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffFCAF23),
                                ),
                                child: new Text(
                                  '提现',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(28),
                                  ),
                                ),
                              )),
                        ),
                      ]),
                    )),
                    Container(
                      width: ScreenUtil().setWidth(695),
                      height: ScreenUtil().setWidth(125),
                      padding: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Color(0xff000000),
                        borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(ScreenUtil().setWidth(10)),
                            bottomRight:
                                Radius.circular(ScreenUtil().setWidth(10))),
                      ),
                      child: new Text(
                        '累计佣金 ￥ ' + sumCommission,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(28),
                            height: 3.5,
                            color: Colors.white),
                      ),
                    )
                  ]),
                ))
          ],
        ));

    Widget listArea = new Expanded(
        flex: 1,
        child: new Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
            child: new GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.all(0.0),
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              // childAspectRatio: 4/4,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/mine/icon_yongjin.png',
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(33),
                          height: ScreenUtil().setWidth(41),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('佣金明细');
                          NavigatorUtils.goBrokerage(context);
                        },
                        child: Text(
                          '佣金明细',
                          style: TextStyle(fontSize: ScreenUtil().setWidth(28)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/mine/icon_haibao.png',
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(33),
                          height: ScreenUtil().setWidth(41),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('推广海报');
                          NavigatorUtils.goInviteQrCode(context);
                        },
                        child: Text(
                          '推广海报',
                          style: TextStyle(fontSize: ScreenUtil().setWidth(28)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Image.asset(
                          'assets/mine/icon_tuandui.png',
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(41),
                          height: ScreenUtil().setWidth(41),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('我的团队');
                          NavigatorUtils.goMyTeam(context);
                        },
                        child: Text(
                          '我的团队',
                          style: TextStyle(fontSize: ScreenUtil().setWidth(28)),
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     '(10)',
                      //     style: TextStyle(
                      //         fontSize: ScreenUtil().setWidth(28),
                      //         color: Color(0xffFCAF23)),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            )));
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
            title: Text('分销中心')),
        body: Container(
            child: new Column(children: <Widget>[
          topArea,
          new SizedBox(
            height: ScreenUtil().setWidth(30),
          ),
          listArea
        ])));
  }
}
