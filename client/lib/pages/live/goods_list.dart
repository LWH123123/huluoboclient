import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_easyrefresh/easy_refresh.dart";
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import '../../widgets/loading.dart';
import '../../service/store_service.dart';
import '../../utils/toast_util.dart';
import '../../widgets/cached_image.dart';
import '../../routers/Navigator_util.dart';
class GoodsList extends StatefulWidget {
  final String id;
  final String shipId;
  final String roomId;
  GoodsList({this.id, this.shipId, this.roomId});
  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  int _page = 0;
  EasyRefreshController _controller = EasyRefreshController();
  bool isLoading = false;
  List listView = [];
  @override
  void initState() {
    super.initState();

    print(widget.id);
    print(widget.shipId);
    print(widget.roomId);
    getList();
  }

  void getList() {
    setState(() {
      isLoading = true;
    });
    _page++;
    if (_page == 1) {
      listView = [];
    }

    Map<String, dynamic> map = Map();

    map.putIfAbsent("category_id", () => widget.id);
    map.putIfAbsent("page", () => _page);
    map.putIfAbsent("limit", () => 10);

    StoreServer().getShopList(map, (success) async {
      setState(() {
        isLoading = false;
        if (_page == 1) {
          //赋值
          listView = success['goods'];
        } else {
          if (success['goods'].length == 0) {
            ToastUtil.showToast('已加载全部数据');
          } else {
            for (var i = 0; i < success['goods'].length; i++) {
              listView.insert(listView.length, success['goods'][i]);
            }
          }
        }
      });
      _controller.finishRefresh();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      _controller.finishRefresh();
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text('商品列表'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: PublicColor.themeColor,
          ),
          body: contentWidget(),
        ),
        isLoading ? LoadingDialog() : Container(),
      ],
    );
  }

  Widget goodsView() {
    List<Widget> arr = <Widget>[];
    Widget content;
    if (listView.length == 0) {
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
      for (var item in listView) {
        arr.add(Container(
          padding: StyleUtil.paddingTow(left: 28, top: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: StyleUtil.borderBottom())),
          child: Column(children: <Widget>[
            new InkWell(
              onTap: () {
                print('商品详情');
                 String shipId = widget.shipId;
                String roomId = widget.roomId;
                String id = item['id'];           
                NavigatorUtils.goXiangQing(context, id, shipId, roomId);
              },
              child: new Container(
                child: Row(
                  children: <Widget>[
                    CachedImageView(
                        ScreenUtil.instance.setWidth(203.0),
                        ScreenUtil.instance.setWidth(203.0),
                        item['thumb'],
                        null,
                        BorderRadius.all(Radius.circular(15.0))),
                    SizedBox(width: StyleUtil.width(15)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item['name'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: PublicColor.textColor,
                                  fontSize: StyleUtil.fontSize(28)),
                            ),
                            SizedBox(height: StyleUtil.width(71)),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '￥' + item['price'],
                                    style: StyleUtil.tontStyle(
                                        fontWeight: FontWeight.bold),
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
              ),
            ),
          ]),
        ));
      }
    }
    content = new Column(
      children: arr,
    );
    return content;
  }

  Widget contentWidget() {
    return Container(
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
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[goodsView()],
        )),
        onRefresh: () async {
          getList();
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 1), () {
            getList();
          });
        },
      ),
    );
  }
}
