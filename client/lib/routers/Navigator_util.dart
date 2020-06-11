import 'package:flutter/material.dart';
import './application.dart';
import './routers.dart';
import 'fluro_convert_util.dart';
// clearStack: true, replace: true
class NavigatorUtils {
  static gologinPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.root, clearStack: true);
  }
  // 首页
  static goHomePage(BuildContext context, [String index]) {
    Application.router.navigateTo(context, Routes.tabs + "?index=$index", clearStack: true, replace: true);
  }
  // 验证码登陆
  static captchaLoginPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.captchaLogin);
  }
  // 注册
  static registerPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.register);
  }
  // 充值中心
  static rechargeCentrePage(BuildContext context) {
    return Application.router.navigateTo(context, Routes.rechargeCentre);
  }
  // 充值记录
  static rechargeRecordPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.rechargeRecord);
  }
 // 找回密码
  static goRetrievePasswordPage(BuildContext context) {
    Application.router.navigateTo(context, Routes.retrievePassword);
  }
  // 完善信息
  static perfectInformationPage(BuildContext context, [String id]) {
    Application.router.navigateTo(context, Routes.perfectInformation + '?id=$id');
  }
  // 兴趣标签页面
  static interestPage(BuildContext context, [Map obj]) {
     String objs = FluroConvertUtils.object2string(obj);
    Application.router.navigateTo(context, Routes.interest + '?objs=$objs');
  }
  //搜索
  static goSearch(BuildContext context) {
    Application.router.navigateTo(context, Routes.search);
  }

  //课程详情
  static goCurriculumDetail(BuildContext context,[String id]) {
    Application.router.navigateTo(context, Routes.curriculumDetail+ '?id=$id');
  }

  // 我的课程
  static goMyCurriculum(BuildContext context) {
    Application.router.navigateTo(context, Routes.myCurriculum);
  }

  // 讲师主页
  static goLecturer(BuildContext context, {String id}) {
    Application.router.navigateTo(context, Routes.lecturer + '?id=$id');
  }

  // 申请讲师
  static goLecturerCentre(BuildContext context) {
    return Application.router.navigateTo(context, Routes.lecturerCentre);
  }

  // 推广二维码
  static goPromoteCode(BuildContext context,String id) {
     Application.router.navigateTo(context, Routes.tuiguangcode + '?id=$id');
  }

  //购买VIP
  static goToBuyMember(BuildContext context){
    Application.router.navigateTo(context, Routes.buymember);
  }


  // 创建课程
  static goCreateCourse(BuildContext context) {
    return Application.router.navigateTo(context, Routes.createCourse);
  }

  // 历史课程
  static goPastCourse(BuildContext context,[bool boo = false]) {
    Application.router.navigateTo(context, Routes.pastCourse,replace:boo);
  }

  // 课程评价
  static goAppraise(BuildContext context, {String id}) {
    return Application.router.navigateTo(context, Routes.appraise + '?id=$id');
  }

  // 申请直播
  static goApplyLive(BuildContext context) {
    return Application.router.navigateTo(context, Routes.applyLive);
  }

  // 创建直播
  static goCreateLive(BuildContext context) {
    return Application.router.navigateTo(context, Routes.createLive);
  }

  // 历史直播
  static goPastLive(BuildContext context,[bool boo = false]) {
    Application.router.navigateTo(context, Routes.pastLive,replace:boo);
  }

  // 收礼价值
  static goPresentPrice(BuildContext context, {String id}) {
    Application.router.navigateTo(context, Routes.presentPrice + '?id=$id');
  }

  // 分销
  static goSecondScreen(BuildContext context) {
    Application.router.navigateTo(context, Routes.secondScreen);
  }

  // 设置
  static goSetting(BuildContext context) {
    return Application.router.navigateTo(context, Routes.setting);
  }

  // 佣金提现
  static goWithdraw(BuildContext context,[String nums]) {
   return Application.router.navigateTo(context, Routes.withdraw + '?nums=$nums');
  }

  // 佣金明细
  static goBrokerage(BuildContext context) {
    Application.router.navigateTo(context, Routes.brokerage);
  }
  // 我的团队
  static goMyTeam(BuildContext context) {
    Application.router.navigateTo(context, Routes.myTeam);
  }
  // 直播带货
  static goLiveGoods(BuildContext context) {
    Application.router.navigateTo(context, Routes.liveGoods);
  }

  // 全部分类
  static goAllClassify(BuildContext context) {
    Application.router.navigateTo(context, Routes.allClassify);
  }

  //职场课程 liveAddGoods
   static goClassification(BuildContext context,[String id]) {
    Application.router.navigateTo(context, Routes.classification+ '?id=$id');
  }

  //直播新增商品 liveAddGoods
  static goLiveAddGoods(BuildContext context) {
    return Application.router.navigateTo(context, Routes.liveAddGoods);
  }
  //直播新增店铺 liveAddStore
  static goliveAddStore(BuildContext context) {
    return Application.router.navigateTo(context, Routes.liveAddStore);
  }
  // 邀请二维码
  static goInviteQrCode(BuildContext context) {
    Application.router.navigateTo(context, Routes.inviteQrCode);
  }

  // 我的订单
  static goMyOrder(BuildContext context, String type, [int status]) {
    if (status == 1) {
      Application.router
          .navigateTo(context, Routes.myOrder + "?type=$type", replace: true);
    } else {
      Application.router.navigateTo(context, Routes.myOrder + "?type=$type");
    }
  }

  // 订单详情
 static toOrderDetail(BuildContext context, [String id,bool boo = false]) {
    Application.router.navigateTo(context, Routes.orderDetail + '?id=$id', replace: boo);
  }

  // 提交订单
  static toTijiaoDingdan(BuildContext context, [Map obj]) {
    String objs = FluroConvertUtils.object2string(obj);
    Application.router
        .navigateTo(context, Routes.tijiaodingdan + "?objs=$objs");
  }

  // 商品详情
  static goXiangQing(BuildContext context, [String id,String roomId,String shipId]) {
    Application.router
        .navigateTo(context, Routes.xiangqing + "?id=$id&roomId=$roomId&shipId=$shipId");
  }

  // 购物车
  static goShoppingCart(BuildContext context) {
    return Application.router.navigateTo(context, Routes.shoppingCart);
  }

  // 直播支付
  static goLivePay(BuildContext context, [Map obj,bool boo = false]) {
    String objs = FluroConvertUtils.object2string(obj);
    return Application.router.navigateTo(context, Routes.livePay + "?objs=$objs",replace: boo);
  }

  // 直播举报
static toTipoffPage(BuildContext context,oid) {
    Application.router.navigateTo(context, Routes.tipoff + "?oid=$oid");
  }

  // 商品列表goodsList
  static goGoodsList(BuildContext context,[String id,String roomId,String shipId]) {
    Application.router.navigateTo(context, Routes.goodsList + "?id=$id&roomId=$roomId&shipId=$shipId");
  }

  // 提现记录 withdrawalRecord
  static goWithdrawalRecord(BuildContext context,[bool boo = false]) {
    return Application.router.navigateTo(context, Routes.withdrawalRecord,replace: boo);
  }

  // 我的足迹 zujiScreen
  static goZujiScreen(BuildContext context) {
    Application.router.navigateTo(context, Routes.zujiScreen);
  }
  // 余额
  static goBalance(BuildContext context) {
    return Application.router.navigateTo(context, Routes.balance);
  }
  // 积分
  static goIntegral(BuildContext context) {
    return Application.router.navigateTo(context, Routes.integral);
  }

  static goOpenZhibo(BuildContext context, [Map live,bool boo = false]) {
    String lives = FluroConvertUtils.object2string(live);
    Application.router.navigateTo(context, Routes.openZhibo + "?lives=$lives",replace: boo);
  }

  static goLookZhibo(BuildContext context, [Map live, Map url,bool boo = false]) {
    String lives = FluroConvertUtils.object2string(live);
    String urls = FluroConvertUtils.object2string(url);
    Application.router
        .navigateTo(context, Routes.lookZhibo + "?lives=$lives&url=$urls",replace: boo);
  }

   static goInformationLivePage(BuildContext context, oid,{String room_id}) {
    Application.router.navigateTo(context, Routes.informationLivePage + "?oid=$oid&room_id=${room_id}");
  }

  static goLiveStore(BuildContext context, oid) {
    Application.router.navigateTo(context, Routes.liveStore + "?oid=$oid");
  }
// 直播间 slideLookZhibo
  static goSlideLookZhibo(BuildContext context,{String room_id, bool boo = false}) {
    Application.router.navigateTo(context, Routes.slideLookZhibo + "?room_id=$room_id",replace: boo);
  }
}




