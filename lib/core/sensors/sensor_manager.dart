import 'package:flutter/material.dart';
import 'simple_sensor_service.dart';

class SensorManager {
  static final SensorManager _instance = SensorManager._internal();
  factory SensorManager() => _instance;
  SensorManager._internal();

  final SimpleSensorService _sensorService = SimpleSensorService();

  bool _isInitialized = false;
  bool _isDarkMode = false;

  // Callbacks
  Function(bool isDarkMode)? onThemeChanged;
  Function()? onRefreshRequested;

  // Initialize sensors
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      print('✅ Sensor manager initialized');
    } catch (e) {
      print('❌ Failed to initialize sensor manager: $e');
    }
  }

  // Start listening to all sensors
  void startListening({
    Function(bool isDarkMode)? onThemeChanged,
    Function()? onRefreshRequested,
  }) {
    this.onThemeChanged = onThemeChanged;
    this.onRefreshRequested = onRefreshRequested;

    _sensorService.startListening(
      onThemeChanged: (bool isDarkMode) {
        _isDarkMode = isDarkMode;
        onThemeChanged?.call(isDarkMode);
      },
      onRefreshRequested: () {
        onRefreshRequested?.call();
      },
    );

    print('🎧 Started listening to sensors');
  }

  // Stop listening to all sensors
  void stopListening() {
    _sensorService.stopListening();
    print('🔇 Stopped listening to sensors');
  }

  // Get current theme mode
  bool get isDarkMode => _isDarkMode;

  // Check if sensors are available (always true for simulation)
  Future<Map<String, bool>> checkSensorAvailability() async {
    return {'proximity': true, 'shake': true};
  }

  // Manual triggers for testing
  void triggerDarkMode() {
    _sensorService.triggerDarkMode();
  }

  void triggerLightMode() {
    _sensorService.triggerLightMode();
  }

  void triggerRefresh() {
    _sensorService.triggerRefresh();
  }

  // Dispose all resources
  void dispose() {
    stopListening();
    _sensorService.dispose();
  }
}
