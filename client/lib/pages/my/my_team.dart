import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';

class MyTeam extends StatefulWidget {
  @override
  _MyTeamState createState() => _MyTeamState();
}

class _MyTeamState extends State<MyTeam> {
  bool isLoading = false;
  List list = [];
  String nums = '';
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    UserServer().getMyTeam(map, (success) async {
      setState(() {
        isLoading = false;
      });
      nums = success['count'].toString();
      list = success['lists'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(120),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffE5E5E5)))),
      child: new Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(
                '团队成员人数：',
                style: TextStyle(
                  color: Color(0xff5E5E5E),
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(30),
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                nums,
                style: TextStyle(
                  color: Color(0xffE92F2F),
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(30),
                ),
              ))
        ],
      ),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (list.length == 0) {
        arr.add(Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '暂无数据',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(35),
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      } else {
        for (var item in list) {
          arr.add(Container(
              height: ScreenUtil().setWidth(120),
              width: ScreenUtil().setWidth(750),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xffE5E5E5))),
              ),
              child: new Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: new Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          alignment: Alignment.topLeft,
                          child: Text(
                            item['nickname'].toString(),
                            style: TextStyle(
                              color: Color(0xff5e5e5e),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.only(right: 15),
                          alignment: Alignment.topRight,
                          child: Text(
                            '佣金:  ' + item['commission'],
                            style: TextStyle(
                              color: Color(0xff5e5e5e),
                              fontSize: ScreenUtil().setSp(28),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              )));
        }
      }
      content = new Column(
        children: arr,
      );
      return content;
    }

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('我的团队'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
          ),
          body: Container(
              child: new ListView(children: <Widget>[
            topArea,
            new SizedBox(
              height: ScreenUtil().setWidth(30),
            ),
            listArea()
          ])),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
