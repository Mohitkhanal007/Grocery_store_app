import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jerseyhub/app/constant/hive_table_constant.dart';
import 'package:jerseyhub/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String email;

  UserHiveModel({
    String? userId,
    required this.username,
    required this.password,
    required this.email,

  }) : userId = userId ?? const Uuid().v4();

  // Initial constructor
  const UserHiveModel.initial()
      : userId = '',
        username = '',
        email = '',
        password = '';

  // Convert from entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.id,
      username: entity.username,
      password: entity.password,
      email: entity.email,
    );
  }

  // Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      username: username,
      password: password,
      email: email,
    );
  }

  @override
  List<Object?> get props => [userId, username, password,email];
}
