// login_state.dart
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool navigateToRegister;
  final String errorMessage;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.navigateToRegister = false,
    this.errorMessage = '',
  });

  const LoginState.initial()
    : isLoading = false,
      isSuccess = false,
      navigateToRegister = false,
      errorMessage = '';

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? navigateToRegister,
    String? errorMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      navigateToRegister: navigateToRegister ?? false,
      errorMessage: errorMessage ?? '',
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    navigateToRegister,
    errorMessage,
  ];
}
