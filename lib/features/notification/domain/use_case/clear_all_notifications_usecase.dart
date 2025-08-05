import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:grocerystore/app/use_case/usecase.dart';
import 'package:grocerystore/core/error/failure.dart';
import 'package:grocerystore/features/notification/domain/repository/notification_repository.dart';

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
