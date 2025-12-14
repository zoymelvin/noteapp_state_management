import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note/auth_helper.dart';
import 'package:flutter_note/firestore_user_helper.dart';
import 'package:flutter_note/models/user_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthHelper authHelper;
  final FirestoreUserHelper fsUserHelper;

  AuthBloc({required this.authHelper, required this.fsUserHelper}) : super(AuthInitial()) {
    
    // 1. Cek Status Login
    on<AuthCheckRequested>((event, emit) async {
      await emit.forEach<User?>(
        authHelper.checkUserSignInState(),
        onData: (user) {
          if (user != null) {
            return AuthAuthenticated(user);
          } else {
            return AuthUnauthenticated();
          }
        },
      );
    });

    // 2. Login Email
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authHelper.signInWithEmailAndPassword(event.email, event.password);
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? 'Login failed'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // 3. Signup Email
    on<AuthSignupRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final credential = await authHelper.signUpWithEmailAndPassword(event.email, event.password);
        if (credential.user != null) {
          await fsUserHelper.addUser(
            UserModel(
              userId: credential.user!.uid,
              userEmail: credential.user!.email ?? '',
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? 'Signup failed'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // 4. Google Login
    on<AuthGoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
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
        emit(AuthError(e.toString()));
      }
    });

    // 5. Logout
    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await authHelper.signOutWithGoogle();
    });
  }
}