import 'dart:async';
import 'dart:math';

class SimpleSensorService {
  static final SimpleSensorService _instance = SimpleSensorService._internal();
  factory SimpleSensorService() => _instance;
  SimpleSensorService._internal();

  Timer? _proximityTimer;
  Timer? _shakeTimer;
  bool _isDarkMode = false;

  // Callbacks
  Function(bool isDarkMode)? onThemeChanged;
  Function()? onRefreshRequested;

  // Simulate proximity sensor
  void startProximitySimulation() {
    print('🎧 Starting proximity sensor simulation');

    _proximityTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      // Simulate hand near/far detection
      final bool isNear = Random().nextBool();
      print('📱 Proximity simulation: ${isNear ? "Hand NEAR" : "Hand FAR"}');

      if (isNear && !_isDarkMode) {
        _isDarkMode = true;
        print('🌙 Dark mode enabled (simulated)');
        onThemeChanged?.call(true);
      } else if (!isNear && _isDarkMode) {
        _isDarkMode = false;
        print('☀️ Light mode enabled (simulated)');
        onThemeChanged?.call(false);
      }
    });
  }

  // Simulate shake sensor
  void startShakeSimulation() {
    print('🎧 Starting shake sensor simulation');

    _shakeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      // Simulate shake detection
      final bool isShaking = Random().nextBool();
      if (isShaking) {
        print('📱 Shake detected! (simulated)');
        print('🔄 Triggering refresh...');
        onRefreshRequested?.call();
      }
    });
  }

  // Start both sensors
  void startListening({
    Function(bool isDarkMode)? onThemeChanged,
    Function()? onRefreshRequested,
  }) {
    this.onThemeChanged = onThemeChanged;
    this.onRefreshRequested = onRefreshRequested;

    startProximitySimulation();
    startShakeSimulation();

    print('✅ Simple sensor simulation started');
  }

  // Stop all sensors
  void stopListening() {
    _proximityTimer?.cancel();
    _shakeTimer?.cancel();
    _proximityTimer = null;
    _shakeTimer = null;
    print('🔇 Stopped sensor simulation');
  }

  // Get current theme mode
  bool get isDarkMode => _isDarkMode;

  // Manual trigger for testing
  void triggerDarkMode() {
    _isDarkMode = true;
    onThemeChanged?.call(true);
    print('🌙 Dark mode manually triggered');
  }

  void triggerLightMode() {
    _isDarkMode = false;
    onThemeChanged?.call(false);
    print('☀️ Light mode manually triggered');
  }

  void triggerRefresh() {
    onRefreshRequested?.call();
    print('🔄 Refresh manually triggered');
  }

  // Dispose resources
  void dispose() {
    stopListening();
  }
}
