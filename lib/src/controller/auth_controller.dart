import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_clone_instagram/src/binding/init_bindings.dart';
import 'package:flutter_clone_instagram/src/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/instagram_user.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find(); // 접근 쉽게 해줌

  Rx<IUser> user = IUser().obs;

  Future<IUser?> loginUser(String uid) async {
    // DB 조회
    var userData = await UserRepository.loginUserByUid(uid);

    if (userData != null) {
      user(userData);
      InitBinding.additionalBinding(); // 로그인할 때 MypageController 바인딩
    }

    return userData;
  }

  void signup(IUser signupUser, XFile? thumbnail) async {
    if (thumbnail == null) {
      _submitSignup(signupUser);
    } else {
      var task = uploadXFile(
          thumbnail, '${signupUser.uid}/profile.${thumbnail.path.split('.').last}');

      task.snapshotEvents.listen((event) async {
        print(event.bytesTransferred);
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          var updatedUserData = signupUser.copyWith(thumbnail: downloadUrl);

          _submitSignup(updatedUserData);
        }
      });
    }
  }

  UploadTask uploadXFile(XFile file, String filename) {
    var f = File(file.path);
    var ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(filename); // users/{uid}/profile.jpg 형태로 저장

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    return ref.putFile(f, metadata);
  }

  void _submitSignup(IUser signupUser) async {
    var result = await UserRepository.signup(signupUser);

    if (result) {
      // result가 true이면 회원가입 된 것
      loginUser(signupUser.uid!);
    }
  }
}
