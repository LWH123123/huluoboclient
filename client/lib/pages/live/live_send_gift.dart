import 'package:client/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//  送礼物动画
class SendGift extends StatefulWidget {
  final Map giftData;
  final Function giftEnd;
  SendGift({this.giftData, this.giftEnd});
  @override
  SendGiftState createState() => SendGiftState();
}

class SendGiftState extends State<SendGift>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animatecontroller;
  var _statusListener;
  bool isAnimating = false;

  void _gestureTap() {
    _statusListener = (AnimationStatus status) {
      print('$status');
      if (status == AnimationStatus.completed) {
        widget.giftEnd();
        isAnimating = false;
        animatecontroller.reset();
        animation.removeStatusListener(_statusListener);
      }
    };

    animation = Tween<double>(
      begin: -ScreenUtil.instance.setWidth(410),
      end: ScreenUtil.instance.setWidth(25),
    ).animate(
      CurvedAnimation(
        parent: animatecontroller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener(_statusListener);
    animatecontroller.reset();
    animatecontroller.forward();
    isAnimating = true;
  }

  @override
  void initState() {
    super.initState();
    animatecontroller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _gestureTap();
  }

  @override
  void dispose() {
    animatecontroller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 600)..init(context);

    // 送礼物动效点击弹窗
    Widget giftInfo(BuildContext context) {
      return Material(
        type: MaterialType.transparency, //透明类型
        child: Center(
          child: new Container(
            width: ScreenUtil.instance.setWidth(620.0),
            height: ScreenUtil.instance.setWidth(255.0),
            padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(20),
                left: ScreenUtil().setWidth(20)),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            child: new Column(children: [
              Container(
                alignment: Alignment.centerRight,
                height: ScreenUtil.instance.setWidth(50.0),
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(15)),
                child: InkWell(
                  child: Image.network(
                    widget.giftData['img'],
                    width: ScreenUtil.instance.setWidth(40.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: ScreenUtil().setWidth(118),
                height: ScreenUtil().setWidth(118),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(59),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(59),
                  child: Image.asset(
                    widget.giftData['headimgurl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  widget.giftData['nickname'],
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(30),
                    color: Colors.black,
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    return Positioned(
      child: Container(
        width: ScreenUtil.instance.setWidth(420.0),
        height: ScreenUtil.instance.setWidth(80.0),
        child: Row(children: [
          Container(
            width: ScreenUtil.instance.setWidth(350.0),
            height: ScreenUtil.instance.setWidth(80.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Row(children: [
              new SizedBox(
                width: ScreenUtil.instance.setWidth(12.0),
              ),
              CachedImageView(
                ScreenUtil.instance.setWidth(65.0),
                ScreenUtil.instance.setWidth(65.0),
                widget.giftData['headimgurl'],
                null,
                BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              new SizedBox(width: ScreenUtil.instance.setWidth(15.0)),
              new InkWell(
                child: Container(
                  height: ScreenUtil.instance.setWidth(80.0),
                  width: ScreenUtil.instance.setWidth(170.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.giftData['nickname'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil.instance.setWidth(28.0),
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1),
                      Text('送出' + widget.giftData['name'],
                          style: TextStyle(
                            color: Color(0xfffc9c5c5),
                            fontSize: ScreenUtil.instance.setWidth(24.0),
                          ),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1)
                    ],
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return giftInfo(context);
                    },
                  );
                },
              ),
              Image.network(
                widget.giftData['img'],
                width: ScreenUtil.instance.setWidth(70.0),
              )
            ]),
          ),
          Container(
            height: ScreenUtil.instance.setWidth(80.0),
            width: ScreenUtil.instance.setWidth(70.0),
            alignment: Alignment.center,
            child: Text(
              'x1',
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil.instance.setWidth(28.0),
              ),
            ),
          )
        ]),
      ),
      left: animation != null
          ? animation.value
          : -ScreenUtil.instance.setWidth(400.0),
      top: ScreenUtil.instance.setWidth(50.0),
    );
  }
}
