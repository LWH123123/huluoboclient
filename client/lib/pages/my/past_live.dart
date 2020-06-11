import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PastLive extends StatefulWidget {
  @override
  _PastLiveState createState() => _PastLiveState();
}

class _PastLiveState extends State<PastLive> {
  EasyRefreshController _controller = EasyRefreshController();
  List arr = [];

  int page = 1;

  getDelHistoryLive (id) {
    LiveServer().getDelHistoryLive({
      "room_id": id
    }, (onSuccess) {
      setState(() {
        ToastUtil.showToast('已删除');
        arr.removeWhere((item) => item['id'] == id);
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  getHistoryLive () {
    LiveServer().getHistoryLive({
      "page": this.page,
      "limit": 10
    }, (onSuccess) {
      _controller.finishRefresh();
      if (onSuccess['room'].length == 0) return ToastUtil.showToast('已加载全部数据');
      setState(() {
        arr.addAll(onSuccess['room']);
      });
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  requestList () {
    setState(() {
      page = 1;
      arr =  [];
      getHistoryLive();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    this.requestList();
    super.initState();
  }
  showDialog_pay(context, id) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Container(
            alignment: Alignment.center,
            child: Text('提示',
                style: StyleUtil.tontStyle(
                    color: PublicColor.textColor,
                    num: 32,
                    fontWeight: FontWeight.bold)),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: StyleUtil.width(60)),
                      Text('此操作将永久删除该文件',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('是否继续?',
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                )
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              onPressed: () {
                print('yes...');
                getDelHistoryLive(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('历史直播'),
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
            children: arr.length > 0 ? arr.map((item) => _itemView(item)).toList() : [Container(
              child: Center(
                child: Text('暂无数据'),
              ),
              height: 200,
            )],
          ),
          onRefresh: () async {
            setState(() {
              this.requestList();
            });
          },
          onLoad: () async {
            await Future.delayed(Duration(seconds: 1), () {
              setState(() {
                page += 1;
                this.getHistoryLive();
              });
            });
          },
        ),
    );
  }

  Widget _itemView(item) {
    return InkWell(
      onTap: () {
        print(item);
        NavigatorUtils.goInformationLivePage(context, item['uid'].toString(), room_id: item['id'].toString());
      },
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
            bottom: ScreenUtil().setWidth(10),
            top: ScreenUtil().setWidth(10)
        ),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: PublicColor.borderColor, width: 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(10)),
                      child: Image.network(item['img'],
                          fit: BoxFit.cover,
                          width: ScreenUtil().setWidth(191),
                          height: ScreenUtil().setWidth(188))),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(104),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(15),
                        top: ScreenUtil().setWidth(7),
                        bottom: ScreenUtil().setWidth(7),
                      ),
                      child: Text(item['is_open'] == '0' ? '预告' : item['is_open'] == '1' ? '直播中' : '已结束', style: TextStyle(color: Colors.white)),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ScreenUtil().setWidth(10)),
                            topRight:
                                Radius.circular(ScreenUtil().setWidth(25)),
                            bottomRight:
                                Radius.circular(ScreenUtil().setWidth(25))),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(19)),
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:StyleUtil.padding(top: 20,bottom: 52),
                        child: Text(item['name'],
                            style: TextStyle(
                                color: PublicColor.textColor,
                                fontSize: ScreenUtil().setSp(28)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                height: ScreenUtil().setWidth(55),
                                child: OutlineButton(
                                    shape: StadiumBorder(),
                                    borderSide: BorderSide(
                                        color: PublicColor.yellowColor),
                                    child: Row(
                                      children: <Widget>[
                                        Image.asset(
                                            'assets/teacher/icon_liwu@2x.png',
                                          width: ScreenUtil().setWidth(29),
                                          height: ScreenUtil().setWidth(28),
                                        ),
                                        SizedBox(width: ScreenUtil().setWidth(9),),
                                        Text(
                                            '收礼价值',
                                          style: TextStyle(
                                            color: PublicColor.yellowColor,
                                            fontSize: ScreenUtil().setSp(28),
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      print('点击收礼价值事件');
                                      NavigatorUtils.goPresentPrice(context, id: item['id'].toString());
                                    })),
                            SizedBox(width: ScreenUtil().setWidth(18),),
                            Container(
                                height: ScreenUtil().setWidth(55),
                                child: OutlineButton(
                                    shape: StadiumBorder(),
                                    borderSide: BorderSide(
                                        color: PublicColor.themeColor),
                                    child: Text(
                                        '删除',
                                        style: TextStyle(
                                            color: PublicColor.themeColor,
                                            fontSize: ScreenUtil().setSp(28),
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    onPressed: () {
                                      //getDelHistoryLive(item['id']);
                                      showDialog_pay(context, item['id']);
                                      print('删除事件');
                                    }))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
