// import 'dart:io';
//
// import 'package:dartz/dartz.dart';
// import 'package:jerseyhub/app/use_case/usecase.dart';
// import 'package:jerseyhub/core/error/failure.dart';
// import 'package:jerseyhub/features/auth/domain/repository/user_repository.dart';
//
// class UploadImageParams {
//   final File file;
//
//   const UploadImageParams({required this.file});
// }
//
// class UploadImageUsecase implements UsecaseWithParams<String, UploadImageParams> {
//   final IUserRepository _userRepository;
//
//   UploadImageUsecase({required IUserRepository userRepository})
//       : _userRepository = userRepository;
//
//   @override
//   Future<Either<Failure, String>> call(UploadImageParams params) {
//     return _userRepository.uploadProfilePicture(params.file);
//   }
// }
