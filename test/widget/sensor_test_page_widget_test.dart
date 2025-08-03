import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jerseyhub/core/widgets/sensor_test_page.dart';

void main() {
  group('SensorTestPage Widget Tests', () {
    testWidgets('should display sensor test page with all elements', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.text('Sensor Test Page'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Trigger Refresh'), findsOneWidget);
      expect(find.text('Sensor Instructions:'), findsOneWidget);
      expect(find.text('Manual Controls (for testing):'), findsOneWidget);
    });

    testWidgets('should display status card with initial values', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Refresh Count: 0'), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('should display sensor instructions correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.text('📱 Shake your phone'), findsOneWidget);
      expect(find.text('Triggers page refresh'), findsOneWidget);
      expect(find.text('🤚 Put hand near camera'), findsOneWidget);
      expect(find.text('Switches to dark mode'), findsOneWidget);
      expect(find.text('👋 Move hand away'), findsOneWidget);
      expect(find.text('Switches to light mode'), findsOneWidget);
    });

    testWidgets('should have manual control buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.byType(ElevatedButton), findsNWidgets(3));
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Light Mode'), findsOneWidget);
      expect(find.text('Trigger Refresh'), findsOneWidget);
    });

    testWidgets('should display footer text', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(
        find.text('This is a simulation. In a real app, these would be actual sensor events.'),
        findsOneWidget,
      );
    });

    testWidgets('should have proper card structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.byType(Card), findsNWidgets(3)); // Status, Instructions, Manual Controls
    });

    testWidgets('should display icons in instructions', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.byIcon(Icons.vibration), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should have proper button styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      final darkModeButton = find.widgetWithText(ElevatedButton, 'Dark Mode');
      final lightModeButton = find.widgetWithText(ElevatedButton, 'Light Mode');
      final refreshButton = find.widgetWithText(ElevatedButton, 'Trigger Refresh');

      expect(darkModeButton, findsOneWidget);
      expect(lightModeButton, findsOneWidget);
      expect(refreshButton, findsOneWidget);
    });

    testWidgets('should display theme mode icon correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
    });

    testWidgets('should have proper text styling in cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.text('Sensor Instructions:'), findsOneWidget);
      expect(find.text('Manual Controls (for testing):'), findsOneWidget);
    });

    testWidgets('should display instruction descriptions', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(const MaterialApp(home: SensorTestPage()));

      // Assert
      expect(find.text('Triggers page refresh'), findsOneWidget);
      expect(find.text('Switches to dark mode'), findsOneWidget);
      expect(find.text('Switches to light mode'), findsOneWidget);
    });
  });
} 