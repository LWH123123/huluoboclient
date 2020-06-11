import 'package:flutter/material.dart';
import './cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductView extends StatelessWidget {
  final List productList;
  final Function getliveurl;
  ProductView(this.productList, this.getliveurl);

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
              childAspectRatio: 0.59,
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
          onTap: () async {
            await getliveurl(productEntity);
          },
          child: Card(
            elevation: 5.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))), //设置圆角
            child: Stack(children: [
              Container(
                child: CachedImageView(
                  ScreenUtil.instance.setWidth(340.0),
                  ScreenUtil.instance.setWidth(370.0),
                  productEntity['img'],
                  null,
                  BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.black.withOpacity(0.5)),
                width: ScreenUtil.instance.setWidth(260.0),
                height: ScreenUtil.instance.setWidth(40.0),
                margin: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15.0),
                    ScreenUtil.instance.setWidth(25.0), 0, 0),
                child: new Row(children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: ScreenUtil.instance.setWidth(40.0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: productEntity['is_open'] == 1
                              ? Color(0xfffdcdcdc)
                              : Color(0xfff3ad542)),
                      child: Text(
                          productEntity['is_open'].toString() == "1"
                              ? '直播中'
                              : '预告',
                          style: TextStyle(
                              color: productEntity['is_open'] == 1
                                  ? Colors.red
                                  : Color(0xfffffffff),
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
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
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                alignment: Alignment.bottomLeft,
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  new Row(
                    children: <Widget>[
                      new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
                      Container(
                        width: ScreenUtil.instance.setWidth(70.0),
                        height: ScreenUtil.instance.setWidth(70.0),
                        decoration: BoxDecoration(
                            color: Color(0xfffa5a5a5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0))),
                        child: CachedImageView(
                            ScreenUtil.instance.setWidth(65.0),
                            ScreenUtil.instance.setWidth(65.0),
                            productEntity['headimgurl'],
                            null,
                            BorderRadius.all(Radius.circular(50.0))),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: ScreenUtil.instance.setWidth(230.0),
                        height: ScreenUtil.instance.setWidth(70.0),
                        child: Text(
                          '  ' + productEntity['nickname'],
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: ScreenUtil.instance.setWidth(34.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  new SizedBox(height: ScreenUtil.instance.setWidth(30.0)),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil.instance.setWidth(15.0),
                        ScreenUtil.instance.setWidth(5.0),
                        ScreenUtil.instance.setWidth(15.0),
                        ScreenUtil.instance.setWidth(5.0)),
                    child: Text(productEntity['goods_name'],
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.instance.setWidth(34.0),
                            fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil.instance.setWidth(15.0),
                        ScreenUtil.instance.setWidth(5.0),
                        ScreenUtil.instance.setWidth(15.0),
                        ScreenUtil.instance.setWidth(30.0)),
                    child: new Row(
                      children: <Widget>[
                        CachedImageView(
                            ScreenUtil.instance.setWidth(100.0),
                            ScreenUtil.instance.setWidth(100.0),
                            productEntity['goods_img'],
                            null,
                            BorderRadius.all(Radius.circular(10.0))),
                        Container(
                          alignment: Alignment.topLeft,
                          height: ScreenUtil.instance.setWidth(100.0),
                          width: ScreenUtil.instance.setWidth(200.0),
                          padding: EdgeInsets.only(
                              left: ScreenUtil.instance.setWidth(10.0)),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productEntity['goods_desc'],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil.instance
                                            .setWidth(23.0))),
                                Text('￥' + productEntity['total'],
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(23.0)))
                              ]),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ]),
          )),
    );
  }
}
