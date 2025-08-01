import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? id;
  final String email;
  final String username;
  final String address;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    this.id,
    required this.email,
    required this.username,
    required this.address,
    this.phoneNumber,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    username,
    address,
    phoneNumber,
    profileImage,
    createdAt,
    updatedAt,
  ];

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? address,
    String? phoneNumber,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
