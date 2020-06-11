import 'package:flutter/material.dart';
class RoundCheckBox extends StatefulWidget {
  var value = false;

  final Function(bool) onChanged;

  RoundCheckBox({Key key, @required this.value, this.onChanged})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: widget.value
                ? Icon(
                    Icons.adjust,
                    size: 25.0,
                    color: Color(0xffE61414),//radio选中颜色
                  )
                : Icon(
                    Icons.panorama_fish_eye,
                    size: 25.0,
                    color: Colors.grey,
                  ),
          )),
    );
  }
}