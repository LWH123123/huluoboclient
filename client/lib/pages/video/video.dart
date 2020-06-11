import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/loading.dart';
import '../../widgets/cached_image.dart';
class VideoPage extends StatefulWidget {
  @override
  VideoPageState createState() => VideoPageState();
}

class VideoPageState extends  State<VideoPage>  with SingleTickerProviderStateMixin{
  bool isloading=false;
  double slider = 30;
  bool isguanzhu = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: isloading?LoadingDialog():Container(
        height: ScreenUtil.instance.setHeight(1334.0),
        child: Swiper(
          loop: false,
          autoplay: false,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil.instance.setHeight(1334.0),
                  width: ScreenUtil.instance.setWidth(750.0),
                  color: Colors.blue,
                ),
                Container(
                  height: ScreenUtil.instance.setHeight(1334.0),
                  width: ScreenUtil.instance.setWidth(750.0),
                  // padding: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
                  alignment: Alignment.bottomRight,
                  child: Column(mainAxisAlignment:MainAxisAlignment.end,children: <Widget>[
                    Container(
                      height: ScreenUtil.instance.setWidth(650.0),
                      child: Row(
                        children:[
                          new SizedBox(width:ScreenUtil.instance.setWidth(30.0)),
                          Container(
                            width:ScreenUtil.instance.setWidth(520.0),
                            height: ScreenUtil.instance.setWidth(650.0),
                            child: new Column(
                              mainAxisAlignment:MainAxisAlignment.end,
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children:[
                                Text('那些年的今天案例炒酸奶',style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(30.0))),
                                new SizedBox(height:ScreenUtil.instance.setWidth(20.0)),
                                Text('叫你如何穿衣服，职场服装，聚会服装，服装搭配,这是描述这是描述这是描述这是描述',softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 5,style: TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(28.0)))
                              ]
                            ),
                          ),
                          new SizedBox(width:ScreenUtil.instance.setWidth(60.0)),
                          Container(
                            width:ScreenUtil.instance.setWidth(100.0),
                            height: ScreenUtil.instance.setWidth(650.0),
                            child: new Column(
                              mainAxisAlignment:MainAxisAlignment.end,
                              children:[
                                Container(
                                  width: ScreenUtil.instance.setWidth(100.0),
                                  height: ScreenUtil.instance.setWidth(120.0),
                                  child: Stack(children: <Widget>[
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: CachedImageView(
                                        ScreenUtil.instance.setWidth(100.0),
                                        ScreenUtil.instance.setWidth(100.0),
                                        'https://dss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2837820063,351118816&fm=111&gp=0.jpg',null,BorderRadius.all(Radius.circular(50))),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: ScreenUtil.instance.setWidth(27.0),
                                      child: InkWell(child: isguanzhu?Text(''):Image.asset('assets/zhibo/guanzhu.png',width:ScreenUtil.instance.setWidth(50.0)),onTap: (){
                                        if(!isguanzhu){
                                          setState(() {
                                            isguanzhu = true;
                                          });
                                        }
                                      },),
                                    )
                                ],),
                                ),
                                new SizedBox(height:ScreenUtil.instance.setWidth(30.0)),
                                InkWell(child: Image.asset('assets/zhibo/dz.png',width: ScreenUtil.instance.setWidth(80.0)),onTap: (){
                                  print('点赞');
                                },),
                                new SizedBox(height:ScreenUtil.instance.setWidth(5.0)),
                                Text('185',style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(26.0))),
                                new SizedBox(height:ScreenUtil.instance.setWidth(30.0)),
                                InkWell(child: Image.asset('assets/zhibo/pl.png',width: ScreenUtil.instance.setWidth(80.0)),onTap: (){
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return XiaoxiWidget();
                                    }
                                  );
                                },),
                                new SizedBox(height:ScreenUtil.instance.setWidth(5.0)),
                                Text('1256',style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(26.0))),
                                new SizedBox(height:ScreenUtil.instance.setWidth(30.0)),
                                InkWell(child: Image.asset('assets/zhibo/fx.png',width: ScreenUtil.instance.setWidth(80.0)),onTap: (){
                                  print('分享');
                                },),
                                new SizedBox(height:ScreenUtil.instance.setWidth(5.0)),
                                Text('186',style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(26.0))),
                              ]
                            ),
                          ),
                        ]
                      ),
                    ),
                    new SizedBox(height:ScreenUtil.instance.setWidth(15.0)),
                    new Slider(
                      value: this.slider,
                      max: 100.0,
                      min: 0.0,
                      inactiveColor:Colors.white,
                      activeColor: Colors.red,
                      onChanged: (double val) {
                        this.setState(() {
                            this.slider = val;
                        });
                      },
                    ),
                    new SizedBox(height:ScreenUtil.instance.setWidth(40.0)),
                  ],),
                )
              ],
            );
          },
          onIndexChanged: (index) {
            debugPrint("index:$index");
          },
          itemCount: 5,
          scrollDirection: Axis.vertical,
        ),
      )
    );
  }
}



class XiaoxiWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DialogContentState();
}

class DialogContentState extends State<XiaoxiWidget> {
  TextEditingController _textEditingController = new TextEditingController();
  ScrollController _controller = ScrollController();
  List listview = [
    {
      'avatar':'https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3256100974,305075936&fm=26&gp=0.jpg',
      'name':'今天的我们',
      'time':'02-12 14:23',
      'message':'刚馆主你埃及都是你死哦我说的话从哪里几十块大红包哪里撒NH打错了'
    },
    {
      'avatar':'https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3256100974,305075936&fm=26&gp=0.jpg',
      'name':'今天的我们',
      'time':'02-12 14:23',
      'message':'刚馆主你埃及都是你死哦我说的话从哪里几十块大红包哪里撒NH打错了'
    },
    {
      'avatar':'https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3256100974,305075936&fm=26&gp=0.jpg',
      'name':'今天的我们',
      'time':'02-12 14:23',
      'message':'刚馆主你埃及都是你死哦我说的话从哪里几十块大红包哪里撒NH打错了'
    },
    {
      'avatar':'https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3256100974,305075936&fm=26&gp=0.jpg',
      'name':'今天的我们',
      'time':'02-12 14:23',
      'message':'刚馆主你埃及都是你死哦我说的话从哪里几十块大红包哪里撒NH打错了'
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget pinglunitem(BuildContext context,item,index){
    return Container(
      child: new Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children:[
          CachedImageView(
            ScreenUtil.instance.setWidth(80.0),
            ScreenUtil.instance.setWidth(80.0),
            item['avatar'],null,BorderRadius.all(Radius.circular(50))
          ),
          new SizedBox(width:ScreenUtil.instance.setWidth(25.0)),
          Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children:[
              Text(item['name'],style: TextStyle(color: Color(0xffff16c65), fontSize: ScreenUtil.instance.setWidth(28.0))),
              new SizedBox(height:ScreenUtil.instance.setWidth(16.0)),
              Container(
                width: ScreenUtil.instance.setWidth(580.0),
                child: Text(item['message'],softWrap: true),
              ),
              new SizedBox(height:ScreenUtil.instance.setWidth(10.0)),
              Text(item['time'],style: TextStyle(color: Colors.black54, fontSize: ScreenUtil.instance.setWidth(28.0))),
              new SizedBox(height:ScreenUtil.instance.setWidth(40.0)),
            ]
          )
        ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: ScreenUtil.instance.setWidth(700.0),
      child: Column(
        children:[
          Container(
            height: ScreenUtil.instance.setWidth(80.0),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children:[
                Expanded(
                  flex:9,
                  child:Container(child: Text('128条评论',style: TextStyle(color: Colors.black, fontSize: ScreenUtil.instance.setWidth(28.0))),alignment: Alignment.center,)
                ),
                Expanded(flex:1,child: Container(alignment: Alignment.center,child:InkWell(
                  child: Image.asset('assets/index/gb.png',width: ScreenUtil.instance.setWidth(40.0),),
                  onTap: (){
                    Navigator.of(context).pop();
                  },)))
              ]
            ),
          ),
          Container(
            height: ScreenUtil.instance.setWidth(440.0),
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
            child: ListView.builder(
              itemCount: listview.length,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return pinglunitem(context, listview[index], index);
              }
            ),
          ),
          Container(
            height: ScreenUtil.instance.setWidth(180.0),
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(25),left: ScreenUtil().setWidth(25)),
            decoration: new ShapeDecoration(
              shape: Border(
                top:BorderSide(color: Color(0xfffcbc9c9),width:1),
              ), // 边色与边宽度
              color: Colors.white,
            ),
            child: Row(
              children:[
                Container(
                  height: ScreenUtil.instance.setWidth(135.0),
                  width: ScreenUtil.instance.setWidth(565.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xffff5f5f5),
                    border: new Border.all(color: Color(0xfffcbc9c9), width: 1), 
                  ),
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(15),left: ScreenUtil().setWidth(15)),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines:null,
                    style: TextStyle(fontSize: ScreenUtil.instance.setWidth(28.0), color: Colors.black),
                    decoration: new InputDecoration(hintText: '请填写您要说的内容', border: InputBorder.none),
                  ),
                ),
                InkWell(child: Container(
                  height: ScreenUtil.instance.setWidth(135.0),
                  width: ScreenUtil.instance.setWidth(130.0),
                  alignment: Alignment.center,
                  child: Text('发布',style: TextStyle(color: Colors.black, fontSize: ScreenUtil.instance.setWidth(35.0))),
                ),onTap: (){
                  print('发送');
                  print(_textEditingController.text);
                  if(_textEditingController.text!=''){
                    listview.insert(listview.length,{
                      'avatar':'https://dss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3256100974,305075936&fm=26&gp=0.jpg',
                      'name':'今天的我们11',
                      'time':'02-12 14:23',
                      'message':_textEditingController.text
                    });
                    setState(() {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    });
                  }
                  
                },)
              ]
            ),
          ),
        ]
      ),
    );
  }
}