import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderGoodsBuilder {
  static Widget build(listView, index) {
    return Container(
      width: ScreenUtil.instance.setWidth(700),
      height: ScreenUtil.instance.setWidth(245),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: Border(
          top: BorderSide(color: Color(0xfffececec), width: 1),
        ),
      ),
      child: new Row(
        children: <Widget>[
          CachedImageView(
              ScreenUtil.instance.setWidth(204.0),
              ScreenUtil.instance.setWidth(204.0),
              listView[index].containsKey('attr_img') ? 
              listView[index]['attr_img'] : listView[index]['thumb'],
              null,
              BorderRadius.all(Radius.circular(0))),
          new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
          Container(
            width: ScreenUtil.instance.setWidth(380.0),
            height: ScreenUtil.instance.setWidth(204.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                  Text(listView[index]['name'],
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: ScreenUtil.instance.setWidth(25.0))),
                  new SizedBox(height: ScreenUtil.instance.setWidth(5.0)),
                  listView[index].containsKey('attr_name') ? Text('规格:' + listView[index]['attr_name'].toString(),
                      style: TextStyle(
                          color: Color(0xfff9f9c9c),
                          fontSize: ScreenUtil.instance.setWidth(24.0))) : Container(),
                  new Row(children: [
                    Container(
                      width: ScreenUtil.instance.setWidth(210.0),
                      height: ScreenUtil.instance.setWidth(75.0),
                      alignment: Alignment.bottomLeft,
                      child: RichText(
                        text: TextSpan(
                            text: '￥' +
                                listView[index]['now_price'].toString() +
                                ' ',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenUtil.instance.setWidth(27.0)),
                            children: [
                              TextSpan(
                                  text: '￥' +
                                      listView[index]['old_price'].toString(),
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Color(0xfffcccccc),
                                      fontSize:
                                          ScreenUtil.instance.setWidth(27.0))),
                            ]),
                      ),
                    ),
                  ])
                ]),
          ),
          Container(
            width: ScreenUtil.instance.setWidth(90.0),
            height: ScreenUtil.instance.setWidth(204.0),
            alignment: Alignment.center,
            child: Text('x' + listView[index]['num'].toString(),
                style: TextStyle(
                    color: Color(0xfff8f8c8d),
                    fontSize: ScreenUtil.instance.setWidth(27.0))),
          ),
        ],
      ),
    );
  }
}
