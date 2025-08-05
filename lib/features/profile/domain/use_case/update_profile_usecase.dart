import 'package:dartz/dartz.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/profile/domain/entity/profile_entity.dart';
import 'package:grocerystore/features/profile/domain/repository/profile_repository.dart';

class UpdateProfileUseCase
    implements UsecaseWithParams<ProfileEntity, ProfileEntity> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }
}
