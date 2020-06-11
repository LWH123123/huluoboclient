import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class HomeServer {
  //首页
  Future getHome(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
//    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.HOME_API,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //课程列表(首页分类二级页面)
  Future getClassApi(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CLASS_API,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //课程详情(首页推荐课程详情)
  Future getCourseDetailApi(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COURSE_DETAIL,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }
//课程收藏
  Future getCourseCollectionApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COURSE_COLLECTION,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //获取热词
  Future getKeywords(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GET_KEYWORDS,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['keywords']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //搜索热词
  Future getSearch(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.SEARCH,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['list']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //首页轮播
  Future getBanner(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.BANNER,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }
  
}
