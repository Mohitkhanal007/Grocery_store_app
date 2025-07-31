import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_logout_usecase.dart';

enum HomeState { initial, loggedOut, logoutError }

class HomeViewModel extends Cubit<HomeState> {
  final UserLogoutUseCase _logoutUseCase;

  HomeViewModel({required UserLogoutUseCase logoutUseCase})
    : _logoutUseCase = logoutUseCase,
      super(HomeState.initial);

  Future<void> logout() async {
    try {
      final result = await _logoutUseCase();
      result.fold(
        (failure) {
          emit(HomeState.logoutError);
        },
        (_) {
          emit(HomeState.loggedOut);
        },
      );
    } catch (e) {
      emit(HomeState.logoutError);
    }
  }
}
