import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/profile/domain/entity/profile_entity.dart';
import 'package:grocerystore/features/profile/domain/repository/profile_repository.dart';

class GetProfileUseCase implements UsecaseWithParams<ProfileEntity, String> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}
