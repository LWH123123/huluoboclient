class Api {
  static const String BASE_URL = 'http://www.bjbskj66.com';

  //胡萝卜
  static const String CODE_LOGIN = BASE_URL + '/server/login/dxlogin'; //手机短信登录
  static const String REGISTER = BASE_URL + '/server/login/register'; //注册
  static const String HOME_API = BASE_URL + '/server/index/index'; //首页
  static const String TAGS_LIST = BASE_URL + '/server/login/tags_list'; //兴趣图标列表
  static const String CREATE_USER_INFO = BASE_URL + '/server/login/createuserinfo'; //保存用户信息
  static const String CLASS_API = BASE_URL + '/server/index/course_list';
  static const String PWD_LOGIN = BASE_URL + '/server/login/pwdlogin'; //手机密码登录
  static const String FORGETPASSWORD = BASE_URL + '/server/login/forgetpassword'; //找回密码
  static const String COURSE_INDEX_COURSE = BASE_URL + '/server/index/course_index_course'; //课程列表
  static const String COURSE_DETAIL = BASE_URL + '/server/index/course_detail'; //课程详情
  static const String COURSE_TYPE = BASE_URL + '/server/index/course_type'; //课程分类
  static const String COURSE_COLLECTION = BASE_URL + '/server/index/collect_course'; //课程收藏
  static const String COURSE_INDEX_TEACHER = BASE_URL + '/server/index/course_index_teacher'; //课程讲师列表
  static const String TEACHER_INDEX = BASE_URL + '/server/index/teacher_index'; //讲师主页
  static const String TEACHER_COLLECT = BASE_URL + '/server/index/teacher_collect'; //收藏讲师
  static const String MY_API = BASE_URL + '/server/per/index'; //我的
  static const String BALANCE_API = BASE_URL + '/server/per/balance';//余额
  static const String MY_TRACK = BASE_URL + '/server/per/my_track';//我的足迹
  static const String CHONG_ZHI = BASE_URL + '/server/per/balancelog';//充值记录
  static const String GET_KEYWORDS = BASE_URL + '/server/index/get_keywords';//获取热词
  static const String SEARCH = BASE_URL + '/server/index/search';//搜索热词
  static const String MY_COURSE = BASE_URL + '/server/per/my_course';//我的-我的课程
  static const String SETTING_API = BASE_URL + '/server/per/setuserinfo';//设置
  static const String UPLOAD_API = BASE_URL + '/server/img/upload';//上传图片
  static const String APPLYLECTURER = BASE_URL + '/server/per/applylecturer';//我的-申请讲师
  static const String CREATE_COURSE = BASE_URL + '/server/per/create_course';//我的-创建课程
  static const String HISTORY_COURSE = BASE_URL + '/server/per/history_course';//我的-历史课程
  static const String ABOUT = BASE_URL + '/server/per/about';//协议
  static const String GETLIVETYPE = BASE_URL + '/server/per/getlivetype';//直播分类
  static const String APPLYOPEN = BASE_URL + '/server/per/applyopen';//申请直播
  static const String GET_TOKEN_RULE=BASE_URL+'/server/video/gettoken';//获取token

  static const String CREATELIVE = BASE_URL + '/server/per/createlive';//创建直播
  static const String GET_BRING_INFO = BASE_URL + '/server/per/get_bring_info';//获取直播带货信息
  static const String DEL_CHOOSE = BASE_URL + '/server/per/del_choose';//删除选择的店铺或商品
  static const String GET_ALL_STORE = BASE_URL + '/server/per/get_all_store';//获取所有店铺
  static const String GET_ALL_GOODS = BASE_URL + '/server/per/get_all_goods';//获取所有商品
  static const String CHOOSE_BRING = BASE_URL + '/server/per/choose_bring';//选择店铺或商品
  static const String HISTORY_LIVE = BASE_URL + '/server/per/history_live';//历史直播
  static const String DEL_HISTORY_LIVE = BASE_URL + '/server/per/del_history_live';//删除历史直播
  static const String GIFT_LOG = BASE_URL + '/server/per/gift_log';//礼物价值
  static const String EVAL_COURSE = BASE_URL + '/server/index/eval_course';//课程评价
  static const String BUY_COURSE = BASE_URL + '/server/index/buy_course';//购买课程

  static const String ORDER_LIST = BASE_URL + '/server/per/order_list';//订单列表
  static const String CANCEL_ORDER = BASE_URL + '/server/per/exit_order';//取消订单
  static const String ORDER_DETAILS = BASE_URL + '/server/per/order_detail';//订单详情
  static const String CONFIRM_SH = BASE_URL + '/server/per/finish_order';//确认收货
  static const String TJ_ORDER = BASE_URL + '/server/per/pay_order';//我的订单(去付款)
  static const String SHOP_DETAILS= BASE_URL + '/server/goods/detail';//商品详情
  static const String ADD_SHOPCAR= BASE_URL + '/server/goods/add-cart';//加入购物车
  static const String SHOPCAR_LIST= BASE_URL + '/server/goods/cart_list';//购物车列表
  static const String CART_CHANGE_URL= BASE_URL + '/server/goods/save-cart';//修改购物车数量
  static const String CART_DEL_URL= BASE_URL + '/server/goods/del-cart';//删除购物车

  static const String TX_API= BASE_URL + '/server/per/cash';//提现
  static const String TX_RECORD= BASE_URL + '/server/per/cash_log';//提现记录
  static const String YJ_RECORD= BASE_URL + '/server/per/rake_back_log';//佣金明细
  static const String MY_TEAM= BASE_URL + '/server/per/my_team';//我的团队
  static const String GET_ORDER_URL= BASE_URL + '/server/goods/get-order';//订单信息
  static const String TJ_ORDER_URL = BASE_URL + '/server/goods/create-order';//提交订单
  static const String WECHAT_LOGIN = BASE_URL + '/server/login/wxlogin';//微信登录
  static const String SEND_CODE = BASE_URL + '/server/login/sendsms';//发送短信

  static const String LIVE_LIST = BASE_URL + '/server/live/index';//直播列表 首页轮播
  static const String BANNER = BASE_URL + '/server/live/banner';//直播轮播

  static const String LIVE_THE_LIST_RULE=BASE_URL+'/server/live/the-list';//送礼列表
  static const String PERSONAL_DATA=BASE_URL+'/server/login/loaduser';//个人资料
  static const String START_LIVE=BASE_URL+'/server/store/start-live';//开始直播推流
  static const String CLOSE_LIVE=BASE_URL+'/server/store/end-live';//结束直播推流
  static const String LIVE_IN_ROOM_RULE=BASE_URL+'/server/live/in-room';//进入直播房间,获取推流地址
  static const String LIVE_GOODS=BASE_URL+'/server/store/live-goods';//主播商品列表
  static const String LIVE_GOODS_DO=BASE_URL+'/server/store/live-goods-do';//主播商品上下架
  static const String LIVE_GIFT_RULE=BASE_URL+'/server/live/gift';//直播礼物列表
  static const String CHECK_BALANCE=BASE_URL+'/server/live/checkbalance';//发送礼物检查余额
  static const String PAY_STATUS_URL=BASE_URL+'/server/notify/pay';//支付轮询
  static const String RECHARGE=BASE_URL+'/server/live/recharge';//充值列表
  static const String TO_RECHARGE=BASE_URL+'/server/live/to-recharge';//充值
  static const String ZHIBO_SHOP = BASE_URL+'/server/live/shopbag_store';//直播店铺
  static const String SHOP_LIST = BASE_URL+'/server/goods/goods_list';//商品列表
  static const String ZHIBO_GOODS = BASE_URL+'/server/live/shopbag_goods';//直播商品
  static const String LIVE_REPORT_URL=BASE_URL+'/server/live/report';//直播间举报
  static const String LIVE_PAY=BASE_URL+'/server/live/livepay';//直播支付

  static const String TORECHARGE=BASE_URL+'/server/per/torecharge';//充值中心-充值

  static const String VIDEO_HISTORY_URL=BASE_URL+'/server/live/anchordetail';//主播直播回放列表
  static const String PAY_TYPE=BASE_URL+'/server/notify/pay';//支付回调
  static const String LIVE_STORE_RULE=BASE_URL+'/server/live/store';//直播商品

  static const String OUT_TRADE_NO=BASE_URL+'/server/notify/buycourse?out_trade_no';//课程支付回调
  static const String CLASS_ISPAY=BASE_URL+'/server/index/course_is_buy';//课程是否支付
  static const String JINYAN_API = BASE_URL+'/server/live/jinyan';//直播间禁言
  static const String LAHEI_API = BASE_URL+'/server/live/lahei';//直播间拉黑
  static const String SET_PERSON = BASE_URL+'/server/live/setadmin';//设置管理员
  static const String CHECK_JY = BASE_URL+'/server/live/checkjinyan';//检查是否禁言
  static const String CHECK_GLY = BASE_URL+'/server/live/checkadmin';//检查是否是管理员

  static const String COURSE_LOOK = BASE_URL+'/server/index/course_look';//观看视频记录
  static const String COURSE_LOG = BASE_URL+'/server/index/course_log';//浏览足迹
  static const String LIVE_LOG = BASE_URL+'/server/live/live_log';//浏览直播足迹
  static const String TIME_ABOUT = BASE_URL+'/server/admin/get-config';// 拉黑时常
  static const String CHECKADMIN = BASE_URL+'/server/live/checkadmin';// 查询管理员状态
  static const String DELADMIN = BASE_URL+'/server/live/deladmin'; //解除管理员状态

  static const String REDIS_USER = BASE_URL+'/server/live/redis_user'; //主播轮询接口
  static const String COIN_LOG = BASE_URL+'/server/per/coin_log'; //余额
  static const String ALL_ROOM = BASE_URL+'/server/live/all_room'; //查询全部直播间ID
  static const String GUANBO = BASE_URL+'/server/per/guanbo'; //关闭直播间
}

