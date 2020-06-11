import 'package:client/common/color.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class LiveAddStore extends StatefulWidget {
  @override
  _LiveAddStoreState createState() => _LiveAddStoreState();
}

class _LiveAddStoreState extends State<LiveAddStore> {
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController _storeKeywords = TextEditingController();
  List list = [], select = [];
  int num = 0;
  getAllStore () {
    LiveServer().getAllStore({
      "keywords": _storeKeywords.text
    }, (onSuccess) {
      setState(() {
        list = onSuccess['list'];
        num = onSuccess['num'];
      });
      _controller.finishRefresh();
    }, (onFail) {
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  getChooseBring () {
    if (select.length == 0) return ToastUtil.showToast('请选择商品');
    String str = select.join(',');
    LiveServer().getChooseBring({
      "ids": str,
      "type": 1
    }, (onSuccess) {
      ToastUtil.showToast('已保存');
      setState(() {
        select = [];
      });
      this.getAllStore();
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getAllStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('新增店铺'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
          actions: <Widget>[
            Container(
              padding: StyleUtil.padding(right: 10),
              child: Center(
                child: InkWell(
                  onTap: () {
                    getChooseBring();
                  },
                  child: Text('保存'),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: StyleUtil.paddingTow(left: 27, top: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: StyleUtil.width(63),
                      padding: StyleUtil.paddingTow(left: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xffEEEEEE),
                          borderRadius:
                          BorderRadius.circular(StyleUtil.width(31))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/cart/icon_sousuo.png',
                            width: StyleUtil.width(25),
                            height: StyleUtil.width(25),
                          ),
                          SizedBox(width: StyleUtil.width(13)),
                          Expanded(
                            flex: 1,
                            child: TextField(
                                autofocus: false,
                                controller: _storeKeywords,
                                textAlign: TextAlign.start,
                                onChanged: (val) {
                                  _storeKeywords.text = val;
                                },
                                onSubmitted: (text) {
                                  _storeKeywords.text = text;
                                  getAllStore();
                                },
                                decoration: new InputDecoration(
                                  hintText: "请选择直播带货商品及店铺",
                                 
                                  border: InputBorder.none,
                                  contentPadding: StyleUtil.padding(bottom: 37),
                                  hintStyle: TextStyle(
                                      color: PublicColor.inputHintColor,
                                      fontSize: StyleUtil.fontSize(24)),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.white,
                    elevation: 0,
                    highlightElevation: 0,
                    splashColor: Colors.white,
                    child: Text('搜索'),
                    onPressed: () {
                      getAllStore();
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: StyleUtil.width(10)),
            Expanded(
              flex: 1,
              child: EasyRefresh(
                  controller: _controller,
                  header: BezierCircleHeader(
                    backgroundColor: PublicColor.themeColor,
                  ),
                  enableControlFinishRefresh: true,
                  child: ListView(
                    children: <Widget>[
                      contView(),
                      ...(list.map((item) => shopView(item)).toList()),
                    ],
                  ),
                  onRefresh: () async {
                    setState(() {
                      this.getAllStore();
                    });
                  }
              ),
            ),

          ],
        ));
  }

  Widget contView () {
    return  Container(
      child: Text("已选: $num",style: StyleUtil.tontStyle(color: PublicColor.textColor)),
      padding: StyleUtil.paddingTow(left: 30, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: StyleUtil.borderBottom())
      ),
    );
  }

  Widget shopView(item) {
    return Container(
      padding: StyleUtil.paddingTow(left: 28, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: StyleUtil.borderBottom())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Image.network(
                    item['img'],
                    fit: BoxFit.cover,
                    width: StyleUtil.width(107),
                    height: StyleUtil.width(107),
                  ),
                ),
                SizedBox(width: StyleUtil.width(21)),
                Text(
                  item['name'],
                  style: TextStyle(
                      color: PublicColor.textColor,
                      fontSize: StyleUtil.fontSize(30)),
                )
              ],
            ),
          ),
          item['is_choose'] == 1 ? Container(
            width: StyleUtil.width(74),
            height: StyleUtil.width(37),
            decoration: BoxDecoration(
              color: PublicColor.borderColor,
              borderRadius: BorderRadius.circular(5)
            ),
            child: Center(
              child: Text('已选', style: StyleUtil.tontStyle(color: PublicColor.textColor,num: 26)),
            ),
          ) :
          InkWell(
            onTap: () => setState(() =>!select.contains(item['id']) ? select.add(item['id']): select.remove(item['id'])),
            child: Container(
              width: StyleUtil.width(51),
              height: StyleUtil.width(51),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: PublicColor.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              child: Icon(
                !select.contains(item['id']) ? Icons.add: Icons.remove,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
