import 'dart:typed_data';
import 'package:client/common/Utils.dart';
import 'package:client/common/color.dart';
import 'package:client/utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Buymember extends StatefulWidget{
  @override
  BuymemberState createState() => BuymemberState();
}


class BuymemberState extends State<Buymember>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购买VIP会员'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PublicColor.themeColor,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
          child: new Container(
              /*width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,*/
              width: 500,
              height: 500,
              color: Colors.red,
            ),
      ),
            new Container(
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                 new Container(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 0.0, 0.0),
                    child: new Text(
                      '¥',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                 new Container(
                   margin: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                   child: new Text(
                      '898',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                 Expanded(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: new Text(
                      '¥1989',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),),//InkWell
                 new Container(
                    width: 135,
                    height: 50,
//                    margin: EdgeInsets.fromLTRB(90.0, 0.0, 0.0, 0.0),
                    alignment: Alignment.center,
                    color: Colors.amber,
                    child: new Text(
                      '立即加入',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );



  }
}