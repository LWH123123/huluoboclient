import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoodsLive extends StatefulWidget {
  @override
  _GoodsLiveState createState() => _GoodsLiveState();
}

class _GoodsLiveState extends State<GoodsLive>  with SingleTickerProviderStateMixin{
  EasyRefreshController _controller = EasyRefreshController();
  TabController _tabController;
  int _tabIndex = 0,page = 1;
  List shop = [];
  List goods = [];

  getBringInfo () {
    LiveServer().getBringInfo({
      "type": _tabIndex + 1
    }, (onSuccess) {
      if(onSuccess['list'].length == 0) return ToastUtil.showToast('已获取全部数据');
      setState(() {
        _tabIndex == 1 ? goods.addAll(onSuccess['list']) : shop.addAll(onSuccess['list']);
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  getDelChoose (id) {
    LiveServer().getDelChoose({
      "id": id
    }, (onSuccess) {
      requestList();
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  requestList(){
    setState(() {
      page = 1;
      shop = [];
      goods = [];
      this.getBringInfo();
    });
  }

  indexset() {
    shop = [];
    goods = [];
    _tabIndex = _tabController.index;
    _tabController.index == _tabController.animation.value.toInt() ? this.requestList() : '';
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() => indexset());
    this.requestList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
            title: Text('直播带货'),
            actions: <Widget>[
              Container(
                padding: StyleUtil.padding(right: 10),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      _tabIndex == 0 ? NavigatorUtils.goliveAddStore(context).then((res) => this.requestList()) :
                      NavigatorUtils.goLiveAddGoods(context).then((res) => this.requestList());
                    },
                    child: Text(_tabIndex == 0 ? '新增店铺' : '新增商品'),
                  ),
                ),
              )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: StyleUtil.borderBottom())),
              child: TabBar(
                controller: _tabController,
                indicatorWeight: 2,
                labelColor: PublicColor.themeColor,
                unselectedLabelColor: PublicColor.textColor,
                indicatorColor: PublicColor.themeColor,
                labelStyle: TextStyle(fontSize: StyleUtil.fontSize(30)),
                tabs: <Widget>[
                  Container(
                    height: StyleUtil.width(93),
                    child: Center(
                      child: Text('店铺'),
                    ),
                  ),
                  Container(
                    height: StyleUtil.width(93),
                    child: Center(
                      child: Text('商品'),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: StyleUtil.width(10)),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  EasyRefresh(
                    controller: _controller,
                    header: BezierCircleHeader(
                      backgroundColor: PublicColor.themeColor,
                    ),
                    enableControlFinishRefresh: true,
                    child: ListView(
                      children: shop.map((item) => shopView(item)).toList(),
                    ),
                    onRefresh: () async {
                      setState(() {
                        this.requestList();
                      });
                    }
                  ),
                  EasyRefresh(
                      controller: _controller,
                      header: BezierCircleHeader(
                        backgroundColor: PublicColor.themeColor,
                      ),
                      enableControlFinishRefresh: true,
                      child: ListView(
                        children: goods.map((item) => goodsView(item)).toList(),
                      ),
                      onRefresh: () async {
                        setState(() {
                          this.requestList();
                        });
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shopView(item) {
    return Container(
      padding: StyleUtil.paddingTow(left: 28, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: StyleUtil.borderBottom())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    item['img'],
                    fit: BoxFit.cover,
                    width: StyleUtil.width(107),
                    height: StyleUtil.width(107),
                  ),
                ),
                SizedBox(width: StyleUtil.width(21)),
                Text(
                  item['name'],
                  style: TextStyle(
                      color: PublicColor.textColor,
                      fontSize: StyleUtil.fontSize(30)),
                )
              ],
            ),
          ),
          Container(
            width: StyleUtil.width(123),
            height: StyleUtil.width(46),
            child: OutlineButton(
                shape: StadiumBorder(),
                borderSide: BorderSide(color: PublicColor.themeColor),
                child: Text('删除', style: StyleUtil.tontStyle()),
                onPressed: () {
                  getDelChoose(item['id']);
                }),
          )
        ],
      ),
    );
  }

  Widget goodsView(item) {
    return Container(
      padding: StyleUtil.paddingTow(left: 28, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: StyleUtil.borderBottom())),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: new Image.network(
              item['img'],
              fit: BoxFit.cover,
              width: StyleUtil.width(203),
              height: StyleUtil.width(203),
            ),
          ),
          SizedBox(width: StyleUtil.width(15)),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: PublicColor.textColor,
                        fontSize: StyleUtil.fontSize(28)
                    ),
                  ),
                  SizedBox(height: StyleUtil.width(71)),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            '￥${item['price']}',
                          style: TextStyle(
                            color: PublicColor.textColor,
                            fontSize: StyleUtil.fontSize(33),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          width: StyleUtil.width(123),
                          height: StyleUtil.width(46),
                          child: OutlineButton(
                              shape: StadiumBorder(),
                              borderSide: BorderSide(color: PublicColor.themeColor),
                              child: Text('删除', style: StyleUtil.tontStyle()),
                              onPressed: () {
                                getDelChoose(item['id']);
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
