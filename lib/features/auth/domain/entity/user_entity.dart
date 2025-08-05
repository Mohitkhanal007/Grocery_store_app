import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String email;
  final String username;
  final String password;
  final String address;

  const UserEntity({
    this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.address,
  });

  @override
  List<Object?> get props => [id, username, password, email, address];
}
