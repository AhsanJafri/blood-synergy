import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum AppImageSource {
  camera,
  gallery
}

class AppImagePicker {

  static Future<File?> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    final afile = File(image.path);
    return afile;
  }

  static Future<File?> _pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image == null) return null;
    final afile = File(image.path);
    return afile;
  }

  static Future<File?> pick(AppImageSource source) {
    switch (source) {
      case AppImageSource.camera:
        return _pickImageFromCamera();
      case AppImageSource.gallery:
        return _pickImageFromGallery();
    }
  }

  static void _dispose() {

  }

}


class fellasImagePickerForName {

  static Future<File?> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image == null) return null;
    final afile = File(image.path);
    // Constants.showImgName = image.name;
    return afile;
  }

  static Future<File?> _pickImageFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if(image == null) return null;
    final afile = File(image.path);
    // Constants.showImgName = image.name;
    return afile;
  }

  static Future<File?> pick(AppImageSource source) {
    switch (source) {
      case AppImageSource.camera:
        return _pickImageFromCamera();
      case AppImageSource.gallery:
        return _pickImageFromGallery();
    }
  }

  static void _dispose() {

  }

}


