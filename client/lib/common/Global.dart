class Global {
  static const String NO_LOGIN = '请先登录';

  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return formatTime(hour) + "" + formatTime(minute) + "" + formatTime(second);
  }

  static String addNums(int n) {
    if (n < 10) {
      return "0" + n.toString();
    } else {
      return n.toString();
    }
  }

  //数字格式化，将 0~9 的时间转换为 00~09
  static String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  // 手机号格式化
  static String formatPhone(String phone) {
    return phone.length == 11
        ? phone.substring(0, 3) +
            '****' +
            phone.substring(phone.length - 4, phone.length)
        : phone;
  }

  static final List city = [
    // {"name":"北京市"},
    // {"name":"天津市"},
    // {"name":"河北省"},
    // {"name":"山西省"},
    // {"name":"内蒙古自治区"},
    // {"name":"辽宁省"},
    // {"name":"吉林省"},
    // {"name":"黑龙江省"},
    // {"name":"上海市"},
    // {"name":"江苏省"},
    // {"name":"浙江省"},
    // {"name":"安徽省"},
    // {"name":"福建省"},
    // {"name":"江西省"},
    // {"name":"山东省"},
    // {"name":"河南省"},
    // {"name":"湖北省"},
    // {"name":"湖南省"},
    // {"name":"广东省"},
    // {"name":"广西壮族自治区"},
    // {"name":"海南省"},
    // {"name":"重庆市"},
    // {"name":"四川省"},
    // {"name":"贵州省"},
    // {"name":"云南省"},
    // {"name":"西藏自治区"},
    // {"name":"陕西省"},
    // {"name":"甘肃省"},
    // {"name":"青海省"},
    // {"name":"宁夏回族自治区"},
    // {"name":"新疆维吾尔自治区"},
    // {"name":"台湾省"},
    // {"name":"香港特别行政区"},
    // {"name":"澳门特别行政区"},

    {"flag": false, "isSelect": false, "name": "北京市"},
    {"flag": false, "isSelect": false, "name": "天津市"},
    {"flag": false, "isSelect": false, "name": "河北省"},
    {"flag": false, "isSelect": false, "name": "山西省"},
    {"flag": false, "isSelect": false, "name": "内蒙古自治区"},
    {"flag": false, "isSelect": false, "name": "辽宁省"},
    {"flag": false, "isSelect": false, "name": "吉林省"},
    {"flag": false, "isSelect": false, "name": "黑龙江省"},
    {"flag": false, "isSelect": false, "name": "上海市"},
    {"flag": false, "isSelect": false, "name": "江苏省"},
    {"flag": false, "isSelect": false, "name": "浙江省"},
    {"flag": false, "isSelect": false, "name": "安徽省"},
    {"flag": false, "isSelect": false, "name": "福建省"},
    {"flag": false, "isSelect": false, "name": "江西省"},
    {"flag": false, "isSelect": false, "name": "山东省"},
    {"flag": false, "isSelect": false, "name": "河南省"},
    {"flag": false, "isSelect": false, "name": "湖北省"},
    {"flag": false, "isSelect": false, "name": "湖南省"},
    {"flag": false, "isSelect": false, "name": "广东省"},
    {"flag": false, "isSelect": false, "name": "广西壮族自治区"},
    {"flag": false, "isSelect": false, "name": "海南省"},
    {"flag": false, "isSelect": false, "name": "重庆市"},
    {"flag": false, "isSelect": false, "name": "四川省"},
    {"flag": false, "isSelect": false, "name": "贵州省"},
    {"flag": false, "isSelect": false, "name": "云南省"},
    {"flag": false, "isSelect": false, "name": "西藏自治区"},
    {"flag": false, "isSelect": false, "name": "陕西省"},
    {"flag": false, "isSelect": false, "name": "甘肃省"},
    {"flag": false, "isSelect": false, "name": "青海省"},
    {"flag": false, "isSelect": false, "name": "宁夏回族自治区"},
    {"flag": false, "isSelect": false, "name": "新疆维吾尔自治区"},
    {"flag": false, "isSelect": false, "name": "台湾省"},
    {"flag": false, "isSelect": false, "name": "香港特别行政区"},
    {"flag": false, "isSelect": false, "name": "澳门特别行政区"},
  ];
}
