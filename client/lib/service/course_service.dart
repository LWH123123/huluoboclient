import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class CourseService {

//课程列表
  Future getCourseList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.COURSE_INDEX_COURSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['course']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //课程分类
  Future getCourseType(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.COURSE_TYPE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['type']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //课程讲师列表
  Future getCourseTeacher(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.COURSE_INDEX_TEACHER,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['teacher']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //课程讲师列表
  Future getTeacherIndex(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.TEACHER_INDEX,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //收藏讲师
  Future getTeacherCollect(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.TEACHER_COLLECT,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //我的-我的课程
  Future getMyCourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.MY_COURSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['list']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //我的-创建课程
  Future getCreateCourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var response = await HttpUtil.instance.post(
        Api.CREATE_COURSE  + '?jwt=${prefs.getString('jwt')}',
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //我的-历史课程
  Future getHistoryCourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.HISTORY_COURSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['list']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //协议
  Future getAbout(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.ABOUT,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //课程评价
  Future getEvalCourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.EVAL_COURSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //购买课程
  Future getBuyCourse(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.BUY_COURSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //上传视频token
  Future getToken(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GET_TOKEN_RULE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //课程是否购买
  Future getCourseIspay(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.CLASS_ISPAY,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['teacher']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //浏览足迹
  Future getCourseLog(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.COURSE_LOG,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['teacher']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }



}