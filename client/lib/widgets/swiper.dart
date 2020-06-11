import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/string.dart';
import './cached_image.dart';
class SwiperView extends StatelessWidget {
  final List bannerData;
  final int size;
  final double viewHeight;
  Function onClick;
  SwiperView(this.bannerData, this.size, this.viewHeight,{this.onClick});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: viewHeight,
      width: double.infinity,
      child: bannerData == null || bannerData.length == 0
          ? Container(
              height: ScreenUtil.instance.setWidth(360.0),
              color: Colors.grey,
              alignment: Alignment.center,
              child: Text(Strings.NO_DATA_TEXT),
            )
          : Swiper(
              onTap: (index) {
                onClick(index);
              },
              itemCount: bannerData.length,
              scrollDirection: Axis.horizontal,
              //滚动方向，设置为Axis.vertical如果需要垂直滚动
              loop: true,
              //无限轮播模式开关
              autoplay: false,
              itemBuilder: (BuildContext buildContext, int index) {
                return CachedImageView(
                    double.infinity, double.infinity, bannerData[index]['img'],null,BorderRadius.circular(0));
              },
              duration: 300,
              pagination: SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                      size: 8.0,
                      color: Colors.white,
                      activeColor: Colors.deepOrangeAccent)),
            ),
    );
  }
}
