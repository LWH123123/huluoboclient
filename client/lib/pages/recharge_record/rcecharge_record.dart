import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:client/common/color.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';

class RcechargeRecord extends StatefulWidget {
  @override
  RcechargeRecordState createState() => RcechargeRecordState();
}

class RcechargeRecordState extends State<RcechargeRecord> {
  bool isLoading = false;
 List tixianList = [];

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  void getRecord() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();

    UserServer().getChongzhiApi(map, (success) async {
      setState(() {
        isLoading = false;
      });
      tixianList = success['list'];
    }, (onFail) async {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget top = new Container(
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setHeight(92),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
        ),
        child: new Row(children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '日期',
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
              alignment: Alignment.center,
              child: Text(
                '状态',
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
              alignment: Alignment.center,
              child: Text(
                '数量',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
        ]),
      ),
    );

    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (tixianList.length == 0) {
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
        for (var item in tixianList) {
          arr.add(Container(
              child: new Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: new Row(children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        item['create_at'],
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
                      alignment: Alignment.center,
                      child: Text(
                        item['status'],
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
                      alignment: Alignment.center,
                      child: Text(
                        item['amount'],
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
            title: Text('充值记录'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
          ),
          body: Container(
              child: new ListView(children: <Widget>[top, listArea()])),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }
}
