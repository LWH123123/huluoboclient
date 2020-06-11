import 'package:client/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './routers/application.dart';
import './routers/routers.dart';
import './common/color.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
void main() {
  Router router = Router();
  Routes.configureRoutes(router);
  Application.router = router;
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  info () async {
    final prefs = await SharedPreferences.getInstance();
    print("MyApp----------->${prefs.getString('jwt')}");
    if (prefs.getString('jwt') == null || prefs.getString('jwt') == '') return;
    await HomeServer().getKeywords({}, (onSuccess) {
      print("getKeywords------------------${onSuccess}");
      Routes.navigatorKey.currentState.pushNamedAndRemoveUntil(
          "/tabs", ModalRoute.withName(Routes.tabs));
    }, (onFail) {

    });
  }

  @override
  _MyAppState createState() {
    info();
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
 
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  _initFluwx() async {
    await fluwx.registerWxApi(
        appId: "wx1945a4c131388cf5",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://huluobozhibo.com/link/");
    var result = await fluwx.isWeChatInstalled();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: Tabs(),
        // initialRoute: '/login',
        navigatorKey: Routes.navigatorKey,
        onGenerateRoute: Application.router.generator,
        theme: mDefaultTheme);
  }
}

//自定义主题
final ThemeData mDefaultTheme =
    ThemeData(primaryColor: PublicColor.themeColor);
