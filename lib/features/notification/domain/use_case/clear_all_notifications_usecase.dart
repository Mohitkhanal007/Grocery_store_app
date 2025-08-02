import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/notification/domain/repository/notification_repository.dart';

class ClearAllNotificationsParams extends Equatable {
  final String userId;

  const ClearAllNotificationsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearAllNotificationsUseCase
    implements UsecaseWithParams<void, ClearAllNotificationsParams> {
  final INotificationRepository _repository;

  ClearAllNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ClearAllNotificationsParams params) async {
    return await _repository.clearAllNotifications(params.userId);
  }
}
