import 'package:client/pages/curriculum/all_classify.dart';
import 'package:client/pages/curriculum/appraise.dart';
import 'package:client/pages/curriculum/curriculum_th_detail.dart';
import 'package:client/pages/home/shoppingcart.dart';
import 'package:client/pages/home/xiangqing.dart';
import 'package:client/pages/live/apply_live.dart';
import 'package:client/pages/live/create_live.dart';
import 'package:client/pages/live/goods_list.dart';
import 'package:client/pages/live/goods_live.dart';
import 'package:client/pages/live/live_add_goods.dart';
import 'package:client/pages/live/live_add_store.dart';
import 'package:client/pages/live/live_goods.dart';
import 'package:client/pages/live/live_pay.dart';
import 'package:client/pages/live/slide_look_zhibo.dart';
import 'package:client/pages/live/tip_off.dart';
import 'package:client/pages/membercenter/MemberWebView.dart';
import 'package:client/pages/mine/fenxiao.dart';
import 'package:client/pages/mine/my_order.dart';
import 'package:client/pages/mine/order_detail.dart';
import 'package:client/pages/mine/teacher.dart';
import 'package:client/pages/mine/tijiaodingdan.dart';
import 'package:client/pages/mine/tuiguang.dart';
import 'package:client/pages/mine/buy_member.dart';
import 'package:client/pages/mine/zuji.dart';
import 'package:client/pages/my/balance.dart';
import 'package:client/pages/my/brokerage.dart';
import 'package:client/pages/my/create_course.dart';
import 'package:client/pages/my/integral.dart';
import 'package:client/pages/my/invite_qr_code.dart';
import 'package:client/pages/my/my_team.dart';
import 'package:client/pages/my/past_course.dart';
import 'package:client/pages/my/past_live.dart';
import 'package:client/pages/my/present_price.dart';
import 'package:client/pages/my/setting.dart';
import 'package:client/pages/my/withdraw.dart';
import 'package:client/pages/my/withdrawal_record.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/login_page/login.dart';
import '../pages/login_page/login_register.dart';
import '../pages/login_page/captcha_login.dart';
import '../pages/login_page/retrieve_password.dart';
import '../pages/tabs/tabs.dart';
import '../pages/recharge_centre/recharge_centre.dart';
import '../pages/recharge_record/rcecharge_record.dart';
import '../pages/text/text.dart';
import '../pages/login_page/perfect_information.dart';
import '../pages/login_page/interest.dart';
import '../pages/home_page/search.dart';
import '../pages/curriculum/curriculum_detail.dart';
import '../pages/mine/kecheng.dart';
import '../pages/curriculum/classification.dart';
import '../pages/live/open_zhibo.dart';
import '../pages/live/look_zhibo.dart';
import '../pages/live/informationLive.dart';
import '../pages/live/zhiboshop.dart';

// 测试跳转页面
Handler textPageHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        TextPage());
// 登录页
Handler loginInfoHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return new Login(type: '0');
});
// 短信登录
Handler captchaLoginHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        CaptchaLogin());
// 注册页
Handler loginRegisterHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        LoginRegister());
// 完善信息
Handler perfectInformationHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        PerfectInformation(id: params['id']?.first));
// 兴趣标签
Handler interestHanderl = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return Interest(objs: objs);
});

// Handler interestHanderl = Handler(
//     handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
//         Interest(information: params['information']?.first));
// 找回密码
Handler retrievePasswordHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        RetrievePassword());
// 首页
Handler tabsHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Tabs());
// 充值记录
Handler rechargeRecordHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        RcechargeRecord());
// 充值中心
Handler rechargeCentreHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        RechargeCentre());

// 搜索
Handler searchHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Search());

// 课程详情
Handler curriculumDetailHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return curriculumDetail(id: id);
});

// 我的课程
Handler myCurriculumHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        KechengScreen());

// 讲师主页
Handler lecturerHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return TeacherDetail(id: params['id']?.first);
});

// 申请讲师
Handler lecturerCentreHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        TeacherScreen());

//推广二维码
Handler tuiguangCodeHanderl = Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String type = params['id']?.first;
  return Tuiguang(type);
  });

//购买VIP
Handler buymemberCourseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Buymember());

// 创建课程
Handler createCourseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        CreateCourse());

// 历史课程
Handler pastCourseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        PastCourse());

// 课程评价
Handler appraiseHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Appraise(id: params['id']?.first));

// 申请直播
Handler applyLiveHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        ApplyLive());

// 创建直播
Handler createLiveHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        CreateLive());

// 历史直播
Handler pastLiveHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        PastLive());

// 收礼价值
Handler presentPriceHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        PresentPrice(id: params['id']?.first));

// 分销
Handler secondScreenHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        WebViewExample());//原生  SecondScreen()

// 设置
Handler settingHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Setting());

// 提现
Handler withdrawHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String nums = params['nums']?.first;
  return Withdraw(nums: nums);
});

// 佣金明细
Handler brokerageHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Brokerage());

// 我的团队
Handler myTeamHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        MyTeam());

// 直播带货
Handler liveGoodsHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        GoodsLive());

// 全部分类
Handler allClassifyHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return AllClassify(id);
});
//职场课程
Handler classificationHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return Classification(id: id);
});

//直播新增商品
Handler liveAddGoodsHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        LiveAddGoods());

//直播新增店铺
Handler liveAddStoreHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        LiveAddStore());

// 邀请二维码 inviteQrCode
Handler inviteQrCodeHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        InviteQrCode());

// 我的订单
Handler myOrderHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String type = params['type']?.first;
  return MyOrderPage(type);
});

// 订单详情
Handler orderDetailHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  return OrderDetailPage(id: id);
});

// 提交订单
Handler tijiaoDingdanHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return TijiaoDingdan(objs: objs);
});

// 商品详情
Handler xiangqingHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  String shipId = params['shipId']?.first;
  String roomId = params['roomId']?.first;
  return XiangQing(id: id, shipId: shipId, roomId: roomId);
});

// 购物车
Handler shoppingCartHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        ShoppingCart());

// 直播支付
var livePayHanderl = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String objs = params['objs']?.first;
  return LivePay(objs: objs);
});

// 直播举报
var tipoffHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return TipPage(oid: oid);
});

// 商品列表
Handler goodsListHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String id = params['id']?.first;
  String shipId = params['shipId']?.first;
  String roomId = params['roomId']?.first;
  return GoodsList(id: id, shipId: shipId, roomId: roomId);
});

// 提现记录 WithdrawalRecord
Handler withdrawalRecordHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        WithdrawalRecord());

// 我的足迹 zujiScreen
Handler zujiScreenHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        ZujiScreen());

// 余额
Handler balanceHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Balance());

// 积分
Handler integralHanderl = Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) =>
        Integral());

Handler openZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String lives = params['lives']?.first;
  return OpenZhibo(live: lives);
});

Handler lookZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String lives = params['lives']?.first;
  String url = params['url']?.first;
  return ZhiboPage(live: lives, url: url);
});

var informationLiveHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  return InformationLive(oid: params['oid']?.first, room_id: params['room_id']?.first);
});

var liveStoreHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String oid = params['oid']?.first;
  return LiveStore(oid: oid);
});

// 直播间 slideLookZhibo
var slideLookZhiboHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return SlideLookZhibo(room_id: params['room_id']?.first);
    });
