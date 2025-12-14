import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart'; 
import 'package:flutter_note/models/user_model.dart'; 
import 'package:flutter_note/routes/app_pages.dart'; 

class AuthController extends GetxController {
  final AuthHelper authHelper;
  final FirestoreUserHelper fsUserHelper;

  AuthController({required this.authHelper, required this.fsUserHelper});


  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(authHelper.checkUserSignInState());
    
    ever(firebaseUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.SIGNIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await authHelper.signInWithEmailAndPassword(email, password);
      Get.snackbar('Success', 'Login Success', 
        backgroundColor: Colors.green.withOpacity(0.5), colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed', 
        backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), 
        backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIC SIGNUP EMAIL ---
  Future<void> register(String email, String password) async {
    isLoading.value = true;
    try {
      final credential = await authHelper.signUpWithEmailAndPassword(email, password);
      
      if (credential.user != null) {
        // Simpan ke Firestore
        await fsUserHelper.addUser(
          UserModel(
            userId: credential.user!.uid,
            userEmail: credential.user!.email ?? '',
            // Tambahkan field lain jika perlu
          ),
        );
        Get.snackbar('Success', 'Register Success', 
          backgroundColor: Colors.green.withOpacity(0.5), colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Register failed', 
        backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), 
        backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIC GOOGLE LOGIN ---
  Future<void> loginGoogle() async {
    isLoading.value = true;
    try {
      final credential = await authHelper.signInWithGoogle();
      
      if (credential?.user != null) {
        await fsUserHelper.addUser(
          UserModel(
            userId: credential!.user!.uid,
            userEmail: credential.user!.email ?? '',
          ),
        );

      }
    } catch (e) {
      Get.snackbar('Error', 'Google Sign in failed: $e', 
        backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGIC LOGOUT ---
  Future<void> logout() async {
    await authHelper.signOutWithGoogle();
  }
}