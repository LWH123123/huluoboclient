import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 举报弹窗
class ReportWidget extends StatefulWidget {
  final roomId;
  ReportWidget({this.roomId});
  @override
  ReportWidgetState createState() => ReportWidgetState();
}

class ReportWidgetState extends State<ReportWidget> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          InkWell(
            child: Image.asset(
              'assets/zhibo/tip_off.png',
              width: ScreenUtil().setWidth(90),
              height: ScreenUtil().setWidth(90),
            ),
            onTap: () {
              print('举报');
              print(widget.roomId);
              NavigatorUtils.toTipoffPage(context,widget.roomId);
            },
          ),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          Text(
            '举报',
            style: TextStyle(fontSize: ScreenUtil().setSp(40)),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
        ],
      ),
    );
  }
}
