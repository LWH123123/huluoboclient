
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
class LiveShare extends StatefulWidget {
  @override
  LiveShareState createState() => LiveShareState();
}

class LiveShareState extends State<LiveShare> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return new Container(
      color: Colors.white,
      height: ScreenUtil.instance.setWidth(250.0),
      padding: EdgeInsets.only(
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setWidth(15),
      ),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setWidth(25)),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/live/weixin.png',
                        width: ScreenUtil.instance.setWidth(97.0),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text(
                        '微信好友',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.instance.setWidth(26.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print('微信好友');
                  fluwx.shareToWeChat(
                      fluwx.WeChatShareWebPageModel(
                          title: 'asdasd',
                          description: 'asdasd',
                      webPage: 'https://www.baidu.com/',
                      thumbnail: 'http://image.muyuzhibo.com/2020-04-24/muyu_cf563d45dc493e769a682c6ff5393674.png',
                      scene: fluwx.WeChatScene.SESSION
                  )
                  ).then((data) {
                  print (data);
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Image.asset(
                        'assets/live/pyq.png',
                        width: ScreenUtil.instance.setWidth(97.0),
                      ),
                      new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                      Text('朋友圈',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil.instance.setWidth(26.0),
                              fontWeight: FontWeight.w500)),
                    ])),
                onTap: () {
                  print('朋友圈');
                  fluwx.shareToWeChat(
                      fluwx.WeChatShareWebPageModel(
                          title: 'asdasd',
                          description: 'asdasd',
                          webPage: 'https://www.baidu.com/',
                          thumbnail: 'http://image.muyuzhibo.com/2020-04-24/muyu_cf563d45dc493e769a682c6ff5393674.png',
                          scene: fluwx.WeChatScene.TIMELINE
                      )
                  ).then((data) {
                    print (data);
                  });
                },
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: InkWell(
            //     child: Container(
            //         alignment: Alignment.center,
            //         child: Column(children: [
            //           Image.asset(
            //             'assets/index/xcx.png',
            //             width: ScreenUtil.instance.setWidth(97.0),
            //           ),
            //           new SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
            //           Text('小程序',
            //               style: TextStyle(
            //                   color: Colors.black,
            //                   fontSize: ScreenUtil.instance.setWidth(26.0),
            //                   fontWeight: FontWeight.w500)),
            //         ])),
            //     onTap: () {
            //       print('小程序');
            //     },
            //   ),
            // ),
          ]),
        )
      ]),
    );
  }
}
