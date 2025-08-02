import 'package:dartz/dartz.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/notification/data/data_source/notification_remote_datasource.dart';
import 'package:jerseyhub/features/notification/domain/entity/notification_entity.dart';
import 'package:jerseyhub/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final INotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
    String userId,
  ) async {
    try {
      final notifications = await _remoteDataSource.getNotifications(userId);
      final entities = notifications.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(
    String notificationId,
  ) async {
    try {
      final notification = await _remoteDataSource.markAsRead(notificationId);
      return Right(notification.toEntity());
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    try {
      await _remoteDataSource.markAllAsRead(userId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications(String userId) async {
    try {
      await _remoteDataSource.clearAllNotifications(userId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> connectToSocket(String userId) async {
    try {
      await _remoteDataSource.connectToSocket(userId);
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectFromSocket() async {
    try {
      await _remoteDataSource.disconnectFromSocket();
      return const Right(null);
    } catch (e) {
      return Left(RemoteDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Stream<NotificationEntity> get notificationStream =>
      _remoteDataSource.notificationStream;
}
