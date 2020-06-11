import 'package:flutter/material.dart';
import '../home_page/home_page.dart';
import '../live/live.dart';
import '../curriculum/curriculum.dart';
import '../my/member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  List list = [HomePage(), Curriculum(), Live(), MemberPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('widget.title'),
      // ),
      body: this.list[this.index],
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color.fromRGBO(73, 57, 0, 1),
          selectedItemColor: Color.fromRGBO(231, 31, 25, 1),
          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) => setState(() => this.index = index),
          items: [
            BottomNavigationBarItem(
              title: Text('首页'),
              icon: Image.asset(
                index == 0
                    ? "assets/tabbar/icon_shouye1.png"
                    : "assets/tabbar/icon_shouye2.png",
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(40),
              ),
            ),
            BottomNavigationBarItem(
              title: Text('课程'),
              icon: Image.asset(
                index == 1
                    ? "assets/tabbar/icon_kecheng1.png"
                    : "assets/tabbar/icon_kecheng2.png",
                width: ScreenUtil().setWidth(43),
                height: ScreenUtil().setWidth(37),
              ),
            ),
            BottomNavigationBarItem(
              title: Text('直播'),
              icon: Image.asset(
                index == 2
                    ? "assets/tabbar/icon_zhibo1.png"
                    : "assets/tabbar/icon_zhibo2.png",
                width: ScreenUtil().setWidth(42),
                height: ScreenUtil().setWidth(39),
              ),
            ),
            BottomNavigationBarItem(
              title: Text('我的'),
              icon: Image.asset(
                index == 3
                    ? "assets/tabbar/icon_wode1.png"
                    : "assets/tabbar/icon_wode2.png",
                width: ScreenUtil().setWidth(39),
                height: ScreenUtil().setWidth(39),
              ),
            ),
          ]),
    );
  }
}
