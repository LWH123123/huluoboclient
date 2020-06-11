import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/color.dart';

//直播分类弹窗

class ChooseCityBuildWidget extends StatefulWidget {
  final String name;
  final Map cityObj;
  ChooseCityBuildWidget({
    Key key,
    @required this.name,
    @required this.cityObj,
  }) : super(key: key);
  @override
  @override
  State<StatefulWidget> createState() => ChooseCityBuildWidgetState();
}

class ChooseCityBuildWidgetState extends State<ChooseCityBuildWidget> {
  bool groupValue = false;

  @override
  void initState() {
    if (widget.cityObj.containsKey(widget.name)) {
      groupValue = widget.cityObj[widget.name];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext content) {
    return new Container(
      child: CheckboxListTile(
        value: this.groupValue,
        onChanged: (bool value) {
          setState(() {
            groupValue = value;
          });
          // if(widget.cityObj.containsKey(widget.name)){
          //   widget.cityObj[widget.name] = value;
          // }else{
          widget.cityObj[widget.name] = value;
          // }
        },
        title: new Text(
          widget.name,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: ScreenUtil().setSp(28),
          ),
        ),
        activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
        selected: this.groupValue,
      ),
    );
  }
}
