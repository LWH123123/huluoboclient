import 'package:client/common/color.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PresentPrice extends StatefulWidget {
  String id;
  PresentPrice({Key key, String this.id}) : super(key: key);
  @override
  _PresentPriceState createState() => _PresentPriceState();
}

class _PresentPriceState extends State<PresentPrice>
    with SingleTickerProviderStateMixin {
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
  List gift = [];
  List give = [];
  int tabIndex = 0,num = 0;
  double amount =  0;

  getGiftLog() {
    if (widget.id ==  null) return ToastUtil.showToast('请选择直播');
    LiveServer().getGiftLog({"room_id": widget.id, "type": tabIndex + 1},
        (onSuccess) {
      setState(() {
        tabIndex == 0 ? gift = onSuccess['gift'] : give = onSuccess['gift'];
        amount = double.parse(onSuccess['amount'].toString());
        num = onSuccess['num'];
      });
      _controller.finishRefresh();
    }, (onFail) {
          _controller.finishRefresh();
          ToastUtil.showToast(onFail);
        });
  }

  indexset() {
    setState(() {
      gift = [];
      give = [];
      tabIndex = _tabController.index;
      _tabController.index == _tabController.animation.value.toInt()
          ? this.getGiftLog()
          : '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => indexset());
    this.getGiftLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
            title: Text('收礼价值')),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(color: PublicColor.borderColor))),
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 2,
                labelColor: PublicColor.themeColor,
                unselectedLabelColor: Color(0xff5E5E5E),
                indicatorColor: PublicColor.themeColor,
                labelStyle: TextStyle(fontSize: ScreenUtil().setSp(30)),
                tabs: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(93),
                    child: Center(
                      child: Text('收礼'),
                    ),
                  ),
                  Container(
                    height: ScreenUtil().setWidth(93),
                    child: Center(
                      child: Text('打赏'),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Container(
                      child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setWidth(164),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    color: PublicColor.borderColor))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    num.toString(),
                                    style: TextStyle(
                                        color: PublicColor.yellowColor,
                                        fontSize: ScreenUtil().setSp(33)),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(28),
                                  ),
                                  Text(
                                    '收礼总数',
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(28)),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(128),
                                  right: ScreenUtil().setWidth(128)),
                              width: 1,
                              height: ScreenUtil().setWidth(80),
                              color: PublicColor.borderColor,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    amount.toString(),
                                    style: TextStyle(
                                        color: PublicColor.yellowColor,
                                        fontSize: ScreenUtil().setSp(33)),
                                  ),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(28),
                                  ),
                                  Text(
                                    '转换佣金数',
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontSize: ScreenUtil().setSp(28)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
                          child: EasyRefresh(
                            controller: _controller,
                            header: BezierCircleHeader(
                              backgroundColor: PublicColor.themeColor,
                            ),
                            enableControlFinishRefresh: true,
                            enableControlFinishLoad: false,

                            child: GridView.count(
                              crossAxisCount: 4,
                              mainAxisSpacing: ScreenUtil().setWidth(20),
                              crossAxisSpacing: ScreenUtil().setWidth(20),
                              childAspectRatio: 3 / 4,
                              children: gift
                                  .map((i) => view(i))
                                  .toList(),
                            ),
                            onRefresh: () async {
                              setState(() {
                                this.getGiftLog();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  )),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setWidth(107),
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(35)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom: BorderSide(
                                      color: PublicColor.borderColor))),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '打赏总数：',
                                style: TextStyle(
                                    color: PublicColor.textColor,
                                    fontSize: ScreenUtil().setSp(30)),
                              ),
                              Text(amount.toString(),
                                  style: TextStyle(
                                      color: PublicColor.yellowColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(30)))
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(ScreenUtil().setWidth(28)),
                            child: EasyRefresh(
                              controller: _controller,
                              header: BezierCircleHeader(
                                backgroundColor: PublicColor.themeColor,
                              ),
                              enableControlFinishRefresh: true,
                              enableControlFinishLoad: false,
                              child: GridView.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: ScreenUtil().setWidth(10),
                                crossAxisSpacing: ScreenUtil().setWidth(10),
                                childAspectRatio: 3 / 4,
                                children: give
                                    .map((i) =>
                                    view(i))
                                    .toList(),
                              ),
                              onRefresh: () async {
                                setState(() {
                                  this.getGiftLog();
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget view(item) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffDCDCDC),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
          border: Border.all(width: 1, color: PublicColor.borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            item['img'],
            fit: BoxFit.cover,
            width: ScreenUtil().setWidth(130),
            height: ScreenUtil().setWidth(97),
          ),
          SizedBox(height: ScreenUtil().setWidth(11)),
          Text(
            item['name'],
            style: TextStyle(fontSize: ScreenUtil().setWidth(28)),
          ),
          SizedBox(height: ScreenUtil().setWidth(11)),
          Text(item['num'].toString(),
              style: TextStyle(
                  color: PublicColor.themeColor,
                  fontSize: ScreenUtil().setWidth(28)))
        ],
      ),
    );
  }
}
