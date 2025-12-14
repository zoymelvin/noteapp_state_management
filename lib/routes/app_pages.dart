import 'package:get/get.dart';
import 'package:flutter_note/features/auth/bindings/auth_binding.dart';
import 'package:flutter_note/pages/signin_page.dart';
import 'package:flutter_note/pages/singup_page.dart';
import 'package:flutter_note/pages/note_home_page.dart';

abstract class Routes {
  static const HOME = '/home';
  static const SIGNIN = '/signin';
  static const SIGNUP = '/signup';
}

class AppPages {
  static const INITIAL = Routes.SIGNIN;

  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const NoteHomePage(),
    ),
    GetPage(
      name: Routes.SIGNIN,
      page: () => const SigninPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupPage(),
      binding: AuthBinding(),
    ),
  ];
}