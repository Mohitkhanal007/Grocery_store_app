import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? id;
  final String email;
  final String username;
  final String address;
  final String? phoneNumber;
  final String? profileImage;
  final DateTime? dateOfBirth;
  final String? gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileEntity({
    this.id,
    required this.email,
    required this.username,
    required this.address,
    this.phoneNumber,
    this.profileImage,
    this.dateOfBirth,
    this.gender,
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
    dateOfBirth,
    gender,
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
    DateTime? dateOfBirth,
    String? gender,
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
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
