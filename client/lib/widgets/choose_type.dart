import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';

//直播分类弹窗

class FenleiWidget extends StatefulWidget {
  final Function onChanged;
  final List typeList;
  final String title;
  final int selectId;
  FenleiWidget({
    Key key,
    @required this.onChanged,
    @required this.typeList,
    @required this.selectId,
    @required this.title,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => DialogFenleiState();
}

class DialogFenleiState extends State<FenleiWidget> {
  int groupValue = 0;
  double containerHeight = 0.0;
  @override
  void initState() {
    groupValue = widget.selectId;
    containerHeight = 75 * widget.typeList.length * 1.0 + 200;
    super.initState();
  }

  @override
  Widget build(BuildContext content) {
    Widget title = new Container(
      // alignment: Alignment.centerLeft,
      height: ScreenUtil().setWidth(75),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
          topRight: Radius.circular(14),
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            child: new Text(
              widget.title,
              style: TextStyle(
                fontSize: ScreenUtil.instance.setWidth(30.0),
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.only(
              right: ScreenUtil().setWidth(50),
            ),
            child: InkWell(
              child: Image.asset(
                'assets/index/gb.png',
                width: ScreenUtil.instance.setWidth(40.0),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
    );

    Widget listbuild() {
      List<Widget> arr = <Widget>[];
      Widget content;
      if (widget.typeList.length != 0) {
        for (var item in widget.typeList) {
          arr.add(
            RadioListTile<int>(
              value: item['id'],
              groupValue: groupValue,
              onChanged: (int value) {
                setState(() {
                  groupValue = value;
                });
                widget.onChanged(item);
                Navigator.of(context).pop();
              },
              title: new Text(
                item['name'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ScreenUtil().setSp(28),
                ),
              ),
              dense: true,
              activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
              isThreeLine: false, // 是否空出第三行
              selected: false,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        }
      }
      content = ListView(
        children: arr,
      );
      return content;
    }

    return Container(
      height: ScreenUtil().setWidth(containerHeight),
      child: Stack(children: <Widget>[
        Container(
          height: ScreenUtil.instance.setWidth(40.0),
          width: double.infinity,
          color: Colors.black54,
        ),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
        ),
        title,
        Container(
          margin: EdgeInsets.only(top: ScreenUtil.instance.setWidth(100.0)),
          child: listbuild(),
        ),
        
      ]),
    );
  }
}
