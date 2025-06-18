import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/core/common/snackbar/my_snakebar.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class RegisterViewModel extends Bloc<RegisterEvent, RegisterState> {
  final UserRegisterUsecase _registerUsecase;

  RegisterViewModel(this._registerUsecase)
      : super(const RegisterState.initial()) {
    on<RegisterUserEvent>(_onRegisterUser);

  }

  Future<void> _onRegisterUser(
      RegisterUserEvent event,
      Emitter<RegisterState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _registerUsecase(
      RegisterUserParams(
        username: event.username,
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
          (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
          context: event.context,
          message: "Registration failed. Try again.",
          color: Colors.red,
        );
      },
          (_) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: "Registration successful!",
          color: Colors.green,
        );
        Navigator.pop(event.context); // or navigate to login screen
      },
    );
  }
}
