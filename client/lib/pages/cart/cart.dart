import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _homeBar('首页搜索栏'),
         
        ],
      ),
    );
  }
}

//头部搜索
Widget _homeBar(String s) {
  return Container(
    color: Colors.red,
    height: ScreenUtil().setWidth(93),
    child: Container(
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(31)))),
      child: new Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(45))),
        ),
        child: new Container(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
          child: new Row(
            children: <Widget>[
              Icon(
                Icons.search,
                size: ScreenUtil().setWidth(40),
                color: Color(0xff4E4E4E),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: TextField(
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(24), //设置字体大小
                        color: Color(0xff4E4E4E)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(45)),
                      ),
                      hintText: '点击搜索主播名称、ID号',
                      // style:TextStyle(),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, ScreenUtil().setWidth(10), 0, 0),
                child: Text(
                  '取消',
                   style: TextStyle(
                        fontSize: ScreenUtil().setSp(33), //设置字体大小
                        color: Color(0xff4E4E4E)),
                  )
                
                )
            ],
          ),
        ),
      ),
    ),
  );
}
//热搜
Widget _hot(String s){
  return Container(

  );
}


//历史记录



