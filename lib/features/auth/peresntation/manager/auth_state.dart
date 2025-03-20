part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoadingState extends AuthState {}

final class LoginSuccessState extends AuthState {
  final String userType;
  LoginSuccessState({required this.userType});
}

final class RegisterLoadingState extends AuthState {}

final class RegisterSuccessState extends AuthState {}

final class DoctorRegistrationLoadingState extends AuthState {}

final class DoctorRegistrationSuccessState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});
}