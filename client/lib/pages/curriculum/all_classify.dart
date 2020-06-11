import 'package:client/common/color.dart';
import 'package:client/service/course_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routers/Navigator_util.dart';

class AllClassify extends StatefulWidget {
  AllClassify(String id);

  @override
  _AllClassifyState createState() => _AllClassifyState();
}

class _AllClassifyState extends State<AllClassify> {
  EasyRefreshController _controller = EasyRefreshController();
  int page = 1;
  List list = [];

  getCourseType() {
    CourseService().getCourseType({"page": this.page,"limit": 10}, (onSuccess) {
      setState(() {
        onSuccess.length > 0 ? list.addAll(onSuccess) : ToastUtil.showToast('已加载全部数据');
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  reuqestList() {
    setState(() {
      page = 1;
      list = [];
      this.getCourseType();
    });
  }

  Widget listData() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (list.length == 0) {
      arr.add(Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(300)),
        child: Text(
          '暂无数据',
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    } else {
      for (var item in list) {
        arr.add(Container(
          child: new InkWell(
              onTap: () {
                 NavigatorUtils.goClassification(context, item['id']);
              },
              child: Container(
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xffdddddd))),
                ),
                child: new Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Image.network(
                        item['img'],
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(28),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerRight,
                          child: new Icon(
                            Icons.navigate_next,
                            color: Color(0xff999999),
                          ),
                        )),
                  ],
                ),
              )),
        ));
      }
    }
    content = new Column(
      children: arr,
    );
    return content;
  }

  @override
  void initState() {
    // TODO: implement initState
    this.reuqestList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('全部分类'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PublicColor.themeColor,
      ),
      body: EasyRefresh(
        controller: _controller,
        header: BezierCircleHeader(
          backgroundColor: PublicColor.themeColor,
        ),
        footer: BezierBounceFooter(
          backgroundColor: PublicColor.themeColor,
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[listData()],
        ),
        onRefresh: () async {
          setState(() {
            this.reuqestList();
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              page += 1;
              this.getCourseType();
            });
          });
        },
      ),
//      body: Container(child: new ListView(children: <Widget>[listData()])),
    );
  }
}
