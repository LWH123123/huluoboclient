import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabclass extends StatefulWidget {
  List course;
  Tabclass({Key key, List this.course}): super(key: key);
  @override
  _TabclassState createState() => _TabclassState();
}

class _TabclassState extends State<Tabclass> {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      color: Colors.white,
      child: new ListView(
        children: widget.course != null ? widget.course.map((item) => Container(
          margin: EdgeInsets.only(top: 15),
          padding: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              border: Border(bottom: StyleUtil.borderBottom())),
          child: Row(
            children: <Widget>[
              //图片
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                child: Stack(children: [
                  Positioned(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item['img'],
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(267),
                          height: ScreenUtil().setWidth(171),
                        )),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Offstage(
                      offstage: int.parse(item['popularity']) == 0,
                      child: Container(
                        height: ScreenUtil().setHeight(42),
                        width: ScreenUtil().setHeight(280),
                        padding: StyleUtil.padding(left: 15),
                        decoration: BoxDecoration(color: Color(0x90000000)),
                        child: Text(
                          '${item['popularity']}人已学习',
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(387),
                      // height: ScreenUtil().setWidth(67),
                      margin:
                      EdgeInsets.only(left: ScreenUtil().setWidth(27)),
                      child: Text(
                        item['title'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(30),
                            color: Color(0xff4E4E4E)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(387),
                      // height: ScreenUtil().setWidth(67),
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(27),
                          ScreenUtil().setWidth(0), 0, 0),
                      child: Text(
                          double.parse(item['price']) == 0 ? '免费' : item['price'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.red),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      child: Row(children: [
                        Container(
                          width: ScreenUtil().setWidth(387),
                          // height: ScreenUtil().setWidth(67),
                          margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(27),
                            top: ScreenUtil().setWidth(20),
                          ),
                          child: Row(children: [
                            Container(
                              child: Text(
                                '共',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Color(0xffc6c6c6),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                item['child_num'],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Colors.orange[100],
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '节课',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Color(0xffc6c6c6),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(130)),
                              child: Text(
                                '${item['good_lv']}%  好评',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                  color: Colors.orange[100],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList() : Center(
          child: Text('暂无数据'),
        )
      ),
    );
  }
}
