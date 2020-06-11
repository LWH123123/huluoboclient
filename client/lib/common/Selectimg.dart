import 'dart:convert';
import 'dart:typed_data';
import 'package:multi_image_picker/multi_image_picker.dart';

typedef OnSuccess<T>(T banners);

class SelectImg {
  Future select(OnSuccess base64) async {
    List resultList = await MultiImagePicker.pickImages(
      // 选择图片的最大数量
      maxImages: 1,
      // 是否支持拍照
      enableCamera: true,
      materialOptions: MaterialOptions(
          // 显示所有照片，值为 false 时显示相册
          startInAllView: true,
          allViewTitle: '所有照片',
          actionBarColor: '#2196F3',
          textOnNothingSelected: '没有选择照片'),
    );
    if (resultList.length != 0) {
      ByteData byteData = await resultList[0].getByteData(quality:10);
      Uint8List imageData = byteData.buffer.asUint8List();
      String _base64 = base64Encode(imageData);

      base64(_base64);
    }
  }

  Future selectMore(int nums, OnSuccess base64) async {
    List resultList = await MultiImagePicker.pickImages(
      // 选择图片的最大数量
      maxImages: nums,
      // 是否支持拍照
      enableCamera: true,
      materialOptions: MaterialOptions(
          // 显示所有照片，值为 false 时显示相册
          startInAllView: true,
          allViewTitle: '所有照片',
          actionBarColor: '#2196F3',
          textOnNothingSelected: '没有选择照片'),
    );
    if (resultList.length != 0) {
      ByteData byteData;
      Uint8List imageData;
      List base64List = [];
      for (var i = 0; i < resultList.length; i++) {
        byteData = await resultList[i].getByteData(quality:30);
        imageData = byteData.buffer.asUint8List();
        base64List.add(base64Encode(imageData));
      }
      base64(base64List);
    }
  }
}
