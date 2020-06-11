import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/loading.dart';
import '../../widgets/checkbox.dart';
import '../../widgets/cached_image.dart';
import '../../widgets/dialog.dart';
import '../../utils/toast_util.dart';
import '../../routers/Navigator_util.dart';
import '../../common/color.dart';
import '../../service/store_service.dart';

class ShoppingCart extends StatefulWidget {
  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCart>
    with SingleTickerProviderStateMixin {
  bool isloading = false;
  bool isbianji = true;
  String jwt = '';
  List cars = [];
  List buy = [];
  List listview = [
    {
      'list':[]
    }
  ];
 

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  void deactivate() {
    //刷新页面
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      getList();
    }
  }

  void getList() async {
    cars = [];
    Map<String, dynamic> map = Map();
    StoreServer().shopCar(map, (success) async {
      var list = success['list'];
      for (var i = 0; i < list.length; i++) {
        list[i]['check'] = false;
      }
      setState(() {
        listview[0]['list'] = list;
      });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  //修改购物车数量
  void changeNumCar(type, id, nums, item) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cart_id", () => id);
    map.putIfAbsent("num", () => nums);

    StoreServer().changeCartNum(map, (success) async {
      if (type == "1") {
        setState(() {
          item['num'] = item['num'] - 1;
          _getallamount();
        });
      } else {
        setState(() {
          item['num'] = item['num'] + 1;
          if (item['num'] > 99) {
            item['num'] = '99+';
          }
          _getallamount();
        });
      }
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }


  //删除购物车
  void delCart() async {
    setState(() {
      isloading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("cart_id", () => cars);

    StoreServer().delCart(map, (success) async {
      setState(() {
        isloading = false;
      });
      getList();
      for (var i = 0; i < listview.length; i++) {
        for (var j = 0; j < listview[i]['list'].length; j++) {
          listview[i]['list'][j]['check'] = false;
        }
      }
    }, (onFail) async {
      setState(() {
        isloading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

 @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('购物车',
              style: TextStyle(
                  color: PublicColor.headerTextColor,
                  fontSize: ScreenUtil.instance.setWidth(30.0))),
          backgroundColor: PublicColor.themeColor,
          actions: <Widget>[
            MaterialButton(
                child: Text(isbianji ? '编辑' : '完成',
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: ScreenUtil.instance.setWidth(30.0))),
                onPressed: () {
                  setState(() {
                    isbianji = !isbianji;
                  });
                }),
          ],
        ),
        body: contentWidget());
  }

  _checkCart(bool isCheck, int listindex, int index) {
    print(listview[0]['list'][index]['check']);
    print(isCheck);
    setState(() {
      listview[0]['list'][index]['check'] = isCheck;
    });
  }

  //删除
  _getItemId() async {
    cars = [];
    int index = 0;
    int leng = 0;
    for (var i = 0; i < listview.length; i++) {
      for (var j = 0; j < listview[i]['list'].length; j++) {
        leng++;
        if (listview[i]['list'][j]['check']) {
          var id = listview[i]['list'][j]['cart_id'];
          cars.add(id);
        } else {
          index++;
        }
      }
    }
    if (index == leng) {
      ToastUtil.showToast('请选择商品');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return MyDialog(
              width: ScreenUtil.instance.setWidth(600.0),
              height: ScreenUtil.instance.setWidth(300.0),
              queding: () async {
                Navigator.of(context).pop();
                delCart();
              },
              quxiao: () {
                Navigator.of(context).pop();
              },
              title: '温馨提示',
              message: '确定删除该商品吗？');
        });
  }

//结算
  _getjiesuan() async {
    List list = listview;
    int k = 0;
    int n = 0;
    for (var i = 0; i < list.length; i++) {
      for (var j = 0; j < list[i]['list'].length; j++) {
        n++;
        if (list[i]['list'][j]['check'] == false) {
          k++;
        }
      }
    }
    if (n == k) {
      ToastUtil.showToast('请选择商品');
    } else {
      for (var i = 0; i < list.length; i++) {
        list[i]['list'].removeWhere((item) => item['check'] == false);
      }
      list.removeWhere((item) => item['list'].length == 0);
      Map obj = {"list": list};
     
      NavigatorUtils.toTijiaoDingdan(context, obj);
    }
  }

  _getallamount() {
    double amount = 0;
      for (var j = 0; j < listview[0]['list'].length; j++) {
        if (listview[0]['list'][j]['check']) {
          int shuliang = int.parse(listview[0]['list'][j]['num'].toString());
          double price = double.parse(listview[0]['list'][j]['price'].toString());
          amount += price * shuliang;
        }
      }
    return amount;
  }

  bool _checkedAllbyindex(int index) {
    var list = listview[index]['list'];
    for (var i = 0; i < list.length; i++) {
      if (list[i]['check'] == null || !list[i]['check']) {
        return false;
      }
    }
    return true;
  }

  bool _checkedAll() {
    for (var i = 0; i < listview.length; i++) {
      var list = listview[i]['list'];
      for (var j = 0; j < list.length; j++) {
        if (list[j]['check'] == null || !list[j]['check']) {
          return false;
        }
      }
    }
    return true;
  }

  _checkedAllitem(bool isCheck) {
    for (var i = 0; i < listview.length; i++) {
      var list = listview[i]['list'];
      for (var j = 0; j < list.length; j++) {
        listview[i]['list'][j]['check'] = isCheck;
      }
    }
  }

  _checkedAllitembyindex(bool isCheck, int index) {
    var list = listview[index]['list'];
    for (var j = 0; j < list.length; j++) {
      listview[index]['list'][j]['check'] = isCheck;
    }
  }

  List<Widget> listBoxs(listView, check, listindex) =>
      List.generate(listView.length, (index) {
        return Container(
          width: ScreenUtil.instance.setWidth(700),
          height: ScreenUtil.instance.setWidth(245),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: Border(
              top: BorderSide(color: Color(0xfffececec), width: 1),
            ),
          ),
          child: new Row(
            children: <Widget>[
              RoundCheckBox(
                  value: check[index]['check'],
                  onChanged: (bool) {
                    _checkCart(bool, listindex, index);
                  }),
              Container(
                child: InkWell(
                  onTap: () {
                    String shipId = listView[index]['ship_id'].toString();
                    String roomId = listView[index]['room_id'].toString();
                    String id = listView[index]['goods_id'];
                    NavigatorUtils.goXiangQing(context, id, shipId, roomId);
                  },
                  child: CachedImageView(
                      ScreenUtil.instance.setWidth(204.0),
                      ScreenUtil.instance.setWidth(204.0),
                      listView[index]['thumb'],
                      null,
                      BorderRadius.all(Radius.circular(0))),
                ),
              ),
              new SizedBox(width: ScreenUtil.instance.setWidth(20.0)),
              Container(
                width: ScreenUtil.instance.setWidth(380.0),
                height: ScreenUtil.instance.setWidth(204.0),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text(
                        listView[index]['name'].toString(),
                        style: TextStyle(
                          color: Color(0xfff9f9c9c),
                          fontSize: ScreenUtil.instance.setWidth(24.0),
                        ),
                      ),
                       new SizedBox(height: ScreenUtil.instance.setWidth(60.0)),
                      new Row(children: [
                        Container(
                          width: ScreenUtil.instance.setWidth(210.0),
                          height: ScreenUtil.instance.setWidth(75.0),
                          alignment: Alignment.bottomLeft,
                          child: RichText(
                            text: TextSpan(
                                text: '￥' +
                                    listView[index]['price'].toString() +
                                    ' ',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize:
                                        ScreenUtil.instance.setWidth(27.0)),
                                ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top:20),
                          width: ScreenUtil.instance.setWidth(150.0),
                          height: ScreenUtil.instance.setWidth(50.0),
                          alignment: Alignment.bottomRight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
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
                                  if (listView[index]['num'] <= 1) {
                                    return;
                                  }
                                  changeNumCar(
                                    "1",
                                    listView[index]['cart_id'],
                                    listView[index]['num'] - 1,
                                    listView[index],
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  child:
                                      Text(listView[index]['num'].toString()),
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
                                    ), // 边色与��宽度
                                  ),
                                  child: Text('+'),
                                ),
                                onTap: () {
                                  changeNumCar(
                                    "2",
                                    listView[index]['cart_id'],
                                    listView[index]['num'] + 1,
                                    listView[index],
                                  );
                                },
                              ),
                            ),
                          ]),
                        )
                      ])
                    ]),
              )
            ],
          ),
        );
      });

  Widget gouwuitem(BuildContext context, item, index) {
    return Container(
      child: new Column(children: [
        new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            border: new Border.all(color: Color(0xfffececec), width: 0.5),
          ),
          child: Column(children: [
            Container(
              height: ScreenUtil.getInstance().setWidth(80.0),
              child: Row(children: [
                RoundCheckBox(
                    value: _checkedAllbyindex(index),
                    onChanged: (bool) {
                      setState(() {
                        _checkedAllitembyindex(bool, index);
                      });
                    }),
                new SizedBox(width: ScreenUtil.instance.setWidth(5.0)),
                Text(
                  '全选',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(28.0)),
                )
              ]),
            ),
            new Column(
                children:
                    listBoxs(item['list'], listview[index]['list'], index))
          ]),
        ),
      ]),
    );
  }

  Widget contentWidget() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          width: ScreenUtil.getInstance().setWidth(700.0),
          margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(110)),
          child: ListView.builder(
              itemCount: listview.length,
              itemBuilder: (BuildContext context, int index) {
                return gouwuitem(context, listview[index], index);
              }),
        ),
        Container(
          height: ScreenUtil.instance.setWidth(100.0),
          decoration: ShapeDecoration(
              shape: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
              color: Colors.white),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            RoundCheckBox(
                value: _checkedAll(),
                onChanged: (bool) {
                  setState(() {
                    _checkedAllitem(bool);
                  });
                }),
            Container(
              width: ScreenUtil.getInstance().setWidth(200.0),
              child: RichText(
                text: TextSpan(
                    text: isbianji ? '合计' : '',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: ScreenUtil.instance.setWidth(30.0)),
                    children: [
                      TextSpan(
                          text: isbianji
                              ? "￥${_getallamount().toStringAsFixed(2)}"
                              : '',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: ScreenUtil.instance.setWidth(30.0),
                              fontWeight: FontWeight.w700)),
                    ]),
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.centerRight,
              height: ScreenUtil.instance.setWidth(100.0),
              child: MaterialButton(
                height: ScreenUtil.instance.setWidth(100.0),
                minWidth: ScreenUtil.instance.setWidth(245.0),
                onPressed: () {
                  isbianji ? _getjiesuan() : _getItemId();
                },
                color: PublicColor.themeColor,
                child: Text(
                  isbianji ? '结算' : '删除',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.instance.setWidth(30.0)),
                ),
              ),
            ))
          ]),
        ),
        isloading ? LoadingDialog() : Container()
      ],
    );
  }
}

