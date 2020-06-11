import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class GoodsServer {

  // //推荐商品列表
  // Future getRecommentList(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.RECOMMEND_LIST_URL,
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //商品详情
  // Future getGoodsDetails(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.GOODS_DETAIL_URL,
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //订单信息
  // Future getOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jwt = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.post(
  //       Api.GET_ORDER_URL + '?jwt=$jwt',
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //提交订单
  // Future payOrder(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jwt = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.post(
  //       Api.PAY_ORDER_URL + '?jwt=$jwt',
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //购物车列表
  // Future addCart(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.ADD_CART_URL,
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //购物车列表
  // Future getCartList(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.CART_LIST_URL,
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //购物车列表
  // Future changeCartNum(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.CART_CHANGE_URL,
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // //购物车删除
  // Future delCart(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String jwt = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.post(
  //       Api.CART_DEL_URL + '?jwt=$jwt',
  //       parameters: parameters,
  //     );
  //     if (response['errcode'] == 0) {
  //       onSuccess(response);
  //     } else {
  //       onFail(response['errmsg']);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
