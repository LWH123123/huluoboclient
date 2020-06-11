import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/color.dart';
import '../../utils/toast_util.dart';
import '../../service/live_service.dart';
import '../../widgets/loading.dart';
import '../../common/Global.dart';

class ZbGoods extends StatefulWidget {
  final roomId;
  ZbGoods({
    this.roomId,
  });
  @override
  ZbGoodsState createState() => ZbGoodsState();
}

class ZbGoodsState extends State<ZbGoods> {
  int status = 0;
  int type = 1;
  List goodsList = [];
  String goodsId = "0";
  bool isLoading = false;
  @override
  void initState() {
    getGoodsList();
    super.initState();
  }

  void getGoodsList() {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("room_id", () => widget.roomId);
    LiveServer().getLiveGoods(map, (success) async {
      setState(() {
        isLoading = false;
        goodsList = success['list'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void optGoods(index) {
    setState(() {
      isLoading = true;
    });
    List goods = [];
    goods.add(goodsId);
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => status);
    map.putIfAbsent("room_id", () => widget.roomId);
    map.putIfAbsent("goods_ids", () => goods);
    LiveServer().goodsDo(map, (success) async {
      setState(() {
        isLoading = false;
        if (status == 1) {
          ToastUtil.showToast('上架成功');
        } else {
          ToastUtil.showToast('下架成功');
        }
      });
      getGoodsList();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  Widget contentWidget() {
    List<Widget> arr = <Widget>[];
    if (goodsList.length != 0) {
      for (var i = 0; i < goodsList.length; i++) {
        arr.add(
          new InkWell(
            child: new Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
              child: new Row(children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(202),
                  child: Stack(children: <Widget>[
                    Positioned(
                      child: Container(
                        child: Image.network(
                          goodsList[i]['thumb'],
                          height: ScreenUtil().setWidth(202),
                          width: ScreenUtil().setWidth(202),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(35),
                        width: ScreenUtil().setWidth(65),
                        decoration: BoxDecoration(
                          color: Color(0xff666666),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                        ),
                        child: Text(
                          Global.addNums(i + 1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28),
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: ScreenUtil().setWidth(202),
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                goodsList[i]['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(28),
                                ),
                              )),
                          Container(
                            child: new Row(children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: RichText(
                                  text: TextSpan(
                                    text: '￥',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            ScreenUtil.instance.setWidth(26)),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '${goodsList[i]['now_price']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: ScreenUtil.instance
                                                  .setWidth(30))),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: InkWell(
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setWidth(56),
                                      width: ScreenUtil().setWidth(142),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: PublicColor.themeColor,
                                              width: 0.5)),
                                      child: Text(
                                        goodsList[i]['isup'] == 1
                                            ? '立即下架'
                                            : '立即上架',
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(28),
                                          color: PublicColor.themeColor,
                                        ),
                                      )),
                                  onTap: () {
                                    goodsId = goodsList[i]['id'].toString();
                                    optGoods(i);
                                  },
                                ),
                              )
                            ]),
                          )
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        );
      }
    }

    return Container(child: ListView(children: arr));
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
                  setState(() {
                    type = value == 0 ? 1 : 0;
                    status = value;
                  });
                  getGoodsList();
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
                      '上架中',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  new Tab(
                    child: Text(
                      '已下架',
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
