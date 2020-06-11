import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './curriculum_th_detail.dart';

class Curriculumth extends StatefulWidget {
  @override
  _CurriculumthState createState() => _CurriculumthState();
}

class _CurriculumthState extends State<Curriculumth> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget teachList = new Container(
      child: new Column(children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new TeacherDetail()));
          },
          child: Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(175),
             decoration: BoxDecoration(
               color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
            ),
            child: Row(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: ClipOval(
                  // child:Image.asset("assets/mine/avatar.png"),
                  child: Image.network(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1587805267580&di=5b7500ba22c6268f8bd7c515138bba7e&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F010852554b7e08000001bf72454a1b.jpg',
                    height: ScreenUtil().setWidth(120),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(500),
                        // margin: EdgeInsets.only(bottom: 10),
                        child: Text('李老师',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(28),
                            )),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(500),
                        child: Text(
                          '课程讲得逻辑性强，很容易听懂~课程讲得逻辑性强，很容易听懂~.....',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: ScreenUtil().setSp(26),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ))
            ]),
          ),
        ),
      ]),
    );

    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
              alignment: Alignment.center,
              child: new ListView(children: <Widget>[
                teachList,
              ])),
        )
      ],
    );
  }
}
