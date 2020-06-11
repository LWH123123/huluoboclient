import 'package:client/common/color.dart';
import 'package:client/routers/Navigator_util.dart';
import 'package:client/service/course_service.dart';
import 'package:client/service/live_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeacherDetail extends StatefulWidget {
  String id;

  TeacherDetail({Key key, String this.id}) : super(key: key);

  @override
  _TeacherDetailState createState() => _TeacherDetailState();
}

class _TeacherDetailState extends State<TeacherDetail> {
  Map teacher;
  List course = [];
  List liveType = ['assets/home/wzb.png','assets/home/icon_zhibozhong.png','assets/home/jb.png'];
  String desc = '',room_id;
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '全部课程'),
    new Tab(text: '讲师介绍'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    this.getTeacherIndex();
    super.initState();
  }

  getTeacherIndex() {
    CourseService().getTeacherIndex({"teacher_id": widget.id}, (onSuccess) {
      setState(() {
        teacher = onSuccess['teacher'];
        course = onSuccess['course'];
        desc = onSuccess['teacher']['desc'];
        room_id = onSuccess['room_id'].toString();
      });
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  getTeacherCollect () {
    CourseService().getTeacherCollect({
      "teacher_id": teacher['id']
    }, (onSuccess) {
      if (teacher['collect_status'] == 0) {
        setState(() {
          teacher['collect_status'] = 1;
          ToastUtil.showToast('收藏成功');
        });
      } else {
        setState(() {
          teacher['collect_status'] = 0;
          ToastUtil.showToast('已取消收藏');
        });
      }
    }, (onFail) => ToastUtil.showToast(onFail));
  }

  // 获得推流地址
  getliveurl(productEntity) async {
    Map<String, dynamic> map = Map();
    map.putIfAbsent("room_id", () => room_id);
    LiveServer().inRoom(map, (success) async {
      Map obj = {'url': success['res']['rtmp_url']};
      // print(obj);
      NavigatorUtils.goSlideLookZhibo(context,room_id: productEntity['id'].toString());
    }, (onFail) async {
      if (onFail['errcode'].toString() == '10108') {
        Map obj= {
          'bgImg':onFail['room']['img'],//背景图
          'headimgurl':onFail['anchor']['headimgurl'],//头像
          'realName':onFail['anchor']['real_name'],//讲师名
          'name':onFail['room']['name'],//直播名称
          'price':onFail['room']['amount'],//直播价格
          'balance':onFail['user']['balance'],//余额
          'roomId':onFail['room']['id'],
          "productEntity": productEntity
        };
        ToastUtil.showToast(onFail['errmsg']);
        NavigatorUtils.goLivePay(context,obj);
      } else {
        ToastUtil.showToast(onFail['errmsg']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PublicColor.themeColor,
        title: Text(
          '讲师主页',
        ),
      ),
      body: Container(
        child: Column(children: [
          Container(
            child: Stack(children: [
              Image.asset(
                'assets/teacher/bg_jiangshizhuye.png',
                width: double.infinity,
                height: ScreenUtil().setHeight(270),
                fit: BoxFit.cover,
              ),
              Container(
                padding: StyleUtil.paddingTow(left: 34),
                margin: StyleUtil.padding(top: 47),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setWidth(150),
                              child: Stack(
                                children: <Widget>[
                                  ClipOval(
                                    // child:Image.asset("assets/mine/avatar.png"),
                                    child: Image.network(
                                      teacher != null
                                          ? teacher['headimgurl']
                                          : '',
                                      fit: BoxFit.cover,
                                      width: ScreenUtil().setWidth(150),
                                      height: ScreenUtil().setWidth(150),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                        liveType[teacher!=null ? teacher['is_open']: 0],
                                        width: ScreenUtil().setWidth(138),
                                        height: ScreenUtil().setWidth(44)),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              if (teacher['is_open'] == 1) {
                                getliveurl(teacher);
                              }
                            },
                          ),
                          SizedBox(width: StyleUtil.width(34)),
                          Text(teacher != null ? teacher['real_name'] : '',
                          style: StyleUtil.tontStyle(color: PublicColor.whiteColor,num: 32,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    Container(
                        width: StyleUtil.width(140),
                        height: StyleUtil.width(55),
                        child: OutlineButton(
                          padding: StyleUtil.paddingTow(left: 18),
                          borderSide: BorderSide(color: Colors.white),
                          splashColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: <Widget>[
                              Image.asset(// icon_shoucang.png
                                teacher!=null ? teacher['collect_status'] !=0?'assets/teacher/ixon_yishoucang.png' : 'assets/teacher/icon_shoucang.png': 'assets/teacher/icon_shoucang.png',
                                width: StyleUtil.width(34),
                                height: StyleUtil.width(32),
                              ),
                              SizedBox(width: StyleUtil.width(10)),
                              Text('收藏',
                                  style: StyleUtil.tontStyle(
                                      color: PublicColor.whiteColor, num: 27))
                            ],
                          ),
                          onPressed: () {
                            teacher!=null ? this.getTeacherCollect() : '';
                          },
                        ))
                  ],
                ),
              ),
            ]),
          ),
          Container(
            color: Colors.white,
            padding: StyleUtil.paddingTow(top: 24),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      teacher != null ? teacher['course_num'].toString() : '',
                      style: StyleUtil.tontStyle(
                          color: PublicColor.textColor, num: 36),
                    ),
                    SizedBox(height: StyleUtil.width(30)),
                    Text(
                      '课程数量',
                      style:
                          StyleUtil.tontStyle(color: Colors.black38, num: 30),
                    )
                  ],
                ),
              ),
              Container(
                width: 1,
                height: StyleUtil.width(100),
                color: Colors.black38,
                margin: StyleUtil.paddingTow(left: 130),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      teacher != null ? teacher['see_num'].toString() : '',
                      style: StyleUtil.tontStyle(
                          color: PublicColor.textColor, num: 36),
                    ),
                    SizedBox(height: StyleUtil.width(30)),
                    Text(
                      '学习人数',
                      style:
                          StyleUtil.tontStyle(color: Colors.black38, num: 30),
                    )
                  ],
                ),
              ),
            ]),
          ),
          SizedBox(height: StyleUtil.width(10)),
          Expanded(
            flex: 1,
            // width: ScreenUtil().setHeight(750),
            // height: ScreenUtil().setHeight(600),
            child: AllClass(),
          ),
        ]),
      ),
    );
  }

  Widget AllClass() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Material(
            color: Colors.white,
            child: TabBar(
              tabs: myTabs,
              indicatorColor: Colors.red,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.blueGrey,
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(28)),
            ),
          ),
        ),
        body: new TabBarView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: new ListView(
                  children: course
                      .map((item) => InkWell(
                    onTap: () {
                      NavigatorUtils.goCurriculumDetail(context,item['id']);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                          border:
                          Border(bottom: StyleUtil.borderBottom())),
                      child: Row(
                        children: <Widget>[
                          //图片
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(27)),
                            child: Stack(children: [
                              Positioned(
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      item['img'],
                                      fit: BoxFit.cover,
                                      width: ScreenUtil().setWidth(267),
                                      height: ScreenUtil().setWidth(171),
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Offstage(
                                  offstage:
                                  int.parse(item['popularity']) == 0,
                                  child: Container(
                                    height: ScreenUtil().setHeight(42),
                                    width: ScreenUtil().setHeight(280),
                                    padding: StyleUtil.padding(left: 15),
                                    decoration: BoxDecoration(
                                        color: Color(0x90000000)),
                                    child: Text(
                                      '${item['popularity']}人已学习',
                                      style: TextStyle(
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: ScreenUtil().setWidth(387),
                                  // height: ScreenUtil().setWidth(67),
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(27)),
                                  child: Text(
                                    item['title'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Color(0xff4E4E4E)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(387),
                                  // height: ScreenUtil().setWidth(67),
                                  margin: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(27),
                                      ScreenUtil().setWidth(0),
                                      0,
                                      0),
                                  child: Text(
                                    double.parse(item['price']) == 0
                                        ? '免费'
                                        : item['price'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Colors.red),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  child: Row(children: [
                                    Container(
                                      width: ScreenUtil().setWidth(387),
                                      // height: ScreenUtil().setWidth(67),
                                      margin: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(27),
                                        top: ScreenUtil().setWidth(20),
                                      ),
                                      child: Row(children: [
                                        Container(
                                          child: Text(
                                            '共',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                              ScreenUtil().setSp(28),
                                              color: Color(0xffc6c6c6),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            item['child_num'],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                              ScreenUtil().setSp(28),
                                              color: Colors.orange[100],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '节课',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                              ScreenUtil().setSp(28),
                                              color: Color(0xffc6c6c6),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil()
                                                  .setWidth(130)),
                                          child: Text(
                                            '${item['good_lv']}%  好评',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize:
                                              ScreenUtil().setSp(28),
                                              color: Colors.orange[100],
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
                      .toList()),
            ),
            Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),
                    ScreenUtil().setWidth(20), 0, 20),
                child: Text(
                  desc,
                  style: TextStyle(
                    color: Color(0xff454545),
                    fontSize: ScreenUtil().setSp(28),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
