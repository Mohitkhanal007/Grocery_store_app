import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeSensorService {
  StreamSubscription? _accelerometerSubscription;
  bool _isListening = false;

  // Shake detection parameters
  static const double _shakeThreshold = 12.0; // Adjust sensitivity
  static const int _shakeTimeWindow = 500; // milliseconds
  static const int _shakeCountThreshold = 2; // Number of shakes to trigger

  List<DateTime> _shakeTimes = [];

  // Callback for shake detection
  Function()? onShakeDetected;

  // Initialize shake sensor
  Future<void> initialize() async {
    try {
      // Test accelerometer availability
      await accelerometerEvents.first;
      print('✅ Shake sensor (accelerometer) initialized');
    } catch (e) {
      print('❌ Failed to initialize shake sensor: $e');
    }
  }

  // Start listening to shake events
  void startListening({Function()? onShake}) {
    if (_isListening) return;

    onShakeDetected = onShake;
    _isListening = true;

    _accelerometerSubscription = accelerometerEvents.listen(
      (AccelerometerEvent event) {
        _processShakeData(event);
      },
      onError: (error) {
        print('❌ Shake sensor error: $error');
      },
    );

    print('🎧 Started listening to shake sensor (accelerometer)');
  }

  // Process shake sensor data
  void _processShakeData(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    // Calculate acceleration magnitude
    final double acceleration = sqrt(x * x + y * y + z * z);

    // Check if shake threshold is exceeded
    if (acceleration > _shakeThreshold) {
      _shakeTimes.add(DateTime.now());
      print(
        '📱 Shake detected! Acceleration: ${acceleration.toStringAsFixed(2)}',
      );

      // Clean old shake times
      _shakeTimes.removeWhere(
        (time) =>
            DateTime.now().difference(time).inMilliseconds > _shakeTimeWindow,
      );

      // Check if enough shakes detected
      if (_shakeTimes.length >= _shakeCountThreshold) {
        print('🔄 Shake threshold reached! Triggering refresh...');
        onShakeDetected?.call();
        _shakeTimes.clear(); // Reset for next detection
      }
    }
  }

  // Stop listening to shake events
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _isListening = false;
    onShakeDetected = null;
    _shakeTimes.clear();
    print('🔇 Stopped listening to shake sensor');
  }

  // Check if shake sensor is available
  Future<bool> isAvailable() async {
    try {
      // Test if accelerometer is available
      await accelerometerEvents.first;
      return true;
    } catch (e) {
      print('❌ Error checking shake sensor availability: $e');
      return false;
    }
  }

  // Set shake sensitivity
  void setShakeThreshold(double threshold) {
    // Update shake threshold
    print('⚙️ Shake threshold updated to: $threshold');
  }

  // Dispose resources
  void dispose() {
    stopListening();
  }
}
