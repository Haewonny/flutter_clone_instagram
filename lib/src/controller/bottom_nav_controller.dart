import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/upload_controller.dart';
import 'package:get/get.dart';

import '../components/message_popup.dart';
import '../pages/upload.dart';

enum PageName { HOME, SEARCH, UPLOAD, ACTIVITY, MYPAGE }

class BottomNavController extends GetxController {
  static BottomNavController get to => Get.find();

  RxInt pageIndex = 0.obs;
  GlobalKey<NavigatorState> searchPageNavigationKey =
      GlobalKey<NavigatorState>();
  List<int> bottomHistory = [0];

  void changeBottomNav(int value, {bool hasGesture = true}) {
    var page = PageName.values[value];

    switch (page) {
      case PageName.UPLOAD:
        Get.to(() => Upload(), binding: BindingsBuilder(() {
          Get.put(UploadController());
        }));
        break;
      case PageName.HOME:
      case PageName.SEARCH:
      case PageName.ACTIVITY:
      case PageName.MYPAGE:
        _changePage(value, hasGesture: hasGesture);
        break;
    }
  }

  void _changePage(int value, {bool hasGesture = true}) {
    pageIndex(value);
    if (!hasGesture) return;
    if (bottomHistory.last != value) {
      bottomHistory.add(value);
      // print(bottomHistory);
    }
  }

  Future<bool> willPopAction() async {
    if (bottomHistory.length == 1) {
      // 하나만 있을 때
      showDialog(
          context: Get.context!,
          builder: (context) => MessagePopup(
                title: '시스템',
                message: '종료하시겠습니까?',
                okCallback: () {
                  exit(0);
                },
                cancleCallback: Get.back,
              ));
      return true;
    } else {

      var page = PageName.values[bottomHistory.last];
      if (page == PageName.SEARCH) {
        var value = await searchPageNavigationKey.currentState!.maybePop();
        if (value) return false;
      }
      bottomHistory.removeLast();
      var index = bottomHistory.last;
      // print(bottomHistory);
      changeBottomNav(index, hasGesture: false);

      return false;
    }
  }
}
