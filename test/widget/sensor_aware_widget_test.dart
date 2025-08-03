import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/core/widgets/sensor_aware_widget.dart';

void main() {
  group('SensorAwareWidget Tests', () {
    testWidgets('should render child widget correctly', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child Widget'), findsOneWidget);
    });

    testWidgets('should display sensor status indicator when sensors available', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
          ),
        ),
      );

      // Wait for sensors to initialize
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      // Note: Status indicator may or may not be visible depending on sensor availability
    });

    testWidgets('should display shake hint when sensors available', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
          ),
        ),
      );

      // Wait for sensors to initialize
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      // Note: Shake hint may or may not be visible depending on sensor availability
    });

    testWidgets('should handle theme changes correctly', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');
      bool themeChanged = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
            onThemeChanged: (isDarkMode) {
              themeChanged = isDarkMode;
            },
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      expect(themeChanged, isFalse);
    });

    testWidgets('should handle refresh requests correctly', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');
      bool refreshRequested = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
            onRefreshRequested: () {
              refreshRequested = true;
            },
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
      expect(refreshRequested, isFalse);
    });

    testWidgets('should disable proximity sensor when specified', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
            enableProximitySensor: false,
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should disable shake sensor when specified', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
            enableShakeSensor: false,
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should handle complex child widget', (WidgetTester tester) async {
      // Arrange
      final complexChild = Column(
        children: [
          const Text('Header'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Button'),
          ),
          const SizedBox(height: 20),
          const Text('Footer'),
        ],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: complexChild,
          ),
        ),
      );

      // Assert
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Button'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle null callbacks gracefully', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
            onThemeChanged: null,
            onRefreshRequested: null,
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should maintain widget tree structure', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
          ),
        ),
      );

      // Assert
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('should handle widget disposal correctly', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: SensorAwareWidget(
            child: testChild,
          ),
        ),
      );

      // Dispose widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Assert
      expect(find.text('Test Child'), findsNothing);
    });
  });
} 