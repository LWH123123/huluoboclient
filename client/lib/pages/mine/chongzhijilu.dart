import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteButton1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '充值记录',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(36),
          ),
        ),
      ),
      body: ListView(children: <Widget>[
        Container(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Row(children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text(
                    '日期',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    '类别',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    '数量',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              // alignment: Alignment.centerLeft,
              child: Row(children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text(
                    '2020-03-12',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    '充值',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    '10.00',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Row(children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text(
                    '2020-03-12',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    '充值',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    '10.00',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
              ]),
            ),
            Container(
              // alignment: Alignment.centerLeft,
              child: Row(children: [
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(40, 10, 0, 0),
                  child: Text(
                    '2020-03-12',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                  child: Text(
                    '充值',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    '10.00',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(36),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ))
      ]),
    );
  }
}
