import 'dart:convert';

import 'package:client/service/user_service.dart';
import 'package:client/utils/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class SelectPicture {
  // 拍照
  Future getImageCamera(succeed) async {
    await ImagePicker.pickImage(source: ImageSource.camera, maxWidth: 400)
        .then((onValue) async {
      List bytes = await onValue.readAsBytes();
      String bs64 = base64Encode(bytes);
      String base64Image = "data:image/png;base64," + bs64;
      UserServer().uploadImg({"info": bs64}, (onSuccess) {
        succeed({"src": base64Image,"url": onSuccess['src'], "file": onValue, "base64": bs64});
        ToastUtil.showToast('图片上传成功');
      }, (onFail) => ToastUtil.showToast(onFail));
    });
  }

  //相册选择
  Future getImageGallery(succeed) async {
    ImagePicker.pickImage(source: ImageSource.gallery, maxWidth: 400)
        .then((onValue) async {
      List bytes = await onValue.readAsBytes();
      String bs64 = base64Encode(bytes);
      String base64Image = "data:image/png;base64," + bs64;
      UserServer().uploadImg({"info": bs64}, (onSuccess) {
        succeed({"src": base64Image,"url": onSuccess['src'], "file": onValue, "base64": bs64});
        ToastUtil.showToast('图片上传成功');
      }, (onFail) => ToastUtil.showToast(onFail));
    });
  }

}
