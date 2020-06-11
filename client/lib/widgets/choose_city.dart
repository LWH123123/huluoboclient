import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/checkbox.dart';

//直播分类弹窗

class ChooseCityWidget extends StatefulWidget {
  final keys;
  final List city;
  final Function configCity;
  final Map mainCity;
  // final int selectId;
  ChooseCityWidget({
    Key key,
    @required this.keys,
    @required this.city,
    @required this.configCity,
    @required this.mainCity,
    // @required this.title,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => ChooseCityWidgetState();
}

class ChooseCityWidgetState extends State<ChooseCityWidget> {
  bool groupValue = false;

  @override
  void initState() {
    print('widget.mainCity---->>>${widget.mainCity}');
    setState(() {
      widget.mainCity.forEach((key, item) {
        if (widget.keys != key) {
          item.forEach((keyc, itemc) {
            if (itemc['name'] == widget.city[keyc]['name']) {
              widget.city[keyc]['isSelect'] = true;
            }
          });
        } else {
          item.forEach((keyc, itemc) {
            if (itemc['name'] == widget.city[keyc]['name']) {
              widget.city[keyc]['isSelect'] = false;
              widget.city[keyc]['flag'] = true;
            }
          });
        }
      });
    });

    super.initState();
  }

  bool _checkedAll() {
    for (var i = 0; i < widget.city.length; i++) {
      if (!widget.city[i]['flag']) {
        return false;
      }
    }
    return true;
  }

  _checkedAllitem(bool isCheck) {
    for (var i = 0; i < widget.city.length; i++) {
      if (!widget.city[i]['isSelect']) {
        widget.city[i]['flag'] = isCheck;
      }
    }
  }

  @override
  Widget build(BuildContext content) {
    Widget title = new Container(
        // alignment: Alignment.centerLeft,
        height: ScreenUtil().setWidth(75),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
                child: InkWell(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                      child: new Text(
                        '全部',
                        style: TextStyle(
                          fontSize: ScreenUtil.instance.setWidth(30.0),
                        ),
                      ),
                    ),
                    Container(
                      child: RoundCheckBox(
                        value: _checkedAll(),
                        onChanged: (bool) {
                          setState(() {
                            _checkedAllitem(bool);
                          });
                        },
                      ),
                    ),
                  ],
                )),
              ),
              new Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  child: InkWell(
                    child: Image.asset(
                      'assets/index/gb.png',
                      width: ScreenUtil.instance.setWidth(40.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.configCity(widget.city, widget.keys);
                    },
                  ))
            ]));

    Widget listbuild() {
      List<Widget> arr = <Widget>[title];
      Widget content;
      for (var item in widget.city) {
        arr.add(Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(30),
            right: ScreenUtil().setWidth(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item['name']),
              item['isSelect']
                  ? Container(
                      padding: EdgeInsets.only(
                        right: ScreenUtil().setWidth(26),
                        top: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(20),
                      ),
                      child: Image.asset(
                        "assets/shop/nock.png",
                        width: ScreenUtil().setWidth(40),
                      ),
                    )
                  : RoundCheckBox(
                      value: item['flag'],
                      onChanged: (bool) {
                        setState(() {
                          item['flag'] = bool;
                        });
                      },
                    ),
            ],
          ),
        ));
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    return new Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: listbuild(),
        ),
        // Container(
        //   height: ScreenUtil().setHeight(100),
        //   color: PublicColor.bodyColor,
        //   alignment: Alignment.center,
        //   child: InkWell(
        //     child: Text('完成'),
        //     onTap: () {
        //       Navigator.of(context).pop();
        //       widget.configCity(widget.city,widget.keys);
        //     },
        //   ),
        // )
      ],
    );
  }
}
