import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/models/instagram_user.dart';
import 'package:get/get.dart';

class MypageController extends GetxController with GetTickerProviderStateMixin{
  late TabController tabController;
  Rx<IUser> targetUser = IUser().obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void setTargetUser() {
    var uid = Get.parameters['targetUid'];
    if (uid == null) {
      targetUser(AuthController.to.user.value);
    } else {
      // 상대 uid로 users collection 조회
    }
  }
  void _loadData() {
    setTargetUser();
    // post list load

    // user info load
  }
}