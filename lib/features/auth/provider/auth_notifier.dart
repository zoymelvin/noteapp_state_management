import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/models/user_model.dart';
import 'auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _authHelper = AuthHelper();
  final _fsUserHelper = FirestoreUserHelper();

  @override
  AuthState build() {
    _checkLoginStatus();
    return AuthState.initial();
  }

  void _checkLoginStatus() {
    _authHelper.checkUserSignInState().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      await _authHelper.signInWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(e.message ?? 'Login Failed');
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register(String email, String password) async {
    state = AuthState.loading();
    try {
      final credential = await _authHelper.signUpWithEmailAndPassword(email, password);
      if (credential.user != null) {
        await _fsUserHelper.addUser(
          UserModel(
            userId: credential.user!.uid,
            userEmail: credential.user!.email ?? '',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      state = AuthState.error(e.message ?? 'Signup Failed');
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> loginGoogle() async {
    state = AuthState.loading();
    try {
      final credential = await _authHelper.signInWithGoogle();
      if (credential?.user != null) {
        await _fsUserHelper.addUser(
          UserModel(
            userId: credential!.user!.uid,
            userEmail: credential.user!.email ?? '',
          ),
        );
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    await _authHelper.signOutWithGoogle();
  }
}