import 'package:flutter_clone_instagram/src/repository/user_repository.dart';
import 'package:get/get.dart';

import '../models/instagram_user.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find(); // 접근 쉽게 해줌

  Rx<IUser> user = IUser().obs;

  Future<IUser?> loginUser(String uid) async {
    // DB 조회
    var userData = await UserRepository.loginUserByUid(uid);

    return userData;
  }

  void signup(IUser signupUser) async {
    var result = await UserRepository.signup(signupUser);

    if (result) { // result가 true이면 회원가입 된 것
      user(signupUser);
    }
  }
}
