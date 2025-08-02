import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/app/use_case/usecase.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/notification/domain/repository/notification_repository.dart';

class MarkAllNotificationsReadParams extends Equatable {
  final String userId;

  const MarkAllNotificationsReadParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class MarkAllNotificationsReadUseCase
    implements UsecaseWithParams<void, MarkAllNotificationsReadParams> {
  final INotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(
    MarkAllNotificationsReadParams params,
  ) async {
    return await _repository.markAllAsRead(params.userId);
  }
}
