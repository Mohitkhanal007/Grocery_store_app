import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/notification/domain/entity/notification_entity.dart';
import 'package:grocerystore/features/notification/domain/repository/notification_repository.dart';

class MarkNotificationReadUseCase {
  final INotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  Future<Either<Failure, NotificationEntity>> call(
    String notificationId,
  ) async {
    return await _repository.markAsRead(notificationId);
  }
}
