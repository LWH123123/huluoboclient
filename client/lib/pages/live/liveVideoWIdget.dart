import 'package:client/common/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class LiveVideo extends StatefulWidget {
  final listItem;
  final changePlay;
  LiveVideo({this.listItem,this.changePlay});
  @override
  _LiveVideoState createState() => _LiveVideoState();
}

class DottedLineWidget extends StatelessWidget {
  final Axis axis; // 虚线的方向
  final double width; // 整个虚线的宽度
  final double height; // 整个虚线的高度
  final double lineWidth; // 每根虚线的宽度
  final double lineHeight; // 每根虚线的高度
  final int count; // 虚线内部实线的个数
  final Color color; // 虚线的颜色

  DottedLineWidget({
    Key key,
    @required this.axis,
    this.width,
    this.height,
    this.lineWidth,
    this.lineHeight,
    this.count,
    this.color = const Color(0xffff0000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Flex(
            direction: this.axis,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              this.count,
              (int index) {
                return SizedBox(
                  width: this.lineWidth,
                  height: this.lineHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: this.color,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _LiveVideoState extends State<LiveVideo> with TickerProviderStateMixin {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;
  Map item = {};
  @override
  void initState() {
    super.initState();
    item = widget.listItem;
  }

  void playsss(item) {
    widget.changePlay(item);
    _videoPlayerController1 =
        VideoPlayerController.network(item['huifang_url']);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 7/10,
      autoPlay: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {
      item['isplay'] = true;
    });
  }

  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 17,
            child: Container(
              width: ScreenUtil().setWidth(20),
              height: ScreenUtil().setWidth(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil.instance.setWidth(40),
            ),
            height: ScreenUtil.instance.setWidth(400),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: ScreenUtil.instance.setWidth(40),
                      ),
                      child: DottedLineWidget(
                        axis: Axis.vertical,
                        width: 1.0,
                        height: 354.0,
                        lineHeight: 5,
                        lineWidth: 0.5,
                        count: 20,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(550),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['create_at'],
                            style: TextStyle(
                              color: Color(0xff969696),
                              fontSize: ScreenUtil.instance.setWidth(24),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil.instance.setWidth(18),
                          ),
                          width: ScreenUtil().setWidth(550),
                          child: Text(
                            item['desc'],
                            style: TextStyle(
                              color: Color(0xff474747),
                              fontSize: ScreenUtil.instance.setWidth(26),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(555),
                              height: ScreenUtil().setWidth(300),
                              color: Colors.black,
                              child: item['isplay']
                                  ? Chewie(
                                      controller: _chewieController,
                                    )
                                  : Container(
                                      width: ScreenUtil().setWidth(555),
                                      height: ScreenUtil().setWidth(300),
                                      decoration: item['img'] != ""
                                          ? BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  item['img'],
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : BoxDecoration(),
                                      child: InkWell(
                                        onTap: () {
                                            item['huifang_url'] != '' ? playsss(item): '';
                                          //playsss(item);
                                        },
                                        child: item['is_huifang'] != "0" ?Image.asset(
                                          "assets/zhibo/play.png",
                                          width: ScreenUtil().setWidth(60),
                                          height: ScreenUtil().setWidth(60),
                                        ): SizedBox(),
                                      ),
                                    ),
                            ),
                            Positioned(
                              left: ScreenUtil().setWidth(10),
                              top: ScreenUtil().setWidth(10),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(200),
                                    height: ScreenUtil().setWidth(40),
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(14)),
                                    decoration: BoxDecoration(
                                      color: Color(0xaa000000),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(15),
                                            right: ScreenUtil().setWidth(15),
                                          ),
                                          height: ScreenUtil().setWidth(40),
                                          decoration: BoxDecoration(
                                            color: Color(0xaa000000),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            item['is_huifang'] == "0" ? '无视频':
                                            item['is_huifang'] == "1"
                                                ? '生成中'
                                                : '可回放',
                                            style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setWidth(20),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          (int.parse(item['views'].toString()) >
                                                      10000
                                                  ? ((int.parse(item['views']
                                                                      .toString()) ~/
                                                                  1000) /
                                                              10)
                                                          .toString() +
                                                      'w'
                                                  : item['views'].toString()) +
                                              '人观看',
                                          style: TextStyle(
                                              fontSize:
                                                  ScreenUtil().setWidth(14),
                                              color: Colors.white),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
