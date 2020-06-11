import 'package:client/common/color.dart';
import 'package:client/common/regExp.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/city_picker.dart';
import '../../routers/fluro_convert_util.dart';
import '../../service/store_service.dart';
import '../../utils/toast_util.dart';
import '../../widgets/cached_image.dart';
class TijiaoDingdan extends StatefulWidget {
  String objs;
  TijiaoDingdan({Key key, String this.objs}) : super(key: key);

  @override
  _TijiaoDingdanState createState() => _TijiaoDingdanState();
}

class _TijiaoDingdanState extends State<TijiaoDingdan> {
  bool isLoading = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _courseName = TextEditingController(),
      _address = TextEditingController(),
      _provinces = TextEditingController(),
      _remark = TextEditingController(),
      _phone = TextEditingController();
  String province = '';
  String city = '';
  String region = '';

  Map lists = {"list": []};
  List getList = [];
  List listview = [];
  String all = '';

  @override
  void initState() {
    super.initState();
    lists = FluroConvertUtils.string2map(widget.objs);
    // 移除多余元素
    for (var i = 0; i < lists['list'].length; i++) {
      lists['list'][i].remove('title');
      for (var j = 0; j < lists['list'][i]['list'].length; j++) {
        getList.add(lists['list'][i]['list'][j]);
      }
    }

    if (getList.length != 0) {
      for (var i = 0; i < getList.length; i++) {
        getList[i].remove('id');
        getList[i].remove('name');
        getList[i].remove('thumb');
        getList[i].remove('desc');
        getList[i].remove('price');
        getList[i].remove('content');
        getList[i].remove('sort');
        getList[i].remove('fare');
        getList[i].remove('stock');
        getList[i].remove('createtime');
        getList[i].remove('type_id');
        getList[i].remove('is_up');
        getList[i].remove('is_del');
        getList[i].remove('check');
      }
    }
    getOrders();
  }

  //获取订单详情
  void getOrders() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> map = Map();
    map.putIfAbsent("list", () => getList);
    StoreServer().getOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      
      all = success['total_amount'].toString();
      listview = success['goods'];
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }


  //提交订单
  void payOrder(obj) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("", () => obj);
    StoreServer().getSubmitOrder(map, (success) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast('提交成功');
      await Future.delayed(Duration(seconds: 2), () {
        NavigatorUtils.toOrderDetail(context, success['res']['order_id'], true);
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('提交订单'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: PublicColor.themeColor,
      ),
      body: contentWidget(),
      bottomNavigationBar: new BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: StyleUtil.padding(left: 10),
              child: Row(
                children: <Widget>[
                  Text('总额：',
                      style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                  Text('￥' + all, style: StyleUtil.tontStyle()),
                ],
              ),
            ),
            Container(
              color: PublicColor.themeColor,
              child: FlatButton(
                child: Text('提交订单',
                    style: StyleUtil.tontStyle(color: PublicColor.whiteColor)),
                onPressed: () {
                  print('提交订单');
                  // print(getList);
                  if(_courseName.text == '') {
                    return ToastUtil.showToast('请输入收货人姓名');
                  } else if (!RegExpTest.checkformate.hasMatch(_courseName.text)) {
                    return ToastUtil.showToast('收货人姓名格式不对!');
                  } else if(_phone.text == '') {
                    return ToastUtil.showToast('请输入手机号');
                  } else if (!RegExpTest.regMobile.hasMatch(_phone.text)) {
                    return ToastUtil.showToast('请输入正确的手机号码!');
                  } else if(_provinces.text == '') {
                    return ToastUtil.showToast('请输入所在地区');
                  } else if(_address.text == '') {
                    return ToastUtil.showToast('请输入详细地址');
                  } else if (!RegExpTest.checkformate.hasMatch(_address.text)) {
                    return ToastUtil.showToast('详细地址格式不对');
                  }
                  Map obj = {
                    "list":getList,
                    "receiving_info":{
                      "receiver":_courseName.text,
                      "phone":_phone.text,
                      "address":_provinces.text,
                      "full_address":_address.text,
                    },
                    "comment":_remark.text
                  };
                  print(obj);
                 payOrder(obj);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget contentWidget() {
    return Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: StyleUtil.width(10)),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text('收货人姓名',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      width: StyleUtil.width(210),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          autofocus: false,
                          controller: _courseName,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入收货人姓名",
                            hintStyle: StyleUtil.tontStyle(
                                color: PublicColor.inputHintColor),
                          )),
                    )
                  ],
                )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text('手机号',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      width: StyleUtil.width(210),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          autofocus: false,
                          controller: _phone,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入手机号",
                            hintStyle: StyleUtil.tontStyle(
                                color: PublicColor.inputHintColor),
                          )),
                    )
                  ],
                )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text('所在地区',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      width: StyleUtil.width(210),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          CityPicker.showCityPicker(
                            context,
                            selectProvince: (value) {
                              _provinces.text = '';
                              _provinces.text =
                                  _provinces.text + value['name'].toString();
                              province = value['name'].toString();
                            },
                            selectCity: (value) {
                              _provinces.text = _provinces.text +
                                  '-' +
                                  value['name'].toString();
                              city = value['name'].toString();
                            },
                            selectArea: (value) {
                              setState(() {
                                _provinces.text = _provinces.text +
                                    '-' +
                                    value['name'].toString();
                                region = value['name'].toString();
                              });
                            },
                          );
                        },
                        child: TextFormField(
                            autofocus: false,
                            controller: _provinces,
                            enabled: false,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入所在地区",
                              hintStyle: StyleUtil.tontStyle(
                                  color: PublicColor.inputHintColor),
                            )),
                      ),
                    )
                  ],
                )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text('详细地址',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      width: StyleUtil.width(210),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          autofocus: false,
                          controller: _address,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入详细地址",
                            hintStyle: StyleUtil.tontStyle(
                                color: PublicColor.inputHintColor),
                          )),
                    )
                  ],
                )),
            SizedBox(height: StyleUtil.width(20)),
            ...listview.map((item) => dingdanitem(item)).toList(),
            // Container(
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border(bottom: StyleUtil.borderBottom())),
            //     padding: StyleUtil.paddingTow(left: 27, top: 40),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: <Widget>[
            //         Text('运费',
            //             style:
            //                 StyleUtil.tontStyle(color: PublicColor.textColor)),
            //         Text('10.00',
            //             style:
            //                 StyleUtil.tontStyle(color: PublicColor.textColor)),
            //       ],
            //     )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text('备注',
                          style: StyleUtil.tontStyle(
                              color: PublicColor.textColor)),
                      width: StyleUtil.width(207),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                          autofocus: false,
                          textAlign: TextAlign.end,
                          controller: _remark,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: "选填",
                            hintStyle: StyleUtil.tontStyle(
                                color: PublicColor.inputHintColor),
                          )),
                    ),
                  ],
                )),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: StyleUtil.borderBottom())),
                padding: StyleUtil.paddingTow(left: 27, top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('小计',
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    Text('￥' + all, style: StyleUtil.tontStyle()),
                  ],
                )),
            SizedBox(height: StyleUtil.width(20)),
          ],
        ));
  }

  Widget dingdanitem(item) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: StyleUtil.borderBottom())),
        padding: StyleUtil.paddingTow(left: 28, top: 52),
        child: Row(
          children: <Widget>[
             CachedImageView(
              ScreenUtil.instance.setWidth(167.0),
              ScreenUtil.instance.setWidth(167.0),
              item['thumb'],
              null,
              BorderRadius.all(Radius.circular(0))),
            SizedBox(width: StyleUtil.width(10)),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left:10),
                    alignment: Alignment.centerLeft,
                    child: Text(item['name'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: StyleUtil.tontStyle(
                            color: Color(0xff333333), num: 30)),
                  ),
                  SizedBox(height: StyleUtil.width(50)),
                  Container(
                     padding: EdgeInsets.only(left:10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Text('￥', style: StyleUtil.tontStyle()),
                              Text(item['price'].toString(),
                                  style: StyleUtil.tontStyle(num: 33)),
                            ],
                          ),
                        ),
                         Expanded(
                          flex: 1,
                          child: Row(
                            children: <Widget>[
                              Text('运费', style: StyleUtil.tontStyle(color: PublicColor.textColor)),
                              Text(item['fare'].toString(),
                                  style: StyleUtil.tontStyle(color: PublicColor.textColor,num:30)),
                            ],
                          ),
                        ),
                        Text(
                          'x' + item['num'].toString(),
                          style:
                              StyleUtil.tontStyle(color: PublicColor.goodsNum),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        )
        );
  }
}
