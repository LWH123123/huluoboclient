import 'package:client/common/color.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LiveAddGoods extends StatefulWidget {
  @override
  _LiveAddGoodsState createState() => _LiveAddGoodsState();
}

class _LiveAddGoodsState extends State<LiveAddGoods> {
  EasyRefreshController _controller = EasyRefreshController();
  TextEditingController _goodsKeywords = TextEditingController();
  List list = [], select = [];
  int num = 0;
  getAllGoods () {
    LiveServer().getAllGoods({
      "keywords": _goodsKeywords.text
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
      "type": 2
    }, (onSuccess) {
      ToastUtil.showToast('已保存');
      setState(() {
        select = [];
      });
      this.getAllGoods();
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  @override
  void initState() {
    // TODO: implement initState
    this.getAllGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('新增商品'),
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
                                controller: _goodsKeywords,
                                textAlign: TextAlign.start,
                                onChanged: (val) {
                                  _goodsKeywords.text = val;
                                },
                                onSubmitted: (text) {
                                  _goodsKeywords.text = text;
                                  getAllGoods();
                                },
                                decoration: new InputDecoration(
                                  hintText: "请选择直播带货商品及店铺",
                                  border: InputBorder.none,
                                  contentPadding: StyleUtil.padding(bottom: 27),
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
                      getAllGoods();
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
                      ...(list.map((item) => goodsView(item)).toList()),
                    ],
                  ),
                  onRefresh: () async {
                    setState(() {
                      this.getAllGoods();
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
  Widget goodsView(item) {
    return Container(
      padding: StyleUtil.paddingTow(left: 28, top: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: StyleUtil.borderBottom())),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: new Image.network(
              item['thumb'],
              fit: BoxFit.cover,
              width: StyleUtil.width(203),
              height: StyleUtil.width(203),
            ),
          ),
          SizedBox(width: StyleUtil.width(15)),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item["name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: PublicColor.textColor,
                        fontSize: StyleUtil.fontSize(28)
                    ),
                  ),
                  item['is_choose'] == 1 ? SizedBox(height: StyleUtil.width(90),) :
                  Container(
                    padding: StyleUtil.paddingTow(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '￥${item['price']}',
                          style: TextStyle(
                              color: PublicColor.textColor,
                              fontSize: StyleUtil.fontSize(33),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        item['is_choose'] == 0 ? Text(''):
                        Container(
                            width: StyleUtil.width(74),
                            height: StyleUtil.width(37),
                            decoration: BoxDecoration(
                                color: PublicColor.textColor,
                                borderRadius: BorderRadius.circular(StyleUtil.width(10))
                            ),
                            alignment: Alignment.center,
                            child: Text('已选',style: StyleUtil.tontStyle(color: Colors.white,num: 26),)
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
