import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchCardWidget extends StatefulWidget {
  final FocusNode focusNode;
  TextEditingController textEditingController;
  final VoidCallback onTap;
  final bool isShowLeading;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final bool isShowSuffixIcon;
  final double elevation;
  Widget rightWidget;

  SearchCardWidget({
    Key key,
    this.focusNode,
    this.textEditingController,
    this.onTap,
    this.isShowLeading = true,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.isShowSuffixIcon = true,
    this.hintText,
    this.elevation = 2.0,
    this.rightWidget,
  }) : super(key: key);

  @override
  _SearchCardWidgetState createState() => _SearchCardWidgetState();
}

class _SearchCardWidgetState extends State<SearchCardWidget> {
//  TextEditingController textEditingController;
  String _hintText;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _hintText = widget.hintText;
    _hintText ??= '点击搜索主播名称、ID号';
    if (widget.textEditingController == null) {
      widget.textEditingController = TextEditingController();
    }

    return searchCard();
  }

  Widget searchCard() => Padding(
        padding: const EdgeInsets.only(top: 0, right: 0),
        child: Card(
          elevation: widget.elevation,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ), //设置圆角
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.isShowLeading
                    ? Padding(
                        padding: EdgeInsets.only(
                          right: ScreenUtil.instance.setWidth(10),
                          top: 0,
                          left: ScreenUtil.instance.setWidth(10),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: ScreenUtil.instance.setWidth(40),
                        ),
                      )
                    : SizedBox(
                        width: ScreenUtil.instance.setWidth(20),
                      ),
                Expanded(
                  child: Container(
                    height: ScreenUtil.instance.setWidth(68),
                    child: TextField(
                      autofocus: widget.autofocus,
                      onTap: widget.onTap,
                      focusNode: widget.focusNode,
                      style:
                          TextStyle(fontSize: ScreenUtil.instance.setWidth(30)),
                      controller: widget.textEditingController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 0),
                        border: InputBorder.none,
                        hintText: _hintText,
                        suffixIcon: widget.textEditingController.text.length ==
                                    0 ||
                                !widget.isShowSuffixIcon
                            ? SizedBox()
                            : Container(
                                width: ScreenUtil.instance.setWidth(40),
                                height: ScreenUtil.instance.setWidth(40),
                                alignment: Alignment.centerRight,
                                child: new IconButton(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil.instance.setWidth(12)),
                                  iconSize: ScreenUtil.instance.setWidth(40),
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.grey[500],
                                    size: ScreenUtil.instance.setWidth(32),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.textEditingController.text = '';
                                      widget.onChanged('');
                                    });
                                  },
                                ),
                              ),
                      ),
                      onSubmitted: widget.onSubmitted,
                      onChanged: widget.onChanged,
//                      onChanged: (value){
//                        print('_GZXSearchCardWidgetState.searchCard  ${widget.textEditingController.text}');
//                      },
//                     ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
