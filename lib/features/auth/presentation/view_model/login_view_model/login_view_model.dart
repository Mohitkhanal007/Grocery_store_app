// login_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_login_usecase.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel(this._userLoginUsecase) : super(const LoginState.initial()) {
    on<NavigateToRegisterViewEvent>((event, emit) {
      emit(state.copyWith(navigateToRegister: true));
    });

    on<LoginWithEmailAndPasswordEvent>(_onLoginWithEmailAndPassword);
  }

  Future<void> _onLoginWithEmailAndPassword(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: ''));

    final result = await _userLoginUsecase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: 'Invalid credentials. Please try again.',
        ),
      ),
      (loginResult) async {
        // LoginResult contains both token and user data
        // The token and user data are already saved in the use case
        emit(state.copyWith(isLoading: false, isSuccess: true));
      },
    );
  }
}
