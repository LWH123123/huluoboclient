import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/toast_util.dart';
import '../../service/live_service.dart';

class LiveStore extends StatefulWidget {
  final oid;
  LiveStore({this.oid});
  @override
  LiveStoreState createState() => LiveStoreState();
}

class LiveStoreState extends State<LiveStore> {
  bool isLoading = false;
  List shopList = [];
  Map anchor = {
    "headimgurl": "",
    "nickname": "",
    "store_img": "",
  };
  @override
  void initState() {
    print('widget.oid---->>>${widget.oid}');
    super.initState();
    getList();
  }

  void getList() async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("aid", () => widget.oid);
    LiveServer().getLiveStore(map, (success) async {
      setState(() {
        anchor = success['anchor'];
        shopList = success['list'];
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget topArea = new Container(
      height: ScreenUtil().setWidth(370),
      width: ScreenUtil().setWidth(750),
      decoration: anchor['store_img'] != ""
          ? BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(anchor['store_img']),
                fit: BoxFit.cover,
              ),
            )
          : BoxDecoration(),
      child: new Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setWidth(120),
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new IconButton(
                  icon: new Icon(
                    Icons.chevron_left,
                    size: ScreenUtil.instance.setWidth(55.0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // new IconButton(
                //   icon: new Icon(
                //     Icons.share,
                //     size: ScreenUtil.instance.setWidth(40.0),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
              ],
            ),
          ),
          new Container(
            height: ScreenUtil().setWidth(190),
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.fromLTRB(50, 30, 20, 0),
            child: new ListTile(
              leading: Container(
                height: ScreenUtil.instance.setWidth(110),
                width: ScreenUtil.instance.setWidth(110),
                child: ClipOval(
                  child: anchor['headimgurl'] != ""
                      ? Image.network(
                          anchor['headimgurl'],
                          width: ScreenUtil().setWidth(400),
                          height: ScreenUtil().setWidth(400),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              ),
              title: Text('${anchor["nickname"]}'),
              // subtitle: Text('销量:${anchor["nickname"]}'),
            ),
          ),
        ],
      ),
    );
    Widget listbar = new Container(
      // child:Stack(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: new Border.all(width: 1, color: Colors.white),
      ),
      // color: Colors.red,
      height: ScreenUtil().setWidth(90),
      width: ScreenUtil().setWidth(750),
      child: new Column(
        children: <Widget>[
          new InkWell(
            child: Container(
              height: ScreenUtil().setWidth(80),
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              // decoration: BoxDecoration(
              //   border: Border(bottom: BorderSide(color: Color(0xffe5e5e5))),
              // ),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // new InkWell(
                    Container(
                        // padding:  EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/shop/rx.png',
                          width: ScreenUtil.instance.setWidth(50.0),
                          fit: BoxFit.cover,
                        ),
                        Text(
                          ' 店铺热卖',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )),
                    Container(
                      child: Text('店铺在售${shopList.length}件宝贝'),
                    ),
                    // ),
                  ]),
            ),
          ),
        ],
      ),
    );
    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (shopList.length == 0) {
        arr.add(Container(
          height: ScreenUtil().setWidth(700),
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
          child: Text(
            '暂无数据',
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
          ),
        ));
      } else {
        for (var item in shopList) {
          arr.add(InkWell(
              child: Container(
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            width: ScreenUtil.instance.setWidth(330),
            child: Container(
              width: ScreenUtil.instance.setWidth(350),
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: PublicColor.whiteColor,
                border: Border.all(
                  width: 1,
                  color: Color(0xffeeeeee),
                ),
              ),
              child: Container(
                width: ScreenUtil.instance.setWidth(350),
                child: Column(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item['thumb'],
                        height: ScreenUtil.instance.setWidth(350),
                        width: ScreenUtil.instance.setWidth(350),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setWidth(20),
                        0),
                    height: ScreenUtil.instance.setWidth(90),
                    width: ScreenUtil.instance.setWidth(350),
                    child: Text(
                      item['name'].toString(),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0,
                        ScreenUtil().setWidth(20), 0),
                    width: ScreenUtil.instance.setWidth(350),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '￥' + item['now_price'].toString(),
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '销量 ' + item['buy_count'].toString(),
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  // 按钮
                  Container(
                      height: ScreenUtil.instance.setWidth(70),
                      width: ScreenUtil.instance.setWidth(300),
                      child: MaterialButton(
                        color: PublicColor.themeColor,
                        child: new Text(
                          '立即抢购',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(26),
                            color: PublicColor.btnColor,
                          ),
                        ),
                        onPressed: () {
                          // NavigatorUtils.toXiangQing(context,item['id'].toString(),"1");
                        },
                      )),
                ]),
              ),
            ),
          )));
        }
      }
      content = new Wrap(
        spacing: 5.0, // 主轴(水平)方向间距
        runSpacing: 7.0,
        alignment: WrapAlignment.start,
        children: arr,
      );
      return content;
    }

    Widget listcar = listArea();
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new Column(children: <Widget>[
              topArea,
              listbar,
              Container(
                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                alignment: Alignment.topLeft,
                child: listcar,
              ),
            ]),
          ),
        ],
      ),
      // resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
    );
  }
}
