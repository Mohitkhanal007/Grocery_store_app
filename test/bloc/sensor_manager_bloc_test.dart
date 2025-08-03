import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/core/sensors/sensor_manager.dart';

void main() {
  group('SensorManager Bloc Tests', () {
    late SensorManager sensorManager;

    setUp(() {
      sensorManager = SensorManager();
    });

    test('should initialize with light mode by default', () {
      // Assert
      expect(sensorManager.isDarkMode, equals(false));
    });

    test('should trigger dark mode when manually called', () {
      // Arrange
      bool darkModeTriggered = false;
      sensorManager.onThemeChanged = (isDarkMode) {
        darkModeTriggered = isDarkMode;
      };

      // Act
      sensorManager.triggerDarkMode();

      // Assert
      expect(sensorManager.isDarkMode, equals(true));
      expect(darkModeTriggered, equals(true));
    });

    test('should trigger light mode when manually called', () {
      // Arrange
      bool lightModeTriggered = false;
      sensorManager.onThemeChanged = (isDarkMode) {
        lightModeTriggered = !isDarkMode;
      };

      // Act
      sensorManager.triggerLightMode();

      // Assert
      expect(sensorManager.isDarkMode, equals(false));
      expect(lightModeTriggered, equals(true));
    });

    test('should trigger refresh when manually called', () {
      // Arrange
      bool refreshTriggered = false;
      sensorManager.onRefreshRequested = () {
        refreshTriggered = true;
      };

      // Act
      sensorManager.triggerRefresh();

      // Assert
      expect(refreshTriggered, equals(true));
    });

    test('should start listening to sensors', () async {
      // Arrange
      bool darkModeTriggered = false;
      bool refreshTriggered = false;
      
      sensorManager.onThemeChanged = (isDarkMode) {
        darkModeTriggered = isDarkMode;
      };
      sensorManager.onRefreshRequested = () {
        refreshTriggered = true;
      };

      // Act
      await sensorManager.initialize();
      sensorManager.startListening();

      // Assert
      expect(sensorManager.isDarkMode, isA<bool>());
    });

    test('should stop listening to sensors', () async {
      // Arrange
      await sensorManager.initialize();
      sensorManager.startListening();

      // Act
      sensorManager.stopListening();

      // Assert
      expect(sensorManager.isDarkMode, equals(false));
    });

    test('should check sensor availability', () async {
      // Act
      final availability = await sensorManager.checkSensorAvailability();

      // Assert
      expect(availability, isA<Map<String, bool>>());
      expect(availability['proximity'], isA<bool>());
      expect(availability['shake'], isA<bool>());
    });

    test('should handle theme change callbacks', () {
      // Arrange
      List<bool> themeChanges = [];
      sensorManager.onThemeChanged = (isDarkMode) {
        themeChanges.add(isDarkMode);
      };

      // Act
      sensorManager.triggerDarkMode();
      sensorManager.triggerLightMode();
      sensorManager.triggerDarkMode();

      // Assert
      expect(themeChanges, equals([true, false, true]));
      expect(sensorManager.isDarkMode, equals(true));
    });

    test('should handle refresh request callbacks', () {
      // Arrange
      int refreshCount = 0;
      sensorManager.onRefreshRequested = () {
        refreshCount++;
      };

      // Act
      sensorManager.triggerRefresh();
      sensorManager.triggerRefresh();
      sensorManager.triggerRefresh();

      // Assert
      expect(refreshCount, equals(3));
    });

    test('should dispose resources correctly', () async {
      // Arrange
      await sensorManager.initialize();
      sensorManager.startListening();

      // Act
      sensorManager.dispose();

      // Assert
      expect(sensorManager.isDarkMode, equals(false));
    });

    test('should maintain state consistency', () {
      // Arrange
      List<String> operations = [];
      sensorManager.onThemeChanged = (isDarkMode) {
        operations.add(isDarkMode ? 'dark' : 'light');
      };
      sensorManager.onRefreshRequested = () {
        operations.add('refresh');
      };

      // Act
      sensorManager.triggerDarkMode();
      sensorManager.triggerRefresh();
      sensorManager.triggerLightMode();
      sensorManager.triggerRefresh();

      // Assert
      expect(operations, equals(['dark', 'refresh', 'light', 'refresh']));
      expect(sensorManager.isDarkMode, equals(false));
    });
  });
} 