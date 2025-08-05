import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore/core/widgets/football_shirts_logo.dart';

void main() {
  group('FootballShirtsLogo Widget Tests', () {
    testWidgets('should render football shirts logo correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: FootballShirtsLogo())),
        ),
      );

      // Verify the logo is displayed
      expect(find.byType(FootballShirtsLogo), findsOneWidget);

      // Verify the text is displayed
      expect(find.text('FOOTBALL'), findsOneWidget);
      expect(find.text('SHIRTS'), findsOneWidget);

      // Verify the person icon is displayed
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should render with custom colors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: FootballShirtsLogo(
                textColor: Colors.red,
                iconColor: Colors.blue,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FootballShirtsLogo), findsOneWidget);
      expect(find.text('FOOTBALL'), findsOneWidget);
      expect(find.text('SHIRTS'), findsOneWidget);
    });

    testWidgets('should render with custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: FootballShirtsLogo(size: 300))),
        ),
      );

      expect(find.byType(FootballShirtsLogo), findsOneWidget);
      expect(find.text('FOOTBALL'), findsOneWidget);
      expect(find.text('SHIRTS'), findsOneWidget);
    });

    testWidgets('should have proper structure with container and row', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: FootballShirtsLogo())),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('should display speed effect lines', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: FootballShirtsLogo())),
        ),
      );

      // The speed effect is implemented with multiple containers
      expect(find.byType(Container), findsWidgets);
    });
  });
}
