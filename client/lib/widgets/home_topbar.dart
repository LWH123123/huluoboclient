import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './search_card.dart';
import '../routers/Navigator_util.dart';
class TopBar extends StatelessWidget {
  // This ui.widget is the root of your application.
  final TextEditingController _keywordTextEditingController = TextEditingController();

  final List<String> searchHintTexts;

  TopBar({Key key, this.searchHintTexts}) : super(key: key);

  final FocusNode _focus = new FocusNode();

  // BuildContext _context;

  void _onFocusChange() {
//    print('HomeTopBar._onFocusChange${_focus.hasFocus}');
//    if(!_focus.hasFocus){
//      return;
//    }
//    NavigatorUtils.gotoSearchGoodsPage(_context);
  }

  @override
  Widget build(BuildContext context) {
    // _context = context;
    _focus.addListener(_onFocusChange);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: PublicColor.themeColor,
      padding: EdgeInsets.only(top: statusBarHeight, left: 0, right: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SearchCardWidget(
              elevation: 0,
              onTap: (){
                // FocusScope.of(context).requestFocus(FocusNode());
                 NavigatorUtils.goSearch(context);
              },
              textEditingController: _keywordTextEditingController,
              focusNode: _focus,
            ),
          ),
       
        ],
      ),
    );
  }
}
