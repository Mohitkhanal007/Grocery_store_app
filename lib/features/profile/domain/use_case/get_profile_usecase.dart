import 'package:dartz/dartz.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/profile/domain/entity/profile_entity.dart';
import 'package:jerseyhub/features/profile/domain/repository/profile_repository.dart';

class GetProfileUseCase implements UsecaseWithParams<ProfileEntity, String> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
