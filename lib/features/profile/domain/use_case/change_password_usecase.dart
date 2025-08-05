import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/profile/domain/repository/profile_repository.dart';

class ChangePasswordParams {
  final String currentPassword;
  final String newPassword;

  ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });
}

class ChangePasswordUseCase
    implements UsecaseWithParams<bool, ChangePasswordParams> {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) async {
    return await repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
