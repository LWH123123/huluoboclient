import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/string.dart';
class CachedImageView extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final BoxDecoration miaoshu;
  final BorderRadius radio;

  CachedImageView(this.width, this.height, this.url, this.miaoshu, this.radio);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      alignment: Alignment.center,
      decoration: this.miaoshu,
      child:ClipRRect(
        borderRadius: this.radio,
        child: Image.network(
         this.url,
          fit: BoxFit.fill,
          width: this.width,
          height: this.height,
        ),
      )
    );
  }
}

// placeholder: (BuildContext context, String url) {
//             return Container(
//               width: this.width,
//               color: Colors.grey[350],
//               height: this.height,
//               alignment: Alignment.center,
//               child: Text(
//                 Strings.LOADING,
//                 style: TextStyle(
//                     fontSize: ScreenUtil.instance.setSp(26.0),
//                     color: Colors.white),
//               ),
//             );
//           },
