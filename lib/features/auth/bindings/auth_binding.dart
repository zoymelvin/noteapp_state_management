import 'package:get/get.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/features/auth/controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthHelper());
    Get.lazyPut(() => FirestoreUserHelper());
    
    Get.lazyPut(() => AuthController(
      authHelper: Get.find<AuthHelper>(),
      fsUserHelper: Get.find<FirestoreUserHelper>(),
    ));
  }
}