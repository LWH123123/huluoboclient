
import 'package:flutter/cupertino.dart';

 class PayLive extends StatefulWidget{
  @override
   PayLiveState createState() => PayLiveState();
}

class PayLiveState extends State<PayLive>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
/*  void getPayStatus(orderId) async {
    print('支付中..');
    StoreServer().pay_type({
      "order_id": orderId,
      "type": 1
    }, (success) async {
      setState(() {
        isLoading = false;
      });
      cancelTimer();
      ToastUtil.showToast('支付成功');
      await Future.delayed(Duration(seconds: 2), () {
        getBalance();
      });
    }, (onFail) async {
      print('支付回调接口--------------------${onFail.toString()}');
//      ToastUtil.showToast(onFail);
//      setState(() {
//        isLoading = false;
//      });
    });
  }

  payMoney() {
    var items = list.indexWhere((item) => (item['id'] == currentId));
    print('查找----$items');
    var money;
    items != -1 ? money = list[items]['name'] : ToastUtil.showToast('请选择支付金额');
    if (money == null) return;
    StoreServer().voucherPay({
      "amount": money
    }, (success) async {
      print(success);
      print(success['res']['appid']);
      fluwx.payWithWeChat(
        appId: success['res']['appid'],
        partnerId: success['res']['partnerid'],
        prepayId: success['res']['prepayid'],
        packageValue: success['res']['package'],
        nonceStr: success['res']['noncestr'],
        timeStamp: success['res']['timestamp'],
        sign: success['res']['sign'],
      );
      orderId = success['res']['order_id'].toString();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }*/


}