part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPessed extends LoginEvent{
  final String email;
  final String password;

  LoginButtonPessed({required this.email, required this.password});
}