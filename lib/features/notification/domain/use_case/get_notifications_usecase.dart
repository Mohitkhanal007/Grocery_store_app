import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/notification/domain/entity/notification_entity.dart';
import 'package:jerseyhub/features/notification/domain/repository/notification_repository.dart';

class GetNotificationsUseCase {
  final INotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<NotificationEntity>>> call(String userId) async {
    return await _repository.getNotifications(userId);
  }
}
