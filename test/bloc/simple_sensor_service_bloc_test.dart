import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/core/sensors/simple_sensor_service.dart';

void main() {
  group('SimpleSensorService Bloc Tests', () {
    late SimpleSensorService sensorService;

    setUp(() {
      sensorService = SimpleSensorService();
    });

    test('should initialize with light mode by default', () {
      // Assert
      expect(sensorService.isDarkMode, equals(false));
    });

    test('should trigger dark mode when manually called', () {
      // Arrange
      bool darkModeTriggered = false;
      sensorService.onThemeChanged = (isDarkMode) {
        darkModeTriggered = isDarkMode;
      };

      // Act
      sensorService.triggerDarkMode();

      // Assert
      expect(sensorService.isDarkMode, equals(true));
      expect(darkModeTriggered, equals(true));
    });

    test('should trigger light mode when manually called', () {
      // Arrange
      bool lightModeTriggered = false;
      sensorService.onThemeChanged = (isDarkMode) {
        lightModeTriggered = !isDarkMode;
      };

      // Act
      sensorService.triggerLightMode();

      // Assert
      expect(sensorService.isDarkMode, equals(false));
      expect(lightModeTriggered, equals(true));
    });

    test('should trigger refresh when manually called', () {
      // Arrange
      bool refreshTriggered = false;
      sensorService.onRefreshRequested = () {
        refreshTriggered = true;
      };

      // Act
      sensorService.triggerRefresh();

      // Assert
      expect(refreshTriggered, equals(true));
    });

    test('should start listening to sensors', () {
      // Arrange
      bool darkModeTriggered = false;
      bool refreshTriggered = false;
      
      sensorService.onThemeChanged = (isDarkMode) {
        darkModeTriggered = isDarkMode;
      };
      sensorService.onRefreshRequested = () {
        refreshTriggered = true;
      };

      // Act
      sensorService.startListening();

      // Assert
      expect(sensorService.isDarkMode, isA<bool>());
    });

    test('should stop listening to sensors', () {
      // Arrange
      sensorService.startListening();

      // Act
      sensorService.stopListening();

      // Assert
      expect(sensorService.isDarkMode, equals(false));
    });

    test('should dispose resources correctly', () {
      // Arrange
      sensorService.startListening();

      // Act
      sensorService.dispose();

      // Assert
      expect(sensorService.isDarkMode, equals(false));
    });

    test('should handle theme change callbacks', () {
      // Arrange
      List<bool> themeChanges = [];
      sensorService.onThemeChanged = (isDarkMode) {
        themeChanges.add(isDarkMode);
      };

      // Act
      sensorService.triggerDarkMode();
      sensorService.triggerLightMode();
      sensorService.triggerDarkMode();

      // Assert
      expect(themeChanges, equals([true, false, true]));
      expect(sensorService.isDarkMode, equals(true));
    });

    test('should handle refresh request callbacks', () {
      // Arrange
      int refreshCount = 0;
      sensorService.onRefreshRequested = () {
        refreshCount++;
      };

      // Act
      sensorService.triggerRefresh();
      sensorService.triggerRefresh();
      sensorService.triggerRefresh();

      // Assert
      expect(refreshCount, equals(3));
    });

    test('should maintain state consistency', () {
      // Arrange
      List<String> operations = [];
      sensorService.onThemeChanged = (isDarkMode) {
        operations.add(isDarkMode ? 'dark' : 'light');
      };
      sensorService.onRefreshRequested = () {
        operations.add('refresh');
      };

      // Act
      sensorService.triggerDarkMode();
      sensorService.triggerRefresh();
      sensorService.triggerLightMode();
      sensorService.triggerRefresh();

      // Assert
      expect(operations, equals(['dark', 'refresh', 'light', 'refresh']));
      expect(sensorService.isDarkMode, equals(false));
    });

    test('should handle multiple start/stop cycles', () {
      // Arrange
      sensorService.startListening();

      // Act
      sensorService.stopListening();
      sensorService.startListening();
      sensorService.stopListening();

      // Assert
      expect(sensorService.isDarkMode, equals(false));
    });
  });
} 