

import 'dart:typed_data';

import 'package:client/common/Utils.dart';
import 'package:client/common/color.dart';
import 'package:client/utils/toast_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';



class Tuiguang extends StatefulWidget{

  String id;
  Tuiguang(this.id);
  @override
  TuiguangState createState() => TuiguangState();
}

class TuiguangState extends State<Tuiguang>{

//  String URL="http://live.gtt20.com/addons/ewei_shopv2/data/poster/1/d888a619950383d9eeef0614aace005a.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('推广二维码'),
          elevation: 0,
          centerTitle: true,
          backgroundColor: PublicColor.themeColor,
        ),
        body: new Container(
          child: new Column(
                children: <Widget>[
                  new InkWell(
                   child: new Image.network(
                   widget.id,
//                    fit: BoxFit.cover,
                   width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
                   height: 520,
                  ),
                  onLongPress: (){
                      //保存至本地一张图片
                      _saveImage(widget.id);

                    },
                  ),
                  new InkWell(
                     child: new Text(
                         "长按保存图片",
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         fontSize: 18.0,
                         color: Colors.red,
                         fontWeight: FontWeight.w700,
                       ),

                     ),
                    onLongPress: (){
                       //保存至本地一张图片
                       _saveImage(widget.id);

                    },
                  )
                ],
          )
        )
        );
  }

  //保存至本地图片
  void _saveImage(String url) async {
    print('标识为====>>>'+widget.id);
//    bool isOpened = await PermissionHandler().openAppSettings();
   //请求权限
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler()
        .requestPermissions([PermissionGroup.storage]);

    // 申请结果
    PermissionStatus permission =

    await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.granted) {

//      Fluttertoast.showToast(msg: "权限申请通过");

    } else {
      ToastUtil.showToast('权限申请被拒绝');
      return;
    }
    var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print('result:$result');
    ToastUtil.showToast('图片保存成功!');

  }

}
