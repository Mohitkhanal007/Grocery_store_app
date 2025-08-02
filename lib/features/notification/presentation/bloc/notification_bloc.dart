import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jerseyhub/core/error/failure.dart';
import 'package:jerseyhub/features/notification/domain/entity/notification_entity.dart';
import 'package:jerseyhub/features/notification/domain/repository/notification_repository.dart';
import 'package:jerseyhub/features/notification/domain/use_case/get_notifications_usecase.dart';
import 'package:jerseyhub/features/notification/domain/use_case/mark_notification_read_usecase.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;

  const LoadNotifications(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ConnectToSocket extends NotificationEvent {
  final String userId;

  const ConnectToSocket(this.userId);

  @override
  List<Object?> get props => [userId];
}

class DisconnectFromSocket extends NotificationEvent {
  const DisconnectFromSocket();
}

class NewNotificationReceived extends NotificationEvent {
  final NotificationEntity notification;

  const NewNotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

// States
abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class SocketConnected extends NotificationState {}

class SocketDisconnected extends NotificationState {}

// BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final INotificationRepository _repository;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markAsReadUseCase;
  StreamSubscription<NotificationEntity>? _notificationSubscription;

  NotificationBloc({
    required INotificationRepository repository,
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationReadUseCase markAsReadUseCase,
  }) : _repository = repository,
       _getNotificationsUseCase = getNotificationsUseCase,
       _markAsReadUseCase = markAsReadUseCase,
       super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<ConnectToSocket>(_onConnectToSocket);
    on<DisconnectFromSocket>(_onDisconnectFromSocket);
    on<NewNotificationReceived>(_onNewNotificationReceived);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    final result = await _getNotificationsUseCase(event.userId);

    result.fold((failure) => emit(NotificationError(failure.message)), (
      notifications,
    ) {
      final unreadCount = notifications.where((n) => !n.read).length;
      emit(
        NotificationsLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    });
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _markAsReadUseCase(event.notificationId);

    result.fold((failure) => emit(NotificationError(failure.message)), (
      updatedNotification,
    ) {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications.map((
          notification,
        ) {
          if (notification.id == event.notificationId) {
            return updatedNotification;
          }
          return notification;
        }).toList();

        final unreadCount = updatedNotifications.where((n) => !n.read).length;

        emit(
          NotificationsLoaded(
            notifications: updatedNotifications,
            unreadCount: unreadCount,
          ),
        );
      }
    });
  }

  Future<void> _onConnectToSocket(
    ConnectToSocket event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _repository.connectToSocket(event.userId);

    result.fold((failure) => emit(NotificationError(failure.message)), (_) {
      emit(SocketConnected());
      _notificationSubscription = _repository.notificationStream.listen(
        (notification) => add(NewNotificationReceived(notification)),
      );
    });
  }

  Future<void> _onDisconnectFromSocket(
    DisconnectFromSocket event,
    Emitter<NotificationState> emit,
  ) async {
    await _notificationSubscription?.cancel();
    final result = await _repository.disconnectFromSocket();

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(SocketDisconnected()),
    );
  }

  void _onNewNotificationReceived(
    NewNotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final updatedNotifications = [
        event.notification,
        ...currentState.notifications,
      ];
      final unreadCount = updatedNotifications.where((n) => !n.read).length;

      emit(
        NotificationsLoaded(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
