import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PublicColor {
  static const Color bodyColor = Color(0xfff5f5f5);
  static const Color btnColor = Color.fromRGBO(255, 255, 255, 1.0); //#按钮字体色
  static const Color searchColor = Color.fromRGBO(78, 78, 78, 0.69); // #4E4E4E
  static const Color textColor = Color(0xff454545); //#545454
  static const Color inputHintColor = Color(0xff545454); //#454545
  static const Color grewNoticeColor = Color(0xff999999); //#999
  static const Color themeColor = Color.fromRGBO(231, 20, 25, 1); //#主题色
  static const Color whiteColor = Color(0xffffffff); //#白色
  static const Color borderColor = Color(0xffE5E5E5);
  static const Color yellowColor = Color(0xfff88718); //#F88718
  static const Color goodsNum = Color(0xffa0A0A0);
  static var headerTextColor;

  static var headerColor; //#E5E5E5
}

class StyleUtil {
  static width(double num) {
    return ScreenUtil().setWidth(num);
  }
  static fontSize(double num) {
    return ScreenUtil().setSp(num);
  }

  static borderBottom ({Color co = PublicColor.borderColor}) {
    return BorderSide(color: co);
  }

  static tontStyle ({Color color = PublicColor.themeColor, double num = 28, FontWeight fontWeight= FontWeight.w400}) {
    return TextStyle(color: color ,fontSize: fontSize(num),fontWeight: fontWeight);
  }

  static padding ({double left = 0, double top  = 0, double right  = 0, double bottom  = 0}) {
    return EdgeInsets.fromLTRB(width(left), width(top), width(right), width(bottom));
  }

  static paddingTow ({double left = 0, double top  = 0}) {
    return EdgeInsets.fromLTRB(width(left), width(top), width(left), width(top));
  }

  static boxShadow () {
    return [
      BoxShadow(
          color: Color.fromRGBO(108, 108, 108, 0.46),
          offset: Offset(0.0, 2), //阴影xy轴偏移量
          blurRadius: 15.0, //阴影模糊程度
          spreadRadius: 1.0 //阴影扩散程度
      )
    ];
  }

}
