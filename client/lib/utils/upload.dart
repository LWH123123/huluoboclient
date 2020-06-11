import 'dart:convert';
import 'package:image_picker/image_picker.dart';
/*
* 葛东泽 2020-05-22
* 功能: 选择图片/视频
* 方式:
* 拍照-图片
* 相册-图片
* 录制视频
* 相册选择视频
* 插件: image_picker: 0.6.2+2
* */

class Upload {
  static Map entity;

  // 拍照
  static Future camera_photo() async {
    await ImagePicker.pickImage(source: ImageSource.camera).then((file) async {
      List<int> imageBytes = await file.readAsBytes();
      String Base64 = base64Encode(imageBytes);
      entity = {"file": file, "base64": Base64};
    });
    return entity;
  }

  // 相册
  static Future gallery_photo() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((file) async {
      List<int> imageBytes = await file.readAsBytes();
      String Base64 = base64Encode(imageBytes);
      entity = {"file": file, "base64": Base64};
    });
    return entity;
  }

  // 录制视频
  static Future camera_Video() async {
    var file;
    await ImagePicker.pickVideo(source: ImageSource.camera).then(((res) {
      file = res;
    }));
    return file;
  }

  // 相册视频
  static Future gallery_Video() async {
    var file;
    await ImagePicker.pickVideo(source: ImageSource.gallery).then(((res) {
      file = res;
    }));
    print("ImagePicker-----------------${file}");
    return file;
  }
}
