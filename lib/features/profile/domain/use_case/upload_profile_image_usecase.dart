import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/profile/domain/repository/profile_repository.dart';

class UploadProfileImageUseCase implements UsecaseWithParams<String, String> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String imagePath) async {
    return await repository.uploadProfileImage(imagePath);
  }
}
