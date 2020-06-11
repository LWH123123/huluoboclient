import 'dart:convert';
import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routers/fluro_convert_util.dart';
class Interest extends StatefulWidget {
  // String information;
  // Interest({Key key, String this.information}) : super(key: key);
   String objs;
  Interest({Key key, String this.objs}) : super(key: key);
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  List lists = new List();
  List listName = [];
  Map list = {};
  // Map<String, dynamic> mapName;
  @override
  void initState() {
    super.initState();
    // mapName = json.decode(widget.information);
    infoRequest();
     list = FluroConvertUtils.string2map(widget.objs);
     print(list);
     print('??????????');
  }
  infoRequest() {
    UserServer().getTagsList((success) {
      print(success['tags']);
      setState(() {
        lists = success['tags'];
      });
    }, (Fail) {});
  }
  saveRequest () {
    list.putIfAbsent('tags', () => listName.join(','));
    UserServer().getCreateUserInfo(list, (onSuccess) {
      ToastUtil.showToast('保存成功');
      NavigatorUtils.gologinPage(context);
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  List<Widget> _viewList() {
    List<Widget> list = new List();
    lists.forEach((item) => {
          list.add(Container(
              child: GestureDetector(
            onTap: () {
              setState(() {
                listName.contains(item['id'])
                    ? listName.remove(item['id'])
                    : listName.add(item['id']);
              });
            },
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.network(item['img'],
                        width: ScreenUtil().setWidth(136), fit: BoxFit.cover),
                    Positioned(
                        right: ScreenUtil().setWidth(5),
                        bottom: ScreenUtil().setWidth(3),
                        child: Offstage(
                          offstage: !listName.contains(item['id']),
                          child: Image.asset('assets/login/icon_xuanzhong.png',
                              width: ScreenUtil().setWidth(34),
                              fit: BoxFit.cover),
                        ))
                  ],
                ),
                SizedBox(height: ScreenUtil().setWidth(23)),
                Text(item['name'])
              ],
            ),
          )))
        });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  child: Image.asset('assets/login/bg_wanshanxinxi.png',
                      fit: BoxFit.cover)),
              Center(
                  child: Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(180)),
                      child: Text('请选择兴趣标签',
                          style: TextStyle(
                              color: PublicColor.whiteColor,
                              fontSize: ScreenUtil().setSp(56))))),
              Container(
                padding: StyleUtil.padding(top: 50),
                child: IconButton(
                  icon: Icon(Icons.navigate_before,color: Colors.white,size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
          Expanded(
            flex: 1,
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  Container(
                    margin: StyleUtil.padding(left: 28,right: 28,top: 10),
                    decoration: new BoxDecoration(
                        color: PublicColor.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: StyleUtil.boxShadow()),
                    child: Column(
                      children: <Widget>[
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3, // 每行显示多少个
                          childAspectRatio: 18 / 17, // 网格比例
                          children: _viewList(),
                          padding: EdgeInsets.all(0),
                          physics: new NeverScrollableScrollPhysics(),//增加
                        ),
                        Container(
                          width: StyleUtil.width(570),
                          height: StyleUtil.width(92),
                          margin: StyleUtil.paddingTow(top: 50),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(46))),
                            color: PublicColor.themeColor,
                            textColor: PublicColor.whiteColor,
                            child: Text('保存'),
                            onPressed: () {
                              listName.length > 0 ? saveRequest() : ToastUtil.showToast('请选择兴趣爱好');
//                          NavigatorUtils.goHomePage(context);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                  /*Container(
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(28),
                          right: ScreenUtil().setWidth(28),
                          top: ScreenUtil().setWidth(10)),
                      decoration: new BoxDecoration(
                          color: PublicColor.whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(108, 108, 108, 0.46),
                                offset: Offset(0.0, 2), //阴影xy轴偏移量
                                blurRadius: 15.0, //阴影模糊程度
                                spreadRadius: 1.0 //阴影扩散程度
                            )
                          ]),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3, // 每行显示多少个
                              childAspectRatio: 18 / 17, // 网格比例
                              children: _viewList(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(58),
                                left: ScreenUtil().setWidth(58),
                                right: ScreenUtil().setWidth(58)),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(46))),
                              color: PublicColor.themeColor,
                              textColor: PublicColor.whiteColor,
                              child: Text('保存'),
                              onPressed: () {
                                listName.length > 1 ? saveRequest() : ToastUtil.showToast('请选择兴趣爱好');
//                          NavigatorUtils.goHomePage(context);
                              },
                            ),
                          ),
                        ],
                      ))*/
                ],
              )/*Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(28),
                      right: ScreenUtil().setWidth(28),
                      top: ScreenUtil().setWidth(10)),
                  decoration: new BoxDecoration(
                      color: PublicColor.whiteColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(108, 108, 108, 0.46),
                            offset: Offset(0.0, 2), //阴影xy轴偏移量
                            blurRadius: 15.0, //阴影模糊程度
                            spreadRadius: 1.0 //阴影扩散程度
                            )
                      ]),
                  child: ListView(children: <Widget>[
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3, // 每行显示多少个
                      childAspectRatio: 18 / 17, // 网格比例
                      children: _viewList(),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(58),
                          left: ScreenUtil().setWidth(58),
                          right: ScreenUtil().setWidth(58)),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(46))),
                        color: PublicColor.themeColor,
                        textColor: PublicColor.whiteColor,
                        child: Text('保存'),
                        onPressed: () {
                          listName.length > 1 ? saveRequest() : ToastUtil.showToast('请选择兴趣爱好');
//                          NavigatorUtils.goHomePage(context);
                        },
                      ),
                    )
                  ]))*/),
        ],
      ),
    );
  }
}
