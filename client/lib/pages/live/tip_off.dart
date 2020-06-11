//import 'package:client/utils/uploadUtils.dart';
import 'package:client/utils/upload.dart';
import 'package:flutter/material.dart';
import '../../common/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/toast_util.dart';
import '../../service/live_service.dart';
//import '../../common/Selectimg.dart';
import '../../service/user_service.dart';
import '../../widgets/dialog.dart';
import '../../widgets/loading.dart';

class TipPage extends StatefulWidget {
  final oid;
  TipPage({this.oid});
  @override
  TipPageState createState() => TipPageState();
}

class TipPageState extends State<TipPage> {
  TextEditingController descController = TextEditingController();
  FocusNode _commentFocus = FocusNode();
  Map groupValue = {"id": 1, "name": "色情暴力赌博"};
  bool isLoading = false;
  String img = "";
  List reportList = [
    {"id": 1, "name": "色情暴力赌博"},
    {"id": 2, "name": "敏感信息"},
    {"id": 3, "name": "民族宗教歧视"},
    {"id": 4, "name": "空镜头挂机"},
    {"id": 5, "name": "其他"},
  ];
  void config() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => widget.oid);
    map.putIfAbsent("reason", () => groupValue['name']);
    map.putIfAbsent("desc", () => descController.text);
    map.putIfAbsent("img", () => img);
    LiveServer().liveReport(map, (success) async {
      setState(() {
        isLoading = false;
        descController.text = "";
        img = "";
        groupValue['id'] = 1;
        groupValue['name'] = "色情暴力赌博";
      });
      ToastUtil.showToast('举报已提交');
      unFouce();
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void upImgLoad(images) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> map = Map();
    map.putIfAbsent("info", () => images);

    UserServer().uploadImg(map, (success) async {
      setState(() {
        isLoading = false;
        img = success['src'];
      });
    }, (onFail) async {
      setState(() {
        isLoading = false;
      });
      ToastUtil.showToast(onFail);
    });
  }

  void unFouce() {
    _commentFocus.unfocus(); // input失去焦点
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    Widget listArea() {
      List<Widget> arr = <Widget>[];
      Widget content;
      for (var item in reportList) {
        arr.add(
          RadioListTile<int>(
            value: item['id'],
            groupValue: groupValue['id'],
            onChanged: (int value) {
              setState(() {
                groupValue = item;
              });
            },
            title: new Text(item['name'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(28),
                )),
            dense: false,
            activeColor: PublicColor.themeColor, // 指定选中时勾选框的颜色
            isThreeLine: false, // 是否空出第三行
            selected: false,
            controlAffinity: ListTileControlAffinity.trailing,
          ),
        );
      }
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: arr,
      );
      return content;
    }

    Widget tipArea = new Container(
      // alignment: Alignment.centerLeft,
      // height: ScreenUtil().setHeight(608),
      width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),

      child: listArea(),
    );

    Widget disArea = new Container(
      margin: EdgeInsets.only(top: 10),
      width: ScreenUtil().setWidth(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Color(0xffe5e5e5), width: 1),
      ),
      child: new TextField(
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        controller: descController,
        focusNode: _commentFocus,
        decoration: const InputDecoration(
          hintText: '添加描述(选填)',
          contentPadding: const EdgeInsets.all(10.0),
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        // 当 value 改变的时候，触发
      ),
    );

    Widget btnArea = new Container(
      height: ScreenUtil().setWidth(86),
      width: ScreenUtil().setWidth(640),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: PublicColor.themeColor,
          borderRadius: new BorderRadius.circular((8.0))),
      child: new FlatButton(
        disabledColor: PublicColor.themeColor,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return MyDialog(
                  width: ScreenUtil.instance.setWidth(600.0),
                  height: ScreenUtil.instance.setWidth(300.0),
                  queding: () {
                    config();
                    Navigator.of(context).pop();
                  },
                  quxiao: () {
                    Navigator.of(context).pop();
                  },
                  title: '温馨提示',
                  message: '确定举报该直播？');
            },
          );
        },
        child: new Text(
          '提交',
          style: TextStyle(
              color: PublicColor.btnColor,
              fontSize: ScreenUtil().setSp(28),
              fontWeight: FontWeight.w600),
        ),
      ),
    );

    Widget addImg = new Container(
        alignment: Alignment.topLeft,
        //height: ScreenUtil().setWidth(100),
        width: ScreenUtil().setWidth(700),
        margin: EdgeInsets.only(top: 10),
        child: Container(
            alignment: Alignment.centerLeft,
            width: ScreenUtil().setWidth(180),
            height: ScreenUtil().setWidth(180),
            child: InkWell(
              child: img == ""
                  ? new Image.asset(
                      'assets/zhibo/addimg.png',
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(280),
                      height: ScreenUtil().setWidth(280),
                    )
                  : new Image.network(
                      img,
                      fit: BoxFit.cover,
                      width: ScreenUtil().setWidth(280),
                      height: ScreenUtil().setWidth(280),
                    ),
              onTap: () {
                Upload.gallery_photo().then((onValue) {
                  upImgLoad(onValue["base64"]);
                });
               /* SelectImg().select((base64) {
                  upImgLoad(base64);
                });*/
              },
            )));

    return Stack(
      children: <Widget>[
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: new Text(
                '直接举报',
                style: TextStyle(
                  color: PublicColor.headerTextColor,
                ),
              ),
              backgroundColor: PublicColor.themeColor,
              leading: new IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                iconSize: 27.0,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: new Container(
              alignment: Alignment.center,
              child: new Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // padding:EdgeInsets.only(top:10,left:20),
                      child: new Text('请选择举报原因',
                          style: new TextStyle(
                              fontSize: ScreenUtil().setSp(28.0))),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0)),
                  new SizedBox(
                    height: ScreenUtil().setWidth(20),
                  ),
                  tipArea,
                  disArea,
                  Container(
                    child: new Text(
                      '上传凭证(选填)',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(15, 8, 5, 0),
                  ),
                  addImg,
                  btnArea
                ],
              ),
            ),
            resizeToAvoidBottomPadding: false, //输入框抵住键盘 内容不随键盘滚动
          ),
        ),
        isLoading ? LoadingDialog() : Container()
      ],
    );
  }
}
