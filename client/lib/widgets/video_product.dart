import 'package:flutter/material.dart';
import './cached_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/video/video.dart';
class ProductView extends StatelessWidget {
  final List productList;

  ProductView(this.productList);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left:ScreenUtil.instance.setWidth(25.0),right:ScreenUtil.instance.setWidth(25.0)),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.78,crossAxisSpacing: 3,mainAxisSpacing:3),
          itemBuilder: (BuildContext context, int index) {
            return _getGridViewItem(context, productList[index]);
          }),
    );
  }

  Widget _getGridViewItem(BuildContext context,productEntity) {
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => VideoPage()));
        },
        child: Card(
          elevation: 5.0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),  //设置圆角
          child: Stack(
            children:[
              Container(
                child: CachedImageView(
                    double.infinity,
                    double.infinity,
                    productEntity['img'],null,BorderRadius.all(Radius.circular(5)))),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                width:double.infinity,
                height:ScreenUtil.instance.setWidth(200.0),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(15), ScreenUtil.instance.setWidth(15), ScreenUtil.instance.setWidth(15), 0),
                child: Text(productEntity['user']['nickname'],softWrap: true,overflow: TextOverflow.ellipsis,maxLines: 3,style: TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(33.0),fontWeight: FontWeight.w700)),
              ),

              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.end,
                  children:[
                    new Row(
                      children: <Widget>[
                        new SizedBox(width:ScreenUtil.instance.setWidth(10.0)),
                        Container(
                          width:ScreenUtil.instance.setWidth(70.0),
                          height:ScreenUtil.instance.setWidth(70.0),
                          decoration: BoxDecoration(
                            color: productEntity['user']['is_open']==1?Colors.red:Color(0xfffa5a5a5),
                            borderRadius:BorderRadius.all(Radius.circular(50.0))
                          ),
                          child:CachedImageView(ScreenUtil.instance.setWidth(65.0),ScreenUtil.instance.setWidth(65.0),productEntity['user']['headimgurl'],null,BorderRadius.all(Radius.circular(50.0))),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width:ScreenUtil.instance.setWidth(180.0),
                          height:ScreenUtil.instance.setWidth(70.0),
                          child:Text('  '+productEntity['name'],maxLines: 1,style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(33.0),fontWeight: FontWeight.w700))
                        ),
                      ],
                    ),
                    new SizedBox(height:ScreenUtil.instance.setWidth(40.0)),
                  ]
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(5),0, 0,ScreenUtil.instance.setWidth(30)),
               
                  child: Container(
                    alignment: Alignment.center,
                    width:ScreenUtil.instance.setWidth(85.0),
                    height:ScreenUtil.instance.setWidth(30.0),
                    decoration: BoxDecoration(
                      color: Color(0xfffe71816),
                      borderRadius:BorderRadius.all(Radius.circular(50.0))
                    ),
                    child: Text(productEntity['user']['is_open'].toString()=="1"?'直播中':'未直播',style:TextStyle(color: Colors.white, fontSize: ScreenUtil.instance.setWidth(20.0),fontWeight: FontWeight.w700)),
                  ),
                  // offstage:!productEntity['zhibo']
              
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.fromLTRB(ScreenUtil.instance.setWidth(95),0, 0,ScreenUtil.instance.setWidth(94)),
                child: Text(productEntity['like'].toString()+'人点赞'+productEntity['comment'].toString()+'人留言',style:TextStyle(color: Color(0xfffc8c3c3), fontSize: ScreenUtil.instance.setWidth(20.0),fontWeight: FontWeight.w700)),
              ),
              Container(
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.fromLTRB(0,0, ScreenUtil.instance.setWidth(20),ScreenUtil.instance.setWidth(18)),
                
                  child: Container(
                    alignment: Alignment.center,
                    width:ScreenUtil.instance.setWidth(85.0),
                    height:ScreenUtil.instance.setWidth(45.0),
                    decoration: BoxDecoration(
                      color: Color(0xfffe71816),
                      borderRadius:BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Text(productEntity['is_follow'].toString()=="1"?'已关注':'未关注',style:TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(24),fontWeight: FontWeight.w700)),
                  ),
                  // offstage:!productEntity['guanzhu']
               
              ),
            ]
          ),
        )
      ),
    );
  }
}
