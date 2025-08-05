import 'dart:async';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:grocerystore/app/constant/backend_config.dart';
import 'package:grocerystore/features/notification/data/model/notification_api_model.dart';
import 'package:grocerystore/features/notification/domain/entity/notification_entity.dart';

abstract class INotificationRemoteDataSource {
  Future<List<NotificationApiModel>> getNotifications(String userId);
  Future<NotificationApiModel> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> clearAllNotifications(String userId);
  Future<void> connectToSocket(String userId);
  Future<void> disconnectFromSocket();
  Stream<NotificationEntity> get notificationStream;
}

class NotificationRemoteDataSource implements INotificationRemoteDataSource {
  final Dio _dio;
  IO.Socket? _socket;
  final StreamController<NotificationEntity> _notificationController =
      StreamController<NotificationEntity>.broadcast();

  NotificationRemoteDataSource(this._dio);

  @override
  Future<List<NotificationApiModel>> getNotifications(String userId) async {
    try {
      print(
        '🔍 NotificationDataSource: Fetching notifications for user: $userId',
      );
      final response = await _dio.get('/notifications/user/$userId');

      print(
        '🔍 NotificationDataSource: Response status: ${response.statusCode}',
      );
      print('🔍 NotificationDataSource: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final notifications = data
            .map((json) => NotificationApiModel.fromJson(json))
            .toList();
        print(
          '🔍 NotificationDataSource: Parsed ${notifications.length} notifications',
        );
        return notifications;
      } else {
        throw Exception(
          'Failed to load notifications: Status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ NotificationDataSource: Error fetching notifications: $e');
      throw Exception('Failed to load notifications: $e');
    }
  }

  @override
  Future<NotificationApiModel> markAsRead(String notificationId) async {
    try {
      final response = await _dio.put('/notifications/$notificationId/read');

      if (response.statusCode == 200) {
        return NotificationApiModel.fromJson(response.data);
      } else {
        throw Exception('Failed to mark notification as read');
      }
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    try {
      final response = await _dio.put(
        '/notifications/user/$userId/mark-all-read',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark all notifications as read');
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  @override
  Future<void> clearAllNotifications(String userId) async {
    try {
      final response = await _dio.delete(
        '/notifications/user/$userId/clear-all',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear all notifications');
      }
    } catch (e) {
      throw Exception('Failed to clear all notifications: $e');
    }
  }

  @override
  Future<void> connectToSocket(String userId) async {
    try {
      // Disconnect existing socket if any
      await disconnectFromSocket();

      // Create new socket connection
      _socket = IO.io(
        BackendConfig.serverAddress,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      // Listen for connection
      _socket!.onConnect((_) {
        print('🔌 Connected to notification socket');
        _socket!.emit('join', userId);
      });

      // Listen for notifications
      _socket!.on('notification', (data) {
        print('🔌 Socket: Received notification data: $data');
        try {
          final notification = NotificationApiModel.fromJson(data).toEntity();
          print('🔌 Socket: Parsed notification: ${notification.message}');
          _notificationController.add(notification);
        } catch (e) {
          print('❌ Error parsing notification: $e');
        }
      });

      // Listen for disconnection
      _socket!.onDisconnect((_) {
        print('🔌 Disconnected from notification socket');
      });

      // Connect to socket
      _socket!.connect();
    } catch (e) {
      throw Exception('Failed to connect to socket: $e');
    }
  }

  @override
  Future<void> disconnectFromSocket() async {
    try {
      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }
    } catch (e) {
      print('❌ Error disconnecting from socket: $e');
    }
  }

  @override
  Stream<NotificationEntity> get notificationStream =>
      _notificationController.stream;

  void dispose() {
    disconnectFromSocket();
    _notificationController.close();
  }
}
