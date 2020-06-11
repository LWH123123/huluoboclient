import 'package:flutter/material.dart';
import './cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductView extends StatelessWidget {
  final List productList;

  ProductView(this.productList);



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: ScreenUtil.instance.setWidth(25.0),
          right: ScreenUtil.instance.setWidth(25.0)),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 5,
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
          onTap: () {},
          child: Card(
            elevation: 4.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
            child: Stack(children: [
              Container(
                  child: CachedImageView(
                      ScreenUtil.instance.setWidth(340.0),
                      ScreenUtil.instance.setWidth(337.0),
                      productEntity['img'],
                      null,
                      BorderRadius.all(Radius.circular(10.0)))),
              Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.black.withOpacity(0.5)),
                width: ScreenUtil.instance.setWidth(200.0),
                height: ScreenUtil.instance.setWidth(40.0),
                margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                    ScreenUtil.instance.setWidth(25.0), 0, 0),
                child: new Row(children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenUtil.instance.setWidth(40.0),
                        child: Text(productEntity['online'].toString() + '人观看',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.instance.setWidth(25.0),
                                fontWeight: FontWeight.w700)),
                      )),
                ]),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                    ScreenUtil.instance.setWidth(250.0), 0, 0),
                child: new Row(
                  children: <Widget>[
                    new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
                    Container(
                      width: ScreenUtil.instance.setWidth(60.0),
                      height: ScreenUtil.instance.setWidth(60.0),
                      decoration: BoxDecoration(
                          color: Color(0xfffa5a5a5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(50.0))),
                      child: CachedImageView(
                          ScreenUtil.instance.setWidth(55.0),
                          ScreenUtil.instance.setWidth(55.0),
                          productEntity['headimgurl'],
                          null,
                          BorderRadius.all(Radius.circular(50.0))),
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: ScreenUtil.instance.setWidth(230.0),
                        height: ScreenUtil.instance.setWidth(70.0),
                        child: Text('  ' + productEntity['real_name'],
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil.instance.setWidth(28.0),
                                fontWeight: FontWeight.w700))),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                    ScreenUtil.instance.setWidth(350.0), 0, 0),
                child: new Column(children: <Widget>[
                  Container(
                      width: ScreenUtil().setWidth(300),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(20), top: 6),
                      child: Text(
                        productEntity['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      )),
                ]),
              )
            ]),
          )),
    );
  }
}
