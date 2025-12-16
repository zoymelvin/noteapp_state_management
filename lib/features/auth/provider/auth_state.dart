import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final bool isLoading;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState();

  factory AuthState.loading() => const AuthState(isLoading: true);

  factory AuthState.authenticated(User user) => AuthState(user: user);

  factory AuthState.unauthenticated() => const AuthState();

  factory AuthState.error(String message) => AuthState(errorMessage: message);
  
  // Helper getter
  bool get isLogin => user != null;
}