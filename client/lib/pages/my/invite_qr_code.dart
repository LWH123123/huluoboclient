import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import '../../widgets/cached_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InviteQrCode extends StatefulWidget {
  @override
  _InviteQrCodeState createState() => _InviteQrCodeState();
}

class _InviteQrCodeState extends State<InviteQrCode> {
  String headImg = '', name = '', id = '', inviterImg = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    inviterImg = '';
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
      inviterImg = success['user']['invite_url'];
    }, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topImg = new Container(
      child: new Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Image.asset(
            "assets/mine/icon_logo.png",
            width: ScreenUtil().setWidth(460),
            height: ScreenUtil().setWidth(155),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Image.asset(
            "assets/mine/icon_zi.png",
            width: ScreenUtil().setWidth(625),
            height: ScreenUtil().setWidth(125),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          width: ScreenUtil().setWidth(553),
          height: ScreenUtil().setWidth(613),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)),
          ),
          child: new Column(children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 70, top: 20),
                child: new Row(children: <Widget>[
                  Expanded(
                      flex: 0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            0,
                            ScreenUtil().setWidth(10),
                            0,
                            ScreenUtil().setWidth(10)),
                        child: CachedImageView(
                            ScreenUtil.instance.setWidth(100.0),
                            ScreenUtil.instance.setWidth(100.0),
                            headImg == '' ? '' : headImg,
                            null,
                            BorderRadius.all(Radius.circular(50.0))),
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(32),
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ])),
            Container(
                width: ScreenUtil().setWidth(278),
                height: ScreenUtil().setWidth(278),
              margin: EdgeInsets.only(top: 10),

              child: QrImage(
                data: inviterImg,              
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  '邀请码 ' + id,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                      color: Color(0xffEC001B),
                      fontWeight: FontWeight.w600),
                ))
          ]),
        )
      ]),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('邀请二维码'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PublicColor.themeColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/mine/bg_yaoqing.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: new ListView(
          children: [topImg],
        ),
      ),
    );
  }
}
