import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RankWidget extends StatefulWidget {
  final List sendList;
  RankWidget({this.sendList});
  @override
  RankWidgetState createState() => RankWidgetState();
}

class RankWidgetState extends State<RankWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(94),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffdddddd),
                ),
              ),
            ),
            child: Text(
              '本场榜单',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.w600,
                color: Color(0xff454545),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setWidth(70),
            padding: EdgeInsets.only(left: 20, right: 20),
            // decoration: BoxDecoration(color: Color(0xfffbfbfb)),
            child: new Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    'TOP100',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xff8f8f8f)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '金币',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                        color: Color(0xff8f8f8f),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setWidth(530),
            padding: EdgeInsets.only(bottom: 10),
            child: new ListView(
              children: <Widget>[
                InkWell(
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(140),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Container(child: Text('1')),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/mine/head.jpg',
                                height: ScreenUtil().setWidth(90),
                                width: ScreenUtil().setWidth(90),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '帅气的小哥哥',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '5.3万',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(140),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Container(child: Text('2')),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/mine/head.jpg',
                                height: ScreenUtil().setWidth(90),
                                width: ScreenUtil().setWidth(90),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '帅气的小哥哥',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '5.3万',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    width: ScreenUtil().setWidth(750),
                    height: ScreenUtil().setWidth(140),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: Container(child: Text('3')),
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/mine/head.jpg',
                                height: ScreenUtil().setWidth(90),
                                width: ScreenUtil().setWidth(90),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              '帅气的小哥哥',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '5.3万',
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
