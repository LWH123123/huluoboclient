import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';

class LoadingDialog extends StatefulWidget {
  final String types;
  LoadingDialog({this.types});
  @override
  _LoadingDialogState createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black12,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: 120,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SpinKitFadingCircle(
                  size: ScreenUtil.instance.setWidth(90.0),
                  color: PublicColor.themeColor,
                ),
                SizedBox(
                  height: 10,
                ),
                widget.types == "1"
                    ? Text('支付中,请稍后...',
                        style: TextStyle(
                          fontSize: 12,
                          color: PublicColor.textColor,
                        ))
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
