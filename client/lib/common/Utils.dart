class Utils {
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static getsocket() {
    var domain = "ws://39.97.219.180:19501";
    if (isRelease) {
      return domain;
    } else {
      return "ws://39.97.219.180:19501";
    }
  }
}
