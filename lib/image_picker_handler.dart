import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class ImagePickerHandler {
  Future<XFile?> pickImage({required ImageSource source});
}

class ImagePickerMobile implements ImagePickerHandler {
  @override
  Future<XFile?> pickImage({required ImageSource source}) async {
    return await ImagePicker().pickImage(source: source);
  }
}

class ImagePickerWeb implements ImagePickerHandler {
  @override
  Future<XFile?> pickImage({required ImageSource source}) async {
    return await ImagePicker().pickImage(source: source);
  }
}

ImagePickerHandler getImagePickerHandler() {
  if (kIsWeb) {
    return ImagePickerWeb();
  } else {
    return ImagePickerMobile();
  }
}
