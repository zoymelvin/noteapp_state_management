import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/models/user_model.dart';

part 'auth_controller.g.dart'; 

@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

@riverpod
class AuthController extends _$AuthController {
  final _authHelper = AuthHelper();
  final _fsUserHelper = FirestoreUserHelper();

  @override
  FutureOr<void> build() {
  }

  //  LOGIN 
  Future<void> login(String email, String password) async {
    state = const AsyncLoading(); // Set loading
    state = await AsyncValue.guard(() async {
      await _authHelper.signInWithEmailAndPassword(email, password);
    });
  }

  //  REGISTER 
  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await _authHelper.signUpWithEmailAndPassword(email, password);
      
      if (credential.user != null) {
       
        await _fsUserHelper.addUser(
          UserModel(
            userId: credential.user!.uid,
            userEmail: credential.user!.email ?? '',
            userName: credential.user!.displayName ?? 'New User', 
          ),
        );
      }
    });
  }

  //  GOOGLE LOGIN 
  Future<void> loginGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await _authHelper.signInWithGoogle();
      
      if (credential?.user != null) {
        await _fsUserHelper.addUser(
          UserModel(
            userId: credential!.user!.uid,
            userEmail: credential.user!.email ?? '',
            userName: credential.user!.displayName ?? 'Google User',
          ),
        );
      }
    });
  }

  //  LOGOUT  
  Future<void> logout() async {
    state = const AsyncLoading();
    
    try {
      await _authHelper.signOutWithGoogle();
      state = const AsyncData(null);
    } catch (e, stack) {
      print("Logout Error: $e");
      state = AsyncError(e, stack);
    }
  }
}