import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail(String message);

class UserServer {

 //手机号短信登录
  Future getUserInfo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.CODE_LOGIN,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //手机号短信登录
  Future getPwdLogin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.PWD_LOGIN,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['data']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //注册
  Future getRegister(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.REGISTER,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']['user']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //兴趣图标列表
  Future getTagsList(OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.TAGS_LIST
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //保存用户信息
  Future getCreateUserInfo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.CREATE_USER_INFO,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //找回密码
  Future getForgetPassword(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.FORGETPASSWORD,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response['data']) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //我的
  Future getMyApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.MY_API,
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

  //余额
   Future getBalanceApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.BALANCE_API,
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

  //充值记录
  Future getChongzhiApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHONG_ZHI,
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

  //我的足迹
   Future getZujiApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.MY_TRACK,
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

  //设置
  Future getSetApi(Map<String, dynamic> parameters,
      OnSuccess onSuccess, OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SETTING_API,
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

  //上传图片
   Future uploadImg(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.post(
        Api.UPLOAD_API,
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

  //我的-申请讲师
  Future getApplylecturer(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.APPLYLECTURER,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //提现
   Future getTxApi(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.TX_API,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }
  
  //提现记录
  Future getTxRecord(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.TX_RECORD,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //佣金明细
  Future getYJRecord(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.YJ_RECORD,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //我的团队
   Future getMyTeam(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.MY_TEAM,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //微信登录
  Future wxLogin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.WECHAT_LOGIN,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  //发送短信
  Future getCode(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      var response = await HttpUtil.instance.get(
        Api.SEND_CODE,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  // 个人资料
  Future getPersonalData(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.PERSONAL_DATA,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response['data']);
      } else {
        onFail(response['errmsg']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getPayStatus(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.PAY_STATUS_URL,
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
}
