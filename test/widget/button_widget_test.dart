import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Button Widget Tests', () {
    testWidgets('should render elevated button with text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Add to Cart'),
            ),
          ),
        ),
      );

      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should handle button tap', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                buttonPressed = true;
              },
              child: const Text('Buy Now'),
            ),
          ),
        ),
      );

      expect(find.text('Buy Now'), findsOneWidget);
      expect(buttonPressed, false);

      await tester.tap(find.byType(ElevatedButton));
      expect(buttonPressed, true);
    });

    testWidgets('should render disabled button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: null,
              child: const Text('Out of Stock'),
            ),
          ),
        ),
      );

      expect(find.text('Out of Stock'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should render icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('should render text button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () {},
              child: const Text('View Details'),
            ),
          ),
        ),
      );

      expect(find.text('View Details'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
