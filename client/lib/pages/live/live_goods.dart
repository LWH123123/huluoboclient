import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/color.dart';
import '../../widgets/loading.dart';
import '../../widgets/cached_image.dart';
import '../../service/live_service.dart';
import '../../utils/toast_util.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/cached_image.dart';
import '../../service/store_service.dart';

class LiveGoods extends StatefulWidget {
  final roomId;
  final shipId;
  LiveGoods({this.roomId, this.shipId});
  @override
  LiveGoodsState createState() => LiveGoodsState();
}

class LiveGoodsState extends State<LiveGoods> {
  bool isLoading = false;

  List shopList = [];
  List goodsList = [];
  @override
  void initState() {
    super.initState();
    getShopList();
    print(widget.roomId);
    getGoodsList();
  }

  //店铺
  void getShopList() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    LiveServer().getShop(map, (success) async {
      setState(() {
        isLoading = false;
        shopList = success['store'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }
  //商品
   void getGoodsList() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.roomId);
    LiveServer().getGoods(map, (success) async {
      setState(() {
        isLoading = false;
        goodsList = success['goods'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }
  
  //加入购物车
  void addShopCars(id) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("num", () => 1);
    map.putIfAbsent("goods_id", () => id);
    map.putIfAbsent("ship_id", () => widget.shipId);
    map.putIfAbsent("room_id", () => widget.roomId);
    StoreServer().addShopCar(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('加入购物车成功');
      Navigator.of(context).pop();
      //  widget.onChanged(-1);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

//店铺
  Widget shop() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (shopList.length == 0) {
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
      for (var item in shopList) {
        arr.add(
          Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
            child: new Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: CachedImageView(
                      ScreenUtil.instance.setWidth(110.0),
                      ScreenUtil.instance.setWidth(110.0),
                      item['img'],
                      null,
                      BorderRadius.all(Radius.circular(50.0))),
                ),
                Expanded(
                  flex: 2,
                  child: Text(item['name']),
                ),
                Container(
                    child: new InkWell(
                        onTap: () {
                          print('进店');
                          String id = item['id'].toString();
                          String roomId = widget.roomId;
                          String shipId = widget.shipId;
                          // print(id);
                          // print(roomId);
                          // print(shipId);
                          NavigatorUtils.goGoodsList(
                              context, id, roomId, shipId);
                        },
                        child: Container(
                          width: ScreenUtil.instance.setWidth(130.0),
                          height: ScreenUtil.instance.setWidth(50.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            color: PublicColor.themeColor,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '进店',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(28)),
                          ),
                        )))
              ],
            ),
          ),
        );
      }
    }
    content = new ListView(
      children: arr,
    );
    return content;
  }
//商品
  Widget commodity() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (goodsList.length == 0) {
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
      for (var item in goodsList) {
        arr.add(Container(
          padding: StyleUtil.paddingTow(left: 28, top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: StyleUtil.borderBottom())),
          child: Column(children: <Widget>[
            new InkWell(
              onTap: () {
                print('商品详情');
                String shipId = widget.shipId;
                String roomId = widget.roomId;
                String id = item['id'].toString();
                NavigatorUtils.goXiangQing(context, id, shipId, roomId);
              },
              child: new Container(
                child: Row(
                  children: <Widget>[
                    CachedImageView(
                        ScreenUtil.instance.setWidth(203.0),
                        ScreenUtil.instance.setWidth(203.0),
                        item['thumb'],
                        null,
                        BorderRadius.all(Radius.circular(15.0))),
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
                                  fontSize: StyleUtil.fontSize(28)),
                            ),
                            SizedBox(height: StyleUtil.width(71)),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '￥' + item['price'],
                                    style: TextStyle(
                                        color: PublicColor.textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: StyleUtil.fontSize(28)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(51.0),
                      height: ScreenUtil.instance.setWidth(51.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        color: PublicColor.themeColor,
                      ),
                      alignment: Alignment.center,
                     child: new InkWell(
                       onTap:(){
                         print('+++++');
                         addShopCars(item['id']);
                       },
                        child: Text(
                        '+',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(32)),
                      ),
                     ),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ));
      }
    }
    content = new ListView(
      children: arr,
    );
    return content;
  }

  Widget contentWidget() {
    return Container(
      child: new TabBarView(
        children: <Widget>[shop(), commodity()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return DefaultTabController(
      length: 2,
      //  initialIndex: int.parse(widget.type),
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: PublicColor.whiteColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Material(
              color: Colors.white,
              child: TabBar(
                onTap: (value) {
                  print(value);
                  if (value == 0) {
                    shop();
                  } else if (value == 1) {
                    commodity();
                  }
                },
                indicatorWeight: 4.0,
                labelPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: PublicColor.themeColor,
                unselectedLabelColor: Color(0xff5e5e5e),
                labelColor: PublicColor.themeColor,
                tabs: <Widget>[
                  new Tab(
                    child: Text(
                      '店铺',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  new Tab(
                    child: Text(
                      '商品',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.grey[100],
          child: isLoading ? LoadingDialog() : contentWidget(),
        ),
      ),
    );
  }
}
