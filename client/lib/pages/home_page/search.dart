import 'dart:convert';
import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/home_service.dart';
import 'package:client/service/live_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/toast_util.dart';
import '../../widgets/search_card.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  EasyRefreshController _controllers = EasyRefreshController();

  int page = 1;
  List resou = [];
  List<String> historyList = [];
  List list = [];
  final TextEditingController _keywordText = TextEditingController();
  getKeywords () {
    HomeServer().getKeywords({}, (onSuccess) {
      setState(() {
        resou = onSuccess;
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  getSearch (val) {
    HomeServer().getSearch({
      "keywords": _keywordText.text,
      "page": this.page,
      "limit": 10
    }, (onSuccess) {
      _controllers.finishRefresh();
      if (onSuccess.length == 0) return ToastUtil.showToast('已加载全部数据');
      setState(() {
        val != null ? list = onSuccess : list.addAll(onSuccess);
      });
    }, (onFail) {
      _controllers.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }
  requestList (val) {
    setState(() {
      page = 1;
      this.getSearch(val);
    });
  }
  getHistoryList() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList('historyList') != null) {
      setState(() {
        historyList = prefs.getStringList('historyList');
      });
    }
  }
  submit () async {
    String str = _keywordText.text;
    historyList.contains(str)
        ? ''
        : historyList.add(str);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('historyList', historyList);
    this.requestList(1);
  }
// 获得推流地址
  getliveurl(productEntity) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => productEntity['id']);
    LiveServer().inRoom(map, (success) async {
      Map obj = {'url': success['res']['rtmp_url']};
      // print(obj);
      NavigatorUtils.goSlideLookZhibo(context,room_id: productEntity['id'].toString());
    }, (onFail) async {
      if (onFail['errcode'].toString() == '10108') {
        Map obj= {
          'bgImg':onFail['room']['img'],//背景图
          'headimgurl':onFail['anchor']['headimgurl'],//头像
          'realName':onFail['anchor']['real_name'],//讲师名
          'name':onFail['room']['name'],//直播名称
          'price':onFail['room']['amount'],//直播价格
          'balance':onFail['user']['balance'],//余额
          'roomId':onFail['room']['id'],
          "productEntity": productEntity
        };
        ToastUtil.showToast(onFail['errmsg']);
        NavigatorUtils.goLivePay(context,obj);
      } else {
        ToastUtil.showToast(onFail['errmsg']);
      }
    });
  }
  @override
  initState() {
    this.getHistoryList();
    this.getKeywords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          child: SearchCardWidget(
            elevation: 0,
            onSubmitted: (text) => submit(),
            textEditingController: _keywordText,
          ),
        ),
        backgroundColor: PublicColor.themeColor,
        actions: <Widget>[
          InkWell(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(right: 14.0),
                child: Text(
                  '取消',
                )),
            onTap: () {
              print('取消');
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: list.length>0 ? searchPage2() : searchPage1()
    );
  }
  searchPage2 () {
    return Container(
//      padding: StyleUtil.paddingTow(left: 10,top: 10),
      child: EasyRefresh(
        controller: _controllers,
        header: BezierCircleHeader(
          backgroundColor: PublicColor.themeColor,
        ),
        footer: BezierBounceFooter(
          backgroundColor: PublicColor.themeColor,
        ),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: false,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(15),
          crossAxisSpacing: ScreenUtil().setWidth(15),
          children: list.map((item) => InkWell(
            onTap: () {
              print(item);
              getliveurl(item);
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(StyleUtil.width(10)),
                        child: Image.network(item['img'].toString(),
                          fit: BoxFit.cover,
                          width: StyleUtil.width(340),
                          height: StyleUtil.width(217),
                        ),
                      ),
                      Offstage(
                        offstage: int.parse(item['is_open']) == 0,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Image.asset('assets/home/icon_zhibozhong.png',
                              width: StyleUtil.width(126),
                              height: StyleUtil.width(50)
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: StyleUtil.padding(left: 16),
                    margin: StyleUtil.paddingTow(top: 15),
                    child: Text(item['name']),
                  ),
                  Container(
                    padding: StyleUtil.padding(left: 16),
                    child: Text("ID: ${item['uid']}"),
                  )
                ],
              ),
            ),
          )).toList(),
        ),
        onRefresh: () async {
          this.requestList(1);
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            setState(() {
              page += 1;
              this.getSearch(null);
            });
          });
        },
      ),
    );
  }
  //热搜
  List<Widget> listBoxs(list) => List.generate(resou.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffececec), width: 0.5),
            ),
            child: Text(
              list[index]['keywords'],
              style: TextStyle(
                color: Colors.black45,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            print(list[index]['keywords']);
            _keywordText.text = list[index]['keywords'];
            submit();
          },
        );
      });
  //历史搜索
  List<Widget> searchHistory(list) => List.generate(list.length, (index) {
        return InkWell(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil.instance.setWidth(15)),
            // alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: new Border.all(color: Color(0xfffececec), width: 0.5),
            ),
            child: Text(
              list[index],
              style: TextStyle(
                color: Colors.black45,
                fontSize: ScreenUtil.instance.setWidth(28),
              ),
            ),
          ),
          onTap: () {
            _keywordText.text = list[index];
            submit();
          },
        );
      });
  //body
  Widget searchPage1() {
    return Container(
      padding: StyleUtil.paddingTow(left: 20),
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ScreenUtil.instance.setWidth(750),
              height: ScreenUtil.instance.setWidth(85),
              padding: EdgeInsets.only(left: ScreenUtil.instance.setWidth(25)),
              child: new Row(children: [
                new Image.asset('assets/home/icon_resou.png',
                    width: ScreenUtil.instance.setWidth(35)),
                Text(
                  ' 热搜',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil.instance.setWidth(30.0)),
                )
              ]),
            ),
            Wrap(
              spacing: 5,
              children: listBoxs(resou),
            ),
            Container(
              width: ScreenUtil.instance.setWidth(750),
              height: ScreenUtil.instance.setWidth(85),
              padding: EdgeInsets.only(
                  left: ScreenUtil.instance.setWidth(25),
                  right: ScreenUtil.instance.setWidth(25)),
              child: new Row(children: [
                Expanded(
                    flex: 1,
                    child: new Row(
                      children: <Widget>[
                        new Image.asset('assets/home/icon_history.png',
                            width: ScreenUtil.instance.setWidth(35)),
                        Text(
                          ' 历史记录',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(30.0)),
                        ),
                      ],
                    ))
              ]),
            ),
            Wrap(
              spacing: 5,
              runSpacing: ScreenUtil.instance.setWidth(10.0),
              children: searchHistory(historyList),
            ),
          ],
        ),
        // isloading ? LoadingDialog() : Container(),
      ]),
    );
  }
}
