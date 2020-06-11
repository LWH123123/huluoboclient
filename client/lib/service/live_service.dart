import '../utils/http_util.dart';
import '../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef OnSuccessList<T>(List<T> banners);

typedef OnSuccess<T>(T banners);

typedef OnFail( message);

class LiveServer {

  //直播分类
  Future getLiveType(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GETLIVETYPE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response["list"]) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //申请直播
  Future getApplyOpen(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.APPLYOPEN,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //创建直播
  Future getCreateLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var response = await HttpUtil.instance.post(
        Api.CREATELIVE + '?jwt=' + prefs.getString('jwt'),
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //直播带货
  Future getBringInfo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GET_BRING_INFO,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //删除选择的店铺或商品
  Future getDelChoose(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.DEL_CHOOSE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //获取所有店铺
  Future getAllStore(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GET_ALL_STORE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //获取所有商品
  Future getAllGoods(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GET_ALL_GOODS,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //选择店铺或商品
  Future getChooseBring(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.CHOOSE_BRING,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //历史直播
  Future getHistoryLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.HISTORY_LIVE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //删除历史直播
  Future getDelHistoryLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.DEL_HISTORY_LIVE,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //礼物价值
  Future getGiftLog(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.GIFT_LOG,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //直播列表
  Future getLiveList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      parameters['jwt'] = prefs.getString('jwt');
      var response = await HttpUtil.instance.get(
        Api.LIVE_LIST,
        parameters: parameters,
      );
      response['errcode'] == 0 ? onSuccess(response) : onFail(response['errmsg']);
    } catch (e) {
      print(e);
    }
  }

  //送礼列表
  Future theList(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_THE_LIST_RULE,
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

  //开始直播
  Future startLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.START_LIVE,
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

  //结束直播
  Future closeLive(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CLOSE_LIVE,
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

  Future inRoom(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_IN_ROOM_RULE,
        parameters: parameters,
      );
      if (response['errcode'] == 0) {
        onSuccess(response);
      } else {
        onFail(response);
      }
    } catch (e) {
      print(e);
    }
  }

  Future getLiveGoods(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_GOODS,
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

  Future goodsDo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.post(
        Api.LIVE_GOODS_DO + '?jwt=$jwt',
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

  Future getLiveGift(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_GIFT_RULE,
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

  // 发送礼物检查余额
  Future checkBalance(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHECK_BALANCE,
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

  // 充值列表
  Future getRecharge(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.RECHARGE,
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

  // 充值
  Future toRecharge(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.TO_RECHARGE,
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

  //直播店铺
   Future getShop(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ZHIBO_SHOP,
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

  //直播商品
   Future getGoods(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ZHIBO_GOODS,
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

  //直播间举报
  Future liveReport(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_REPORT_URL,
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

  //直播支付
  Future livePay(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_PAY,
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

  Future getHistory(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.VIDEO_HISTORY_URL,
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

  Future getLiveStore(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_STORE_RULE,
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

  //直播间禁言
  Future getJinyan(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.JINYAN_API,
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

  //拉黑
  Future getLahei(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LAHEI_API,
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

  //设置管理员
  Future getSetPerson(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.SET_PERSON,
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
  //检查是否禁言
  Future getCheckJy(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHECK_JY,
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

  //检查是否是管理员
  Future getCheckGly(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHECK_GLY,
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

  // 观看视频记录
  Future getCourseLook(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.COURSE_LOOK,
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

  // 观看视频记录
  Future getLiveLog(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.LIVE_LOG,
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

  // 拉黑时常
  Future getTimeAbout(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = 'admin123456!';
    try {
      var response = await HttpUtil.instance.get(
        Api.TIME_ABOUT,
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


  // 查询管理员状态
  Future getCheckadmin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.CHECKADMIN,
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

  // 解除管理员
  Future getDeladmin(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.DELADMIN,
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

  // 直播轮询
  Future getRedisUser(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.REDIS_USER,
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

  // 查询全部直播间ID
  Future getAllRoom(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.ALL_ROOM,
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

  // 关闭直播间
  Future getGuanbo(Map<String, dynamic> parameters, OnSuccess onSuccess,
      OnFail onFail) async {
    final prefs = await SharedPreferences.getInstance();
    parameters['jwt'] = prefs.getString('jwt');
    try {
      var response = await HttpUtil.instance.get(
        Api.GUANBO,
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
