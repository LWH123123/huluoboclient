import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import '../../service/goods_service.dart';
import '../../utils/toast_util.dart';
import '../../widgets/loading.dart';

class FukuanWidget extends StatefulWidget {
  final double total;
  final String aid;
  final String jwt;
  final List cartId;
  final String balance;
  final String isbalance;
  final List listview;
  final Function startTimer;
  final Function popContent;
  FukuanWidget({
    this.total,
    this.jwt,
    this.aid,
    this.cartId,
    this.balance,
    this.isbalance,
    this.listview,
    this.startTimer,
    this.popContent,
  });
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<FukuanWidget> {
  int groupValue = 1;
  bool isloading = false;
  String orderId = '';
  String open = "1";
  @override
  void initState() {
    super.initState();
    // 监听 支付回调
    fluwx.responseFromPayment.listen((res) {
      print("pay============== :${res.errCode}");
      if (res.errCode == 0) {
        widget.startTimer(orderId);
      } else {
        if (open == "1") {
          open = "2";
          ToastUtil.showToast('支付失败,请重试');
          widget.popContent();
        }
      }
    });
  }

  void payOrder() async {
    // setState(() {
    //   isloading = true;
    // });
    // Map<String, dynamic> map = Map();
    
    // map.putIfAbsent("aid", () => widget.aid);
    // map.putIfAbsent("pay_state", () => 1);
    // map.putIfAbsent("cart", () => widget.cartId);
    // map.putIfAbsent("balance", () => widget.balance);
    // map.putIfAbsent("amount", () => widget.total);
    // map.putIfAbsent("is_balance", () => widget.isbalance);
    // map.putIfAbsent("list", () => widget.listview);
    // GoodsServer().payOrder(map, (success) async {
    //   setState(() {
    //     isloading = false;
    //   });
    //   Navigator.pop(context);
    //   fluwx.payWithWeChat(
    //     appId: success['res']['appid'],
    //     partnerId: success['res']['partnerid'],
    //     prepayId: success['res']['prepayid'],
    //     packageValue: success['res']['package'],
    //     nonceStr: success['res']['noncestr'],
    //     timeStamp: success['res']['timestamp'],
    //     sign: success['res']['sign'],
    //   );
    //   orderId = success['res']['order_id'].toString();
    // }, (onFail) async {
    //   setState(() {
    //     isloading = false;
    //   });
    //   ToastUtil.showToast(onFail);
    // });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil.instance.setWidth(450.0),
          child: Column(
            children: [
              new SizedBox(height: ScreenUtil.instance.setWidth(25.0)),
              Row(children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                    child: Text('请选择付款方式',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                            color: Colors.black)),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                    child: InkWell(
                      child: Image.asset(
                        'assets/index/gb.png',
                        width: ScreenUtil.instance.setWidth(40.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
              ]),
              new SizedBox(height: ScreenUtil.instance.setWidth(25.0)),
              new Container(
                height: ScreenUtil.instance.setWidth(2.0),
                color: Color(0xfffececec),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(15.0)),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Text('实付金额:${widget.total}',
                    style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(28.0),
                        color: Colors.black54)),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(35.0)),
              Container(
                padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(25),
                    left: ScreenUtil().setWidth(25)),
                child: Row(children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Image.asset(
                          'assets/index/wxzf.png',
                          width: ScreenUtil.instance.setWidth(75.0),
                        ),
                        new SizedBox(width: ScreenUtil.instance.setWidth(30.0)),
                        Text('微信支付',
                            style: TextStyle(
                                fontSize: ScreenUtil.instance.setWidth(28.0),
                                color: Colors.black))
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Radio(
                          value: 1,
                          groupValue: this.groupValue,
                          activeColor: PublicColor.themeColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (v) {
                            setState(() {
                              this.groupValue = v;
                            });
                          }),
                    ),
                  ),
                ]),
              ),
              new SizedBox(height: ScreenUtil.instance.setWidth(40.0)),
              Center(
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: ScreenUtil.instance.setWidth(95.0),
                    width: ScreenUtil.instance.setWidth(640.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: PublicColor.themeColor,
                    ),
                    child: Text(
                      '去付款',
                      style: TextStyle(
                        fontSize: ScreenUtil.instance.setWidth(30.0),
                        color: PublicColor.btnColor,
                      ),
                    ),
                  ),
                  onTap: () {
                    // NavigatorUtils.toYifukuanPage(context);
                    payOrder();
                  },
                ),
              )
            ],
          ),
        ),
        isloading
            ? LoadingDialog()
            : Container(
                height: ScreenUtil().setHeight(0),
              ),
      ],
    );
  }
}
