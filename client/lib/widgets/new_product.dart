import 'package:flutter/material.dart';
import './cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../config/Navigator_util.dart';

class ProductView extends StatelessWidget {
  final List productList;

  ProductView(this.productList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil.instance.setWidth(10.0),
          right: ScreenUtil.instance.setWidth(10.0)),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.78,
              crossAxisSpacing: 0,
              mainAxisSpacing: 3),
          itemBuilder: (BuildContext context, int index) {
            return _getGridViewItem(context, productList[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context, productEntity) {
    return Container(
      child: InkWell(
          onTap: () {
            // NavigatorUtils.toXiangQing(context,productEntity['id'].toString());
            // Navigator.push(context, MaterialPageRoute(builder: (context) => XiangQing(productEntity)));
          },
          child: Card(
            elevation: 5.2,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
            child: Stack(children: [
              Container(
                padding: EdgeInsets.only(bottom:ScreenUtil.instance.setWidth(10.0)),
                decoration: new BoxDecoration(
                  color: Color(0xfffff4625),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                alignment: Alignment.bottomCenter,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(productEntity['name'],
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.instance.setWidth(24.0))),
                  RichText(
                    text: TextSpan(
                        text: '爱心价',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.instance.setWidth(26.0)),
                        children: [
                          TextSpan(
                              text: productEntity['love_price'],
                              style: TextStyle(
                                  color: Color(0xffffbcb12),
                                  fontSize:
                                      ScreenUtil.instance.setWidth(26.0))),
                          TextSpan(
                              text: '元',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      ScreenUtil.instance.setWidth(26.0))),
                        ]),
                  ),
                ]),
              ),
              Container(
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(500.0),
                  ScreenUtil.instance.setWidth(215.0),
                  productEntity['thumb'],
                  null,
                  BorderRadius.vertical(
                    top: Radius.elliptical(10, 10),
                  ),
                ),
              ),
              // Positioned(
              //   left:0,
              //   bottom:0,
              //   child:Container(
              //     // width:ScreenUtil.instance.setWidth(230.0),
              //     height: ScreenUtil.instance.setWidth(70.0),
              //     decoration: new BoxDecoration(
              //       color: Color(0xfffff4625),
              //     ),
              //     child: Text(
              //       productEntity['name'],
              //       maxLines: 2,
              //       overflow: TextOverflow.ellipsis,
              //       style: TextStyle(color: Colors.black54, fontSize: 14.0),
              //     ),
              //   ),
              // )
            ]),
          )),
    );
  }
}
