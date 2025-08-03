import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximitySensorService {
  StreamSubscription? _proximitySubscription;
  bool _isListening = false;

  // Callback for proximity changes
  Function(bool isNear)? onProximityChanged;

  // Initialize proximity sensor
  Future<void> initialize() async {
    try {
      // Check if proximity sensor is available
      final bool available = await ProximitySensor.isAvailable();
      if (!available) {
        print('⚠️ Proximity sensor not available on this device');
        return;
      }
      print('✅ Proximity sensor initialized');
    } catch (e) {
      print('❌ Failed to initialize proximity sensor: $e');
    }
  }

  // Start listening to proximity changes
  void startListening({Function(bool isNear)? onChanged}) {
    if (_isListening) return;

    onProximityChanged = onChanged;
    _isListening = true;

    _proximitySubscription = ProximitySensor.events.listen(
      (double distance) {
        // Convert distance to boolean (near/far)
        final bool isNear = distance < 5.0; // 5cm threshold
        print(
          '📱 Proximity sensor: ${isNear ? "Hand NEAR" : "Hand FAR"} (${distance.toStringAsFixed(1)}cm)',
        );
        onProximityChanged?.call(isNear);
      },
      onError: (error) {
        print('❌ Proximity sensor error: $error');
      },
    );

    print('🎧 Started listening to proximity sensor');
  }

  // Stop listening to proximity changes
  void stopListening() {
    _proximitySubscription?.cancel();
    _proximitySubscription = null;
    _isListening = false;
    onProximityChanged = null;
    print('🔇 Stopped listening to proximity sensor');
  }

  // Check if proximity sensor is available
  Future<bool> isAvailable() async {
    try {
      return await ProximitySensor.isAvailable();
    } catch (e) {
      print('❌ Error checking proximity sensor availability: $e');
      return false;
    }
  }

  // Dispose resources
  void dispose() {
    stopListening();
  }
}
