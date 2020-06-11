import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 举报弹窗
class FeatureWidget extends StatefulWidget {
  final switchCamera;
  final startmeiyan;
  final controller;
  FeatureWidget({
    this.switchCamera,
    this.startmeiyan,
    this.controller,
  });
  @override
  FeatureWidgetState createState() => FeatureWidgetState();
}

class FeatureWidgetState extends State<FeatureWidget> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              print('切换摄像头');
              widget.switchCamera();
            },
            child: Image.asset(
              'assets/zhibo/icon_xuanzhuan.png',
              width: ScreenUtil.instance.setWidth(80.0),
            ),
          ),
          new SizedBox(
            width: ScreenUtil.instance.setWidth(20.0),
          ),
          InkWell(
            onTap: () {
              print('美颜');
              widget.startmeiyan();
            },
            child: Image.asset(
              'assets/zhibo/icon_meiyan.png',
              width: ScreenUtil.instance.setWidth(80.0),
            ),
          ),
          new SizedBox(
            width: ScreenUtil.instance.setWidth(20.0),
          ),
          InkWell(
            onTap: () {
              print('预览镜像');
              widget.controller.setPreviewMirror(mirror: true);
            },
            child: Image.asset(
              'assets/zhibo/icon_yulanjingxiang.png',
              width: ScreenUtil.instance.setWidth(80.0),
            ),
          ),
          new SizedBox(
            width: ScreenUtil.instance.setWidth(20.0),
          ),
          InkWell(
            onTap: () {
              print('推流镜像');
              widget.controller.setPreviewMirror(mirror: true);
            },
            child: Image.asset(
              'assets/zhibo/icon_tuiliu.png',
              width: ScreenUtil.instance.setWidth(80.0),
            ),
          ),
        ],
      ),
    );
  }
}
