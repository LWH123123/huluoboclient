import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../service/user_service.dart';
import '../../widgets/loading.dart';
import '../../utils/toast_util.dart';

class Brokerage extends StatefulWidget {
  @override
  _BrokerageState createState() => _BrokerageState();
}

class _BrokerageState extends State<Brokerage> {
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;

  List listView = [];

   @override
  void initState() {
    super.initState();
    getList();
  }
  void getList() async {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      listView = [];
    }

    Map<String, dynamic> map = Map();

    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);

    UserServer().getYJRecord(map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          listView = success['log'];
        } else {
          if (success['log'].length == 0) {
            ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['log'].length; i++) {
              listView.insert(listView.length, success['log'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('佣金明细'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget top() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setHeight(92),
        width: ScreenUtil().setWidth(750),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
        ),
        child: new Row(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                '日期',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '时间',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '类目',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                '金额',
                style: TextStyle(
                  color: Color(0xff5e5e5e),
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget listArea() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listView.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in listView) {
        arr.add(Container(
            child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: new Row(children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(left: 2),
                    alignment: Alignment.center,
                    child: Text(
                      item['Ymd'].toString(),
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      item['Hi'].toString(),
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      item['num'],
                      style: TextStyle(
                        color: Color(0xff5e5e5e),
                        fontSize: ScreenUtil().setSp(28),
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        )));
      }
    }
    content = new Column(
      children: arr,
    );
    return content;
  }

  Widget contentWidget() {
    return Container(
      child: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(
          backgroundColor: PublicColor.themeColor,
        ),
        footer: BezierBounceFooter(
          backgroundColor: PublicColor.themeColor,
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[top(), listArea()],
        )),
        onRefresh: () async {
          getList();
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            getList();
          });
        },
      ),
    );
  }
}
