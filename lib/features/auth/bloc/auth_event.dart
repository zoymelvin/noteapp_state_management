import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

// Event Login Email
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Event Signup Email
class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignupRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// Event Google Login
class AuthGoogleLoginRequested extends AuthEvent {}

// Event Logout
class AuthLogoutRequested extends AuthEvent {}