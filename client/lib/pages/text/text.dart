import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routers/application.dart';

class TextPage extends StatefulWidget {
  TextPage({Key key}) : super(key: key);

  @override
  _TextPageState createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  /*getCourseType () {
    CourseService().getCourseType({
      "page": this.page
    }, (onSuccess) {

    }, (onFail) => ToastUtil.showToast(onFail));
  }*/

  /*getCourseType() {
    CourseService().getCourseType({"page": this.page}, (onSuccess) {
      setState(() {
        list = onSuccess;
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }*/

    /*ree () {
      return WillPopScope(
      child: DefaultTabController(
        length: 2,
        child: Text(),
      ),
      onWillPop: () async {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          ToastUtil.showToast('再按一次退出');
          return false;
        } else {
          lastPopTime = DateTime.now();
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return true;
        }
      },
    )
    }
*/

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('text'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: Center(
            child: RaisedButton(
          child: Text('返回'),
          onPressed: () {
            Application.router.pop(context);
          },
        )));
  }
}
