import 'package:client/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Curriculumkc extends StatefulWidget {
  List course = [];
  Curriculumkc({Key key, List this.course}) : super(key: key);
  @override
  _CurriculumkcState createState() => _CurriculumkcState();
}

class _CurriculumkcState extends State<Curriculumkc> {
  List courseList = [];
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '职场'),
    new Tab(text: '数学'),
    new Tab(text: '英语'),
    new Tab(text: '语文'),
    new Tab(text: '历史'),
    new Tab(text: '化学'),
    new Tab(text: '其他'),
  ];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      courseList = widget.course;
    });
    print('_CurriculumkcState++++++$courseList');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //排序
    Widget sortArea = new Container(
      child: Container(
          child: Stack(children: <Widget>[
        Positioned(
          child: Container(
              child: Container(
                  color: Colors.white,
                  width: ScreenUtil().setWidth(750),
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    ExpansionTile(
                        title: const Text('综合排序'),
                        children: const <Widget>[
                          ListTile(title: Text('免费课程')),
                          ListTile(title: Text('价格优先')),
                          ListTile(title: Text('人气优先')),
                          ListTile(title: Text('好评优先'))
                        ]),
                  ]))),
        ),
      ])),
    );

//    Widget listArea = new ;
    return DefaultTabController(
      length: myTabs.length,
      child: new Scaffold(
          appBar: TabBar(
            tabs: myTabs,
            isScrollable: true,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.blueGrey,
            indicatorColor: Colors.red,
            labelStyle: TextStyle(fontSize: 14),
          ),
          body: Container(
            color: Colors.grey[100],
            child: new ListView(children: <Widget>[
              sortArea,
              ...widget.course.map((item) => Container(
                padding: StyleUtil.paddingTow(left: 27,top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                  border: Border(bottom: StyleUtil.borderBottom())
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          //图片
                          Stack(
                            children: <Widget>[
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10)),
                                  child: Image.network(item['img'],
                                      fit: BoxFit.cover,
                                      width: ScreenUtil().setWidth(267),
                                      height: ScreenUtil().setWidth(171))),

                              Positioned(
                                bottom: 0,
                                child: Offstage (
                                    offstage: int.parse(item['popularity']) == 0, // 设置是否可见：true:不可见 false:可见
                                    child: Container(
                                      width: ScreenUtil().setWidth(267),
                                      padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(15),
                                        top: ScreenUtil().setWidth(7),
                                        bottom: ScreenUtil().setWidth(7),
                                      ),
                                      child: Text('${item['popularity']}人已学习',
                                          style: TextStyle(color: Colors.white)),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                                ScreenUtil().setWidth(10)),
                                            bottomRight: Radius.circular(
                                                ScreenUtil().setWidth(10))),
                                      ),
                                    )
                                ),
                              ),
                            ],
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
                                      ScreenUtil().setWidth(27),
                                      0,
                                      0),
                                  child: Text(
                                    item['level'],
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
                                        top: ScreenUtil().setWidth(40),
                                      ),
                                      child: Row(children: [
                                        Container(
                                          child: Text(
                                            '共',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Color(0xffc6c6c6),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            item['child_num'],
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Color(0xffF88718),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            '节课',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Color(0xffc6c6c6),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(130)),
                                          child: Text(
                                            '${item['good_lv']}%  好评',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Color(0xffF88718),
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
                  ],
                ),
              )).toList()
            ]),
          )),
    );
  }
}

class Todetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: () {
      print('跳转课程详情');
    });
  }
}



/*
<Widget>[
Container(
color: Colors.white,
padding: EdgeInsets.only(left:20),
child: Column(
children: <Widget>[
Container(
padding: EdgeInsets.only(left: ScreenUtil().setWidth(27)),
height: ScreenUtil().setWidth(21),
child: Row(
children: <Widget>[],
),
),
new Container(
child: Row(
children: <Widget>[
//图片
Stack(
children: <Widget>[
ClipRRect(
borderRadius: BorderRadius.circular(
ScreenUtil().setWidth(10)),
child: Image.asset('assets/home/bgchanpin2.png',
width: ScreenUtil().setWidth(267),
height: ScreenUtil().setWidth(171))),
Positioned(
bottom: 0,
child: Container(
width: ScreenUtil().setWidth(267),
padding: EdgeInsets.only(
left: ScreenUtil().setWidth(15),
top: ScreenUtil().setWidth(7),
bottom: ScreenUtil().setWidth(7),
),
child: Text('100人已学习',
style: TextStyle(color: Colors.white)),
decoration: BoxDecoration(
color: Color.fromRGBO(0, 0, 0, 0.5),
borderRadius: BorderRadius.only(
bottomLeft: Radius.circular(
ScreenUtil().setWidth(10)),
bottomRight: Radius.circular(
ScreenUtil().setWidth(10))),
),
),
),
],
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
'掌握六节职场礼仪,为自己加分!',
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
ScreenUtil().setWidth(27),
0,
0),
child: Text(
'免费',
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
top: ScreenUtil().setWidth(40),
),
child: Row(children: [
Container(
child: Text(
'共',
textAlign: TextAlign.start,
style: TextStyle(
fontSize: ScreenUtil().setSp(28),
color: Color(0xffc6c6c6),
),
),
),
Container(
child: Text(
'4',
textAlign: TextAlign.start,
style: TextStyle(
fontSize: ScreenUtil().setSp(28),
color: Color(0xffF88718),
),
),
),
Container(
child: Text(
'节课',
textAlign: TextAlign.start,
style: TextStyle(
fontSize: ScreenUtil().setSp(28),
color: Color(0xffc6c6c6),
),
),
),
Container(
margin: EdgeInsets.only(
left: ScreenUtil().setWidth(130)),
child: Text(
'80%  好评',
textAlign: TextAlign.start,
style: TextStyle(
fontSize: ScreenUtil().setSp(28),
color: Color(0xffF88718),
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
],
),
),
]*/
