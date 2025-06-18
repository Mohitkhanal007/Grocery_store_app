import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/core/common/snackbar/my_snakebar.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view/register_view.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:jerseyhub/features/auth/presentation/view_model/login_view_model/login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(const LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  void _onNavigateToRegisterView(
      NavigateToRegisterViewEvent event,
      Emitter<LoginState> emit,
      ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [],
          child: RegisterView(),
        ),
      ),
    );
  }

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPasswordEvent event,
      Emitter<LoginState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));

    final result = await _userLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));

        showMySnackBar(
          context: event.context,
          message: 'Invalid credentials. Please try again.',
          color: Colors.red,
        );
      },
          (token) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: 'Login successful!',
          color: Colors.green,
        );
      },
    );
  }
}
