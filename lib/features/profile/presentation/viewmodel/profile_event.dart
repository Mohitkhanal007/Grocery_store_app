import 'package:equatable/equatable.dart';
import 'package:grocerystore/features/profile/domain/entity/profile_entity.dart';
import 'package:grocerystore/features/profile/domain/use_case/change_password_usecase.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileEvent extends ProfileEvent {
  final String userId;

  const GetProfileEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileEvent extends ProfileEvent {
  final ProfileEntity profile;

  const UpdateProfileEvent(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UploadProfileImageEvent extends ProfileEvent {
  final String imagePath;

  const UploadProfileImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ChangePasswordEvent extends ProfileEvent {
  final ChangePasswordParams params;

  const ChangePasswordEvent(this.params);

  @override
  List<Object?> get props => [params];
}
