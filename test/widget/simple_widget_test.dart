import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Simple Widget Tests', () {
    testWidgets('should render basic container widget', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(16),
              child: const Text('Test Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Test Widget'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('should render card widget with content', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Order ID: 12345'),
                    const Text('Total: ₹99.99'),
                    const Text('Status: Confirmed'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Order ID: 12345'), findsOneWidget);
      expect(find.text('Total: ₹99.99'), findsOneWidget);
      expect(find.text('Status: Confirmed'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('should render list of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: [
                ListTile(title: const Text('Item 1')),
                ListTile(title: const Text('Item 2')),
                ListTile(title: const Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
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
              child: const Text('Press Me'),
            ),
          ),
        ),
      );

      expect(find.text('Press Me'), findsOneWidget);
      expect(buttonPressed, false);

      await tester.tap(find.byType(ElevatedButton));
      expect(buttonPressed, true);
    });

    testWidgets('should render icon with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 8),
                const Text('Cart Items'),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
      expect(find.text('Cart Items'), findsOneWidget);
    });
  });
}
