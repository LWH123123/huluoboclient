import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class VideoServer {

  // Future getViodeType(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.VIDEO_TYPE_RULE,
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

  // Future getViodeList(Map<String, dynamic> parameters, OnSuccess onSuccess,
  //     OnFail onFail) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   parameters['jwt'] = prefs.getString('jwt');
  //   try {
  //     var response = await HttpUtil.instance.get(
  //       Api.VIDEO_LIST_RULE,
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
