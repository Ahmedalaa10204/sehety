part of 'auth_bloc.dart';

sealed class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final UserType userType;
  RegisterEvent(
      {required this.email,
      required this.password,
      required this.name,
      required this.userType});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final UserType userType;
  LoginEvent(
      {required this.email, required this.password, required this.userType});
}

class UpdateDoctorDataEvent extends AuthEvent {
  final DoctorModel doctorModel;

  UpdateDoctorDataEvent({required this.doctorModel});
}