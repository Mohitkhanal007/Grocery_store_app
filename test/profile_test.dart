import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/features/profile/domain/entity/profile_entity.dart';
import 'package:jerseyhub/features/profile/data/model/profile_model.dart';

void main() {
  group('Profile Tests', () {
    test('ProfileEntity should be created correctly', () {
      final profile = ProfileEntity(
        id: '1',
        email: 'test@example.com',
        username: 'testuser',
        address: '123 Test St',
        phoneNumber: '+1234567890',
        profileImage: 'https://example.com/image.jpg',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(profile.id, '1');
      expect(profile.email, 'test@example.com');
      expect(profile.username, 'testuser');
      expect(profile.address, '123 Test St');
      expect(profile.phoneNumber, '+1234567890');
      expect(profile.profileImage, 'https://example.com/image.jpg');
      expect(profile.gender, 'Male');
    });

    test('ProfileModel should convert from JSON correctly', () {
      final json = {
        '_id': '1',
        'email': 'test@example.com',
        'username': 'testuser',
        'address': '123 Test St',
        'phoneNumber': '+1234567890',
        'profileImage': 'https://example.com/image.jpg',
        'dateOfBirth': '1990-01-01T00:00:00.000Z',
        'gender': 'Male',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'updatedAt': '2023-01-01T00:00:00.000Z',
      };

      final profileModel = ProfileModel.fromJson(json);

      expect(profileModel.id, '1');
      expect(profileModel.email, 'test@example.com');
      expect(profileModel.username, 'testuser');
      expect(profileModel.address, '123 Test St');
      expect(profileModel.phoneNumber, '+1234567890');
      expect(profileModel.profileImage, 'https://example.com/image.jpg');
      expect(profileModel.gender, 'Male');
    });

    test('ProfileModel should convert to entity correctly', () {
      final profileModel = ProfileModel(
        id: '1',
        email: 'test@example.com',
        username: 'testuser',
        address: '123 Test St',
        phoneNumber: '+1234567890',
        profileImage: 'https://example.com/image.jpg',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final entity = profileModel.toEntity();

      expect(entity.id, '1');
      expect(entity.email, 'test@example.com');
      expect(entity.username, 'testuser');
      expect(entity.address, '123 Test St');
      expect(entity.phoneNumber, '+1234567890');
      expect(entity.profileImage, 'https://example.com/image.jpg');
      expect(entity.gender, 'Male');
    });

    test('ProfileEntity copyWith should work correctly', () {
      final original = ProfileEntity(
        id: '1',
        email: 'test@example.com',
        username: 'testuser',
        address: '123 Test St',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = original.copyWith(
        username: 'newuser',
        address: '456 New St',
      );

      expect(updated.id, '1');
      expect(updated.email, 'test@example.com');
      expect(updated.username, 'newuser');
      expect(updated.address, '456 New St');
    });
  });
}
