import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'chongzhijilu.dart';
class RouteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.yellow,
      onPressed: () {
        print('object');
        _navigateToXiaoJieJie(context);
      },
      child: Text('充值'),
    );
  }

  _navigateToXiaoJieJie(BuildContext context) async {
    //async是启用异步方法

  await Navigator.push(
        //等待
        context,
        MaterialPageRoute(builder: (context) => XiaoJieJie()));

    // Scaffold.of(context).showSnackBar(SnackBar(content: Text('$result')));
  }
}

class XiaoJieJie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '充值中心',
        ),
        actions: <Widget>[
          Container(
            width: 30,
          ),
          new IconButton(
              icon: Text(
                '充值记录',

                style: TextStyle(
                  fontSize: ScreenUtil().setSp(26),
                ),
              ),
              onPressed: () {
Navigator.push(context,new  MaterialPageRoute(
              builder:(context) =>new RouteButton1())
            );

              })
        ],
        centerTitle: true,
      ),
      body: ListView(children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(20, 30, 0, 0),
          child: Row(
            children: [
              //当前余额
              Text(
                '当前余额',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(36),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 0),
                child: Text(
                  '20.00',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil().setSp(36),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            height: 80.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  child: Text(
                    '10元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  width: 100.0,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                ),
                new Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  child: Text(
                    '20元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  width: 100.0,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: Text(
                    '50元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  width: 100.0,
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  decoration: new BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ],
            )),
        Container(
            height: 80.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  child: Text(
                    '100元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  width: 100.0,
                  decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12)),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: Text(
                    '200元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  width: 100.0,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: Text(
                    '400元',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(46),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  width: 100.0,
                  decoration: new BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ],
            )),
        Container(
          decoration: new BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(32)),
          alignment: Alignment.center,
          child: Text(
            '立即充值',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(46),
            ),
          ),
          margin: EdgeInsets.fromLTRB(15, 100, 15, 0),
          height: 50,
        )
      ]),
    );
  }
}
