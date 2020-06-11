//验证用户名
class RegExpTest {
  // 正则匹配手机号
  static RegExp exp = RegExp(r'^1[3456789]\d{9}$');
  static RegExp checknum = RegExp(r'^[0-9]{7}$');
  static RegExp num = RegExp(r'^[0-9]{1,}$');
  static RegExp checkformate = RegExp(r"[\u4e00-\u9fa5|;|A-Z|a-z|0-9]+");
  static RegExp identity_card = RegExp(r'^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]\$');
  static RegExp regMobile = new RegExp(
      '^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}\$');
}
