import 'package:flutter/material.dart';

@immutable
sealed class LoginEvent {}

class NavigateToRegisterViewEvent extends LoginEvent {
  // No context here
  // UI will handle navigation on this event externally
}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailAndPasswordEvent({required this.email, required this.password});
}
