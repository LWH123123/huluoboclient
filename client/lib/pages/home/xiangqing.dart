import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/loading.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
// import '../../widgets/swiper.dart';
import '../../widgets/cached_image.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/loading.dart';
import '../../service/store_service.dart';
import '../../utils/toast_util.dart';

class XiangQing extends StatefulWidget {
  final String id;
  final String shipId;
  final String roomId;
  XiangQing({this.id, this.shipId, this.roomId});
  @override
  XiangQingState createState() => XiangQingState();
}

// List guige = ['10个/包', '20个/包', '30个/包', '40个/包', '50个/包', '60个/包'];

int buynum = 1;
int checkindex = -1;
bool isLoading = false;
String headImg = '',
    title = '',
    fare = '',
    price = '',
    desc = '',
    stock = '',
    content = '';
String shipId = "";
String roomId = "";
String id = "";
String carNum = '';
int checkindex1 = -1;
class XiangQingState extends State<XiangQing>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  EasyRefreshController _controller = EasyRefreshController();

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      shopDetailsApi();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.finishRefresh();
    shopDetailsApi();
  }

  //获取详情
  void shopDetailsApi() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("id", () => widget.id);
    StoreServer().getShopDetails(map, (success) async {
      setState(() {
        isLoading = false;
      });
      headImg = success['goods']['thumb'];
      title = success['goods']['name'];
      fare = success['goods']['fare'];
      price = success['goods']['price'];
      desc = success['goods']['desc'];
      stock = success['goods']['stock'].toString();
      carNum = success['goods']['cart_num'].toString();
      content = success['goods']['content'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void buy(goods) async {
    Map obj = {
      "list": [
        {
          "list": [goods]
        }
      ]
    };
    NavigatorUtils.toTijiaoDingdan(context, obj);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          title: Text('宝贝详情'),
          backgroundColor: PublicColor.themeColor,
        ),
        body: contentWidget());
  }

  Widget contentWidget() {
    return isloading
        ? LoadingDialog()
        : Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    bottom: ScreenUtil.instance.setWidth(100.0)),
                color: Color(0xffff5f5f5),
                child: EasyRefresh(
                  controller: _controller,
                  header: BezierCircleHeader(
                    backgroundColor: Color(0xffE71419),
                  ),
                  footer: BezierBounceFooter(
                    backgroundColor: Color(0xffE71419),
                  ),
                  enableControlFinishRefresh: true,
                  enableControlFinishLoad: false,
                  // onRefresh: () async {
                  //   _controller.finishRefresh();
                  // },
                  // onLoad: () async {
                  //   _controller.finishRefresh();
                  // },
                  child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                    // SwiperView([
                    //   {
                    //     'img':
                    //         "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3386247472,87720242&fm=26&gp=0.jpg",
                    //   },
                    //   {
                    //     'img':
                    //         "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3922344982,423380743&fm=26&gp=0.jpg",
                    //   },
                    // ], 2, ScreenUtil.instance.setWidth(360.0)),
                    Container(
                      child: CachedImageView(
                        ScreenUtil.instance.setWidth(750.0),
                        ScreenUtil.instance.setWidth(360.0),
                        headImg,
                        null,
                        BorderRadius.all(
                          Radius.circular(0.0),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                      color: Colors.white,
                      child: new Row(
                        children: <Widget>[
                          Container(
                              child: Text(
                            '￥',
                            style: TextStyle(
                                color: Color(0xffE61414),
                                fontSize: ScreenUtil().setWidth(26),
                                fontWeight: FontWeight.w700),
                          )),
                          Expanded(
                              flex: 2,
                              child: Text(
                                price,
                                style: TextStyle(
                                    color: Color(0xffE61414),
                                    fontSize: ScreenUtil().setWidth(36),
                                    fontWeight: FontWeight.w700),
                              )),
                          Container(
                              child: Text(
                            '运费: ' + fare,
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: ScreenUtil().setWidth(28),
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: ScreenUtil().setWidth(25),
                          right: ScreenUtil().setWidth(25)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: Stack(children: [
                              Text(title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.instance.setWidth(30.0),
                                      color: Color(0xfff000000))),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(750),
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, bottom: 10),
                      child: new Column(children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(750),
                          alignment: Alignment.centerLeft,
                          child: Text('商品描述',
                              style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Color(0xfff999999))),
                        ),
                        Container(
                            width: ScreenUtil().setWidth(750),
                            alignment: Alignment.centerLeft,
                            child: Text(desc,
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.instance.setWidth(28.0),
                                    color: Color(0xfff999999))))
                      ]),
                    ),
                    new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
                    Container(
                      width: ScreenUtil.instance.setWidth(750.0),
                      height: ScreenUtil.instance.setWidth(100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil.instance.setWidth(135.0),
                            height: ScreenUtil.instance.setWidth(2.0),
                            color: Color(0xfff7a7a7a),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(15.0),
                            height: ScreenUtil.instance.setWidth(2.0),
                          ),
                          Text('宝贝信息',
                              style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(30),
                                  color: Color(0xfff7a7a7a))),
                          Container(
                            width: ScreenUtil.instance.setWidth(15.0),
                            height: ScreenUtil.instance.setWidth(2.0),
                          ),
                          Container(
                            width: ScreenUtil.instance.setWidth(135.0),
                            height: ScreenUtil.instance.setWidth(2.0),
                            color: Color(0xfff7a7a7a),
                          ),
                        ],
                      ),
                    ),
                    CachedImageView(
                        ScreenUtil.instance.setWidth(750.0),
                        ScreenUtil.instance.setWidth(495.0),
                        content,
                        null,
                        BorderRadius.all(Radius.circular(0))),
                  ])),
                ),
              ),
              Container(
                  height: ScreenUtil.instance.setWidth(100.0),
                  child: Row(children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        child: Container(
                          height: ScreenUtil.instance.setWidth(100.0),
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(children: [
                                Icon(
                                  Icons.local_grocery_store,
                                ),
                                Positioned(
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: ScreenUtil.instance.setWidth(25.0),
                                      height:
                                          ScreenUtil.instance.setWidth(25.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        color: Colors.red,
                                      ),
                                      child: Text(carNum,
                                          style: TextStyle(
                                            fontSize: ScreenUtil.instance
                                                .setWidth(18.0),
                                            color: Colors.white,
                                          )),
                                    ),
                                    right: 0,
                                    top: 0)
                              ]),
                              Text(
                                '购物车',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          print('购物车');

                          NavigatorUtils.goShoppingCart(context).then((res) => this.shopDetailsApi());
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          print('加入购物车');
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return GuigeWidget(
                                  onChanged: (index) {
                              if (index == -1) {
                                shopDetailsApi();
                              } else {
                                setState(() {
                                  checkindex1 = index;
                                });
                              }
                            },
                                  id: widget.id,
                                  shipId: widget.shipId,
                                  roomId: widget.roomId,
                                );
                              });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Color(0xffFF8B00),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '加入购物车',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          print('立即购买');
                          Map goods = {
                            'cart_id': 0,
                            'goods_id': widget.id,
                            'num': buynum,
                            'ship_id': widget.shipId,
                            'room_id': widget.roomId
                          };

                          print(goods);
                          buy(goods);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Color(0xffDC1515),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '立即购买',
                                style: TextStyle(
                                  fontSize: ScreenUtil.instance.setWidth(28.0),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]))
            ],
          );
  }
}

class GuigeWidget extends StatefulWidget {
  final Function(int) onChanged;
  final String id;
  final String roomId;
  final String shipId;
  GuigeWidget({
    Key key,
    this.onChanged,
    this.id,
    this.shipId,
    this.roomId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<GuigeWidget> {
  @override
  void initState() {
    super.initState();
  }

  //加入购物车
  void addShopCars(buynum) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("num", () => buynum);
    map.putIfAbsent("goods_id", () => widget.id);
    map.putIfAbsent("ship_id", () => widget.shipId);
    map.putIfAbsent("room_id", () => widget.roomId);
    StoreServer().addShopCar(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('加入购物车成功');
      Navigator.of(context).pop();
       widget.onChanged(-1);
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void buy(goods) async {
    Map obj = {
      "list": [
        {
          "list": [goods]
        }
      ]
    };
    Navigator.of(context).pop();
    NavigatorUtils.toTijiaoDingdan(context, obj);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      // height: ScreenUtil.instance.setWidth(1000.0),
      // color: Colors.pink,
      child: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(20), top: ScreenUtil().setWidth(15)),
          child: InkWell(
            child: Image.asset(
              'assets/mine/icon_guanbi.png',
              width: ScreenUtil.instance.setWidth(40.0),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(505.0),
          child: ListView(children: [
            Container(
              height: ScreenUtil.instance.setWidth(230.0),
              decoration: new ShapeDecoration(
                shape: Border(
                  bottom: BorderSide(color: Color(0xfffececec), width: 1),
                ), // 边色与边宽度
              ),
              padding: EdgeInsets.only(
                  right: ScreenUtil().setWidth(25),
                  left: ScreenUtil().setWidth(25)),
              child: Row(children: [
                CachedImageView(
                    ScreenUtil.instance.setWidth(195.0),
                    ScreenUtil.instance.setWidth(200.0),
                    headImg,
                    null,
                    BorderRadius.all(Radius.circular(0))),
                new SizedBox(width: ScreenUtil.instance.setWidth(10.0)),
                Container(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
                  child: Column(
                    children: <Widget>[
                      Text('￥' + price,
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil.instance.setWidth(27.0))),
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text('库存 ' + stock,
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: ScreenUtil.instance.setWidth(25.0))),
                    ],
                  ),
                )
              ]),
            ),
            new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text('购买数量',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0))),
                    ),
                    Container(
                      width: ScreenUtil.instance.setWidth(150.0),
                      height: ScreenUtil.instance.setWidth(50.0),
                      alignment: Alignment.bottomRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: new Border.all(
                            color: Color(0xfffcccccc), width: 0.5),
                      ),
                      child: Row(children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: new ShapeDecoration(
                                shape: Border(
                                  right: BorderSide(
                                      color: Color(0xfffececec), width: 1),
                                ), // 边色与边宽度
                              ),
                              child: Text('-'),
                            ),
                            onTap: () {
                              print('减');
                              if (buynum <= 1) {
                                return;
                              }
                              setState(() {
                                buynum = buynum - 1;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(buynum.toString()),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: new ShapeDecoration(
                                shape: Border(
                                  left: BorderSide(
                                      color: Color(0xfffececec), width: 1),
                                ), // 边色与边宽度
                              ),
                              child: Text('+'),
                            ),
                            onTap: () {
                              print('加');
                              setState(() {
                                buynum = buynum + 1;
                              });
                            },
                          ),
                        ),
                      ]),
                    )
                  ],
                ))
          ]),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(105.0),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil.instance.setWidth(90.0),
                      width: ScreenUtil.instance.setWidth(330.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border:
                            new Border.all(color: Color(0xffE71419), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text('加入购物车',
                          style: TextStyle(
                              color: Color(0xffE71419),
                              fontSize: ScreenUtil.instance.setWidth(27.0))),
                    ),
                    onTap: () {
                      print('加入购物车');
                      addShopCars(buynum);
                      setState(() {
                          buynum = 1;
                      });
                    },
                  ),
                )),
            Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
                  child: InkWell(
                    child: Container(
                      height: ScreenUtil.instance.setWidth(90.0),
                      width: ScreenUtil.instance.setWidth(330.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Color(0xffE71419)),
                      alignment: Alignment.center,
                      child: Text('立即购买',
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: ScreenUtil.instance.setWidth(27.0))),
                    ),
                    onTap: () {
                      print('立即购买');
                      print(widget.id);
                      Map goods = {
                        'cart_id': 0,
                        'goods_id': widget.id,
                        'num': buynum,
                        'ship_id': widget.shipId,
                        'room_id': widget.roomId
                      };

                      print(goods);
                      buy(goods);
                    },
                  ),
                ))
          ]),
        ),
      ]),
    );
  }
}
