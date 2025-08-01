import 'package:dartz/dartz.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/profile/domain/repository/profile_repository.dart';

class UploadProfileImageUseCase implements UsecaseWithParams<String, String> {
  final ProfileRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String imagePath) async {
    return await repository.uploadProfileImage(imagePath);
  }
}
