import 'package:equatable/equatable.dart';
import 'package:jerseyhub/features/profile/domain/entity/profile_entity.dart';

class ProfileModel extends Equatable {
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

  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'address': address,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      email: email,
      username: username,
      address: address,
      phoneNumber: phoneNumber,
      profileImage: profileImage,
      dateOfBirth: dateOfBirth,
      gender: gender,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      address: entity.address,
      phoneNumber: entity.phoneNumber,
      profileImage: entity.profileImage,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

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
}
