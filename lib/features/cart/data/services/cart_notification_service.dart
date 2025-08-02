import 'package:dio/dio.dart';
import 'package:jerseyhub/app/constant/backend_config.dart';
import 'package:jerseyhub/app/shared_prefs/user_shared_prefs.dart';

class CartNotificationService {
  final Dio _dio;
  final UserSharedPrefs _userSharedPrefs;

  CartNotificationService({
    required Dio dio,
    required UserSharedPrefs userSharedPrefs,
  }) : _dio = dio,
       _userSharedPrefs = userSharedPrefs;

  /// Send notification when item is added to cart
  Future<void> sendAddToCartNotification({
    required String productName,
    required int quantity,
  }) async {
    try {
      final userId = _userSharedPrefs.getCurrentUserId();
      print('🔍 CartNotificationService: Current user ID: $userId');

      if (userId == null) {
        print('❌ CartNotificationService: No user ID found');
        return;
      }

      print('🔍 CartNotificationService: Sending notification to backend...');
      final response = await _dio.post(
        '${BackendConfig.baseUrl}cart/add-notification',
        data: {
          'userId': userId,
          'productName': productName,
          'quantity': quantity,
        },
      );
      print(
        '✅ CartNotificationService: Add to cart notification sent successfully',
      );
      print('🔍 CartNotificationService: Backend response: ${response.data}');
    } catch (e) {
      print(
        '❌ CartNotificationService: Failed to send add to cart notification: $e',
      );
    }
  }

  /// Send notification when item is removed from cart
  Future<void> sendRemoveFromCartNotification({
    required String productName,
    required int quantity,
  }) async {
    try {
      final userId = _userSharedPrefs.getCurrentUserId();
      if (userId == null) {
        print('❌ CartNotificationService: No user ID found');
        return;
      }

      await _dio.post(
        '${BackendConfig.baseUrl}cart/remove-notification',
        data: {
          'userId': userId,
          'productName': productName,
          'quantity': quantity,
        },
      );
      print('✅ CartNotificationService: Remove from cart notification sent');
    } catch (e) {
      print(
        '❌ CartNotificationService: Failed to send remove from cart notification: $e',
      );
    }
  }

  /// Send cart reminder notification
  Future<void> sendCartReminderNotification({required int itemCount}) async {
    try {
      final userId = _userSharedPrefs.getCurrentUserId();
      if (userId == null) {
        print('❌ CartNotificationService: No user ID found');
        return;
      }

      await _dio.post(
        '${BackendConfig.baseUrl}cart/reminder-notification',
        data: {'userId': userId, 'itemCount': itemCount},
      );
      print('✅ CartNotificationService: Cart reminder notification sent');
    } catch (e) {
      print(
        '❌ CartNotificationService: Failed to send cart reminder notification: $e',
      );
    }
  }

  /// Send cart total update notification
  Future<void> sendCartTotalUpdateNotification({
    required double oldTotal,
    required double newTotal,
    String? changeReason,
  }) async {
    try {
      final userId = _userSharedPrefs.getCurrentUserId();
      if (userId == null) {
        print('❌ CartNotificationService: No user ID found');
        return;
      }

      await _dio.post(
        '${BackendConfig.baseUrl}cart/total-update-notification',
        data: {
          'userId': userId,
          'oldTotal': oldTotal,
          'newTotal': newTotal,
          'changeReason': changeReason,
        },
      );
      print('✅ CartNotificationService: Cart total update notification sent');
    } catch (e) {
      print(
        '❌ CartNotificationService: Failed to send cart total update notification: $e',
      );
    }
  }
}
