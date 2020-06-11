import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/store_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Balance extends StatefulWidget {
  @override
  _BalanceState createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  EasyRefreshController _controller = EasyRefreshController();
  List monthArr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List typeArr = [], log = [];
  int month, page = 1,type;
  Map user;
  requestList() {
    setState(() {
      page = 1;
      log = [];
      coinLog();
    });
  }

  coinLog() {
    StoreServer().coinLog(
        {"type": type, "month": month, "page": page, "limit": 10}, (onSuccess) {
      print(onSuccess);
      typeArr = onSuccess['type'];
      user = onSuccess['user'];
      _controller.finishRefresh();
      if (onSuccess['log'].length == 0) return ToastUtil.showToast('已加载全部数据');
      setState(() {
        log.addAll(onSuccess['log']);
      });
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    coinLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('余额'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
          actions: <Widget>[
            InkWell(
              onTap: () {
                print('充值');
                NavigatorUtils.rechargeCentrePage(context);
              },
              child: Center(
                child: Text(
                  '充值',
                  style: StyleUtil.tontStyle(color: Colors.white, num: 30),
                ),
              ),
            ),
            SizedBox(width: StyleUtil.width(15))
          ],
        ),
        body: Column(
          children: <Widget>[
            Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(user != null ? user["balance"] : '0',
                            style: StyleUtil.tontStyle(
                                num: 34, fontWeight: FontWeight.bold)),
                        Text('余额数量',
                            style: StyleUtil.tontStyle(
                                color: PublicColor.borderColor, num: 30))
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: StyleUtil.width(88),
                    color: PublicColor.borderColor,
                    margin: StyleUtil.paddingTow(left: 128, top: 25),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(user != null ? user["consume"] : '0',
                            style: StyleUtil.tontStyle(
                                num: 34, fontWeight: FontWeight.bold)),
                        Text('消费数量',
                            style: StyleUtil.tontStyle(
                                color: PublicColor.borderColor, num: 30))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: StyleUtil.paddingTow(left: 28),
              margin: StyleUtil.padding(top: 25),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        margin: StyleUtil.padding(right: 11),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 230, 230, 1),
                            borderRadius:
                                BorderRadius.circular(StyleUtil.width(10))),
                        padding: StyleUtil.paddingTow(left: 20),
                        child: DropdownButton(
                          isExpanded: true,
                          style:
                              StyleUtil.tontStyle(color: PublicColor.textColor),
                          underline: Container(
                              height: 0, color: PublicColor.borderColor),
                          hint: Text('请选择类型'),
                          onChanged: (value) {
                            setState(() {
                              type = value;
                            });
                          },
                          value: type,
                          items: [
                            ...typeArr.map((item) => DropdownMenuItem(
                              child: Padding(
                                padding: StyleUtil.paddingTow(left: 20),
                                child: Text(item['name']),
                              ),
                              value: int.parse(item['value']),
                            )).toList(),
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        margin: StyleUtil.padding(right: 17),
                        padding: StyleUtil.paddingTow(left: 20),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 230, 230, 1),
                            borderRadius:
                                BorderRadius.circular(StyleUtil.width(10))),
                        child: DropdownButton(
                          isExpanded: true,
                          style:
                              StyleUtil.tontStyle(color: PublicColor.textColor),
                          underline: Container(
                              height: 0, color: PublicColor.borderColor),
                          hint: Text('请选择月份'),
                          onChanged: (value) {
                            setState(() {
                              month = value;
                            });
                          },
                          value: month,
                          items: monthArr
                              .map((item) => DropdownMenuItem(
                                    child: Padding(
                                      padding: StyleUtil.paddingTow(left: 20),
                                      child: Text('$item月份'),
                                    ),
                                    value: item,
                                  ))
                              .toList(),
                        )),
                  ),
                  Container(
                    width: StyleUtil.width(150),
                    height: StyleUtil.width(90),
                    child: RaisedButton(
                      color: PublicColor.themeColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '查询',
                        style:
                            StyleUtil.tontStyle(color: PublicColor.whiteColor),
                      ),
                      onPressed: () {
                        this.requestList();
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: StyleUtil.width(36)),
            Container(
              padding: StyleUtil.paddingTow(left: 28),
              margin: StyleUtil.padding(bottom: 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: StyleUtil.width(750 / 3 - 28),
                    child: Text('日期',
                        style: StyleUtil.tontStyle(
                            color: PublicColor.textColor, num: 30)),
                  ),
                  Container(
                    width: StyleUtil.width(750 / 3 - 28),
                    alignment: Alignment.center,
                    child: Text('类别',
                        style: StyleUtil.tontStyle(
                            color: PublicColor.textColor, num: 30)),
                  ),
                  Container(
                    width: StyleUtil.width(750 / 3 - 28),
                    alignment: Alignment.centerRight,
                    child: Text('数量',
                        style: StyleUtil.tontStyle(
                            color: PublicColor.textColor, num: 30)),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: PublicColor.whiteColor,
                child: EasyRefresh(
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
                    children: log.length > 0
                        ? log.map((item) => div(item)).toList()
                        : [
                      Center(
                        child: Text('暂无数据'),
                      )
                    ],
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
                        this.coinLog();
                      });
                    });
                  },
                ),
              ),
            )
          ],
        ));
  }

  Widget div(item) {
    return Container(
      padding: StyleUtil.paddingTow(left: 28, top: 28),
      margin: StyleUtil.padding(bottom: 23),
      decoration:
          BoxDecoration(border: Border(bottom: StyleUtil.borderBottom())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: StyleUtil.width(750 / 3 - 28),
            child: Text(item['create_at'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    StyleUtil.tontStyle(color: PublicColor.textColor, num: 30)),
          ),
          Container(
            width: StyleUtil.width(750 / 3 - 28),
            alignment: Alignment.center,
            child: Text(item["class"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    StyleUtil.tontStyle(color: PublicColor.textColor, num: 30)),
          ),
          Container(
            width: StyleUtil.width(750 / 3 - 28),
            alignment: Alignment.centerRight,
            child: Text(item["balance"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    StyleUtil.tontStyle(color: PublicColor.textColor, num: 30)),
          )
        ],
      ),
    );
  }
}
