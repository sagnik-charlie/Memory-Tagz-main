import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class storageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadFile(File _image, String fileName) async {
    var file = _image;
    try {
      await _firebaseStorage
          .ref('images/snappedObject/$fileName')
          .putFile(_image);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String> getUrl(String path) async {
    String url = "";
    try {
      url = await _firebaseStorage
          .ref('images/snappedObject/$path')
          .getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }
    return url;
  }
}
