import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? userId;
  final String firstName;
  final String lastName;
  final String? profileImage;
  final String phone;
  final String username;
  final String password;

  const UserEntity({
    this.userId,
    required this.firstName,
    required this.lastName,
    this.profileImage,
    required this.phone,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    profileImage,
    phone,
    username,
    password,
  ];
}
