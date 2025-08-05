import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:grocerystore/app/constant/hive_table_constant.dart';
import 'package:grocerystore/features/auth/domain/entity/user_entity.dart';
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

  @HiveField(4)
  final String address;

  UserHiveModel({
    String? userId,
    required this.username,
    required this.password,
    required this.email,
    required this.address,
  }) : userId = userId ?? const Uuid().v4();

  // Initial constructor
  const UserHiveModel.initial()
    : userId = '',
      username = '',
      email = '',
      password = '',
      address = '';

  // Convert from entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.id,
      username: entity.username,
      password: entity.password,
      email: entity.email,
      address: entity.address,
    );
  }

  // Convert to entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      username: username,
      password: password,
      email: email,
      address: address,
    );
  }

  @override
  List<Object?> get props => [userId, username, password, email, address];
}
