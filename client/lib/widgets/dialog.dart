import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class MyDialog extends Dialog {
  final double width;
  final double height;
  final Function queding;
  final Function quxiao;
  final String title;
  final String message;
  MyDialog({Key key,this.width,this.height,this.queding,this.quxiao,this.title,this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:750,height:1334)..init(context);
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: this.width,
          height: this.height,
          child: new Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width:this.width,
                  height: this.height-ScreenUtil.instance.setWidth(100.0),
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children:[
                      Text(this.title,style: TextStyle(color: Colors.black, fontSize: ScreenUtil.instance.setWidth(27.0))),
                      new SizedBox(height:ScreenUtil.instance.setWidth(10.0)),
                      Text(this.message,style: TextStyle(color: Colors.black45, fontSize: ScreenUtil.instance.setWidth(27.0)))
                    ]
                  ),
                ),
                Container(
                  width:this.width,
                  height: ScreenUtil.instance.setWidth(100.0),
                  decoration: new ShapeDecoration(
                    shape: Border(
                      top:BorderSide(color: Color(0xfffececec),width:1),
                    ), // 边色与边宽度
                  ),
                  child: Row(
                    children:[
                      Expanded(
                        flex:1,
                        child: InkWell(
                          onTap: (){
                            queding();
                          },
                          child: Container(
                            child:Text('确认',style: TextStyle(color: Color(0xffE71419), fontSize: ScreenUtil.instance.setWidth(30.0))),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex:1,
                        child: InkWell(
                          onTap: (){
                            quxiao();
                          },
                          child: Container(
                            decoration: new ShapeDecoration(
                              shape: Border(
                                left:BorderSide(color: Color(0xfffececec),width:1),
                              ), // 边色与边宽度
                            ),
                            child:Text('取消',style: TextStyle(color: Colors.black, fontSize: ScreenUtil.instance.setWidth(30.0))),
                            alignment: Alignment.center,
                          ),
                        ),
                      )
                    ]
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}

