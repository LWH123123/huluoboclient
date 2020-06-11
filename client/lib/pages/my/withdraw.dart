import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../routers/Navigator_util.dart';
import '../../widgets/loading.dart';
import '../../service/user_service.dart';
import '../../utils/toast_util.dart';

class Withdraw extends StatefulWidget {
  final String nums;
  Withdraw({this.nums});
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  TextEditingController _num = TextEditingController();
  TextEditingController _account = TextEditingController();
  String classType = '请选择提现方式';
  int groupValue = 0;
  String type = '';
  @override
  void initState() {
    super.initState();
    print(widget.nums);
  }

  void getTxApi() async {
    if (classType == '请选择提现方式') {
      ToastUtil.showToast('请选择提现方式');
      return;
    }
    if (_num.text == '') {
      ToastUtil.showToast('请输入提现金额');
      return;
    }
     if (_account.text == '') {
      ToastUtil.showToast('请输入提现账号');
      return;
    }

    if (classType == '微信') {
      type = '2';
    }

    if (classType == '支付宝') {
      type = '1';
    }
    Map<String, dynamic> map = Map();
    map.putIfAbsent("type", () => type);
    map.putIfAbsent("money", () => _num.text);
    map.putIfAbsent("account", () => _account.text);
    UserServer().getTxApi(map, (success) async {
      ToastUtil.showToast('提现成功');
     classType = '请选择提现方式';
      _num.text = '';
      _account.text = '';
       await Future.delayed(Duration(seconds: 1), () {
           NavigatorUtils.goWithdrawalRecord(context,true);
        });
    }, (onFail) async {
      ToastUtil.showToast(onFail);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    Widget topArea = new Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setWidth(120),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffE5E5E5)))),
      child: new Row(
        children: <Widget>[
          Expanded(
              flex: 6,
              child: Text(
                '当前可提现佣金',
                style: TextStyle(
                  color: Color(0xff5E5E5E),
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(30),
                ),
              )),
          Expanded(
              flex: 2,
              child: Text(
                '￥' + widget.nums,
                style: TextStyle(
                  color: Color(0xffE92F2F),
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(30),
                ),
              ))
        ],
      ),
    );

    Widget tixianArea = new Container(
      width: ScreenUtil().setWidth(750),
      child: new Column(children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffE5E5E5)))),
          child: new Row(
            children: <Widget>[
              Expanded(
                  flex: 4,
                  child: Text(
                    '提现方式',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  )),
              Expanded(
                flex: 0,
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogFenleiState();
                        });
                  },
                  child: Text(
                    classType,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(28),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: new Icon(
                  Icons.navigate_next,
                  color: Color(0xff999999),
                ),
              )
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffE5E5E5)))),
          child: new Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                '提现金额',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              )),
              Expanded(
                flex: 3,
                child: new TextField(
                  controller: _num,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.end,
                  decoration: new InputDecoration(
                      hintText: '请输入提现金额', border: InputBorder.none),
                ),
              )
            ],
          ),
        ),
        Container(
          height: ScreenUtil().setWidth(120),
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xffE5E5E5)))),
          child: new Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                '提现账号',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(28),
                ),
              )),
              Expanded(
                flex: 3,
                child: new TextField(
                  controller: _account,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.end,
                  decoration: new InputDecoration(
                      hintText: '请输入提现账号', border: InputBorder.none),
                ),
              )
            ],
          ),
        ),
        Container(
          child: InkWell(
              onTap: () {
                print('提交');
                print(_num.text);
                getTxApi();
              },
              child: Container(
                margin: EdgeInsets.only(top: 150),
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(570),
                height: ScreenUtil().setWidth(92),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffE71419),
                ),
                child: Text(
                  '提交',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ),
              )),
        )
      ]),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: PublicColor.themeColor,
        title: Text('佣金提现'),
        actions: <Widget>[
          InkWell(
            child: Container(
                padding: const EdgeInsets.only(right: 14.0),
                child: Text(
                  '提现记录',
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(30),
                    height: 2.7,
                  ),
                )),
            onTap: () {
              
              NavigatorUtils.goWithdrawalRecord(context);
            },
          )
        ],
      ),
      body: Container(
          child: new ListView(children: <Widget>[
        topArea,
        new SizedBox(
          height: ScreenUtil().setWidth(30),
        ),
        tixianArea
      ])),
    );
  }

  //支付方式
  Widget DialogFenleiState() {
    return Container(
      height: 170,
      child: Column(
        children: <Widget>[
          Container(
            padding: StyleUtil.paddingTow(left: 20, top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '提现方式',
                  style: StyleUtil.tontStyle(
                      color: PublicColor.textColor, num: 32),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset('assets/mine/icon_guanbi.png',
                      width: StyleUtil.width(40)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              children: <Widget>[
                RadioListTile<int>(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        classType = '微信';
                      });
                      Navigator.of(context).pop();
                    },
                    title: Text("微信",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    dense: true,
                    activeColor: PublicColor.themeColor,
                    // 指定选中时勾选框的颜色
                    isThreeLine: false,
                    // 是否空出第三行
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing),
                RadioListTile<int>(
                    value: 2,
                    groupValue: groupValue,
                    title: Text("支付宝",
                        style:
                            StyleUtil.tontStyle(color: PublicColor.textColor)),
                    activeColor: PublicColor.themeColor,
                    isThreeLine: false,
                    dense: true,
                    selected: false,
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (int value) {
                      setState(() {
                        groupValue = value;
                        classType = '支付宝';
                      });
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
