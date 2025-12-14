import 'package:get/get.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/features/auth/controller/auth_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    // Inject Helper
    Get.put(AuthHelper());
    Get.put(FirestoreUserHelper());

    Get.put(AuthController(
      authHelper: Get.find<AuthHelper>(),
      fsUserHelper: Get.find<FirestoreUserHelper>(),
    ), permanent: true); 
  }
}