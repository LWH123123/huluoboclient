import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes {
  static String root = '/';
  static String text = '/text';
  static String login = '/login';
  static String captchaLogin = '/captchaLogin';
  static String register = '/register';
  static String tabs = '/tabs';
  static String rechargeCentre = '/rechargeCentre';
  static String rechargeRecord = '/rechargeRecord';
  static String retrievePassword = '/retrievePassword';
  static String perfectInformation = '/perfectInformation';
  static String interest = '/interest';
  static String search = '/search';//搜索
  static String curriculumDetail = '/curriculumDetail';//课程详情
  static String myCurriculum = '/myCurriculum';//  我的课程
  static String lecturer = '/lecturer';//  讲师主页
  static String lecturerCentre = '/lecturerCentre';//  讲师中心
  static String tuiguangcode ='/tuiguangcode'; //推广二维码
  static String buymember ='/buymember'; //购买VIP
  static String pastCourse = '/pastCourse';//  历史课程
  static String createCourse = '/createCourse'; // 创建课程
  static String appraise = '/appraise'; // 课程评价
  static String applyLive = '/applyLive'; // 申请直播
  static String createLive = '/createLive'; // 课程评价
  static String pastLive = '/pastLive'; // 历史直播
  static String presentPrice = '/presentPrice'; // 收礼价值
  static String secondScreen = '/secondScreen';// 分销
  static String setting = '/setting'; // 设置
  static String withdraw = '/withdraw'; // 提现
  static String brokerage = '/brokerage'; // 佣金明细
  static String myTeam = '/myTeam'; // 我的团队
  static String liveGoods = '/liveGoods'; // 直播带货
  static String allClassify = '/allClassify'; // 全部分类
   static String classification = '/classification'; // 职场课程
  static String liveAddGoods = '/liveAddGoods';//直播新增商品
  static String liveAddStore = '/liveAddStore';//直播新增店铺
  static String inviteQrCode = '/inviteQrCode';// 邀请二维码
  static String myOrder = '/myOrder';// 订单
  static String orderDetail = "/orderDetail";// 订单详情
  static String tijiaodingdan= "/tijiaodingdan";// 提交订单
  static String xiangqing= "/xiangqing"; // 商品详情
  static String shoppingCart= "/shoppingCart";// 购物车
  static String livePay= "/livePay";// 直播支付
  static String tipoff= "/tipoff";// 直播举报
  static String goodsList= "/goodsList";// 商品列表
  static String withdrawalRecord= "/withdrawalRecord";// 提现记录
  static String zujiScreen= "/zujiScreen";// 我的足迹 zujiScreen
  static String balance= "/balance"; // 余额
  static String integral= "/integral"; // 积分 integral
  static String slideLookZhibo= "/slideLookZhibo"; // 直播间 slideLookZhibo
  static String openZhibo = "/openZhibo";
  static String lookZhibo = "/lookZhibo";
  static String informationLivePage = "/informationLivePage";
  static String liveStore = "/liveStore";
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static void configureRoutes(Router router) {
    print(router);
    router.notFoundHandler = new Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("路由地址错误");
      return;
    });
    router.define(root, handler: loginInfoHanderl);
    // 测试跳转页面
    router.define(text, handler: textPageHanderl,transitionType: TransitionType.inFromRight);
    // 首页
    router.define(tabs, handler: tabsHanderl,transitionType: TransitionType.inFromRight);
    // 登录页
    router.define(login, handler: loginInfoHanderl,transitionType: TransitionType.inFromRight);
    // 找回密码
    router.define(retrievePassword, handler: retrievePasswordHanderl,transitionType: TransitionType.inFromRight);
    // 短信登录
    router.define(captchaLogin, handler: captchaLoginHanderl,transitionType: TransitionType.inFromRight);
    // 注册页
    router.define(register, handler: loginRegisterHanderl,transitionType: TransitionType.inFromRight);
    // 充值中心
    router.define(rechargeCentre, handler: rechargeCentreHanderl,transitionType: TransitionType.inFromRight);
    // 充值记录
    router.define(rechargeRecord, handler: rechargeRecordHanderl,transitionType: TransitionType.inFromRight);
    // 完善信息
    router.define(perfectInformation, handler: perfectInformationHanderl,transitionType: TransitionType.inFromRight);
    // 兴趣标签
    router.define(interest, handler: interestHanderl,transitionType: TransitionType.inFromRight);
    //搜索
    router.define(search, handler: searchHanderl,transitionType: TransitionType.inFromRight);
    //课程详情
    router.define(curriculumDetail, handler: curriculumDetailHanderl,transitionType: TransitionType.inFromRight);
    // 我的课程
    router.define(myCurriculum, handler: myCurriculumHanderl,transitionType: TransitionType.inFromRight);
    // 讲师主页
    router.define(lecturer, handler: lecturerHanderl,transitionType: TransitionType.inFromRight);
    // 申请讲师
    router.define(lecturerCentre, handler: lecturerCentreHanderl,transitionType: TransitionType.inFromRight);
    //推广二维码
    router.define(tuiguangcode,handler: tuiguangCodeHanderl,transitionType: TransitionType.inFromRight);
    //购买VIP
    router.define(buymember,handler: buymemberCourseHanderl,transitionType: TransitionType.inFromRight);
    // 创建课程
    router.define(createCourse, handler: createCourseHanderl,transitionType: TransitionType.inFromRight);
    // 历史课程
    router.define(pastCourse, handler: pastCourseHanderl,transitionType: TransitionType.inFromRight);
    // 课程评价
    router.define(appraise, handler: appraiseHanderl,transitionType: TransitionType.inFromRight);
    // 申请直播
    router.define(applyLive, handler: applyLiveHanderl,transitionType: TransitionType.inFromRight);
    // 创建直播
    router.define(createLive, handler: createLiveHanderl,transitionType: TransitionType.inFromRight);
    // 历史直播
    router.define(pastLive, handler: pastLiveHanderl,transitionType: TransitionType.inFromRight);
    // 收礼价值
    router.define(presentPrice, handler: presentPriceHanderl,transitionType: TransitionType.inFromRight);
    // 分销
    router.define(secondScreen, handler: secondScreenHanderl,transitionType: TransitionType.inFromRight);
    // 设置
    router.define(setting, handler: settingHanderl,transitionType: TransitionType.inFromRight);
    // 提现
    router.define(withdraw, handler: withdrawHanderl,transitionType: TransitionType.inFromRight);
    // 佣金明细
    router.define(brokerage, handler: brokerageHanderl,transitionType: TransitionType.inFromRight);
    // 我的团队
    router.define(myTeam, handler: myTeamHanderl,transitionType: TransitionType.inFromRight);
    // 直播带货
    router.define(liveGoods, handler: liveGoodsHanderl,transitionType: TransitionType.inFromRight);
    // 全部分类 allClassify
    router.define(allClassify, handler: allClassifyHanderl,transitionType: TransitionType.inFromRight);
    //职场课程
    router.define(classification, handler: classificationHanderl,transitionType: TransitionType.inFromRight);
    //直播新增商品
    router.define(liveAddGoods, handler: liveAddGoodsHanderl,transitionType: TransitionType.inFromRight);
    //直播新增店铺
    router.define(liveAddStore, handler: liveAddStoreHanderl,transitionType: TransitionType.inFromRight);
    // 邀请二维码
    router.define(inviteQrCode, handler: inviteQrCodeHanderl,transitionType: TransitionType.inFromRight);
    // 订单
    router.define(myOrder, handler: myOrderHanderl,transitionType: TransitionType.inFromRight);
    // 订单详情
    router.define(orderDetail, handler: orderDetailHanderl, transitionType: TransitionType.inFromRight);
    // 提交订单
    router.define(tijiaodingdan, handler: tijiaoDingdanHandler, transitionType: TransitionType.inFromRight);
    // 商品详情
    router.define(xiangqing, handler: xiangqingHandler, transitionType: TransitionType.inFromRight);
    // 购物车
    router.define(shoppingCart, handler: shoppingCartHanderl, transitionType: TransitionType.inFromRight);
    // 直播支付
    router.define(livePay, handler: livePayHanderl, transitionType: TransitionType.inFromRight);
    // 直播举报
    router.define(tipoff, handler: tipoffHandler, transitionType: TransitionType.inFromRight);
    // 商品列表
    router.define(goodsList, handler: goodsListHanderl, transitionType: TransitionType.inFromRight);
    // 提现记录
    router.define(withdrawalRecord, handler: withdrawalRecordHanderl, transitionType: TransitionType.inFromRight);
    // 我的足迹 zujiScreen
    router.define(zujiScreen, handler: zujiScreenHanderl, transitionType: TransitionType.inFromRight);

    // 余额 balance
    router.define(balance, handler: balanceHanderl, transitionType: TransitionType.inFromRight);
    // 积分 integral
    router.define(integral, handler: integralHanderl, transitionType: TransitionType.inFromRight);
    // 直播间 slideLookZhibo
    router.define(slideLookZhibo, handler: slideLookZhiboHandler, transitionType: TransitionType.inFromRight);
    router.define(openZhibo, handler:openZhiboHandler, transitionType: TransitionType.inFromRight);
    router.define(lookZhibo, handler:lookZhiboHandler, transitionType: TransitionType.inFromRight);
    router.define(informationLivePage, handler:informationLiveHandler, transitionType: TransitionType.inFromRight);
    router.define(liveStore, handler:liveStoreHandler, transitionType: TransitionType.inFromRight);
  }
}
