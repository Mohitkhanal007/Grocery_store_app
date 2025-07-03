import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String email;
  final String username;
  final String password;

  const UserApiModel({
    this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  /// JSON -> Model
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  /// Model -> JSON
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  /// Model -> Entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      password: password,
    );
  }

  /// Entity -> Model
  factory UserApiModel.fromEntity(UserEntity entity) {
    return UserApiModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props => [id, email, username, password];
}
