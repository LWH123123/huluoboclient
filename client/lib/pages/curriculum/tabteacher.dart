import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabteacher extends StatefulWidget {
  String introduce;
  Tabteacher({Key key, String this.introduce}) : super(key: key);
  @override
  _TabteacherState createState() => _TabteacherState();
}

class _TabteacherState extends State<Tabteacher> {
  @override
  void initState() {
    print("widget.introduce----${widget.introduce}");
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
        color: Colors.white,
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), ScreenUtil().setWidth(20), 0, 20),
          child: Text(
            widget.introduce != null ? widget.introduce : '',
            style: TextStyle(
              color: Color(0xff454545),
              fontSize: ScreenUtil().setSp(28),
            ),
          ),
        )
      ],
    ));
  }
}
