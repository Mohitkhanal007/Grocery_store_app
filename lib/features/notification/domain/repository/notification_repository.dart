import 'package:dartz/dartz.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
    String userId,
  );
  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead(String userId);
  Future<Either<Failure, void>> clearAllNotifications(String userId);
  Future<Either<Failure, void>> connectToSocket(String userId);
  Future<Either<Failure, void>> disconnectFromSocket();
  Stream<NotificationEntity> get notificationStream;
}
